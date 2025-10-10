import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:iq_mall/screens/bill_screen/controller/bill_controller.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/screens/bill_screen/widgets/PaymentDetailsSection.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/main.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iq_mall/utils/ShImages.dart';
import 'package:iq_mall/widgets/ui.dart';
import 'package:progressive_image/progressive_image.dart';

import '../../Product_widget/Product_widget.dart';
import '../../cores/math_utils.dart';
import '../../routes/app_routes.dart';
import '../../widgets/CommonWidget.dart';
import '../Home_screen_fragment/controller/Home_screen_fragment_controller.dart';
import 'controller/BrandsScreen_controller.dart';

class BrandsScreen extends GetView<BrandsScreenController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar('Our brands'.tr),
      body: Obx(
        () => SingleChildScrollView(
          controller: controller.ScrollListener.value,
          key: UniqueKey(),
          physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 16),
              child: Obx(
                () => controller.loading.value
                    ? SizedBox(height: Get.height, child: Center(child: Ui.circularIndicator(color: MainColor)))
                    : controller.brands.isNotEmpty
                        ? Column(
                            children: [
                              Obx(()=>
                                  GridView.builder(
                                    shrinkWrap: true,
                                    // Important to keep within a Column
                                    physics: NeverScrollableScrollPhysics(),
                                    // Since it's inside a SingleChildScrollView
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: (MediaQuery.of(context).size.width * 0.44) / getVerticalSize(160),
                                    ),
                                    itemCount: controller.brands.length,
                                    itemBuilder: (context, index) {
                                      var brands =controller.brands;
                                      return InkWell(
                                        onTap: () {
                                          // Your onTap functionality
                                        },
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.44,
                                              child: InkWell(
                                                onTap: () {
                                                  var f = {
                                                    "brands": [
                                                      brands[index].id.toString(),
                                                    ],
                                                  };
                                                  String jsonString = jsonEncode(f);

                                                  Get.toNamed(AppRoutes.View_All_Products, arguments: {
                                                    'title': brands[index].brandName.toString(),
                                                    'id': brands[index].id.toString(),
                                                    'type': jsonString,
                                                  });
                                                },
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      decoration: const BoxDecoration(
                                                          borderRadius: BorderRadius.only(
                                                            topLeft: Radius.circular(8.0),
                                                            topRight: Radius.circular(8.0),
                                                            bottomLeft: Radius.circular(8.0),
                                                            bottomRight: Radius.circular(8.0),
                                                          ),
                                                          color: Colors.transparent),
                                                      child: ClipRRect(
                                                        borderRadius: const BorderRadius.only(
                                                          topLeft: Radius.circular(8.0),
                                                          topRight: Radius.circular(8.0),
                                                          bottomLeft: Radius.circular(8.0),
                                                          bottomRight: Radius.circular(8.0),
                                                        ),
                                                        child: Stack(
                                                          children: [
                                                            ProgressiveImage(
                                                              placeholder: const AssetImage(AssetPaths.placeholder),

                                                              // size: 1.87KB
                                                              thumbnail: CachedNetworkImageProvider(
                                                                convertToThumbnailUrl(brands[index].main_image ?? '', isBlurred: true),
                                                                errorListener: (p0) {},
                                                              ),
                                                              blur: 0,
                                                              // size: 1.29MB
                                                              image: CachedNetworkImageProvider(convertToThumbnailUrl(brands[index].main_image ?? '', isBlurred: false)),
                                                              height: getVerticalSize(160),
                                                              width: Get.size.width,
                                                              fit: BoxFit.cover,

                                                              fadeDuration: Duration(milliseconds: 200),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  )
                              ),
                              Obx(() => controller.loadingMore.value ? Ui.circularIndicator(color: MainColor) : const SizedBox())
                            ],
                          )
                        : Center(
                            child: Text(
                            'Brands List is Empty',
                            style: TextStyle(color: Button_color, fontSize: 23, fontWeight: FontWeight.bold),
                          )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
