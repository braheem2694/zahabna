import 'package:iq_mall/screens/Orders_list_screen/controller/Orders_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/screens/Orders_list_screen/widgets/OrdersListView.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/widgets/CommonWidget.dart';
import 'package:get/get.dart';
import 'package:iq_mall/utils/ShImages.dart';
import 'package:iq_mall/models/orders.dart';

class Orders_list_screen extends GetView<Orders_list_Controller> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar('My Orders'.tr),
        body: Obx(() => controller.loading.value
            ? Center(
          child: Progressor_indecator(),
        )
            : Obx(
              () => !controller.loading.value && orderslist.isNotEmpty
              ? Container(

                  width: MediaQuery.of(context).size.width, child: OrderListView())
              : Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Image.asset(AssetPaths.emptyorder_image)),
                ],
              ),
            ),
          ),
        )));
  }
}
