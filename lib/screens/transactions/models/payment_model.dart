class SubmitPaymentResult {
  final bool success;
  final String message;
  final int? transactionId;
  final DateTime? subscriptionEndDate;
  final int? tableName;
  final int? attachmentKind;
  final Map<String, dynamic>? raw;

  SubmitPaymentResult({
    required this.success,
    required this.message,
    this.transactionId,
    this.subscriptionEndDate,
    this.tableName,
    this.attachmentKind,
    this.raw,
  });

  factory SubmitPaymentResult.fromMap(Map<String, dynamic> map) {
    DateTime? parseDate(String? s) {
      if (s == null || s.isEmpty) return null;
      try {
        return DateTime.parse(s);
      } catch (_) {
        return null;
      }
    }

    return SubmitPaymentResult(
      success: (map['success'] == true),
      message: (map['message'] as String?) ?? '',
      transactionId: (map['transaction_id'] is int) ? map['transaction_id'] as int : int.tryParse('${map['transaction_id']}'),
      subscriptionEndDate: parseDate(map['subscription_end_date'] as String?),
      tableName: (map['table_name'] is int) ? map['table_name'] as int : int.tryParse('${map['table_name']}'),
      attachmentKind: (map['attachment_kind'] is int) ? map['attachment_kind'] as int : int.tryParse('${map['attachment_kind']}'),
      raw: map,
    );
  }
}
