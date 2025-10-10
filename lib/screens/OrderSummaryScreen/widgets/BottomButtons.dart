import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/screens/OrderSummaryScreen/controller/OrderSummaryScreen_controller.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/cores/assets.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/main.dart';
import 'package:get/get.dart';
import 'package:iq_mall/widgets/ShWidget.dart';

class BottomButtonsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    OrderSummaryScreenController controller = Get.find();
    return Container(
      height: getSize(60),
      decoration: const BoxDecoration(
        boxShadow: [BoxShadow(color: sh_shadow_Color, blurRadius: 10, spreadRadius: 2, offset: Offset(0, 3))],
        color: sh_white,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Obx(
                  () {
                    return controller.paying_method.toString() == 'pickup'
                        ? Obx(
                            () => controller.coupon_percentage.value != 0.0
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                          "$sign${formatter.format(double.parse((Get.context!.read<Counter>().calculateTotal(controller.coupon_percentage.value) + (globalController.sum.value)).toString()))}",
                                          style: const TextStyle(fontSize: 20, color: Colors.black)),
                                    ],
                                  )
                                : Text(
                                    "$sign ${formatter.format(double.parse((double.parse(total!.value.toString())).toString()))} ",
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                          )
                        : Obx(
                            () => controller.coupon_percentage.value != 0.0
                                ? Obx(() => controller.coupon_percentage.value != 0.0
                                    ? Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                              "$sign${formatter.format(double.parse((Get.context!.read<Counter>().calculateTotal(controller.coupon_percentage.value) + (globalController.sum.value)).toString()))}",
                                              style: const TextStyle(fontSize: 20, color: Colors.black)),
                                        ],
                                      )
                                    : Container())
                                : Obx(() => Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                            "$sign ${(double.parse(Get.context!.read<Counter>().calculateTotal(0.0).toString()) + globalController.sum.value).toString()}",
                                            style: const TextStyle(fontSize: 20, color: Colors.black)),
                                      ],
                                    )),
                          );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: InkWell(
              child: Container(
                color: MainColor,
                alignment: Alignment.center,
                height: double.infinity,
                child: Text(
                  "Confirm Order".tr,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                ),
              ),
              onTap: () async {
                if (controller.agreement_accepted.value) {
                  if (controller.paying_method!.value == 'none') {
                    toaster(context, 'Choose paying method first'.tr);
                  } else if (controller.paying_method!.value == 'Wallet') {
                    if (total!.value > balance!.value) {
                      toaster(context, 'No enough balance to proceed'.tr);
                    } else {
                      controller.Checkout();
                    }
                  } else {
                    controller.Checkout();
                  }
                } else {
                  toaster(context, 'Accept privacy policy first'.tr);
                }
                //  controller.OrderConfirmation();
              },
            ),
          )
        ],
      ),
    );
  }
}
