import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:iq_mall/Product_widget/Product_widget.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iq_mall/main.dart';

import '../../../cores/math_utils.dart';
import '../../../utils/ShImages.dart';
import '../../../widgets/ShWidget.dart';
import '../../../widgets/custom_image_view.dart';
import '../controller/Filter_Products_controller.dart';

// ignore: must_be_immutable
class CustomListView extends StatelessWidget {
  final Filter_ProductsController controller;

  const CustomListView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Align(
        alignment: controller.Products?.length == 1 ? Alignment.centerLeft : Alignment.center,
        child:
            controller.Products!.isEmpty?Center(
                child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: CustomImageView(
                      image: AssetPaths.noresultsfound,
                      height: Get.width * 0.8,
                      width: Get.width * 0.8,
                      fit: BoxFit.cover,
                    ))):
            Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List.generate(
            (controller.Products!.length / 2).ceil(),
                (rowIndex) {
              final startIndex = rowIndex * 2;
              final endIndex = startIndex + 2;
              return Row(
                children: List.generate(
                  endIndex <=  controller.Products!.length ? 2 : 1,
                      (columnIndex) {
                    final index = startIndex + columnIndex;
                    final product = controller.Products!.where((product) => product.cart_id != null).elementAt(index);
                    return product.cart_id != null
                        ? Expanded(
                      child: Padding(
                        padding: getPadding(all: 4.0),
                        child: ProductWidget(product: product,fromKey: "filter",tag:controller.tag),
                      ),
                    )
                        : SizedBox();
                  },
                ),
              );

            },
          ),
        )

      // GridView.builder(
      //     shrinkWrap: true,
      //     key: UniqueKey(),
      //     physics: const NeverScrollableScrollPhysics(),
      //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      //         crossAxisCount: 2, // Adjust the number of items per row
      //         crossAxisSpacing: 10.0, // Spacing between items horizontally
      //         mainAxisSpacing: 10.0,
      //         childAspectRatio: 0.58 // Spacing between items vertically
      //         ),
      //     itemCount: controller.Products!.length,
      //     itemBuilder: (context, index) {
      //       final product = controller.Products?.where((product) => product.cart_id != null).elementAt(index);
      //       return product?.cart_id != null ? ProductWidget(product: product!,fromKey: "filter",) : SizedBox();
      //     },
      //   )

        // Wrap(
        //             spacing: 5.0,
        //             runSpacing: 8.0,
        //             children: List.generate(controller.Products!.length, (index) {
        //               return ProductWidget(
        //                 product: controller.Products![index],
        //               );
        //             }),
        //           ),
        ));
  }
}
