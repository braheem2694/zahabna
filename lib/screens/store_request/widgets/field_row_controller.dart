import 'package:flutter/widgets.dart';

enum FieldEntryType { text, number, birthday }

/// Controller for one dynamic row (Title + Value) in your form UI.
class FieldRowController {
  final TextEditingController title;
  final TextEditingController value;
  final bool isRequired;
  final String? Function(String? value)? validator;

  /// When true, the *title* is not editable.
  final bool isTitleLocked;

  /// Controls how the value is entered.
  FieldEntryType entryType;

  FieldRowController({
    this.isRequired = true,
    this.validator,
    String initialTitle = '',
    String initialValue = '',
    this.isTitleLocked = false,
    this.entryType = FieldEntryType.text, // default
  })  : title = TextEditingController(text: initialTitle),
        value = TextEditingController(text: initialValue);

  void dispose() {
    title.dispose();
    value.dispose();
  }
}
