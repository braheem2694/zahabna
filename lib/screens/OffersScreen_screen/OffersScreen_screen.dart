import 'package:iq_mall/Product_widget/Product_widget.dart';

import 'package:iq_mall/screens/OffersScreen_screen/controller/OffersScreen_controller.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/widgets/CommonWidget.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iq_mall/main.dart';

import '../../cores/math_utils.dart';

class OffersScreen extends GetView<OffersScreenController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar(controller.offer == '1' ? 'My Offers'.tr : 'Stores'.tr),
        body: SingleChildScrollView(
          controller: controller.ScrollListener,
          child: Obx(() => controller.loading.value
              ? Center(
                  child: Progressor_indecator(),
                )
              : !controller.loading.value && controller.MyOffers!.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 180.0),
                      child: Center(
                        child: Column(
                          children: [
                            SVG('assets/icons/Empty_cart_icon.svg', 150, 150, Colors.grey),
                            Text(
                              'No offers available'.tr,
                              style: TextStyle(color: Colors.grey, fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Center(
                    child: Wrap(
                      spacing: 10.0,
                      runSpacing: 10.0,
                      children: List.generate(controller.MyOffers!.length, (index) {
                        return ProductWidget(
                          product: controller.MyOffers![index],
                        );
                      }),
                    ),
                  )),
        ));
  }
}
