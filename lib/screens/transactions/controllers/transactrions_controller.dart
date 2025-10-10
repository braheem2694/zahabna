import 'dart:math';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iq_mall/main.dart';
import 'package:iq_mall/models/store_request.dart';
import 'package:iq_mall/screens/transactions/models/transaction_item.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

// Call example:
// await fetchTransactions(useMock: true);
// or
// await fetchTransactions(from: ..., to: ..., paymentType: ..., useMock: false);

enum TxnFilter { all, day, week, month, custom }

class TransactionsController extends GetxController with GetTickerProviderStateMixin {
  // ----------------- State -----------------
  final RxList<TransactionItem> allTxns = <TransactionItem>[].obs;
  final RxList<TransactionItem> filteredTxns = <TransactionItem>[].obs;

  final Rx<TxnFilter> activeFilter = TxnFilter.all.obs;
  final Rx<DateTime?> customFrom = Rx<DateTime?>(null);
  final Rx<DateTime?> customTo = Rx<DateTime?>(null);

  final currency = RxString('\$');
  final isLoading = true.obs;
  final isLoadingTransactions = true.obs;

  final NumberFormat money = NumberFormat.currency(locale: 'en_US', symbol: '');
  final RxList<StoreRequest> requests = <StoreRequest>[].obs;

  // Optional quick filters (sent to API and also applied locally)
  final RxString paymentTypeFilter = ''.obs; // "Card" | "Cash" | ...
  final RxString recipientSearch = ''.obs; // partial match
  final RxDouble minAmount = RxDouble(double.negativeInfinity);
  final RxDouble maxAmount = RxDouble(double.infinity);
  bool _error = false;
  late final AnimationController refreshController;

  final Rx<ContractPDF?> contractPdf = Rx<ContractPDF?>(null);

  @override
  void onInit() {
    super.onInit();
    refreshController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    // Initial load of transactions with "all" filter (no date range)
    initializeScreen();
  }

  initializeScreen() async {
    await fetchStoreRequests();
    await fetchTransactions(filter: TxnFilter.all, useMock: false);
  }

  // ----------------- Store Requests (unchanged) -----------------
  Future<List<StoreRequest>> fetchStoreRequests() async {
    isLoading.value = true;
    final String token = prefs!.getString("token") ?? "";

    final Map<String, dynamic> response = await api.getData(
      {'token': token},
      "stores/get-store-requests",
    );

    try {
      if (response['success'] == true && response['requests'] != null) {
        final List<dynamic> dataList = response['requests'];
        requests
          ..clear()
          ..addAll(
            dataList.map((item) => StoreRequest.fromMap(item)).toList(),
          );
      } else {}
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
    return requests;
  }

  // ----------------- Transactions API -----------------

  Future<void> fetchTransactions({
    TxnFilter? filter,
    DateTime? from,
    DateTime? to,
    String? paymentType,
    String? recipientContains,
    double? minAmt,
    double? maxAmt,
    bool useMock = false,
    bool fallbackToMockOnError = true,
  }) async {
    isLoadingTransactions.value = true;

    final String token = prefs!.getString("token") ?? "";

    final String? dateFromStr = from != null ? _asYMD(from) : null;
    final String? dateToStr = to != null ? _asYMD(to) : null;

    final String effPaymentType = paymentType ?? paymentTypeFilter.value;
    final String effRecipient = recipientContains ?? recipientSearch.value;
    final double effMin = minAmt ?? minAmount.value;
    final double effMax = maxAmt ?? maxAmount.value;

    final Map<String, dynamic> payload = {
      'token': token,
      'request_id': requests.first.id,
      if (dateFromStr != null) 'date_from': dateFromStr,
      if (dateToStr != null) 'date_to': dateToStr,
      if (effPaymentType.isNotEmpty) 'payment_type': effPaymentType,
      if (effRecipient.isNotEmpty) 'recipient_like': effRecipient,
      if (effMin != double.negativeInfinity) 'min_amount': effMin,
      if (effMax != double.infinity) 'max_amount': effMax,
    };

    Future<Map<String, dynamic>> _loadMock() async {
      final jsonStr = await rootBundle.loadString('assets/data/transactions.json');
      return jsonDecode(jsonStr) as Map<String, dynamic>;
    }

    Future<Map<String, dynamic>> _loadReal() async {
      return await api.getData(payload, "stores/get-payments");
    }

    try {
      final Map<String, dynamic> response = useMock ? await _loadMock() : await _loadReal();

      // ---- Parse response ----
      final success = response['success'] == true;
      final txList = response['transactions'];

      // Contract PDF (optional)
      contractPdf.value = (response['contract_pdf'] != null) ? ContractPDF.fromJson(response['contract_pdf'] as Map<String, dynamic>) : null;

      if (success && txList is List) {
        // Prefer using your TransactionItem.fromJson directly
        final items = <TransactionItem>[];
        for (final raw in txList) {
          try {
            items.add(TransactionItem.fromJson(raw as Map<String, dynamic>));
          } catch (_) {
            // ignore malformed entries
          }
        }
        allTxns.assignAll(items);
        _applyCurrent();
      } else {
        allTxns.clear();
        _applyCurrent();
      }
    } catch (e) {
      // Optional: fallback to mock if API fails
      if (!useMock && fallbackToMockOnError) {
        try {
          final response = await _loadMock();

          contractPdf.value = (response['contract_pdf'] != null) ? ContractPDF.fromJson(response['contract_pdf'] as Map<String, dynamic>) : null;

          final txList = response['transactions'];
          if (txList is List) {
            final items = txList.map((raw) => TransactionItem.fromJson(raw as Map<String, dynamic>)).toList();
            allTxns.assignAll(items);
          } else {
            allTxns.clear();
          }
          _applyCurrent();
        } catch (_) {
          allTxns.clear();
          _applyCurrent();
        }
      } else {
        allTxns.clear();
        _applyCurrent();
      }
    } finally {
      Future.delayed(Duration(seconds: 1), () {
        isLoadingTransactions.value = false;
      });
    }
  }

  /// Maps backend JSON to TransactionItem.
  TransactionItem _mapToTransaction(Map<String, dynamic> json) {
    final dynamic rawAmount = json['amount'];
    double amount;
    if (rawAmount is int) {
      amount = rawAmount.toDouble();
    } else if (rawAmount is double) {
      amount = rawAmount;
    } else if (rawAmount is String) {
      amount = double.tryParse(rawAmount) ?? 0.0;
    } else {
      amount = 0.0;
    }

    String? dateStr = json['date']?.toString();
    String? subEndStr = json['subscriptionEndDate']?.toString();
    // Fallback to common keys
    dateStr ??= json['created_at']?.toString();
    subEndStr ??= json['subscription_end']?.toString();

    return TransactionItem(
      id: (json['id'] ?? json['txn_id'] ?? '').toString(),
      date: dateStr != null ? DateTime.parse(dateStr) : DateTime.now(),
      amount: amount,
      paymentType: (json['paymentType'] ?? json['payment_type'] ?? 'Unknown').toString(),
      recipientName: (json['recipientName'] ?? json['recipient'] ?? 'Unknown').toString(),
      subscriptionEndDate: subEndStr != null ? DateTime.parse(subEndStr) : DateTime.now(),
    );
  }

  // ----------------- Local filter (UI) -----------------
  Future<void> refreshData() async {
    refreshController.repeat();
    isLoadingTransactions.value = true;

    // Re-fetch with the active filter + existing quick filters
    await fetchTransactions(
      filter: activeFilter.value,
      from: customFrom.value,
      to: customTo.value,
      useMock: false,
      paymentType: paymentTypeFilter.value.isEmpty ? null : paymentTypeFilter.value,
      recipientContains: recipientSearch.value.isEmpty ? null : recipientSearch.value,
      minAmt: minAmount.value == double.negativeInfinity ? null : minAmount.value,
      maxAmt: maxAmount.value == double.infinity ? null : maxAmount.value,
    );

    Future.delayed(Duration(seconds: 1), () {
      isLoadingTransactions.value = false;
      refreshController.stop();
    });
  }

  /// Apply a date filter for the UI. If [f] is custom, pass [from] and [to].
  void applyFilter(TxnFilter f, {DateTime? from, DateTime? to}) {
    activeFilter.value = f;

    if (f == TxnFilter.custom) {
      customFrom.value = from;
      customTo.value = to;
    } else {
      customFrom.value = null;
      customTo.value = null;
    }

    // Instant local feedback (UI remains snappy)
    _applyCurrent();

    // Compute the exact range to send to API, then fetch
    final range = _computeRangeFromFilter(f, from: from, to: to);
    fetchTransactions(
      filter: f,
      useMock: true,
      from: range?.start,
      to: range?.end,
    );
  }

  /// Also apply quick filters locally (useful if API doesn’t filter them)
  void setQuickFilters({
    String? paymentType,
    String? recipientContains,
    double? minAmt,
    double? maxAmt,
  }) {
    if (paymentType != null) paymentTypeFilter.value = paymentType;
    if (recipientContains != null) recipientSearch.value = recipientContains;
    if (minAmt != null) minAmount.value = minAmt;
    if (maxAmt != null) maxAmount.value = maxAmt;
    _applyCurrent();
  }

  void clearQuickFilters() {
    paymentTypeFilter.value = '';
    recipientSearch.value = '';
    minAmount.value = double.negativeInfinity;
    maxAmount.value = double.infinity;
    _applyCurrent();
  }

  void _applyCurrent() {
    final now = DateTime.now();
    Iterable<TransactionItem> src = allTxns;

    // 1) Date range
    switch (activeFilter.value) {
      case TxnFilter.all:
        break;
      case TxnFilter.day:
        final start = DateTime(now.year, now.month, now.day);
        final end = start.add(const Duration(days: 1));
        src = src.where((t) => t.date.isAfter(start) && t.date.isBefore(end));
        break;
      case TxnFilter.week:
        final start = now.subtract(const Duration(days: 7));
        src = src.where((t) => t.date.isAfter(start) && t.date.isBefore(now.add(const Duration(days: 1))));
        break;
      case TxnFilter.month:
        final start = DateTime(now.year, now.month, 1);
        final end = DateTime(now.year, now.month + 1, 1);
        src = src.where((t) => t.date.isAfter(start) && t.date.isBefore(end));
        break;
      case TxnFilter.custom:
        final from = customFrom.value;
        final to = customTo.value;
        if (from != null && to != null) {
          final inclusiveTo = DateTime(to.year, to.month, to.day, 23, 59, 59);
          src = src.where((t) => !t.date.isBefore(from) && !t.date.isAfter(inclusiveTo));
        } else {
          src = const <TransactionItem>[];
        }
        break;
    }

    // 2) Quick filters (applied locally too)
    if (paymentTypeFilter.value.isNotEmpty) {
      src = src.where((t) => t.paymentType.toLowerCase() == paymentTypeFilter.value.toLowerCase());
    }
    if (recipientSearch.value.isNotEmpty) {
      final q = recipientSearch.value.toLowerCase();
      src = src.where((t) => t.recipientName.toLowerCase().contains(q));
    }
    src = src.where((t) => t.amount >= minAmount.value && t.amount <= maxAmount.value);

    // Sort newest first
    final sorted = src.toList()..sort((a, b) => b.date.compareTo(a.date));
    filteredTxns.assignAll(sorted);
  }

  // ----------------- Helpers -----------------
  DateTimeRange? _computeRangeFromFilter(TxnFilter f, {DateTime? from, DateTime? to}) {
    final now = DateTime.now();

    DateTime start, end;

    switch (f) {
      case TxnFilter.all:
        return null;

      case TxnFilter.day:
        start = DateTime(now.year, now.month, now.day);
        end = DateTime(now.year, now.month, now.day, 23, 59, 59);
        return DateTimeRange(start: start, end: end);

      case TxnFilter.week:
        start = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 6));
        end = DateTime(now.year, now.month, now.day, 23, 59, 59);
        return DateTimeRange(start: start, end: end);

      case TxnFilter.month:
        start = DateTime(now.year, now.month, 1);
        final nextMonth = (now.month == 12) ? DateTime(now.year + 1, 1, 1) : DateTime(now.year, now.month + 1, 1);
        end = nextMonth.subtract(const Duration(seconds: 1)); // last day 23:59:59
        return DateTimeRange(start: start, end: end);

      case TxnFilter.custom:
        if (from == null || to == null) return null;
        final inclusiveTo = DateTime(to.year, to.month, to.day, 23, 59, 59);
        return DateTimeRange(start: from, end: inclusiveTo);
    }
  }

  /// Format date as 'YYYY-MM-DD' (common for backend filters)
  String _asYMD(DateTime dt) => DateFormat('yyyy-MM-dd').format(dt);
}
