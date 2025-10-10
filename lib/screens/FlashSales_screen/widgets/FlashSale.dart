import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iq_mall/widgets/CommonFunctions.dart';
import 'package:html/parser.dart';
import '../../../Product_widget/Product_widget.dart';
import '../../../cores/math_utils.dart';
import '../../../main.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/ShColors.dart';
import '../../../utils/ShImages.dart';
import '../../../widgets/ViewAllButton.dart';

//ignore @immutable;
class FlashLists extends StatelessWidget {
  final items;
  final type;
  final flashSale;

  FlashLists(this.items, this.type, this.flashSale);

  @override
  Widget build(BuildContext context) {
    return type == 0
        ? Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,


              children: List.generate(
              (items!.length / 2).ceil(),
              (rowIndex) {
                final startIndex = rowIndex * 2;
                final endIndex = startIndex + 2;
                return Row(
                  children: List.generate(
                    endIndex <= items!.length ? 2 : 1,
                    (columnIndex) {
                      final index = startIndex + columnIndex;
                      final product = items!.where((product) => product.cart_id != null).elementAt(index);
                      return product.cart_id != null
                          ? Padding(
                            padding: getPadding(all: 4.0),
                            child: ProductWidget(product: product),
                          )
                          : const SizedBox();
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
            )
        : ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ProductWidget(
                product: items[index],
              );
            },
          );
  }
}
