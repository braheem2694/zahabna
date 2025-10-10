import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:iq_mall/screens/View_all_Products_screen/widgets/Listview.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/widgets/CommonWidget.dart';
import 'controller/View_all_Products_controller.dart';

class View_all_Productsscreen extends GetView<View_all_ProductsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(controller.title),
      body: Container(
        decoration: BoxDecoration(
          gradient: controller.flashSale != null
              ? LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(int.parse(controller.flashSale!.color1.replaceFirst('#', '0xff'))),
                    Color(int.parse(controller.flashSale!.color2.replaceFirst('#', '0xff'))),
                    Color(int.parse(controller.flashSale!.color3.replaceFirst('#', '0xff')))
                  ],
                  stops: const [0.0, 0.5, 1.0],
                )
              : null, // Or provide a default gradient or another fallback here
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 4.0,
                right: 4,
              ),
              child: ListView(
                controller: controller.scrollController,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: [
                  Obx(
                    () => !controller.loading.value
                        ? Row(
                            children: [Expanded(child: CustomListView())],
                          )
                        : Container(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                    child: Obx(
                      () => controller.loader.value ? Progressor_indecator() : Container(),
                    ),
                  ),
                ],
              ),
            ),
            Obx(
              () => !controller.loading.value
                  ? Container()
                  : Align(
                      alignment: Alignment.center,
                      child: Progressor_indecator(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
