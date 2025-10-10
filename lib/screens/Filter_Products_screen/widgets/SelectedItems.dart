import 'dart:convert';

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:iq_mall/utils/ShColors.dart';
import '../../../models/HomeData.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iq_mall/utils/ShImages.dart';

import '../controller/Filter_Products_controller.dart';

class SelectedItemsWidget extends StatefulWidget {
  final RxList<Category> categories;
  final RxList<Brand> brands;
  final String tag;


  SelectedItemsWidget({required this.categories, required this.brands, required this.tag, });

  @override
  _SelectedItemsWidgetState createState() => _SelectedItemsWidgetState();
}

class _SelectedItemsWidgetState extends State<SelectedItemsWidget> {

  late Filter_ProductsController controller;
  RxList<Category> categories = <Category>[].obs;
  @override
  initState() {
    controller = Get.find(tag: widget.tag);
    categories.addAll(controller.categories);
    super.initState();
  }

  Widget build(BuildContext context) {
    return Obx(
      () {
        List<Widget> selectedItems = [];
        controller.categories.where((category) => category.isSelected).forEach((category) {
          selectedItems.add(_buildItem(category.categoryName, () {
            setState(() {
              category.isSelected = false;
              categories.remove(category);

              for(int i=0; i<controller.categories.length; i++){
                if(controller.categories[i].id==category.id){
                  setState(() {
                    controller.categories[i].isSelected=false;
                    controller.selectedCategory?.value=Category(id: 0, categoryName: "categoryName", slug: "slug", parent: 0, main_image: "main_image", showInNavbar: 0, productCount: 0, isSelected: false,hasProduct: false);
                  });
                }
              }


              controller.selectedCategoryIds = null;

            });
          }));
        });
        Future.delayed(Duration.zero, () {
          setState(() {
            controller.categories.refresh();
            controller.categories.refresh();
          });
        });

        widget.brands.where((brand) => brand.isSelected).forEach((brand) {
          selectedItems.add(_buildItem(brand.brandName, () {
            setState(() {
              brand.isSelected = false;
            });
          }));
       //   controller.selectedBrandIds.add(brand.id);
        });
        Future.delayed(Duration.zero, () {
          setState(() {
            controller.brands.refresh();
          });
        });
        return Wrap(
          spacing: 8.0, // Spacing between items
          runSpacing: 8.0, // Spacing between lines
          children: selectedItems,
        );
      },
    );
  }

  Widget _buildItem(String name, VoidCallback onRemove) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Button_color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.cancel,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
