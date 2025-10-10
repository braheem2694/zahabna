import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/screens/Home_screen_fragment/widgets/sections.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/widgets/Grid_Widget.dart';
import 'package:iq_mall/widgets/ui.dart';
import '../../../main.dart';
import '../../../models/HomeData.dart';
import '../controller/Home_screen_fragment_controller.dart';
import 'categories_view_product.dart';

class SpecialList extends StatelessWidget {
  SpecialList({Key? key, required this.loading}) : super(key: key);

  final RxBool loading;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return
        globalController.homeDataList.value.productSections != null  && globalController.homeDataList.value.productSections!.isNotEmpty?
        ListView.builder(
            shrinkWrap: true,
            // key: UniqueKey(),
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,

            padding: getPadding(top: 0,bottom: getBottomPadding(context: context)+50),
            itemCount: globalController.homeDataList.value.productSections?.length,
            itemBuilder: (BuildContext context, int index) {
              // RxList<Product>? filteredProducts = <Product>[].obs;
              // filteredProducts.value = globalController.homeDataList.value.products!
              //     .where((product) => product.product_section.toString() == globalController.homeDataList.value.productSections?[index].id.toString())
              //     .toList();
              return Obx(() {
                return
                  loading.value?
                      Ui.circularIndicator():
                  Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    globalController.homeDataList.value.productSections?[index].gridElements != null
                        ? BannerWidget(gridElements: globalController.homeDataList.value.productSections?[index].gridElements!)
                        : const SizedBox(),
                    sections(
                      index: index,
                      loading: loading,

                    ),
                  ],
                );
              });
            }) :
        ListView.builder(
            shrinkWrap: true,
            // key: UniqueKey(),
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,

            padding: getPadding(top: 0,bottom: getBottomPadding(context: context)+50),
            itemCount: globalController.homeDataList.value.categories?.length,
            itemBuilder: (BuildContext context, int index) {
              // RxList<Product>? filteredProducts = <Product>[].obs;
              // filteredProducts.value = globalController.homeDataList.value.products!
              //     .where((product) => product.product_section.toString() == globalController.homeDataList.value.productSections?[index].id.toString())
              //     .toList();
              return Obx(() {
                return
                  loading.value?
                  Ui.circularIndicator():
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      CategoriesViewProducts(
                        index: index,
                        loading: loading,

                      ),
                    ],
                  );
              });
            });
    });
  }
}
