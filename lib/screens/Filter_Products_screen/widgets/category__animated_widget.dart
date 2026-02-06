import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:iq_mall/widgets/ui.dart';

import '../../../Product_widget/Product_widget.dart';
import '../../../cores/math_utils.dart';
import '../../../main.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/ShColors.dart';
import '../../../utils/ShConstant.dart';
import '../../../utils/ShImages.dart';

class CustomSliverAppBar extends StatelessWidget {
  final controller; // Assume this is provided and initialized
  final categories; // Assume this is provided and initialized

  CustomSliverAppBar({required this.controller, required this.categories});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      curve: Curves.fastEaseInToSlowEaseOut,
      tween: Tween<double>(begin: 0.0, end: controller.pinnedTopPad.value),
      builder: (context, value, child) {
        if (value > 30 && !controller.animateSubCategories.value) {
          controller.animateSubCategories.value = true;
        } else if (value < 30) {
          controller.animateSubCategories.value = false;
        }

        return SliverAppBar(
          pinned: true,
          leading: SizedBox(),
          leadingWidth: 0,
          expandedHeight: !controller.animateSubCategories.value
              ? getSize(133 - value)
              : getSize(60),
          collapsedHeight: !controller.animateSubCategories.value
              ? getSize(133 - value)
              : getSize(60),
          backgroundColor: ColorConstant.whiteA700,
          flexibleSpace: DecoratedBox(
            decoration: BoxDecoration(color: ColorConstant.whiteA700),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 800),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: SizedBox(
                height: categories.isEmpty
                    ? 0
                    : !controller.animateSubCategories.value
                        ? getSize(133 - value)
                        : getSize(60),
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.all(0),
                  itemCount: globalController.homeDataList.value.categories!
                      .where((category) =>
                          category.parent.toString() ==
                          controller.category.value.toString())
                      .length,
                  itemBuilder: (BuildContext context, int index) {
                    var filteredCategories = globalController
                        .homeDataList.value.categories!
                        .where((category) =>
                            category.parent ==
                            int.parse(controller.category.value))
                        .toList();
                    var unescape = HtmlUnescape();
                    var text = unescape
                        .convert(filteredCategories[index].categoryName);

                    return GestureDetector(
                      onTap: () {
                        var category = filteredCategories[index];
                        var categoryData = {
                          "categories": [category.id.toString()],
                        };
                        String jsonString = jsonEncode(categoryData);

                        Get.toNamed(AppRoutes.Filter_products, arguments: {
                          'title': category.categoryName.toString(),
                          'id': int.parse(category.id.toString()),
                          'type': jsonString,
                        }, parameters: {
                          'tag':
                              "${int.parse(category.id.toString())}:${category.categoryName.toString()}"
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 800),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                return ScaleTransition(
                                    scale: animation, child: child);
                              },
                              child: Obx(() {
                                return !controller.animateSubCategories.value
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50)),
                                        child: ProgressiveImage(
                                          key: UniqueKey(),
                                          placeholder: AssetImage(
                                              AssetPaths.placeholderCircle),
                                          thumbnail: Ui.isValidUri(
                                                  convertToThumbnailUrl(
                                                      filteredCategories[index]
                                                              .main_image ??
                                                          '',
                                                      isBlurred: true))
                                              ? CachedNetworkImageProvider(
                                                  convertToThumbnailUrl(
                                                      filteredCategories[index]
                                                              .main_image ??
                                                          '',
                                                      isBlurred: true),
                                                )
                                              : const AssetImage(AssetPaths
                                                      .placeholderCircle)
                                                  as ImageProvider,
                                          blur: 0,
                                          image: Ui.isValidUri(
                                                  convertToThumbnailUrl(
                                                      filteredCategories[index]
                                                              .main_image ??
                                                          "",
                                                      isBlurred: false))
                                              ? CachedNetworkImageProvider(
                                                  convertToThumbnailUrl(
                                                          filteredCategories[
                                                                      index]
                                                                  .main_image ??
                                                              "",
                                                          isBlurred: false) ??
                                                      '',
                                                )
                                              : const AssetImage(AssetPaths
                                                      .placeholderCircle)
                                                  as ImageProvider,
                                          height: getSize(78 - value),
                                          width: getSize(76 - value),
                                          fit: BoxFit.cover,
                                          fadeDuration:
                                              Duration(milliseconds: 200),
                                        ),
                                      )
                                    : SizedBox();
                              }),
                            ),
                            SizedBox(height: spacing_control),
                            value < 30
                                ? SizedBox(
                                    width: getSize(76 - (value / 2)),
                                    child: Text(
                                      text,
                                      maxLines: 2,
                                      softWrap: true,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        overflow: TextOverflow.visible,
                                        color: Colors.black,
                                        fontSize: getFontSize(15),
                                      ),
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          color: ColorConstant.logoSecondColor,
                                          width: 1),
                                    ),
                                    padding: EdgeInsets.all(5),
                                    child: Text(
                                      text,
                                      maxLines: 1,
                                      softWrap: true,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        overflow: TextOverflow.visible,
                                        color: Colors.black,
                                        fontSize: getFontSize(15),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Define ColorConstant and other missing classes/variables based on your existing codebase.
