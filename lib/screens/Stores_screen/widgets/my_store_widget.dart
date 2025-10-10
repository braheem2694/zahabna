import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/screens/Filter_Products_screen/widgets/Listview.dart';
import 'package:iq_mall/screens/Filter_Products_screen/widgets/sidemenu.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/utils/ShConstant.dart';
import 'package:iq_mall/widgets/CommonWidget.dart';
import 'package:get/get.dart';
import 'package:iq_mall/widgets/custom_image_view.dart';
import 'package:progressive_image/progressive_image.dart';

import '../../../Product_widget/Product_widget.dart';
import '../../../main.dart';
import '../../../models/HomeData.dart';
import '../controller/my_store_controller.dart';
import 'package:iq_mall/utils/ShImages.dart';

import 'my_store_products_listview.dart';

class MyStoreScreen extends GetView<MyStoreController> {
  MyStoreScreen({super.key});

  final dynamic unescape = HtmlUnescape();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: controller.scaffoldKey,
        backgroundColor: Colors.white,
        // drawer: CustomDrawer(),
        appBar: AppBar(
          elevation: 1,
          toolbarHeight: getSize(50),
          backgroundColor: Colors.white,
          title: Obx(() => Text(unescape.convert(controller.title.value))),
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          iconTheme: const IconThemeData(color: sh_textColorPrimary),
          actionsIconTheme: const IconThemeData(color: sh_textColorPrimary),
        ),
        body: RefreshIndicator(
          onRefresh: () {
            return controller.getProducts(1);
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
            controller: controller.scrollController,
            shrinkWrap: true,
            slivers: [
              Obx(
                () {
                  // var categories = globalController.homeDataList.value.categories!.where((category) => category.parent.toString() == controller.category.value.toString()).toList();
                  // var categories = globalController.homeDataList.value.categories!.toList();
                  RxList<Category> categories = globalController.homeDataList.value.categories!.toList().obs;

                  return categories.isNotEmpty
                      ? TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.fastEaseInToSlowEaseOut,
                          tween: Tween<double>(begin: 0.0, end: controller.pinnedTopPad.value),
                          builder: (context, value, child) {
                            // print(value);
                            if (value > 30 && !controller.animateSubCategories.value) {
                              controller.animateSubCategories.value = true;
                            } else if (value < 30) {
                              controller.animateSubCategories.value = false;
                            }

                            // print("valueeee: ${(Get.height / Get.width) / 1.5}");
                            return SliverAppBar(
                              pinned: true,
                              leading: SizedBox.fromSize(),
                              leadingWidth: 0,
                              expandedHeight: !controller.animateSubCategories.value ? getSize(133 - value) : getSize(60),
                              collapsedHeight: !controller.animateSubCategories.value ? getSize(133 - value) : getSize(60),
                              backgroundColor: ColorConstant.whiteA700,
                              flexibleSpace: DecoratedBox(
                                decoration: BoxDecoration(color: ColorConstant.whiteA700),
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 800),
                                  transitionBuilder: (Widget child, Animation<double> animation) {
                                    return ScaleTransition(scale: animation, child: child);
                                  },
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: categories.isEmpty
                                        ? 0
                                        : !controller.animateSubCategories.value
                                            ? getSize(133 - value)
                                            : getSize(60),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      padding: getPadding(all: 0),
                                      itemCount: categories.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        var categories = globalController.homeDataList.value.categories!.toList();
                                        var unescape = HtmlUnescape();
                                        var text = unescape.convert(categories[index].categoryName);
                                        return GestureDetector(
                                            onTap: () {
                                              // Get.delete<Filter_ProductsController>();

                                              // Filter_ProductsController _controller = Get.find();
                                              // _controller.onInit();
                                              // Get.to(
                                              //   () => Filter_Productsscreen(),
                                              //   arguments: {
                                              //     'title': categories[index].categoryName.toString(),
                                              //     'id': int.parse(categories[index].id.toString()),
                                              //     'type': jsonString,
                                              //   },
                                              // );
                                              var f = {
                                                "categories": [
                                                  categories[index].id.toString(),
                                                ],
                                              };
                                              if (controller.selectedCategoryIndex.value == index) {
                                                controller.selectedCategoryIndex.value = (-1);
                                                controller.type = null;
                                              } else {
                                                controller.selectedCategoryIndex.value = index;
                                                String jsonString = jsonEncode(f);
                                                controller.type = jsonString;
                                              }

                                              controller.page.value = 1;
                                              controller.getProducts(controller.page.value);
                                              // controller.category.value = categories[index].id.toString();
                                              // controller.type = jsonString;
                                              // controller.title.value = categories[index].categoryName.toString();
                                              // controller.selectedCategoryIds = int.parse(categories[index].id.toString());
                                            },
                                            child: Padding(
                                              padding: getPadding(left: 8.0, right: 8, top: 8),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  // mediaWidget(
                                                  //   convertToThumbnailUrl(categories[index].main_image ?? '', isBlurred: true),
                                                  //   AssetPaths.placeholder,
                                                  //   height: getSize(78),
                                                  //   width: getSize(76),
                                                  //   isCategory: true,
                                                  //   fit: BoxFit.contain,
                                                  // ),
                                                  AnimatedSwitcher(
                                                      duration: const Duration(milliseconds: 800),
                                                      transitionBuilder: (Widget child, Animation<double> animation) {
                                                        return ScaleTransition(scale: animation, child: child);
                                                      },
                                                      child: Obx(
                                                        () => !controller.animateSubCategories.value
                                                            ? AnimatedContainer(
                                                                duration: Duration(milliseconds: 800),
                                                                decoration: BoxDecoration(
                                                                  border: controller.selectedCategoryIndex.value == index ? Border.all(color: ColorConstant.logoSecondColor, width: 2) : null,
                                                                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                                                                ),
                                                                child: ClipRRect(
                                                                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                                                                  child: ProgressiveImage(
                                                                    key: UniqueKey(),

                                                                    placeholder: const AssetImage(AssetPaths.placeholderCircle),
                                                                    // size: 1.87KB
                                                                    thumbnail: CachedNetworkImageProvider(
                                                                      convertToThumbnailUrl(categories[index].main_image ?? '', isBlurred: true),
                                                                    ),
                                                                    blur: 0,
                                                                    // size: 1.29MB
                                                                    image: CachedNetworkImageProvider(convertToThumbnailUrl(categories[index].main_image ?? "", isBlurred: false) ?? ''),
                                                                    height: getSize(78 - value),
                                                                    width: getSize(76 - value),

                                                                    fit: BoxFit.cover,
                                                                    fadeDuration: Duration(milliseconds: 200),
                                                                  ),
                                                                ),
                                                              )
                                                            : SizedBox(),
                                                      )),

                                                  // Container(
                                                  //   height: getSize(83),
                                                  //   width: getSize(80),
                                                  //   decoration: BoxDecoration(
                                                  //     borderRadius: BorderRadius.circular(5), // Adjust the value as needed
                                                  //     image: DecorationImage(
                                                  //       image: getAvatarImageProvider(categories[index].main_image, AssetPaths.placeholder),
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                  const SizedBox(height: spacing_control),
                                                  value < 30
                                                      ? SizedBox(
                                                          width: getSize(76 - (value / 2)),
                                                          child: Text(
                                                            text,
                                                            maxLines: 2,
                                                            softWrap: true,
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                              overflow: TextOverflow.visible,
                                                              color: Colors.black,
                                                              fontSize: getFontSize(15),
                                                            ),
                                                          ))
                                                      : GestureDetector(
                                                          onTap: () {
                                                            var f = {
                                                              "categories": [
                                                                categories[index].id.toString(),
                                                              ],
                                                            };
                                                            if (controller.selectedCategoryIndex.value == index) {
                                                              controller.selectedCategoryIndex.value = (-1);
                                                              controller.type = null;
                                                            } else {
                                                              controller.selectedCategoryIndex.value = index;
                                                              String jsonString = jsonEncode(f);
                                                              controller.type = jsonString;
                                                            }

                                                            controller.page.value = 1;
                                                            controller.getProducts(controller.page.value);
                                                          },
                                                          child: Obx(() {
                                                            return Container(
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(5),
                                                                  border: Border.all(color: controller.selectedCategoryIndex.value == index ? ColorConstant.logoSecondColor : Colors.grey, width: 1),
                                                                  color: controller.selectedCategoryIndex.value == index ? ColorConstant.logoSecondColor.withOpacity(0.5) : Colors.transparent),
                                                              padding: getPadding(all: 5),
                                                              child: Text(
                                                                text,
                                                                maxLines: 1,
                                                                softWrap: true,
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                  overflow: TextOverflow.visible,
                                                                  color: Colors.black,
                                                                  fontSize: getFontSize(15),
                                                                ),
                                                              ),
                                                            );
                                                          }),
                                                        ),
                                                ],
                                              ),
                                            ));
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : SliverToBoxAdapter(child: SizedBox());
                },
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 25.0, bottom: 10, top: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 3.0),
                        child: Text(
                          'Products'.tr,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        children: [
                          Obx(() => Text('${controller.count.value.toString()} results    ')),
                          Obx(() => Text(
                                unescape.convert(controller.title.value),
                                style: TextStyle(color: Colors.grey[600]),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 20),
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      Obx(() => !controller.loader.value
                          ? MyStoreCustomListView(
                              controller: controller,
                            )
                          : Progressor_indecator()),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(child: Obx(() => !controller.loadmore.value ? Container() : Align(alignment: Alignment.center, child: Progressor_indecator())))
            ],
          ),
        ));
  }
}
