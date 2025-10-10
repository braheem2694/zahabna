// import 'package:flutter/material.dart';
// import 'package:iq_mall/screens/ProductDetails_screen/controller/ProductDetails_screen_controller.dart';
// import 'package:iq_mall/utils/ShConstant.dart';
// import 'package:get/get.dart';
// import 'package:iq_mall/models/Review.dart';
// import 'package:iq_mall/screens/ProductDetails_screen/widgets/flutter_rating_bar.dart';
//
// import '../../Order_Details/widgets/orderStatus.dart';
//
// class ReviewsSection extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     Get.lazyPut(() => ProductDetails_screenController());
//     var controller = Get.find<ProductDetails_screenController>();
//     return Obx(() => !controller.loading.value && controller.product.is_ordered_before == 1
//         ? ListView.builder(
//             scrollDirection: Axis.vertical,
//             itemCount: reviewlist.length,
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemBuilder: (context, index) {
//               return Container(
//                 margin: EdgeInsets.only(bottom: spacing_standard_new),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Row(
//                       children: [
//                         Text(
//                           reviewlist[index].first_name + " " + reviewlist[index].last_name,
//                           style: const TextStyle(
//                             color: Colors.black,
//                             fontSize: 16.0,
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(left: 40.0),
//                           child: Row(
//                             children: [
//                               RatingBar(
//                                 initialRating: double.parse(reviewlist[index].rate.toString()),
//                                 direction: Axis.horizontal,
//                                 allowHalfRating: true,
//                                 tapOnlyMode: true,
//                                 itemCount: 5,
//                                 itemSize: 16,
//                                 itemBuilder: (context, _) => const Icon(
//                                   Icons.star,
//                                   color: Colors.amber,
//                                 ),
//                               ),
//                               Text(
//                                 "  ${double.parse(reviewlist[index].rate.toString())}",
//                                 style: const TextStyle(color: Colors.grey),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     Text(
//                       getTime(reviewlist[index].review_date).toString(),
//                       style: const TextStyle(fontSize: 16.0),
//                     ),
//                     Text(
//                       reviewlist[index].review,
//                       style: const TextStyle(color: Colors.black),
//                     ),
//                     const SizedBox(height: spacing_standard_new),
//                     const Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: <Widget>[
//                         Text(''),
//                       ],
//                     ),
//                   ],
//                 ),
//               );
//             },
//           )
//         : Container());
//   }
// }
