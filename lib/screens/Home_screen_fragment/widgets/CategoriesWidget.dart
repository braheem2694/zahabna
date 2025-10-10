import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/utils/ShImages.dart';
import 'package:get/get.dart';
import 'package:progressive_image/progressive_image.dart';
import '../../../Product_widget/Product_widget.dart';
import '../../../main.dart';
import '../../../models/HomeData.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/ShColors.dart';
import '../../../widgets/image_widget.dart';
import '../../Filter_Products_screen/Filter_Products_screen.dart';
import '../controller/Home_screen_fragment_controller.dart';

class CategoriesWidget extends StatefulWidget {
  const CategoriesWidget({Key? key}) : super(key: key);

  @override
  _CategoriesWidgetState createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getSize((prefs!.getString('category_grid') == 'Double Columns' ? getVerticalSize(260) : getVerticalSize(120))),
      child: globalController.homeDataList.value.categories != null
          ? CustomScrollView(
              scrollDirection: Axis.horizontal,
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              slivers: <Widget>[
                SliverPadding(
                  padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                  sliver: SliverGrid(
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(mainAxisSpacing: 1, childAspectRatio: getScreenRatio() > 1 ? (Get.height / Get.width) / 1.7 : (Get.height / Get.width) / 0.9, crossAxisSpacing: 1.0, crossAxisCount: (prefs!.getString('category_grid') == 'Double Columns' ? 2 : 1)),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        var categories = globalController.homeDataList.value.categories?.where((category) => category.parent == null).toList();
                        var unescape = HtmlUnescape();
                        String text = "";
                        if (categories != null) {
                          text = unescape.convert(categories[index].categoryName);
                        }
                        return GestureDetector(
                            onTap: () {
                              var f = {
                                "categories": [
                                  categories?[index].id.toString(),
                                ],
                              };
                              String jsonString = jsonEncode(f);

                              // Get.to(
                              //   () => Filter_Productsscreen(),
                              //   arguments: {
                              //     'title': categories[index].categoryName.toString(),
                              //     'id': int.parse(categories[index].id.toString()),
                              //     'type': jsonString,
                              //   },
                              //   preventDuplicates: true,
                              // );
                              Get.toNamed(AppRoutes.Filter_products, arguments: {
                                'title': categories?[index].categoryName.toString(),
                                'id': int.parse(categories != null ? categories[index].id.toString() : "0"),
                                'type': jsonString,
                              }, parameters: {
                                'tag': "${int.parse(categories != null ? categories[index].id.toString() : "0")}:${categories?[index].categoryName.toString()}"
                              });
                              // Get.toNamed(AppRoutes.Filter_products, arguments: {
                              //   'title': categories[index].categoryName,
                              //   'id': categories[index].id,
                              //   'type': jsonString,
                              // });
                            },
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: ColorConstant.logoSecondColorConstant, width: 1),
                                  ),
                                  padding: getPadding(all: 3),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: ProgressiveImage(
                                      key: UniqueKey(),

                                      placeholder: const AssetImage(AssetPaths.placeholderCircle),
                                      // size: 1.87KB
                                      thumbnail: CachedNetworkImageProvider(
                                        convertToThumbnailUrl(categories?[index].main_image ?? '', isBlurred: true),
                                      ),
                                      blur: 0,
                                      // size: 1.29MB
                                      image: CachedNetworkImageProvider(convertToThumbnailUrl(categories?[index].main_image ?? "", isBlurred: false) ?? ''),
                                      height: getSize(78),
                                      width: getSize(76),

                                      fit: BoxFit.contain,
                                      fadeDuration: const Duration(milliseconds: 200),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: getPadding(top: 8.0),
                                    child: Text(
                                      text,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: getFontSize(11), fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ));
                      },
                      childCount: globalController.homeDataList.value.categories?.where((category) => category.parent == null).length,
                    ),
                  ),
                ),
              ],
            )
          : SizedBox(),
    );
  }

  Widget buildDynamicCategoriesWidget() {
    // Determine the layout based on preferences
    final bool isDoubleColumn = prefs?.getString('category_grid') == 'Double Columns';

    // Access categories list once
    final List<Category> categories = globalController.homeDataList.value.categories?.where((category) => category.parent == null).toList() ?? [];

    // Calculate the height based on whether it's a double column or not
    final double containerHeight = isDoubleColumn ? getVerticalSize(260) : getVerticalSize(120);

    return Container(
      height: containerHeight,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: isDoubleColumn ? buildDoubleRowCategories(categories) : buildSingleRowCategories(categories),
      ),
    );
  }

  Widget buildSingleRowCategories(List<Category> categories) {
    return Row(
      children: List.generate(categories.length, (index) => buildCategoryItem(categories[index])),
    );
  }

  Widget buildDoubleRowCategories(List<Category> categories) {
    // Assuming categories length is even for simplicity, adjust logic as needed for odd numbers
    List<Widget> rows = [];
    for (int i = 0; i < categories.length; i += 2) {
      rows.add(
        Row(
          children: [
            buildCategoryItem(categories[i]),
            if (i + 1 < categories.length) buildCategoryItem(categories[i + 1]),
          ],
        ),
      );
    }

    return Column(
      children: rows,
    );
  }

  Widget buildCategoryItem(Category category) {
    var unescape = HtmlUnescape();
    var categoryName = unescape.convert(category.categoryName);

    return GestureDetector(
      onTap: () => navigateToCategoryDetails(category),
      child: Container(
        width: MediaQuery.of(context).size.width / 4,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: FadeInImage.assetNetwork(
                  placeholder: AssetPaths.placeholderCircle,
                  image: convertToThumbnailUrl(category.main_image ?? "", isBlurred: false),
                  fit: BoxFit.contain,
                  fadeInDuration: Duration(milliseconds: 200),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                categoryName,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToCategoryDetails(Category category) {
    var filter = {
      "categories": [category.id.toString()],
    };
    String jsonString = jsonEncode(filter);

    Get.toNamed(AppRoutes.Filter_products, arguments: {
      'title': category.categoryName,
      'id': category.id,
      'type': jsonString,
    }, parameters: {
      'tag': "${category.id.toString()}:${category.categoryName}"
    });

    // Get.toNamed(AppRoutes.Filter_products, arguments: {
    //   'title': category.categoryName,
    //   'id': category.id,
    //   'type': jsonString,
    // });
  }
}

ImageProvider<Object> getAvatarImageProvider(dynamic filePath, String placeholderAsset) {
  if (filePath == null) {
    return AssetImage(placeholderAsset);
  }

  String strPath = filePath.toString();

  if (strPath == 'null') {
    return AssetImage(placeholderAsset);
  }

  return CachedNetworkImageProvider(strPath);
}
