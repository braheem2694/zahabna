// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import '../../../main.dart';
//
// class CardInputWidget extends StatefulWidget {
//   @override
//   _CardInputWidgetState createState() => _CardInputWidgetState();
// }
//
// class _CardInputWidgetState extends State<CardInputWidget> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
//   @override
//   void initState() {
//     super.initState();
//     Stripe.publishableKey = prefs!.getString('stp_key')!;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(height: 20.0),
//             CardField(
//               cvcHintText: 'eweewew',
//               onCardChanged: (card) {
//                 // Handle card changes, if necessary
//               },
//             ),
//             SizedBox(height: 20.0),
//             ElevatedButton(
//               onPressed: () {
//                 // Handle the form submission or payment
//                 if (_formKey.currentState!.validate()) {
//                   // Process the payment
//                 }
//               },
//               child: Text("Submit"),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
