import 'dart:convert';
import 'package:iq_mall/Product_widget/Product_widget.dart';
import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/screens/Home_screen_fragment/controller/Home_screen_fragment_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iq_mall/utils/ShConstant.dart';
import 'package:iq_mall/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iq_mall/widgets/CommonWidget.dart';
import 'package:iq_mall/widgets/ViewAllButton.dart';
import '../../../models/HomeData.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/ShColors.dart';

class CategoriesViewProducts extends StatefulWidget {
  final int? index;
  final RxBool? loading;

  CategoriesViewProducts({
    this.index,
    this.loading,
  });

  @override
  _sectionsState createState() => _sectionsState();
}

class _sectionsState extends State<CategoriesViewProducts> {
  // Home_screen_fragmentController Home_Controller = Get.find();
  // RxList<Product>? filteredProducts = <Product>[].obs;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // filteredProducts?.value = globalController.homeDataList.value.products!
    //     .where((product) => product.product_section.toString() == globalController.homeDataList.value.productSections?[widget.index!].id.toString())
    //     .toList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => widget.loading!.value
        ? Progressor_indecator()
        : globalController.homeDataList.value.products!=null && globalController.homeDataList.value.products!
        .where((product) => product.category_id.toString() == globalController.homeDataList.value.categories?[widget.index!].id.toString())
        .toList().isNotEmpty
            ? Column(
                key: scaffoldKey,
                children: [
                  Padding(
                    padding: getPadding(left: 15.0, right: 15.0, bottom: 12, top: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          globalController.homeDataList.value.categories![widget.index!].categoryName.toString(),
                          style: TextStyle(color: MainColor, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        CustomButton(
                          onTap: () {


                            var f = {
                              "categories": [
                                globalController.homeDataList.value.categories?[widget.index!].id.toString(),
                              ],
                            };
                            String jsonString = jsonEncode(f);
                            Get.toNamed(AppRoutes.Filter_products, arguments: {
                              'title':   globalController.homeDataList.value.categories?[widget.index!].categoryName,
                              'id':   globalController.homeDataList.value.categories?[widget.index!].id,
                              'type': jsonString,
                            }, parameters: {
                              'tag': "${  globalController.homeDataList.value.categories?[widget.index!].id}:${  globalController.homeDataList.value.categories?[widget.index!].categoryName}"
                            })?.then((value) {
                              globalController.updateCurrentRout(Get.currentRoute);
                            });





                          },
                          label: 'View All'.tr,
                          color: MainColor.withOpacity(0.9),
                        )
                      ],
                    ),
                  ),

                  // ListView.builder(
                  //   itemCount: globalController.homeDataList.value.productSections?.length ?? 0,
                  //   shrinkWrap: true,
                  //   physics: NeverScrollableScrollPhysics(),
                  //   itemBuilder: (context, index) {
                  //     var section = globalController.homeDataList.value.productSections![index];
                  //     var products = _filteredProductsForSection(section.id.toString());
                  //
                  //     return section.slider_type.toString() == '0'
                  //         ? _buildProductRows(products)
                  //         : _buildListViewWidget(products);
                  //   },
                  // ),

                   _buildProductRows( globalController.homeDataList.value.products!
                      .where((product) => product.category_id.toString() == globalController.homeDataList.value.categories?[widget.index!].id.toString())
                      .toList()) ,
                ],
              )
            : const SizedBox());
  }


  Widget _buildProductRows(List<Product>? products) {
    // First, filter the products to only those with a non-null cart_id.
    List<Product> filteredProducts = products!.where((product) => product.cart_id != null).toList();

    // Now, let's create the rows of products.
    List<Widget> productRows = [];
    for (int startIndex = 0; startIndex < filteredProducts.length; startIndex += 2) {
      // For each row, take up to two products.
      List<Product> rowProducts = filteredProducts.skip(startIndex).take(2).toList();

      // Build a row for these products.
      Widget row = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: rowProducts.asMap().entries.map((entry) {
          int index = entry.key;
          Product product = entry.value;
          EdgeInsets padding = EdgeInsets.fromLTRB(
            index == 0 ? 6.0 : 3.0, // Left padding for the left item
            2.0, // Top padding
            index == 0 ? 3.0 : 6.0, // Right padding for the left item
            2.0, // Bottom padding
          );
          return Expanded(
            child: Padding(
              padding: padding,
              child: ProductWidget(product: product, fromKey: "filter", index: index),
            ),
          );
        }).toList(),
      );

      // Add the constructed row to the list of rows.
      productRows.add(row);
    }

    // Return a Column containing all product rows. This Column will be a direct
    // child of your outer ListView, or wrapped in a Container or similar if needed
    // for layout purposes.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: productRows,
    );
  }

  Widget _buildListViewWidget(List<Product>? products) {
    // Check if products is null or empty

    if (products == null || products.isEmpty) {
      return const SizedBox(height: 0); // Return an empty box with a fixed height
    }

    return SizedBox(
      height: products.isNotEmpty ? getSize(310) : 0,
      child: Center(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          key: UniqueKey(),
          shrinkWrap: true,
          itemCount: products.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: getPadding(left: 8.0, right: 8),
              key: UniqueKey(),
              child: ProductWidget(product: products[index]),
            );
          },
        ),
      ),
    );
  }
}
