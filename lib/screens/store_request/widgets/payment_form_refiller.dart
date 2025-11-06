import 'package:get/get.dart';
import 'package:flutter/widgets.dart';
import 'package:iq_mall/screens/store_request/widgets/field_row_controller.dart';
import 'package:iq_mall/screens/store_request/widgets/payment_form_data.dart';

/// Refill the dynamic form on your screen using user-provided data.
///
/// - [data]: parsed PaymentFormData (from JSON or raw).
/// - [fields]: your observable list of FieldRowController (RxList).
/// - [htmlCtrl]: the TextEditingController backing your HTML multi-line field.
/// - [onRequestId]: optional callback if you want to show/use the request id in the UI.
class PaymentFormRefiller {
  static void refillPaymentForm({
    required PaymentFormData data,
    required RxList<FieldRowController> fields,
    required TextEditingController htmlCtrl,
    void Function(String requestId)? onRequestId,
  }) {
    // Optional: do something with requestId (subtitle, etc.)
    if (data.requestId != null && onRequestId != null) {
      onRequestId(data.requestId!);
    }

    // Clear existing rows/controllers safely
    for (final f in fields) {
      f.dispose();
    }
    fields.clear();

    // Rebuild rows
    if (data.fields.isEmpty) {
      // keep at least one empty row to avoid empty UI
      fields.add(FieldRowController(valueFocusNode: FocusNode()));
    } else {
      for (final pf in data.fields) {
        fields.add(FieldRowController(initialTitle: pf.title, initialValue: pf.value, valueFocusNode: FocusNode()));
      }
    }

    // HTML text
    htmlCtrl.text = data.htmlText;
  }
}
