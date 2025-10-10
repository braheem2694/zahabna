import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/routes/app_routes.dart';
import 'package:iq_mall/utils/ShImages.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import '../../../Product_widget/Product_widget.dart';
import '../../../main.dart';
import '../../../utils/ShColors.dart';
import '../../../widgets/ViewAllButton.dart';
import '../../../widgets/image_widget.dart';
import '../controller/Home_screen_fragment_controller.dart';

class BrandsWidget extends StatefulWidget {
  const BrandsWidget({Key? key}) : super(key: key);

  @override
  _BrandsWidgetState createState() => _BrandsWidgetState();
}

class _BrandsWidgetState extends State<BrandsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        globalController.homeDataList.value.brands!.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 15, right: 15, bottom: 15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Top Brands'.tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        CustomButton(
                          onTap: () {
                            Get.toNamed(AppRoutes.BrandScreen);
                          },
                          label: 'View All'.tr,
                          color: MainColor.withOpacity(0.9),
                        )
                      ],
                    ),
                  ],
                ),
              )
            : Container(),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Wrap(
            spacing: 10.0,
            runSpacing: 10.0,
            children: List.generate(globalController.homeDataList.value.brands!.length, (index) {
              var brands = globalController.homeDataList.value.brands!;
              return SizedBox(
                width: getHorizontalSize(175),
                child: InkWell(
                  onTap: () {
                    var f = {
                      "flash_sales": [
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
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0),
                          ),
                          child: mediaWidget(
                            brands[index].main_image.toString(),
                            AssetPaths.placeholder,
                            height: getSize(200)!,
                            width: Get.size.width, // Adjust width if necessary
                            fromKey: "",
                            isProduct: false,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
