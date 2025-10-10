// import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:get/get.dart';
// import 'package:iq_mall/screens/HomeScreenPage/ShHomeScreen.dart';
// import 'package:iq_mall/utils/ShColors.dart';
//
// import '../../../main.dart';
// import '../controller/OrderSummaryScreen_controller.dart';
//
// class PolicyDialog {
//   void showPolicyDialog(BuildContext context) {
//     OrderSummaryScreenController Summarycontroller = Get.find();
//     showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: const Icon(
//                   Icons.clear,
//                   color: Colors.black,
//                 ),
//               ),
//             ],
//           ),
//           content: ListView(children: [
//              Text('Terms and Conditions'.tr),
//             SizedBox(width: 200, height: 200, child: Html(data: prefs!.getString('terms_conditions')!)),
//             const Divider(),
//              Text('Privacy policy'.tr),
//             SizedBox(
//               width: 200,
//               child: Html(data: prefs!.getString('privacy_policy')!),
//             ),
//             GestureDetector(
//               onTap: () {
//                 Summarycontroller.agreement_accepted.value = !Summarycontroller.agreement_accepted.value;
//               },
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 8.0),
//                 child: Row(
//                   children: [
//                     Obx(() {
//                       return Summarycontroller.agreement_accepted.value
//                           ? const Icon(
//                               Icons.check_box_rounded,
//                               color: Colors.green,
//                             )
//                           : Icon(
//                               Icons.check_box_outline_blank,
//                               color: MainColor,
//                             );
//                     }),
//                     Text(
//                       'I have read and accept'.tr,
//                       style: TextStyle(color: MainColor),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ]),
//           actions: <Widget>[
//             GestureDetector(
//               onTap: () {
//                 if (Summarycontroller.agreement_accepted.value) Navigator.of(context).pop();
//               },
//               child: Obx(
//                 () {
//                   return Container(
//                     width: 80,
//                     height: 40,
//                     decoration: BoxDecoration(
//                       color: Summarycontroller.agreement_accepted.value ? MainColor : Colors.grey,
//                       border: Border.all(
//                         color: Summarycontroller.agreement_accepted.value ? MainColor : Colors.grey,
//                       ),
//                       borderRadius: const BorderRadius.all(Radius.circular(5)),
//                     ),
//                     child: Center(
//                       child: Text(
//                         'Done'.tr,
//                         style: const TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
