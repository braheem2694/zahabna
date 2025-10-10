// import 'dart:convert';
// import 'dart:core';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:iq_mall/cores/assets.dart';
// import 'package:iq_mall/models/Address.dart';
// import 'package:iq_mall/models/Currency.dart';
//
// import 'package:iq_mall/widgets/ShWidget.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import '../main.dart';
// import '../screens/Cart_List_screen/controller/Cart_List_controller.dart';
// import 'PaypalServices.dart';
// import 'package:http/http.dart' as http;
//
// class PaypalPayment extends StatefulWidget {
//   static String? tag = '/PaypalPayment';
//
//   final String? type;
//   final String? amount;
//   final String? message;
//   final String? gift_id;
//   final String? receiver;
//   final String? code;
//   final String? unique_id;
//   var product;
//
//   PaypalPayment({this.type, this.unique_id, this.amount, this.message, this.gift_id, this.receiver, this.product, this.code});
//
//   @override
//   State<StatefulWidget> createState() {
//     return PaypalPaymentState();
//   }
// }
//
// class PaypalPaymentState extends State<PaypalPayment> {
//   GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   String? checkoutUrl;
//   String? executeUrl;
//   String? accessToken;
//   PaypalServices services = PaypalServices();
//
//   Map<dynamic, dynamic> defaultCurrency = {"symbol": "USD ", "decimalDigits": 2, "symbolBeforeTheNumber": true, "currency": "USD"};
//
//   bool isEnableShipping = false;
//   bool isEnableAddress = false;
//
//   String? returnURL = 'return.example.com';
//   String? cancelURL = 'cancel.example.com';
//
//   @override
//   void initState() {
//     super.initState();
//
//     Future.delayed(Duration.zero, () async {
//       try {
//         accessToken = await services.getAccessToken();
//
//         final transactions = getOrderParams();
//         final res = await services.createPaypalPayment(transactions, accessToken);
//         if (res != null) {
//           setState(() {
//             checkoutUrl = res["approvalUrl"];
//             executeUrl = res["executeUrl"];
//           });
//         }
//       } catch (e) {
//         final snackBar = SnackBar(
//           content: Text(e.toString()),
//           duration: Duration(seconds: 10),
//           action: SnackBarAction(
//             label: 'Close',
//             onPressed: () {
//               // Some code to undo the change.
//             },
//           ),
//         );
//         //_scaffoldKey.currentState.showSnackBar(snackBar);
//       }
//     });
//   }
//
//   String? itemName = 'iPhone X';
//   int quantity = 1;
//   String? paying_method;
//
//   Map<String, dynamic> getOrderParams() {
//     List items = [
//       {"name": itemName, "quantity": quantity, "price": widget.amount.toString(), "currency": defaultCurrency["currency"]}
//     ];
//     String? totalAmount = widget.amount.toString();
//     String? subTotalAmount = widget.amount.toString();
//     String? shippingCost = '0';
//     int shippingDiscountCost = 0;
//     String? userFirstName = 'Gulshan';
//     String? userLastName = 'Yadav';
//     String? addressCity = 'Delhi';
//     String? addressStreet = 'Mathura Road';
//     String? addressZipCode = '110014';
//     String? addressCountry = 'India';
//     String? addressState = 'Delhi';
//     String? addressPhoneNumber = '+919990119091';
//
//     Map<String, dynamic> temp = {
//       "intent": "sale",
//       "payer": {"payment_method": "paypal"},
//       "transactions": [
//         {
//           "amount": {
//             "total": totalAmount,
//             "currency": defaultCurrency["currency"],
//             "details": {"subtotal": subTotalAmount, "shipping": shippingCost, "shipping_discount": ((-1.0) * shippingDiscountCost).toString()}
//           },
//           "description": "The payment transaction description.",
//           "payment_options": {"allowed_payment_method": "INSTANT_FUNDING_SOURCE"},
//           "item_list": {
//             "items": items,
//             if (isEnableShipping && isEnableAddress)
//               "shipping_address": {
//                 "recipient_name": "$userFirstName $userLastName",
//                 "line1": addressStreet,
//                 "line2": "",
//                 "city": addressCity,
//                 "country_code": addressCountry,
//                 "postal_code": addressZipCode,
//                 "phone": addressPhoneNumber,
//                 "state": addressState
//               },
//           }
//         }
//       ],
//       "note_to_payer": "Contact us for any questions on your order.",
//       "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL}
//     };
//     return temp;
//   }
//
//   bool enteragain = true;
//
//   @override
//   Widget build(BuildContext context) {
//     if (checkoutUrl != null) {
//       return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           leading: GestureDetector(
//               child: Icon(
//                 Icons.arrow_back_ios,
//                 color: Colors.black,
//               ),
//               onTap: () => Navigator.pop(context, false)),
//         ),
//         body: Container(),
//       );
//     } else {
//       return Scaffold(
//         key: _scaffoldKey,
//         appBar: AppBar(
//           leading: IconButton(
//               icon: Icon(Icons.arrow_back),
//               onPressed: () {
//                 //  Navigator.of(context).pop();
//               }),
//           backgroundColor: Colors.black12,
//           elevation: 0.0,
//         ),
//         body: Center(child: Container(child: CircularProgressIndicator())),
//       );
//     }
//   }
// }
