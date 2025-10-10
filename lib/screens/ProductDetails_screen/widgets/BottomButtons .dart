import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iq_mall/models/HomeData.dart';
import 'package:iq_mall/screens/ProductDetails_screen/controller/ProductDetails_screen_controller.dart';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'package:iq_mall/widgets/CommonFunctions.dart';
import 'package:iq_mall/main.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../utils/ShColors.dart';
import '../../Cart_List_screen/controller/Cart_List_controller.dart';



class BottomButtons extends StatelessWidget {
  final Product product;

  const BottomButtons({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    RxBool addingToCard = false.obs;
    return Container(
      height: 70,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.transparent,
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
        color: Colors.white,
      ),
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 1, // Adjust flex ratio if needed
            child: Obx(() => InkWell(
              onTap: () {
                ProductDetails_screenController controller = Get.find();

                if(controller.loading.value){
                  toaster(Get.context!, 'Please wait to load the quantity'.tr);

                }
                else{
                  addingToCard.value = true;

                  controller.AddToCart(controller.product.value, '1',context).then((value) {
                    controller.product.value?.quantity = (int.parse(controller.product.value!.quantity!) + 1).toString();
                    addingToCard.value = false;
                    Future.delayed(Duration(milliseconds: 800)).then((value) {
                      Get.context!.read<Counter>().calculateTotal(0.0);
                      Cart_ListController Cartcontroller = Get.find();
                      Cartcontroller.GetCart();
                    });
                  });
                }
                // Add your tap logic here
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Button_color,
                  borderRadius: BorderRadius.circular(4), // Rounded corners
                ),
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 8), // Add some margin
                child: addingToCard.value
                    ? LoadingAnimationWidget.threeArchedCircle(color: MainColor, size: 25)
                    : Text(
                  product.product_qty_left < 1 ? 'Out Of Stock'.tr : 'ADD TO CART'.tr,
                  style: TextStyle(
                    color: button_text_color,
                    fontSize: 16.0,
                  ),
                ),
              ),
            )),
          ),
          Flexible(
            flex: 1, // Adjust flex ratio if needed
            child: InkWell(
              onTap: () {
                // Add your tap logic here
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4), // Rounded corners
                ),
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 8), // Add some margin
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Total Amount'.tr,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                      ),
                    ),
                    Text(
                      product.price_after_discount.toString() == 'null'
                          ? '$sign ${product.product_price.toString()}'
                          : '$sign ${product.price_after_discount!}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



// class BottomButtons extends StatelessWidget {
//
//   final Product product;
//
//   const BottomButtons({super.key, required this.product});
//
//
//   @override
//   Widget build(BuildContext context) {
//     RxBool addingToCard = false.obs;
//     return Container(
//       height: 70,
//       decoration: BoxDecoration(
//         boxShadow: [
//           BoxShadow(
//             color: MainColor.withOpacity(0.2), // Adjust opacity as needed
//             spreadRadius: 1, // Adjust spread radius as needed
//             blurRadius: 2, // Adjust blur radius as needed
//             offset: const Offset(0, 1), // Change position as needed
//           ),
//         ],
//         color: Colors.white,
//       ),
//       child: Row(
//         children: <Widget>[
//           Obx(() =>
//          addingToCard.value
//               ? Container(
//             width: MediaQuery.of(context).size.width * 0.5,
//             color: Button_color,
//             alignment: Alignment.center,
//             height: double.infinity,
//             child: LoadingAnimationWidget.threeArchedCircle(color: MainColor, size: 25),
//           )
//               :
//           product.product_qty_left < 1
//               ? Container(
//             width: MediaQuery
//                 .of(context)
//                 .size
//                 .width * 0.5,
//             color: Button_color,
//             alignment: Alignment.center,
//             height: double.infinity,
//             child: Text(
//               'Out Of Stock'.tr,
//               style: TextStyle(
//                 color: button_text_color,
//                 fontSize: 16.0,
//               ),
//             ),
//           )
//               : prefs!.getString('cart_btn') == '0' || product.cart_btn == 0
//               ? Container(
//             width: MediaQuery
//                 .of(context)
//                 .size
//                 .width * 0.5,
//             color: Button_color,
//             alignment: Alignment.center,
//             height: double.infinity,
//             child: Text(
//               ''.tr,
//               style: TextStyle(
//                 color: button_text_color,
//                 fontSize: 16.0,
//               ),
//             ),
//           )
//               : GestureDetector(
//             onTap: () async {
//               ProductDetails_screenController controller = Get.find();
//
//               if(controller.loading.value){
//                   toaster(Get.context!, 'Please wait to load the quantity'.tr);
//
//               }
//               else{
//                 addingToCard.value = true;
//
//                 controller.AddToCart(controller.product.value, '1').then((value) {
//                   controller.product.value?.quantity = (int.parse(controller.product.value!.quantity!) + 1).toString();
//                   addingToCard.value = false;
//                 });
//               }
//
//               // } else {
//               //   toaster(Get.context!, 'Maximum Quantity Reached'.tr);
//               // }
//             },
//             child: Container(
//               width: MediaQuery
//                   .of(context)
//                   .size
//                   .width * 0.5,
//               color: Button_color,
//               alignment: Alignment.center,
//               height: double.infinity,
//               child: Text(
//                 'ADD TO CART'.tr,
//                 style: TextStyle(
//                   color: button_text_color,
//                   fontSize: 16.0,
//                 ),
//               ),
//             ),
//           )
//           ),
//           Container(
//             width: MediaQuery
//                 .of(context)
//                 .size
//                 .width * 0.5,
//             color: Colors.white,
//             alignment: Alignment.center,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const SizedBox(),
//                 Column(
//                   children: [
//                     Text(
//                       'Total Amount'.tr,
//                       style: const TextStyle(
//                         color: Colors.black,
//                         fontSize: 12.0,
//                       ),
//                     ),
//                     Text(
//                       product.price_after_discount.toString() == 'null'
//                           ? '$sign ${product.product_price.toString()}'
//                           : '$sign ${product.price_after_discount!}',
//                       style: const TextStyle(
//                         color: Colors.black,
//                         fontSize: 16.0,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }