import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class CustomAlert {

  static void show({
    required BuildContext context,
    required String content,
    required QuickAlertType type,
  }) {
    QuickAlert.show(
      context: context,
      type: type,
      text: content,

    );

  }
}
