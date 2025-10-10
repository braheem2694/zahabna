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

import '../../Product_widget/Product_widget.dart';
import '../../main.dart';
import '../../models/HomeData.dart';
import '../../widgets/image_widget.dart';
import '../Home_screen_fragment/controller/Home_screen_fragment_controller.dart';
import '../Home_screen_fragment/widgets/CategoriesWidget.dart';
import 'controller/Filter_Products_controller.dart';
import 'package:iq_mall/utils/ShImages.dart';

class Filter_Productsscreen extends GetView<Filter_ProductsController> {
  Filter_Productsscreen({super.key});

  final Filter_ProductsController controller = Get.find(tag: Get.parameters.values.first);
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
                  var categories = globalController.homeDataList.value.categories!.where((category) => category.parent.toString() == controller.category.value.toString()).toList();

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
                              child: Obx(() {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  padding: getPadding(all: 0),
                                  itemCount:controller.subCategoriesList.length,
                                  itemBuilder: (BuildContext context, int index) {


                                    var unescape = HtmlUnescape();
                                    var text = unescape.convert(controller.subCategoriesList[index].categoryName);
                                    return GestureDetector(
                                        onTap: () {
                                          var f = {
                                            "categories": [
                                              controller.subCategoriesList[index].id.toString(),
                                            ],
                                          };

                                          controller.selectedCategoryForFilter = controller.subCategoriesList[index].id.toString();

                                          String jsonString = jsonEncode(f);

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

                                          Get.toNamed(AppRoutes.Filter_products, arguments: {
                                            'title': controller.subCategoriesList[index].categoryName.toString(),
                                            'id': int.parse(controller.subCategoriesList[index].id.toString()),
                                            'store_id': controller.arguments["store_id"],
                                            'type': jsonString,
                                          }, parameters: {
                                            'tag': "${int.parse(controller.subCategoriesList[index].id.toString())}:${controller.subCategoriesList[index].categoryName.toString()}"
                                          });
                                          // controller.category.value = categories[index].id.toString();
                                          // controller.type = jsonString;
                                          // controller.title.value = categories[index].categoryName.toString();
                                          // controller.selectedCategoryIds = int.parse(categories[index].id.toString());
                                        },
                                        child: Padding(
                                          padding: getPadding(left: 8.0, right: 8, top: 8, bottom: 8),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                decoration: !controller.animateSubCategories.value
                                                    ? BoxDecoration(border: Border.all(width: 1, color: ColorConstant.logoSecondColor), shape: BoxShape.circle)
                                                    : null,
                                                alignment: Alignment.center,
                                                padding: getPadding(all: 3),
                                                child: AnimatedSwitcher(
                                                    duration: const Duration(milliseconds: 800),
                                                    transitionBuilder: (Widget child, Animation<double> animation) {
                                                      return ScaleTransition(scale: animation, child: child);
                                                    },
                                                    child: Obx(
                                                          () =>
                                                      !controller.animateSubCategories.value
                                                          ? ClipRRect(
                                                        borderRadius: const BorderRadius.all(Radius.circular(50)),
                                                        child: ProgressiveImage(
                                                          key: UniqueKey(),

                                                          placeholder: const AssetImage(AssetPaths.placeholderCircle),
                                                          // size: 1.87KB
                                                          thumbnail: CachedNetworkImageProvider(
                                                            convertToThumbnailUrl(controller.subCategoriesList[index].main_image ?? '', isBlurred: true),
                                                          ),
                                                          blur: 0,
                                                          // size: 1.29MB
                                                          image: CachedNetworkImageProvider(convertToThumbnailUrl(controller.subCategoriesList[index].main_image ?? "", isBlurred: false) ?? ''),
                                                          height: getSize(75 - value),
                                                          width: getSize(75 - value),

                                                          fit: BoxFit.cover,
                                                          fadeDuration: Duration(milliseconds: 200),
                                                        ),
                                                      )
                                                          : SizedBox(),
                                                    )),
                                              ),

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
                                                  ? Expanded(
                                                child: SizedBox(
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
                                                    )),
                                              )
                                                  : Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    border: Border.all(color: ColorConstant.logoSecondColor, width: 1),
                                                  ),
                                                  padding: getPadding(all: 5),
                                                  alignment: Alignment.center,
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
                                                ),
                                              ),
                                            ],
                                          ),
                                        ));
                                  },
                                );
                              }),
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
                          Obx(() =>
                              Text(
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
                  padding: const EdgeInsets.only(left: 12.0, right: 25, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          _showBottomSheet(context);
                        },
                        child: Container(
                            height: getSize(50),
                            width: getHorizontalSize(50),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              border: Border.all(color: Colors.white.withOpacity(0.5)),
                              color: sh_light_grey, // Use sh_light_grey here
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade300,
                                  blurRadius: 1,
                                  offset: const Offset(1, 2),
                                ),
                              ],
                            ),
                            child: Icon(Icons.filter_list)),
                      ),
                      typeDropDown(context),
                      LayoutBuilder(
                        builder: (BuildContext context, BoxConstraints constraints) {
                          // Define the maximum width.
                          double maxWidth = getHorizontalSize(200);

                          // Sample texts to measure. Replace with your actual dropdown items.
                          final List<String> sampleTexts = [
                            'Newest',
                            'Lowest price',
                            'Highest price',
                          ];

                          double calculateTextWidth(String text) {
                            final textPainter = TextPainter(
                              text: TextSpan(text: text, style: TextStyle(fontSize: getFontSize(13))),
                              maxLines: 1,
                              textDirection: TextDirection.ltr,
                            );
                            textPainter.layout(minWidth: 0, maxWidth: double.infinity);
                            return textPainter.width;
                          }

                          // Calculate the maximum text width.
                          double textWidth = sampleTexts.map(calculateTextWidth).reduce(max);

                          // Add extra padding or other element widths.
                          double totalWidth = textWidth + 20; // Adjust 20 for padding or other elements.

                          // Ensure the total width does not exceed the maximum width.
                          totalWidth = min(totalWidth, maxWidth);

                          return Obx(
                                () =>
                                Container(
                                  constraints: BoxConstraints(minWidth: Get.width / 3, maxWidth: Get.width / 2),
                                  height: getSize(50),
                                  width: getHorizontalSize(130),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25.0),
                                    border: Border.all(color: Colors.white.withOpacity(0.5)),
                                    color: sh_light_grey, // Use sh_light_grey here
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade300,
                                        blurRadius: 1,
                                        offset: const Offset(1, 2),
                                      ),
                                    ],
                                  ),
                                  padding: getPadding(left: 16),
                                  alignment: Alignment.bottomCenter,
                                  child: DropdownButtonHideUnderline(
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                        canvasColor: sh_light_grey, // Dropdown background color
                                        popupMenuTheme: PopupMenuThemeData(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25),
                                          ),
                                        ),
                                      ),
                                      child: DropdownButton<String>(
                                        value: controller.selectedValue?.value,
                                        items: [
                                          DropdownMenuItem(
                                            value: 'newest',
                                            child: Text(
                                              'Newest'.tr,
                                              style: TextStyle(color: Colors.black87, fontSize: getFontSize(13)), // Text color
                                            ),
                                          ),
                                          DropdownMenuItem(
                                            value: 'lowestToHighest',
                                            child: Text(
                                              'Lowest to Highest Price'.tr,
                                              style: TextStyle(color: Colors.black87),
                                            ),
                                          ),
                                          DropdownMenuItem(
                                            value: 'highestToLowest',
                                            child: Text(
                                              'Highest to Lowest Price'.tr,
                                              style: const TextStyle(color: Colors.black87),
                                            ),
                                          ),
                                        ],
                                        onChanged: (value) {
                                          controller.loader.value = true;
                                          controller.selectedValue?.value = value!;
                                          controller.page.value = 1;
                                          controller.loading.value = true;
                                          controller.Products?.clear();
                                          controller.Products?.clear();
                                          controller.getProducts(1).then((value) => controller.loader.value = false);
                                          // ... Your existing onChanged logic ...
                                        },
                                        hint: const Text(
                                          'Sorting Options',
                                          style: TextStyle(color: Colors.black54), // Hint text style
                                        ),
                                        icon: const Icon(
                                          Icons.arrow_drop_down_sharp,
                                          color: Colors.black, // Icon color
                                        ),
                                        style: TextStyle(color: Colors.black),
                                        // Selected item style
                                        isExpanded: true,
                                        dropdownColor: sh_light_grey,
                                        elevation: 16,
                                        // Shadow elevation
                                        borderRadius: BorderRadius.circular(15),
                                        // Border radius of dropdown
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), // Inner padding
                                      ),
                                    ),
                                  ),
                                ),
                          );
                        },
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
                      Obx(() =>
                      !controller.loader.value
                          ? CustomListView(
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

  Widget typeDropDown(BuildContext context) {
    return Obx(() {
      return Container(
        height: getSize(50),
        width: getHorizontalSize(110),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(color: Colors.white.withOpacity(0.5)),
          color: sh_light_grey,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 1,
              offset: const Offset(1, 2),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: getSize(12)), // Add padding for internal alignment
        child: DropdownButtonHideUnderline(
          child:  Theme(
            data: Theme.of(context).copyWith(
              canvasColor: sh_light_grey, // Dropdown background color
              popupMenuTheme: PopupMenuThemeData(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
            child: DropdownButton<String>(
              isExpanded: true,
              value: controller.selectedType?.value,
              items: globalController.homeDataList.value.productTypes?.where((element) => element.type=="Metal").map((type) {
                return DropdownMenuItem<String>(
                  value: type.name,
                  child: Text(
                    type.name.toString().tr,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: getFontSize(13),
                    ),
                  ),
                );
              }).toList(),
              icon: Icon(Icons.arrow_drop_down,), // Adjust icon size if needed
              onChanged: (newValue) {
                controller.selectedType?.value = newValue.toString();
                controller.selectedTypeObject?.value = globalController
                    .homeDataList.value.productTypes!
                    .firstWhere((element) => element.name == newValue.toString());
                controller.loader.value = true;
                controller.page.value = 1;
                controller.loading.value = true;
                controller.Products?.clear();
                controller.getProducts(1).then((value) => controller.loader.value = false);
              },
              hint: Text(
                "Select type".tr,
                style: TextStyle(
                  fontSize: getFontSize(13),
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              style: TextStyle(color: Colors.black),
              // Selected item style
              dropdownColor: sh_light_grey,
              elevation: 16,
              // Shadow elevation
              borderRadius: BorderRadius.circular(15),
              // Border radius of dropdown
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            ),
          ),
        ),
      );
    });
  }


  void _showBottomSheet(BuildContext context) {
    Get.bottomSheet(
      FilterMenu(
          tag: controller.tag
      ),
      isDismissible: true,
      enableDrag: true,
      ignoreSafeArea: true,

      backgroundColor: Colors.white,

      isScrollControlled: true, // Set this to true to make the sheet full-screen.
    );
  }
}
