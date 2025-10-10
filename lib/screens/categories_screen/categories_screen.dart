import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/screens/categories_screen/controller/categories_controller.dart';
import 'package:progressive_image/progressive_image.dart';
import '../../Product_widget/Product_widget.dart';
import '../../getxController.dart';
import '../../main.dart';
import '../../models/HomeData.dart';
import '../../routes/app_routes.dart';
import '../../utils/ShColors.dart';
import '../../utils/ShImages.dart';
import '../../widgets/ViewAllButton.dart';
import '../../widgets/image_widget.dart';
import '../Cart_List_screen/widgets/continue_button.dart';
import '../Filter_Products_screen/Filter_Products_screen.dart';
import '../HomeScreenPage/ShHomeScreen.dart';
import '../tabs_screen/controller/tabs_controller.dart';
// ignore_for_file: must_be_immutable

class CategoriesScreen extends StatelessWidget {
  CategoriesController controller = Get.put(CategoriesController());

  CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return WillPopScope(
      onWillPop: () {
        TabsController _controller = Get.find();
        _controller.currentIndex.value = 0;

        return Future.value(false);
      },
      child: Scaffold(
          key: scaffoldKey,
          // drawer: MainDrawer(),
          backgroundColor: ColorConstant.white,
          body: RefreshIndicator(
            color: MainColor,
            onRefresh: globalController.refreshFunctions,
            child: Obx(
              () => controller.loading.value
                  ? Container()
                  : controller.parentCategories.isEmpty
                      ? Center(child: Image.asset(AssetPaths.noresultsfound))
                      : GestureDetector(
                          onTap: () {
                              
                          },
                          child: Padding(
                            padding: EdgeInsets.only(top: getVerticalSize(Platform.isIOS ? 45 :  getTopPadding()) + AppBar().preferredSize.height),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildCategoryList(context),
                                buildProductGrid(context),
                              ],
                            ),
                          ),
                        ),
            ),
          )),
    );
  }

  Widget buildCategoryList(context) {
    return Padding(
      padding: getPadding(top: 8.0, right: 4, bottom: getBottomPadding(context: context) + getSize(50)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0, bottom: 8, left: 5),
            child: Text(
              'Categories'.tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () => Container(
                width: getScreenWidth() > 400 ? getSize(120) : getSize(110),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10.0),
                    )),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                  itemCount: controller.parentCategories.length,
                  controller: controller.categoryScrollController.value,
                  itemBuilder: (context, index) {
                    final parent = controller.parentCategories[index];
                    var unescape = HtmlUnescape();
                    var text = unescape.convert(parent.categoryName!);
                    return GestureDetector(
                      onTap: () {
                        controller.setSelectedParent(parent.id!, parent, 'double_click');
                          Future.delayed(Duration.zero, () {
                            
                          });

                        controller.parent = parent;
                        // print((index - controller.selectedCategoryIndex.value).abs());

                        if ((index - controller.selectedCategoryIndex.value).abs() > 3) {
                          // Calculate the target scroll position
                          double targetScrollPosition = getSize(50) * (index - controller.selectedCategoryIndex.value.abs());

                          if (!controller.categoryScrollController.value.position.isScrollingNotifier.value) {
                            // Check if the scroll position is not already animating
                            controller.categoryScrollController.value.animateTo(
                              targetScrollPosition,
                              curve: Curves.easeOut,
                              duration: const Duration(milliseconds: 1800),
                            );
                          } else {
                            // If the scroll position is animating, set it directly without animation
                            controller.categoryScrollController.value.jumpTo(targetScrollPosition);
                          }
                        }

                        controller.selectedCategoryIndex.value = index;
                        try {
                          controller.animationController.reverse().then((value) => controller.animationController.forward());
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Stack(
                              alignment: Alignment.centerLeft,
                              children: [
                                AnimatedBuilder(
                                  animation: controller.colorAnimation,
                                  builder: (context, child) {
                                    return Obx(() => Container(
                                          height: getSize(50),
                                          decoration: BoxDecoration(
                                            color: controller.selectedCategoryIndex.value == index ? controller.colorAnimation.value : Colors.transparent,
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(index - 1 == controller.selectedCategoryIndex.value ? 10 : 0),
                                                bottomRight: Radius.circular(index + 1 == controller.selectedCategoryIndex.value ? 10 : 0)),
                                          ),
                                          child: child,
                                        ));
                                  },
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Obx(() {
                                      return controller.selectedCategoryIndex.value == index
                                          ? Container(
                                              height: getSize(50),
                                              width: 2,
                                              color: ColorConstant.logoSecondColor,
                                            )
                                          : SizedBox();
                                    }),
                                    Expanded(
                                      child: Padding(
                                        padding: getPadding(left: 4.0, right: 4),
                                        child: Obx(() => Text(
                                              text,
                                              maxLines: 2,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontSize: getFontSize(12),
                                                fontWeight: controller.isSelectedParent(parent.id!) ? FontWeight.bold : FontWeight.normal,
                                                overflow: TextOverflow.visible,
                                                color: controller.selectedParentId.value == parent.id ? Button_color : Colors.black,
                                              ),
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 0.5,
                            color: Colors.grey[300],
                            thickness: 0.5,
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProductGrid(BuildContext context) {
    return Obx(
      () => Expanded(
        child: Column(
          children: [
            Padding(
              padding: getPadding(top: 20.0, bottom: 8, left: 15, right: 24),
              child: Align(alignment: Alignment.centerRight, child: buildStackedRow()),
            ), // Your custom stacked row widget
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(left: 15, right: 15, bottom: getBottomPadding() + getSize(50)),
                physics: ClampingScrollPhysics(parent: BouncingScrollPhysics()),
                itemCount: (controller.getRelatedParentItems().length / calculateColumns(context)).ceil(),
                itemBuilder: (context, rowIndex) {
                   List<Category> items = controller.getRelatedParentItems();
                  final startIndex = rowIndex * calculateColumns(context);
                  final endIndex = (rowIndex + 1) * calculateColumns(context);
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start, // Align items to the start of the row
                    children: List.generate(
                      calculateColumns(context),
                      (columnIndex) {
                        final index = startIndex + columnIndex;
                        if (index < items.length) {
                          final item = items[index];
                          return Expanded(
                            child: Container(
                              height: getSize(110),
                              width: getSize(80),
                              child: buildGridItem(item),
                            ),
                          );
                        } else {
                          return const Expanded(
                            child: SizedBox(),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  int calculateColumns(BuildContext context) {
    // Calculate the number of columns based on the screen width
    double screenWidth = MediaQuery.of(context).size.width;
    int columns = screenWidth ~/ 120; // Assuming each item width is 150, adjust this value as needed
    return columns > 0 ? columns : 1; // Ensure at least one column
  }

  Widget buildStackedRow() {
    // Replace with your actual row content
    return SizedBox(
      height: getSize(35),
      width: getSize(140),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ContinueButtonWidget(
            isText: false,
            text: "Show All".tr,
            onTap: () {
              controller.setSelectedParent(controller.parent.id!, controller.parent, "");
            },
          ),
        ],
      ),
    );
  }

  Widget buildGridItem(Category item) {
    var unescape = HtmlUnescape();
    var text = unescape.convert(item.categoryName);
    return GestureDetector(
      onTap: () {
        var f = {
          "categories": [
            item.id.toString(),
          ],
        };
        String jsonString = jsonEncode(f);
        Get.toNamed(AppRoutes.Filter_products, arguments: {
          'title': item.categoryName,
          'id': item.id,
          'type': jsonString,
        }, parameters: {
          'tag': "${item.id}:${item.categoryName}"
        })?.then((value) {
          globalController.updateCurrentRout(Get.currentRoute);
        });
        // Get.to(
        //       () => Filter_Productsscreen(),
        //   arguments: {
        //     'title': item.categoryName,
        //     'id': item.id,
        //     'type': jsonString,
        //   },
        //   preventDuplicates: false,
        // );

        // Get.toNamed(AppRoutes.Filter_products, arguments: {
        //   'title': item.categoryName,
        //   'id': item.id,
        //   'type': jsonString,
        // });
      },
      child: Column(
        children: [
          Obx(() => controller.changingCategory.value
                  ? SizedBox(
                      height: getSize(70),
                      width: getSize(70),
                    )
                  : ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                      child: ProgressiveImage(
                        key: UniqueKey(),
                        placeholder: const AssetImage(AssetPaths.placeholderCircle),
                        // size: 1.87KB
                        thumbnail: CachedNetworkImageProvider(
                          convertToThumbnailUrl(item.main_image ?? '', isBlurred: true),
                        ),
                        blur: 0,
                        // size: 1.29MB
                        image: CachedNetworkImageProvider(convertToThumbnailUrl(item.main_image ?? "", isBlurred: false) ?? ''),
                        height: getSize(70),
                        width: getSize(70),

                        fit: BoxFit.cover,
                        fadeDuration: Duration(milliseconds: 200),
                      ),
                    )

              // mediaWidget(
              //                 item.mainImage,
              //                 AssetPaths.placeholder,
              //                 height: getSize(70),
              //                 width: getSize(70),
              //                 isCategory: true,
              //                 fit: BoxFit.cover,
              //               ),
              ),
          const SizedBox(height: 8),
          Text(
            text,
            overflow: TextOverflow.visible,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: getFontSize(9), fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
