import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iq_mall/models/category.dart';
import 'package:iq_mall/utils/ShImages.dart';
import 'package:iq_mall/widgets/custom_image_view.dart';
import '../../../cores/math_utils.dart';
import '../../../main.dart';
import 'package:flutter/material.dart';

import '../../../models/HomeData.dart';
import '../../../utils/ShColors.dart';
import '../controller/store_detail_controller.dart';

// ignore: must_be_immutable
class storeCategory extends StatelessWidget {
  final Category model;

  var controller = Get.find<StoreDetailController>();

  storeCategory({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getHorizontalSize(
        90.00,
      ),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 1,color: ColorConstant.logoSecondColor)

      ),
      padding: getPadding(all: 3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: getPadding(
              top: 0,
              bottom: 4,
            ),
            child: ClipRRect(
              borderRadius:BorderRadius.circular(5),
              child: CustomImageView(
                image: model.main_image,
                // imagePath: AssetPaths.placeholder,
                placeHolder: AssetPaths.placeholder,
                borderRadius:BorderRadius.circular(5),
                fit: BoxFit.cover,
                width: getHorizontalSize(  90.00),
                height: Get.height*0.09,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: getPadding(left: 4,right: 4),

                child: Text(model.categoryName??"",
                  maxLines: 3,
                  textDirection: TextDirection.rtl,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: getFontSize(14)),
                ),
              ),
            ),
          ),

          // Text(model.title??"",
          //   maxLines: 2,
          // )

        ],
      ),
    );
  }
}
