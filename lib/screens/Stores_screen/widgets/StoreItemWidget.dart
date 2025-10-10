
import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:iq_mall/routes/app_routes.dart';
import 'package:iq_mall/screens/Stores_screen/widgets/my_store_widget.dart';
import 'package:iq_mall/widgets/custom_image_view.dart';
import 'package:iq_mall/widgets/ui.dart';
import 'package:photo_view/photo_view.dart';

import '../../../cores/math_utils.dart';
import '../../../utils/ShColors.dart';
import '../../../utils/ShImages.dart';


class StoreItemWidget extends StatelessWidget {
  final String storeName;
  final String mainImage;

  StoreItemWidget({required this.storeName, required this.mainImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getVerticalSize(100),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey[200]!),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: ColorConstant.black900.withOpacity(0.15),
            blurRadius: 4.0,
            spreadRadius: 0.0,
            offset: const Offset(0, 3.0),
          ),
        ],
      ),
      width: getHorizontalSize(175),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.bottomRight,
                colors: [
                  ColorConstant.logoSecondColor.withOpacity(0.4),
                  ColorConstant.logoSecondColor.withOpacity(0.6),
                  ColorConstant.logoSecondColor.withOpacity(0.9),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(7),
                topRight: Radius.circular(7),
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 3),
                child: Text(
                  storeName,
                  style: TextStyle(
                    color: ColorConstant.logoFirstColor.withOpacity(0.7),
                    fontWeight: FontWeight.w700,
                    fontSize: getFontSize(18),
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          CustomImageView(
            image: mainImage.isNotEmpty ? mainImage : AssetPaths.placeholder,
            placeHolder: AssetPaths.placeholder,
            height: getVerticalSize(100),
            width: Get.width * 0.25,
            fit: BoxFit.cover,
          ),
          const Spacer(),
          Container(
            width: getHorizontalSize(190),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.bottomRight,
                colors: [
                  ColorConstant.logoSecondColor.withOpacity(0.4),
                  ColorConstant.logoSecondColor.withOpacity(0.6),
                  ColorConstant.logoSecondColor.withOpacity(0.9),
                ],
              ),
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(7),
                bottomLeft: Radius.circular(7),
              ),
            ),
            padding: getPadding(top: 8, left: 10, right: 10, bottom: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Container(
                    decoration: BoxDecoration(color: fromHex('#996c22'), borderRadius: BorderRadius.circular(5)),
                    width: getHorizontalSize(140),
                    alignment: Alignment.center,
                    padding: getPadding(top: 8, left: 15, right: 15, bottom: 8),
                    child: const Text(
                      "Shop",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {

                    Get.toNamed(AppRoutes.soreDetails, arguments: {"store": storeName});
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Container(
                      decoration: BoxDecoration(color: ColorConstant.logoFirstColorConstant.withOpacity(0.8), borderRadius: BorderRadius.circular(5)),
                      width: getHorizontalSize(140),
                      alignment: Alignment.center,
                      padding: getPadding(top: 8, left: 15, right: 15, bottom: 8),
                      child: const Text(
                        "Info",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
