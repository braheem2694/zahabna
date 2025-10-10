import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/screens/OrderSummaryScreen/controller/OrderSummaryScreen_controller.dart';
import 'package:iq_mall/screens/OrderSummaryScreen/widgets/BottomButtons.dart';
import 'package:iq_mall/screens/OrderSummaryScreen/widgets/PaymentDetails.dart';
import 'package:iq_mall/screens/OrderSummaryScreen/widgets/PaymentMethodsWidets/PaymentMethodsWidget.dart';
import 'package:iq_mall/screens/OrderSummaryScreen/widgets/shippingaddress.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/cores/assets.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/utils/ShConstant.dart';
import 'package:iq_mall/utils/ShImages.dart';
import 'package:iq_mall/widgets/CommonWidget.dart';
import 'package:iq_mall/main.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart' as htmlparser;
import 'package:iq_mall/widgets/ui.dart';

import '../../widgets/ShWidget.dart';
import '../../widgets/image_widget.dart';
import '../Cart_List_screen/controller/Cart_List_controller.dart';
import '../Cart_List_screen/widgets/continue_button.dart';

class OrderSummaryScreen extends GetView<OrderSummaryScreenController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar('Order Summary'.tr),
      body: IgnorePointer(
        ignoring: controller.ordering.value,
        child: Obx(() => !controller.loading.value && !controller.loadingall.value
            ? Stack(
                alignment: Alignment.bottomLeft,
                children: <Widget>[
                  SingleChildScrollView(
                    controller: controller.summaryController,
                    child: Padding(
                      padding: getPadding(bottom: getSize(70)),
                      child: Column(
                        children: <Widget>[
                          ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: cartlist!.length,
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(bottom: spacing_standard_new),
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                  ),
                                  margin: const EdgeInsets.only(left: spacing_standard_new, right: spacing_standard_new, top: spacing_standard_new),
                                  child: IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        mediaWidget(
                                          cartlist![index].main_image.toString(),
                                          AssetPaths.placeholder,
                                          height: getSize(120),
                                          width: getSize(120),
                                          fromKey: "",
                                          fit: BoxFit.cover,
                                        ),
                                        // CachedNetworkImage(
                                        //   fit: BoxFit.cover,
                                        //   height: 120,
                                        //   width: 120,
                                        //   imageUrl: cartlist!.value[index].main_image.toString(),
                                        //   placeholder: (context, url) => Container(
                                        //     width: 120.0,
                                        //     height: 120.0,
                                        //     child: Container(
                                        //       width: 120.0,
                                        //       height: 120.0,
                                        //       color: Colors.grey,
                                        //     ),
                                        //   ),
                                        //   errorWidget: (context, url, error) => Image.asset(AssetPaths.ic_app_background),
                                        // ),
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    const SizedBox(
                                                      height: spacing_standard,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 16.0, bottom: 2, right: 16),
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: <Widget>[
                                                          Text(
                                                            "$sign ${cartlist![index].product_price}",
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              color: sh_textColorPrimary,
                                                              fontSize: 16,
                                                              decoration: cartlist![index].sales_discount != null ? TextDecoration.lineThrough : TextDecoration.none,
                                                            ),
                                                          ),
                                                          cartlist![index].sales_discount.toString() == 'null'
                                                              ? const SizedBox()
                                                              : Padding(
                                                                  padding: const EdgeInsets.only(left: 16.0, right: 16),
                                                                  child: Text(
                                                                    "$sign ${cartlist![index].price_after_discount}",
                                                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                                                  ),
                                                                )
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 16.0, bottom: 2, right: 16),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "${'Quantity'.tr}:",
                                                            style: const TextStyle(
                                                              fontSize: 15,
                                                            ),
                                                          ),
                                                          Text(
                                                            " ${cartlist!.value[index].quantity}${" PCE".tr}",
                                                            style: const TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 15,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    cartlist![index].shipping_cost != null && prefs!.getString('has_shipping') == '1'
                                                        ? cartlist!.value[index].free_shipping.toString() != '1'
                                                            ? Padding(
                                                                padding: const EdgeInsets.only(left: 15.0, bottom: 5),
                                                                child: Row(
                                                                  children: [
                                                                    Obx(() => Text(
                                                                        "${'Shipping'.tr} ${sign.value}${formatter.format(double.parse(cartlist![index].shipping_cost.toString()) * int.parse(cartlist!.value[index].multi_shipping.toString() == '1' ? cartlist!.value[index].quantity.toString() : '1'))}")),
                                                                  ],
                                                                ),
                                                              )
                                                            : Padding(
                                                                padding: const EdgeInsets.only(left: 15.0, bottom: 5),
                                                                child: Row(
                                                                  children: [
                                                                    Obx(() => const Text("Free Shipping")),
                                                                  ],
                                                                ),
                                                              )
                                                        : Container(),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 16.0, bottom: 2, right: 16),
                                                      child: cartlist!.value[index].sales_discount.toString() == 'null'
                                                          ? Text(
                                                              "${'Total: '.tr}$sign ${formatter.format(double.parse(cartlist!.value[index].product_price.toString()) * int.parse(cartlist!.value[index].quantity!))}",
                                                              style: const TextStyle(
                                                                color: sh_textColorPrimary,
                                                                fontSize: 15,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            )
                                                          : cartlist!.value[index].boolean_percent_discount == 1
                                                              ? Text(
                                                                  "${"Total: ".tr}$sign ${formatter.format(double.parse((((double.parse(cartlist!.value[index].product_price.toString()) - ((double.parse(cartlist!.value[index].sales_discount.toString()) * double.parse(cartlist!.value[index].product_price.toString()) / 100))) * double.parse(cartlist!.value[index].quantity.toString())).toString())))}",
                                                                  style: const TextStyle(
                                                                    color: sh_textColorPrimary,
                                                                    fontSize: 15,
                                                                  ),
                                                                )
                                                              : Text(
                                                                  "${"Total: ".tr}$sign ${formatter.format(double.parse(((((double.parse(cartlist!.value[index].product_price.toString()) - (double.parse(cartlist!.value[index].sales_discount.toString()))) * double.parse(cartlist!.value[index].quantity.toString())).toString()))))}",
                                                                  style: const TextStyle(color: sh_textColorPrimary, fontSize: 16, fontWeight: FontWeight.bold),
                                                                ),
                                                    ),
                                                    cartlist![index].variations?.isEmpty ?? true
                                                        ? Container()
                                                        : SizedBox(
                                                            height: getSize(25),
                                                            width: getHorizontalSize(200),
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(left: 15.0),
                                                              child: ListView.separated(
                                                                scrollDirection: Axis.horizontal, // to scroll items in one line (horizontally)
                                                                itemCount: cartlist![index].variations?.length ?? 0,
                                                                itemBuilder: (context, index2) {
                                                                  final variation = cartlist![index].variations![index2];

                                                                  if (variation.is_color == 1) {
                                                                    return Row(
                                                                      children: [
                                                                        Text('${variation.type}: '),
                                                                        Container(
                                                                          width: 25,
                                                                          margin: const EdgeInsets.all(8.0),
                                                                          decoration: BoxDecoration(
                                                                            color: Color(int.parse(variation.color!.substring(1), radix: 16) + 0xFF000000),
                                                                            borderRadius: BorderRadius.circular(10.0), // This will round the container
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  } else {
                                                                    return Row(
                                                                      children: [
                                                                        Text('${variation.type}: '),
                                                                        Container(
                                                                          margin: const EdgeInsets.only(left: 8, right: 8),
                                                                          child: Text(
                                                                            variation.name!,
                                                                            style: const TextStyle(fontSize: 18),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  }
                                                                },
                                                                separatorBuilder: (context, index) {
                                                                  return const VerticalDivider(
                                                                    width: 5.0, // adjust width as necessary
                                                                    color: Colors.black,
                                                                    indent: 5.0,
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 16.0, bottom: 2),
                                                      child: Text(
                                                        cartlist![index].product_name??"",
                                                        style: const TextStyle(color: sh_textColorPrimary, fontWeight: FontWeight.bold, fontSize: 16),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                          ShippingAddressWidget(),
                          PaymentDetailWidget(
                            controller: controller,
                          ),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: SingleChildScrollView(
                                      // Add this
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Icon(
                                                  Icons.clear,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Container()
                                            ],
                                          ),
                                          Text(
                                            "Terms and conditions".tr,
                                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                          ),
                                          const Divider(),
                                          Text(convertHtmlToPlainText(prefs!.getString('terms_conditions') ?? '').toString()),
                                          Text(
                                            "Privacy Policy".tr,
                                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                          ),
                                          const Divider(),
                                          Text(convertHtmlToPlainText(prefs!.getString('privacy_policy') ?? '').toString()),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              controller.agreement_accepted.value = !controller.agreement_accepted.value;
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 8.0),
                                              child: Row(
                                                children: [
                                                  Obx(() {
                                                    return controller.agreement_accepted.value
                                                        ? const Icon(
                                                            Icons.check_box_rounded,
                                                            color: Colors.green,
                                                          )
                                                        : Icon(
                                                            Icons.check_box_outline_blank,
                                                            color: MainColor,
                                                          );
                                                  }),
                                                  Text(
                                                    'I have read and accept'.tr,
                                                    style: TextStyle(color: MainColor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Obx(() => Container(
                                            decoration: BoxDecoration(
                                              color: controller.agreement_accepted.value ? Colors.green : Colors.grey, // filled color
                                              borderRadius: BorderRadius.circular(15.0), // rounded corners
                                            ),
                                            child: TextButton(
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors.white, padding: EdgeInsets.all(16.0), // Padding inside the button
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(15.0),
                                                ), // Matches the borderRadius of Container for consistent appearance
                                              ),
                                              child: Text(
                                                'OK'.tr,
                                                style: TextStyle(color: Colors.white), // Adjust text color to contrast with background
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          )),
                                    ],
                                  );
                                },
                              );
                              // PolicyDialog().showPolicyDialog(context);
                            },
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Obx(() {
                                  return

                                      // AnimatedBuilder(
                                      //   animation: controller.policyAlert.value ? ColorTween(begin: Colors.black, end: Colors.white).animate(
                                      //     CurvedAnimation(
                                      //       parent: controller.policyAnimationController,
                                      //       curve: Curves.easeInOut,
                                      //     ),
                                      //   ) : ColorTween(begin: Colors.white, end: Colors.black).animate(
                                      //     CurvedAnimation(
                                      //       parent: controller.policyAnimationController,
                                      //       curve: Curves.easeInOut,
                                      //     ),
                                      //
                                      //   ),
                                      //   builder: (context, child) {
                                      //     return Container(
                                      //       width: getFontSize(165),
                                      //       decoration: BoxDecoration(
                                      //         borderRadius: BorderRadius.circular(10),
                                      //         color: controller.policyAlert.value ? Colors.red : Colors.transparent,
                                      //       ),
                                      //       child: Row(
                                      //         children: [
                                      //           controller.agreement_accepted.value == true
                                      //               ? const Icon(
                                      //             Icons.check_box_rounded,
                                      //             color: Colors.green,
                                      //           )
                                      //               : Icon(
                                      //             Icons.check_box_outline_blank,
                                      //             color: MainColor,
                                      //           ),
                                      //           Expanded(
                                      //             child: Obx(() {
                                      //               return Text(
                                      //                 'Press to accept policy'.tr,
                                      //                 overflow: TextOverflow.ellipsis,
                                      //                 style: TextStyle(color: controller.policyAlert.value ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
                                      //               );
                                      //             }),
                                      //           ),
                                      //         ],
                                      //       ),
                                      //     );
                                      //   },
                                      // );

                                      AnimatedContainer(
                                    width: getSize(175),
                                    decoration: BoxDecoration(color: controller.policyAlert.value ? Colors.red[300] : Colors.transparent, borderRadius: BorderRadius.circular(10)),
                                    duration: Duration(milliseconds: 400),
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Row(
                                        children: [
                                          controller.agreement_accepted.value == true
                                              ? const Icon(
                                                  Icons.check_box_rounded,
                                                  color: Colors.green,
                                                )
                                              : Obx(() {
                                                  return Icon(
                                                    Icons.check_box_outline_blank,
                                                    color: controller.policyAlertText.value ? Colors.white : ColorConstant.logoFirstColor,
                                                  );
                                                }),
                                          Expanded(
                                            child: Padding(
                                              padding: getPadding(right: 8.0),
                                              child: Obx(() {
                                                return Text(
                                                  'Press to accept policy'.tr,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(color: controller.policyAlertText.value ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
                                                );
                                              }),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                          PaymentMethodsWidget(
                            controller: controller.summaryController,
                          ),
                        ],
                      ),
                    ),
                  ),
                  controller.ordering.value
                      ? Center(
                          child: Padding(
                          padding: EdgeInsets.only(top: Get.height / 2),
                          child: Column(
                            children: [
                              Container(
                                  width: 100,
                                  height: 100,
                                  child: Image.asset(
                                    'assets/images/loader2.gif',
                                    color: MainColor,
                                  )),
                              Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: Text(
                                  '',
                                  style: TextStyle(color: MainColor, fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ))
                      : const SizedBox(),
                  controller.checking_data
                      ? Center(
                          child: Padding(
                          padding: const EdgeInsets.only(top: 250.0),
                          child: Column(
                            children: [
                              Container(
                                  width: 100,
                                  height: 100,
                                  child: Image.asset(
                                    'assets/images/loader2.gif',
                                    color: MainColor,
                                  )),
                              Container(
                                height: 30,
                                color: Colors.grey,
                                child: Text(
                                  'Checking data for updates'.tr,
                                  style: TextStyle(color: MainColor, fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ))
                      : const SizedBox(),
                  SizedBox(
                    height: getSize(70),
                    child: Padding(
                      padding: getPadding(
                          bottom: getSize(
                            20,
                          ),
                          right: 24,
                          left: 24),
                      child: Row(
                        children: [
                          ContinueButtonWidget(
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
                                controller.summaryController.animateTo(
                                  controller.summaryController.position.maxScrollExtent,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );

                                if (!Get.isSnackbarOpen) {
                                  Get.snackbar("Alert".tr, 'Accept privacy policy first'.tr,
                                      snackPosition: SnackPosition.TOP, colorText: ColorConstant.white, backgroundColor: ColorConstant.logoSecondColor);
                                  controller.policyAlert.value = true;
                                  controller.policyAlertText.value = true;
                                  Future.delayed(Duration(seconds: 1)).then((value) {
                                    controller.policyAlert.value = false;
                                  });
                                  Future.delayed(Duration(milliseconds: 1400)).then((value) {
                                    controller.policyAlertText.value = false;
                                  });
                                }

                                // toaster(context, 'Accept privacy policy first'.tr);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            : Ui.circularIndicator()),
      ),
    );
  }
}

String convertHtmlToPlainText(String htmlText) {
  var document = htmlparser.parse(htmlText);
  return document.body!.text;
}
