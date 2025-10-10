import 'package:equatable/equatable.dart';

class PaymentFormField extends Equatable {
  final String title;
  final String value;

  const PaymentFormField({required this.title, required this.value});

  factory PaymentFormField.fromMap(Map<String, dynamic> map) {
    return PaymentFormField(
      title: (map['title'] ?? '').toString(),
      value: (map['value'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'value': value,
      };

  @override
  List<Object?> get props => [title, value];
}
