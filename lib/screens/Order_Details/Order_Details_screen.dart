import 'package:iq_mall/main.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/screens/Order_Details/widgets/items.dart';
import 'package:iq_mall/screens/Order_Details/widgets/orderStatus.dart';
import 'package:iq_mall/screens/Order_Details/widgets/paymentDetail.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/utils/ShConstant.dart';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'package:iq_mall/widgets/CommonWidget.dart';
import 'controller/Order_Details_controller.dart';

class OrderDetailsscreen extends GetView<Order_DetailsController> {
  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(Get.context!);
    print(myLocale.countryCode); // To get country code
    print(myLocale.languageCode); // To get language code

    return Scaffold(
        appBar: CommonAppBar('Order Details'.tr),
        body: Obx(() => controller.loading.value
            ? Align(alignment: Alignment.center, child: Progressor_indecator())
            : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    OrderStatusWidget(),
                    PaymentDetailsWidget(),
                    const SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 18.0),
                      child: Container(
                        margin: const EdgeInsets.only(
                          left: spacing_standard_new,
                          right: spacing_standard_new,
                          top: spacing_standard_new,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0), // Optional
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5), // this is the shadow color
                              spreadRadius: 5, // Spread the shadow
                              blurRadius: 7, // Blur the shadow
                              offset: Offset(0, 3), // Position of shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            spacing_standard_new,
                            spacing_middle,
                            spacing_standard_new,
                            spacing_middle,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                prefs!.getString("store_name")!,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      'Order ID'.tr,
                                      style: TextStyle(color: MainColor, fontSize: 17),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      "#" + controller.order.id,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: MainColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      'Phone Number'.tr,
                                      style: TextStyle(color: MainColor, fontSize: 17),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      controller.order.address_phone_number,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: MainColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      'Payment Type'.tr,
                                      style: TextStyle(color: MainColor, fontSize: 17),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      controller.order.payment_type_name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: MainColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(
                                height: 1,
                                color: sh_view_color,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Obx(() {
                      return controller.loading.value
                          ? Container()
                          : ItemWidget();
                    }),
                  ],
                ),
              )));
  }
}
