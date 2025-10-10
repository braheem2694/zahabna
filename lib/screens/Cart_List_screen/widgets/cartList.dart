import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/routes/app_routes.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/utils/ShConstant.dart';
import 'package:iq_mall/widgets/ui.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:uuid/uuid.dart';
import '../../../Product_widget/Product_widget.dart';
import '../../../cores/assets.dart';
import '../../../models/HomeData.dart';
import '../../../widgets/custom_image_view.dart';
import '../../../widgets/image_new_widget.dart';
import '../../../widgets/image_widget.dart';
import '../../ProductDetails_screen/ProductDetails_screen.dart';
import '../controller/Cart_List_controller.dart';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'package:iq_mall/main.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iq_mall/utils/ShImages.dart';
import 'Quantity.dart';
import 'package:iq_mall/models/functions.dart';

class cartList extends StatelessWidget {
  Cart_ListController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Stack(
        alignment: Alignment.center,
        children: [
          ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: cartlist?.length,
            shrinkWrap: false,
            controller: controller.ScrollListenerCART,
            padding: const EdgeInsets.only(top: 5),
            physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
            itemBuilder: (context, index) {
              return Padding(
                padding: getPadding(bottom: index == cartlist!.length - 1 ? 65 : 8.0),
                child: Obx(() {
                  return ImageFiltered(
                    imageFilter: ImageFilter.blur(
                      sigmaX: 4.0,
                      sigmaY: 4.0,
                    ),
                    enabled: controller.deleting_items.value,
                    child: Stack(
                      alignment: Alignment.topLeft,
                      children: [
                        Padding(
                          padding: getPadding(bottom: 10.0),
                          child: GestureDetector(
                            onTap: () {
                              String tag = uuid.v4().toString();
                              print("tagswswsw: $tag");

                              if( globalController.cartListRoute.value != AppRoutes.tabsRoute){
                                globalController.cartCount++;

                              }


                              Get.toNamed(
                                AppRoutes.Productdetails_screen,
                                arguments: {
                                  'product': cartlist![index],
                                  'fromCart': false,
                                  'productSlug': null,
                              'tag': Uuid().v4(),
                                },
                                parameters: {
                                  'tag': Uuid().v4(), // Generate a unique tag for each item
                                },
                              )?.then((value) {
                                globalController.updateCurrentRout(Get.currentRoute);
                              });

                              // Get.toNamed(AppRoutes.Productdetails_screen,
                              //     arguments: {
                              // 'tag': "${cartlist![index].product_id}"
                              // },
                              // );
                              // Get.to(()=>
                              //     ProductDetails_screen(
                              //       product: cartlist![index],
                              //       fromCart: false,
                              //       productSlug: null,
                              //     ),
                              // );

                            },
                            onLongPress: () {
                              controller.Products_to_delete.add(cartlist![index]);
                              controller.select(cartlist![index].product_id);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(15.0),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1), // Shadow color with opacity
                                      spreadRadius: 1, // Spread radius
                                      blurRadius: 2, // Blur radius
                                      offset: const Offset(0, 3), // Position of the shadow
                                    ),
                                  ]),
                              child: IntrinsicHeight(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    // Container(
                                    //   decoration: BoxDecoration(
                                    //       color: ColorConstant.gray300,
                                    //       borderRadius: const BorderRadius.all(Radius.circular(5)),
                                    //       shape: BoxShape.rectangle),
                                    //   child: ProgressiveImage(
                                    //
                                    //     placeholder: AssetImage( AssetPaths.placeholder,),
                                    //     // size: 1.87KB
                                    //     thumbnail: CachedNetworkImageProvider(
                                    //       convertToThumbnailUrl( cartlist![index].main_image ?? '', isBlurred: true),
                                    //     ),
                                    //     blur: 0,
                                    //     // size: 1.29MB
                                    //     image:
                                    //     CachedNetworkImageProvider(convertToThumbnailUrl( cartlist![index].main_image ?? "", isBlurred: false) ?? ''),
                                    //     height: getSize(120),
                                    //     width: getSize(120),
                                    //     fit: BoxFit.cover,
                                    //     fadeDuration: const Duration(milliseconds: 200),
                                    //   ),
                                    // ),
                                    Padding(
                                      padding:getPadding(all: 8.0),
                                      child:

                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10.0),
                                        child: CustomImageView(
                                          height: getSize(112),
                                            width: getSize(112),
                                            fit: BoxFit.cover,
                                          color: ColorConstant.logoFirstColor,
                                          url: cartlist![index].main_image,
                                        ),
                                      )                                      // mediaWidget(
                                      //   cartlist![index].main_image,
                                      //   AssetPaths.placeholder,
                                      //   // backgroundColor: ColorConstant.gray300,
                                      //   height: getSize(112),
                                      //   width: getSize(112),
                                      //   fromKey: "",
                                      //   fit: BoxFit.cover,
                                      // ),
                                    ),
                                    Padding(
                                      padding: getPadding(left: 10.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          const SizedBox(
                                            height: spacing_standard,
                                          ),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: getHorizontalSize(187),
                                                child: Padding(
                                                  padding: const EdgeInsets.only(right: 8.0),
                                                  child: Text(
                                                    cartlist![index].product_name??'',
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 3,
                                                    textAlign: TextAlign.left,
                                                    style: const TextStyle(
                                                      color: sh_textColorPrimary,
                                                      fontSize: textSizeSMedium,
                                                      overflow: TextOverflow.ellipsis,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  // text(
                                                  //   cartlist![index].product_name,
                                                  //   textColor: sh_textColorPrimary,
                                                  //   fontSize: textSizeSMedium,
                                                  //   textOverflow: TextOverflow.ellipsis,
                                                  //
                                                  // ),
                                                ),
                                              ),
                                              InkWell(
                                                splashColor: Colors.transparent,
                                                highlightColor: Colors.transparent,
                                                onTap: () {
                                                  controller.select(int.parse(cartlist![index].product_id.toString()));
                                                },
                                                onLongPress: () {
                                                  controller.select(int.parse(cartlist![index].product_id.toString()!));
                                                },
                                                child: Obx(() {
                                                  return Icon(
                                                    controller.selectedProductIds.contains(int.parse(cartlist![index].product_id.toString())) ? Icons.radio_button_checked_rounded : Icons.radio_button_off,
                                                    color: ColorConstant.logoSecondColor,
                                                    size: 22,
                                                  );
                                                }),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              cartlist?[index].price_after_discount != null
                                                  ? Text(
                                                      sign.toString() + cartlist![index].price_after_discount.toString(),
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: price_color,
                                                        fontSize: getFontSize(15),
                                                        decoration: TextDecoration.none,
                                                      ),
                                                    )
                                                  : Container(),
                                              Padding(
                                                padding: getPadding(left: 4.0),
                                                child: Text(
                                                  sign.toString() + cartlist![index].product_price.toString(),
                                                  style: TextStyle(
                                                    fontWeight: cartlist![index].price_after_discount == null || cartlist![index].price_after_discount.toString() == 'null'
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                    color: cartlist![index].price_after_discount != null ? discount_price_color : price_color,
                                                    fontSize: cartlist![index].price_after_discount != null || cartlist![index].price_after_discount.toString() == 'null'
                                                        ? getFontSize(14)
                                                        : getFontSize(12),
                                                    decoration: cartlist![index].price_after_discount != null ? TextDecoration.lineThrough : TextDecoration.none,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          cartlist![index].variations?.isEmpty ?? true
                                              ? Container()
                                              : SizedBox(
                                                  height: 30,
                                                  width: getHorizontalSize(170),
                                                  child: ListView.separated(
                                                    shrinkWrap: true,
                                                    scrollDirection: Axis.horizontal,
                                                    // to scroll items in one line (horizontally)
                                                    itemCount: cartlist![index].variations?.length ?? 0,
                                                    itemBuilder: (context, index2) {
                                                      final variation = cartlist![index].variations![index2];

                                                      if (variation.is_color == 1) {
                                                        return Row(
                                                          children: [
                                                            Text(
                                                              '${variation.type}: ',
                                                              style: TextStyle(fontSize: getFontSize(12)),
                                                            ),
                                                            Container(
                                                              width: getSize(15),
                                                              margin: const EdgeInsets.only(left: 8, right: 8),
                                                              decoration: BoxDecoration(
                                                                shape: BoxShape.circle,
                                                                color: Color(int.parse(variation.color!.substring(1), radix: 16) + 0xFF000000),

                                                                // This will round the container
                                                                border: Border.all(
                                                                  color: Colors.black, // Set border color
                                                                  width: 1.0, // Set border width
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      } else {
                                                        return Row(
                                                          children: [
                                                            Text(
                                                              '${variation.type}: ',
                                                              style: TextStyle(fontSize: getFontSize(12)),
                                                            ),
                                                            Container(
                                                              margin: const EdgeInsets.only(left: 8, right: 8),
                                                              child: Text(
                                                                variation.name!,
                                                                style: TextStyle(fontSize: getFontSize(12)),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      }
                                                    },
                                                    separatorBuilder: (context, index) {
                                                      return const VerticalDivider(
                                                        width: 5.0, // adjust width as necessary
                                                        color: Colors.black,
                                                        indent: 5.0,
                                                      );
                                                    },
                                                  ),
                                                ),
                                          cartlist![index].shipping_cost != null && prefs!.getString('has_shipping') == '1'
                                              ? cartlist![index].free_shipping.toString() != '1'
                                                  ? Padding(
                                                      padding: const EdgeInsets.only(left: 15.0, bottom: 5),
                                                      child: Row(
                                                        children: [
                                                          Obx(() => Text(
                                                              "${'Shipping'.tr} ${sign.value}${formatter.format(double.parse(cartlist![index].shipping_cost.toString()) * int.parse(cartlist![index].multi_shipping.toString() == '1' ? cartlist![index].quantity.toString() : '1'))}")),
                                                        ],
                                                      ),
                                                    )
                                                  : Padding(
                                                      padding: const EdgeInsets.only(left: 15.0, bottom: 5),
                                                      child: Row(
                                                        children: [
                                                          Obx(() => const Text("Free Shipping")),
                                                        ],
                                                      ),
                                                    )
                                              : Container(),
                                          const Expanded(child: SizedBox()),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,

                                            children: [
                                              SizedBox(
                                                width: getHorizontalSize(114),
                                                height: getSize(28),
                                                child:

                                                Obx(() => globalController.refreshingPrice.value
                                                    ? Ui.circularIndicator()
                                                    : cartlist![index].sales_discount.toString() == 'null'
                                                    ? Text(
                                                  "$sign ${controller.calculateTotalCost(cartlist![index].product_price, cartlist![index])}",
                                                  style: const TextStyle(color: sh_textColorPrimary, fontSize: 18, fontWeight: FontWeight.bold),
                                                )
                                                    : Text(
                                                  "$sign ${controller.calculateTotalCost(cartlist![index].price_after_discount!, cartlist![index])}",
                                                  style: const TextStyle(color: sh_textColorPrimary, fontSize: 18, fontWeight: FontWeight.bold),
                                                )),
                                              ),
                                              Padding(
                                                padding: getPadding(left: 5.0),
                                                child: CartItemWidget(
                                                  index: index,
                                                ),
                                              ),
                                            ],
                                          ),

                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  );
                }),
              );
            },
          ),
          Obx(() {
            return controller.deleting_items.value ? Ui.circularIndicator(color: MainColor, width: getSize(30), height: getSize(30)) : SizedBox();
          })
        ],
      );
    });
  }
}
