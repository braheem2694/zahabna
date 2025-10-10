import 'payment_form_field.dart';

class PaymentFormData {
  final String? requestId; // optional
  final List<PaymentFormField> fields;
  final String htmlText;

  PaymentFormData({
    this.requestId,
    required this.fields,
    required this.htmlText,
  });

  factory PaymentFormData.fromMap(Map<String, dynamic> map) {
    final rawFields = (map['fields'] as List?) ?? const [];
    return PaymentFormData(
      requestId: map['request_id']?.toString(),
      fields: rawFields.map((e) => PaymentFormField.fromMap(Map<String, dynamic>.from(e))).toList(),
      htmlText: (map['html_text'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toMap() => {
        if (requestId != null) 'request_id': requestId,
        'fields': fields.map((f) => f.toMap()).toList(),
        'html_text': htmlText,
      };
}
