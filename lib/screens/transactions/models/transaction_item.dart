import 'package:equatable/equatable.dart';

class TransactionItem extends Equatable {
  final String id;
  final DateTime date;
  final double amount;
  final String paymentType; // e.g. "Card", "Cash", "Bank Transfer"
  final String recipientName;
  final DateTime subscriptionEndDate;

  const TransactionItem({
    required this.id,
    required this.date,
    required this.amount,
    required this.paymentType,
    required this.recipientName,
    required this.subscriptionEndDate,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    double parseAmount(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      if (v is String) return double.tryParse(v) ?? 0.0;
      return 0.0;
    }

    return TransactionItem(
      id: json['id'].toString(),
      date: DateTime.parse(json['date'].toString()),
      amount: parseAmount(json['amount'].toString()),
      paymentType: json['paymentType'].toString(),
      recipientName: json['recipientName'].toString(),
      subscriptionEndDate: DateTime.parse(json['subscriptionEndDate'].toString()),
    );
  }

  /// Convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'amount': amount,
      'paymentType': paymentType,
      'recipientName': recipientName,
      'subscriptionEndDate': subscriptionEndDate.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, date, amount, paymentType, recipientName, subscriptionEndDate];
}

class ContractPDF {
  final String id;
  final String pdfName;
  final String pdfUrl;
  final DateTime? createdAt;

  const ContractPDF({
    required this.id,
    required this.pdfName,
    required this.pdfUrl,
    required this.createdAt,
  });

  factory ContractPDF.fromJson(Map<String, dynamic> json) {
    return ContractPDF(
      id: json['id'].toString(),
      pdfName: json['pdf_name'].toString(),
      pdfUrl: json['pdf_url'].toString(),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pdf_name': pdfName,
      'pdf_url': pdfUrl,
    };
  }
}
