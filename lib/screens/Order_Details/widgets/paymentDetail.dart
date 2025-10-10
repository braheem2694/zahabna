import 'package:iq_mall/main.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/cores/assets.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/utils/ShConstant.dart';
import '../controller/Order_Details_controller.dart';

class PaymentDetailsWidget extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    Order_DetailsController controller = Get.find();

    return Container(
      margin: const EdgeInsets.only(
        left: spacing_standard_new,
        right: spacing_standard_new,
        top: spacing_standard_new,
      ),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),  // Optional
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // this is the shadow color
            spreadRadius: 5,  // Spread the shadow
            blurRadius: 7,   // Blur the shadow
            offset: Offset(0, 3), // Position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(
              spacing_standard_new,
              spacing_middle,
              spacing_standard_new,
              4,
            ),
            child: Text(
              'Payment Details'.tr,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(
            height: 1,
            color: sh_view_color,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              spacing_standard_new,
              0,
              spacing_standard_new,
              spacing_middle,
            ),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: spacing_standard,
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "${'Amount'.tr}:",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: textSizeLargeMedium,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        " \$${formatter.format(
                            ((double.parse(controller.order.total) * (1 - (double.parse(controller.order.discount ?? '0') / 100))) )
                        )}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: textSizeLargeMedium,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "${'Delivery & shipping Amount'.tr}:",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: textSizeLargeMedium,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        " $sign${formatter
                                .format(
                              double.parse(
                                  ((double.parse(
                                      controller.order.shipping_amount.toString())))
                                      .toString(),

                              ),
                            )}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: textSizeLargeMedium,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Total'.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: textSizeLargeMedium,
                          color: Colors.black,
                        ),
                      ),

                      Text(
                        " \$${formatter.format(
                            ((double.parse(controller.order.total) * (1 - (double.parse(controller.order.discount ?? '0') / 100))) + controller.order.shipping_amount)
                        )}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: textSizeLargeMedium,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                )

              ],
            ),
          ),
        ],
      ),
    );
  }
}

