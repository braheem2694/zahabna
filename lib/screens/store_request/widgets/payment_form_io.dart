import 'dart:convert';

import 'package:iq_mall/screens/store_request/widgets/payment_form_data.dart';
import 'package:iq_mall/screens/store_request/widgets/payment_form_field.dart';

class PaymentFormIO {
  /// Parse a JSON string provided by the user.
  static PaymentFormData fromJsonString(String jsonString) {
    final map = jsonDecode(jsonString) as Map<String, dynamic>;
    return PaymentFormData.fromMap(map);
  }

  /// Convert to JSON string (useful if you want to let them export/share again).
  static String toJsonString(PaymentFormData data) {
    return jsonEncode(data.toMap());
  }

  /// Convenience: build from raw maps (e.g., from a form or request payload).
  static PaymentFormData fromRaw({
    String? requestId,
    required List<Map<String, String>> fields, // [{title:..., value:...}]
    required String htmlText,
  }) {
    return PaymentFormData(
      requestId: requestId,
      fields: fields.map((e) => PaymentFormField(title: e['title'] ?? '', value: e['value'] ?? '')).toList(),
      htmlText: htmlText,
    );
  }
}
