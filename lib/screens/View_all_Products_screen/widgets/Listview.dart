import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iq_mall/Product_widget/Product_widget.dart';

import '../../../cores/math_utils.dart';
import '../controller/View_all_Products_controller.dart';

class CustomListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    View_all_ProductsController controller = Get.find();
    return

      Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(
              (controller.Products!.length / 2).ceil(),
                  (rowIndex) {
                final startIndex = rowIndex * 2;
                final endIndex = startIndex + 2;
                return Row(
                  children: List.generate(
                    endIndex <= controller.Products!.length ? 2 : 1,
                        (columnIndex) {
                      final index = startIndex + columnIndex;
                      final product = controller.Products!.where((product) => product.cart_id != null).elementAt(index);
                      return product.cart_id != null
                          ? Expanded(
                        child: Padding(
                          padding: getPadding(all: 4.0),
                          child: ProductWidget(product: product),
                        ),
                      )
                          : SizedBox();
                    },
                  ),
                );
              },
            ),
          )

        // Wrap(
        //   spacing: 10.0,
        //   runSpacing: 10.0,
        //   children:
        //   products!
        //       .map((product) => product.cart_id != null
        //           ? ProductWidget(product: product)
        //           : SizedBox())
        //       .toList(),
        // ),
      );
    //   ListView(
    //   physics: NeverScrollableScrollPhysics(),
    //   shrinkWrap: true,
    //   children: [
    //     Obx(()=>Center(
    //       child: Wrap(
    //         spacing: 10.0,
    //         runSpacing: 10.0,
    //         children: List.generate(controller.Products!.length, (index) {
    //           return ProductWidget(
    //             product: controller.Products![index],
    //           );
    //         }),
    //       ),
    //     )),
    //
    //   ],
    // );
  }
}
