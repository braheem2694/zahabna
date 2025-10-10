import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/utils/ShConstant.dart';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'package:iq_mall/main.dart';
import 'package:get/get.dart';
import 'package:iq_mall/screens/OrderSummaryScreen/controller/OrderSummaryScreen_controller.dart';
import 'package:iq_mall/widgets/ui.dart';
import '../../../cores/assets.dart';
import '../../Cart_List_screen/controller/Cart_List_controller.dart';
import 'package:iq_mall/main.dart';

class PaymentDetailWidget extends StatelessWidget {
  final OrderSummaryScreenController controller;

  const PaymentDetailWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(spacing_standard_new),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10), // Match the border radius with the card
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("${'Order Summary'.tr} ", style: TextStyle(fontSize: getFontSize(textSizeLargeMedium), color: Colors.black, fontWeight: FontWeight.w700)),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: spacing_middle),
              child: Column(children: <Widget>[
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("${'Total items'.tr} ", style: TextStyle(fontSize: getFontSize(20), color: Colors.black)),
                        Text(
                          cartlist!.fold<int>(0, (sum, item) => sum + int.parse(item.quantity!)).toString(),
                          style: const TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ],
                    )),
                Divider(),
                SizedBox(height: 2),
                // Add spacing
                prefs!.getString('has_shipping') == '1'
                    ? Obx(
                        () {
                          return controller.paying_method.toString() == 'pickup'
                              ? const SizedBox()
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('Shipping'.tr, style: const TextStyle(fontSize: 20, color: Colors.black)),
                                    Text("${sign.value}${formatter.format(globalController.sum.value)}", style: const TextStyle(fontSize: 20, color: Colors.black)),
                                  ],
                                );
                        },
                      )
                    : Container(),
                const SizedBox(height: spacing_standard),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Delivery'.tr, style: const TextStyle(fontSize: 20, color: Colors.black)),
                    Text("${sign.value}${formatter.format(double.parse(prefs!.getString('delivery_cost')!))}", style: const TextStyle(fontSize: 20, color: Colors.black)),
                  ],
                ),
                const SizedBox(height: spacing_standard),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Total Shipment'.tr, style: const TextStyle(fontSize: 20, color: Colors.black)),
                    Text("${sign.value}${formatter.format(double.parse(prefs!.getString('delivery_cost')!) + globalController.sum.value)}", style: const TextStyle(fontSize: 20, color: Colors.black)),
                  ],
                ),
                const Divider(color: Colors.black, endIndent: 2, thickness: 0.6),
                Obx(
                  () {
                    return controller.coupon_percentage.toString() == '0.0'
                        ? const SizedBox()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Coupon code %'.tr, style: const TextStyle(fontSize: 20, color: Colors.black)),
                              Text("${controller.coupon_percentage}${'%'}", style: const TextStyle(fontSize: 20, color: Colors.black)),
                            ],
                          );
                  },
                ),
                controller.coupon_percentage.toString() == '0.0' ? Container() : Divider(color: Colors.black, endIndent: 2, thickness: 0.6),
                // Add spacing
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Sub Total Amount '.tr, style: const TextStyle(fontSize: 20, color: Colors.black)),
                        Text("$sign${(globalController.result.value - (double.parse(prefs!.getString('delivery_cost')!) + globalController.sum.value)).toDouble().floor()}",
                            style: const TextStyle(fontSize: 20, color: Colors.black)),
                      ],
                    )),
                const SizedBox(height: spacing_standard),
                // Add spacing
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Total Amount + shipment'.tr, style: const TextStyle(fontSize: 20, color: Colors.black)),
                    Obx(() => Text(controller.total.value, style: const TextStyle(fontSize: 20, color: Colors.black))),
                  ],
                ),

                const SizedBox(height: spacing_standard),
                // Add spacing

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Discounted Total Amount'.tr, style: const TextStyle(fontSize: 20, color: Colors.black)),
                    Obx(() => Text("$sign${(double.parse(globalController.result.value.toString()) + double.parse((globalController.sum.value.toString())))}",
                        style: const TextStyle(fontSize: 20, color: Colors.black))),
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 16),
                    child: Row(children: [
                      Expanded(
                        child: Container(
                          height: 50.0, // You can adjust this height as needed
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5.0),
                              bottomLeft: Radius.circular(5.0),
                            ),
                            border: Border.all(
                              color: Colors.grey, // You can adjust the border color as needed
                              width: 1.0,
                            ),
                          ),
                          child: Center(
                            child: TextFormField(
                              controller: controller.couponCode,
                              decoration: InputDecoration(
                                labelText: 'Enter coupon code'.tr,
                                border: InputBorder.none, // Remove the default border
                                contentPadding: const EdgeInsets.only(left: 10, top: 8, bottom: 10), // Adjust padding as needed
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50.0, // Same height as the TextFormField
                        child: ElevatedButton(
                          onPressed: () {
                            if (!controller.applyingCouponCode.value) {
                              controller.ApplyCouponCode(controller.couponCode.text.toString());
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Button_color, // Assuming Button_color is a defined color
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(5),
                              ),
                            ),
                          ),
                          child: Obx(() => !controller.applyingCouponCode.value
                              ? SizedBox(width: getSize(60), child: Text('Apply'.tr, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)))
                              : SizedBox(width: getSize(60), child: Ui.circularIndicator())),
                        ),
                      ),
                    ]))
              ]),
            )
          ],
        ),
      ),
    );
  }
}
