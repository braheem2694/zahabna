import 'dart:convert';

import 'package:iq_mall/Product_widget/Product_widget.dart';
import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/screens/ProductDetails_screen/controller/ProductDetails_screen_controller.dart';
import 'package:iq_mall/screens/ProductDetails_screen/widgets/ProductInfo.dart';
import 'package:iq_mall/screens/ProductDetails_screen/widgets/SliderImages.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/screens/ProductDetails_screen/widgets/add_to_cart_button.dart';
import 'package:iq_mall/screens/ProductDetails_screen/widgets/variants.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/widgets/custom_image_view.dart';
import 'package:iq_mall/utils/ShConstant.dart';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'package:iq_mall/widgets/CommonWidget.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:iq_mall/widgets/ui.dart';
import 'package:uuid/uuid.dart';
import '../../main.dart';
import '../../models/HomeData.dart';
import '../../routes/app_routes.dart';
import '../../utils/ShImages.dart';
import '../../widgets/image_widget.dart';
import 'package:share_plus/share_plus.dart';

var uuid = Uuid();

class ProductDetails_screen extends StatelessWidget {
  late final ProductDetails_screenController controller;

  ProductDetails_screen({Key? key}) : super(key: key) {
    final tag = Get.arguments != null ? Get.arguments['tag'] ?? 'default' : prefs?.getString("tag");
    controller = Get.isRegistered<ProductDetails_screenController>(tag: "${UniqueKey()}$tag") ? Get.find<ProductDetails_screenController>(tag: tag) : Get.put(ProductDetails_screenController(), tag: "${UniqueKey()}$tag");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        globalController.cartCount--;
        return Future(() => true);
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar: Obx(() => controller.product.value != null
              ? Container(
                  height: getSize(40) + getBottomPadding(),
                  alignment: Alignment.topCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => AddToCartButtons(
                            product: controller.updatePriceInAddToCart.value ? controller.product.value! : controller.product.value!,
                            addingToCard: controller.addingToCard.value,
                            animatingAddToCardTick: controller.animatingAddToCardTick.value,
                            productDetailsController: controller,
                            onTap: () {
                              ProductDetails_screenController controller = Get.find(tag: Get.parameters.values.first);

                              if (controller.addingToCard.value) {
                                toaster(context, 'Please wait while processing the request'.tr);
                              } else {
                                if (controller.loading.value) {
                                  toaster(context, 'Please wait to load the quantity'.tr);
                                } else if ((controller.product.value?.product_qty_left ?? 0) < 1) {
                                  toaster(context, 'Out of Stock'.tr, title: "Alert".tr);
                                } else {
                                  controller.addingToCard.value = true;

                                  Ui.onTapWhatsapp(controller.product.value!, controller.product.value!.store.storeWhatsappNumber);
                                  controller.addingToCard.value = false;

                                  // controller.AddToCart(controller.product.value, '1', context).then((value) {
                                  //   // controller.product.value?.quantity = (int.parse(controller.product.value!.quantity!) + 1).toString();
                                  //   controller.addingToCard.value = false;
                                  //   if (value ?? false) {
                                  //     controller.createOverlayEntry(context);
                                  //     controller.applyTickAnimation();
                                  //   }
                                  //   Future.delayed(Duration(milliseconds: 900)).then((value) {
                                  //     context.read<Counter>().calculateTotal(0.0);
                                  //     Cart_ListController Cartcontroller = Get.find();
                                  //     Cartcontroller.GetCart();
                                  //   });
                                  // });
                                }
                              }
                            },
                          )),
                    ],
                  ),
                )
              : const SizedBox()),
          body: Hero(
            tag: UniqueKey(),
            createRectTween: (begin, end) {
              return MaterialRectCenterArcTween(begin: begin, end: end);
            },
            child: Obx(
              () => controller.fromBanner.value
                  ? Progressor_indecator()
                  : controller.product.value == null
                      ? const SizedBox()
                      : Padding(
                          padding: EdgeInsets.only(top: getTopPadding()),
                          child: IgnorePointer(
                            ignoring: controller.freez.value,
                            child: Stack(
                              alignment: Alignment.bottomLeft,
                              children: <Widget>[
                                Column(
                                  children: [
                                    SizedBox(
                                      height: getSize(50),
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              Get.back(result: controller.product.value);
                                            },
                                            child: Padding(
                                              padding: getPadding(left: 16.0),
                                              child: SizedBox(
                                                width: getSize(30),
                                                height: getSize(30),
                                                child: const Icon(
                                                  Icons.arrow_back_ios,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: getPadding(left: 16.0),
                                            child: Text(
                                              'Product Details'.tr,
                                              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                                            ),
                                          ),
                                          const Expanded(child: SizedBox()),
                                          // Padding(
                                          //   padding: getPadding(right: 8,),
                                          //
                                          //   child: InkWell(
                                          //     splashColor: Colors.transparent,
                                          //     focusColor: Colors.transparent,
                                          //     highlightColor: Colors.transparent,
                                          //     onTap: () =>
                                          //     {
                                          //       globalController.cartCount++,
                                          //
                                          //       Get.toNamed(AppRoutes.cartScreen,
                                          //
                                          //           parameters: {'tag': "${controller.product.value?.product_id}"}, arguments: {"fromKey": "product"}, preventDuplicates: false)
                                          //       // Get.to(() => Cart_Listscreen(),transition: Transition.cupertino,duration: Duration(milliseconds: 350),arguments: {"fromKey":"product"});
                                          //     },
                                          //     key: controller.endPointKey,
                                          //     child:
                                          //     ItemsCount.value.toString()!="" && ItemsCount.value.toString()!="0"?
                                          //     Badge(
                                          //       backgroundColor: ColorConstant.logoSecondColor,
                                          //       label: Text(
                                          //         ItemsCount.value.toString(),
                                          //         textAlign: TextAlign.center,
                                          //         style: TextStyle(
                                          //           color: Colors.white,
                                          //           fontSize: getFontSize(12),
                                          //           fontWeight: FontWeight.bold,
                                          //         ),
                                          //       ),
                                          //       child: CustomImageView(
                                          //         width: getSize(30),
                                          //         height: getSize(30),
                                          //         color: ColorConstant.logoFirstColor,
                                          //         svgPath: AssetPaths.cartIcon,
                                          //       ),
                                          //     ):CustomImageView(
                                          //       width: getSize(30),
                                          //       height: getSize(30),
                                          //       color: ColorConstant.logoFirstColor,
                                          //       svgPath: AssetPaths.cartIcon,
                                          //     ),
                                          //   ),
                                          // ),
                                          Padding(
                                            padding: getPadding(right: 8, left: 8),
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              highlightColor: Colors.transparent,
                                              onTap: () async {
                                                final box = context.findRenderObject() as RenderBox?;
                                                await Share.shareUri(
                                                  Uri.parse('cms.lebanonjewelry.net/product/${controller.product.value!.product_id}'),
                                                  sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
                                                );

                                                // await Share.shareUri( prefs!.getString('store_name').toString(),,
                                                //   chooserTitle: prefs!.getString('store_name').toString(),
                                                // );
                                              },
                                              child: CustomImageView(
                                                width: getSize(28),
                                                height: getSize(28),
                                                color: ColorConstant.logoFirstColor,
                                                image: AssetPaths.shareIcon,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      key: UniqueKey(),
                                      child: SingleChildScrollView(
                                        physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            Obx(
                                              () {
                                                return SliderImages(
                                                  newImages: controller.imagesInfo ?? <MoreImage>[].obs,
                                                  product: controller.product.value,
                                                );
                                              },
                                            ),
                                            Obx(
                                              () => controller.loading.value
                                                  ? Padding(
                                                      padding: getPadding(top: 15.0),
                                                      child: Ui.circularIndicator(color: ColorConstant.logoFirstColor),
                                                    )
                                                  : ProductInfo(
                                                      controller: controller,
                                                    ),
                                            ),
                                            SizedBox(height: 8),

                                            Obx(() {
                                              return _buildMetalList(controller.metals);
                                            }),
                                            SizedBox(height: 8),

                                            Obx(() {
                                              return controller.loading.value
                                                  ? SizedBox()
                                                  : Column(
                                                      children: [
                                                        _buildGemstoneStyles(controller.gemstoneStyles),
                                                      ],
                                                    );
                                            }),

                                            Obx(() => controller.variants.isNotEmpty && !controller.loading.value
                                                ? Variants(
                                                    productVariations: controller.variants,
                                                    controller: controller,
                                                  )
                                                : const SizedBox()),
                                            Obx(
                                              () => controller.loading.value
                                                  ? Container()
                                                  : controller.product.value?.express_delivery == 1
                                                      ? Padding(
                                                          padding: const EdgeInsets.only(left: 18.0),
                                                          child: Row(
                                                            children: [
                                                              mediaWidget(
                                                                prefs!.getString('express_delivery_img')!,
                                                                AssetPaths.placeholder,
                                                                width: 50,
                                                                height: 50,
                                                                isProduct: false,
                                                                fromKey: "filter",
                                                                fit: BoxFit.cover,
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.only(left: 12.0),
                                                                child: Text('Express Delivery'.tr),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : Container(),
                                            ),
                                            Obx(() {
                                              return controller.product.value?.model != null && controller.product.value?.model != ""
                                                  ? Padding(
                                                      padding: const EdgeInsets.only(left: 12.0),
                                                      child: Text("Model: ".tr + (controller.product.value?.model ?? '')),
                                                    )
                                                  : SizedBox();
                                            }),

                                            controller.product.value?.description.toString() == 'null' || controller.product.value?.description.toString() == ''
                                                ? const SizedBox()
                                                : Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: SelectableText(parse(controller.product.value?.description).body!.text),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                            // Padding(
                                            //   padding: const EdgeInsets.only(left: 15.0),
                                            //   child: ReviewsSection(),
                                            // ),

                                            Obx(() => !controller.loading.value
                                                ? Padding(
                                                    padding: getPadding(left: 8.0, right: 8.0, top: 10),
                                                    child: Container(
                                                      width: Get.width,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(width: 0.5, color: ColorConstant.logoFirstColor),
                                                          borderRadius: const BorderRadius.all(
                                                            Radius.circular(8.0),
                                                          ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.black.withOpacity(0.1), // Shadow color with opacity
                                                              spreadRadius: 1, // Spread radius
                                                              blurRadius: 2, // Blur radius
                                                              offset: const Offset(0, 2), // Position of the shadow
                                                            ),
                                                          ]),
                                                      child: Padding(
                                                        padding: getPadding(all: 8.0),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Padding(
                                                              padding: getPadding(left: 8.0, right: 8),
                                                              child: Row(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    "Store".tr,
                                                                    style: TextStyle(fontSize: getFontSize(15)),
                                                                  ),
                                                                  Expanded(child: SizedBox()),
                                                                  Padding(
                                                                    padding: getPadding(right: 8.0),
                                                                    child: Text(
                                                                      controller.product.value!.store.name ?? '',
                                                                      style: TextStyle(color: ColorConstant.logoFirstColor, fontSize: getFontSize(18)),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    decoration: BoxDecoration(border: Border.all(color: ColorConstant.logoFirstColor.withOpacity(0.5), width: 0.5), shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(5)),
                                                                    child: CustomImageView(
                                                                      image: controller.product.value!.store.image,
                                                                      width: getSize(35),
                                                                      height: getSize(35),
                                                                      fit: BoxFit.cover,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: getPadding(top: 8.0, left: 8, right: 8),
                                                              child: Divider(
                                                                color: ColorConstant.black900.withOpacity(0.2),
                                                                thickness: 0.5,
                                                                height: 0.5,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: getPadding(left: 8.0, right: 8, top: 8),
                                                              child: Obx(() {
                                                                return _buildProductCategories(controller.productCategories);
                                                              }),
                                                            ),

                                                            // Padding(
                                                            //   padding: getPadding(left: 8.0, right: 8, top: 8),
                                                            //   child: Divider(
                                                            //     color: ColorConstant.black900.withOpacity(0.2),
                                                            //     thickness: 0.5,
                                                            //     height: 0.5,
                                                            //   ),
                                                            // ),
                                                            // Padding(
                                                            //   padding: getPadding(left: 8.0, right: 8, top: 8),
                                                            //   child: Row(
                                                            //     crossAxisAlignment: CrossAxisAlignment.center,
                                                            //     children: [
                                                            //       Text("Contact Store".tr),
                                                            //       Expanded(child: SizedBox()),
                                                            //       GestureDetector(
                                                            //         behavior: HitTestBehavior.translucent,
                                                            //         onTap: () => Ui.launchWhatsApp(controller.product.value!.store.storeWhatsappNumber ?? '', controller.product.value!.store.name ?? ''),
                                                            //         child:
                                                            //         Icon(FontAwesomeIcons.whatsapp, color: ColorConstant.logoSecondColor,size: getSize(18),
                                                            //         )
                                                            //
                                                            //         // CustomImageView(
                                                            //         //   imagePath: AssetPaths.whatsapp,
                                                            //         //   width: getSize(30),
                                                            //         //   height: getSize(30),
                                                            //         //   fit: BoxFit.contain,
                                                            //         //
                                                            //         // ),
                                                            //       ),
                                                            //     ],
                                                            //   ),
                                                            // )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : SizedBox()),
                                            SizedBox(height: getSize(15)),
                                            Obx(() => !controller.loading.value
                                                ? controller.product.value!.fields.isEmpty
                                                    ? SizedBox()
                                                    : Padding(
                                                        padding: getPadding(left: 8.0, right: 8.0, top: 10, bottom: getBottomPadding()),
                                                        child: Container(
                                                          width: Get.width,
                                                          decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              border: Border.all(width: 0.5, color: ColorConstant.logoFirstColor),
                                                              borderRadius: const BorderRadius.all(
                                                                Radius.circular(8.0),
                                                              ),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors.black.withOpacity(0.1), // Shadow color with opacity
                                                                  spreadRadius: 1, // Spread radius
                                                                  blurRadius: 2, // Blur radius
                                                                  offset: const Offset(0, 2), // Position of the shadow
                                                                ),
                                                              ]),
                                                          child: Padding(
                                                            padding: getPadding(all: 8.0),
                                                            child: Padding(
                                                              padding: getPadding(
                                                                left: 8.0,
                                                                right: 8,
                                                                top: 8,
                                                              ),
                                                              child: Obx(() {
                                                                return Row(
                                                                  crossAxisAlignment: controller.productCategories.length == 1 ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      "Specifications".tr,
                                                                      style: TextStyle(fontSize: getFontSize(15)),
                                                                    ),
                                                                    Expanded(
                                                                      child: Align(
                                                                        alignment: Alignment.topRight,
                                                                        child: ListView.builder(
                                                                          itemCount: controller.product.value?.fields.length,
                                                                          shrinkWrap: true,
                                                                          padding: getPadding(top: 0),
                                                                          physics: NeverScrollableScrollPhysics(),
                                                                          itemBuilder: (BuildContext context, int index) {
                                                                            ItemFormField? specification = controller.product.value?.fields[index];
                                                                            return Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.end,
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: getPadding(bottom: controller.productCategories.length == 1 ? 0 : 8.0),
                                                                                  child: Row(
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: getPadding(right: 8.0),
                                                                                        child: Text(
                                                                                          specification?.field ?? "",
                                                                                          style: TextStyle(color: ColorConstant.logoSecondColor, fontSize: getFontSize(15)),
                                                                                        ),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: getPadding(right: 8.0),
                                                                                        child: Text(
                                                                                          specification?.field ?? "",
                                                                                          style: TextStyle(color: ColorConstant.logoSecondColor, fontSize: getFontSize(15)),
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                if (index != controller.productCategories.length - 1)
                                                                                  Padding(
                                                                                    padding: getPadding(bottom: 8),
                                                                                    child: Container(
                                                                                      width: Get.width * 0.35,
                                                                                      color: ColorConstant.logoSecondColor.withOpacity(0.5),
                                                                                      height: 0.5,
                                                                                    ),
                                                                                  )
                                                                              ],
                                                                            );
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                );
                                                              }),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                : SizedBox()),

                                            Obx(() {
                                              return controller.Similarproducts!.isEmpty
                                                  ? SizedBox()
                                                  : Padding(
                                                      padding: const EdgeInsets.only(top: 8.0),
                                                      child: horizontalHeading(
                                                        'Similar products'.tr,
                                                        callback: () {
                                                          // Ensure product and category_id are not null before using
                                                          if (controller.product.value?.r_flash_id != null) {
                                                            Get.toNamed(AppRoutes.View_All_Products, arguments: {
                                                              'title': 'Similar products'.tr,
                                                              'id': controller.product..value?.r_flash_id.toString(),
                                                              'type': 'category',
                                                            })?.then((value) {
                                                              globalController.updateCurrentRout(AppRoutes.tabsRoute);
                                                            });
                                                          }
                                                        },
                                                      ),
                                                    );
                                            }),
                                            // Obx(
                                            //   () => controller.similaritiesloading.value
                                            //       ? Container()
                                            //       : controller.Similarproducts == null || controller.Similarproducts!.isEmpty
                                            //           ? const SizedBox()
                                            //           : Padding(
                                            //               padding: const EdgeInsets.only(top: 8.0),
                                            //               child: horizontalHeading(
                                            //                 'Similar products'.tr,
                                            //                 callback: () {
                                            //                   // Ensure product and category_id are not null before using
                                            //                   if (controller.product.value?.r_flash_id != null) {
                                            //                     Get.toNamed(AppRoutes.View_All_Products, arguments: {
                                            //                       'title': 'Similar products'.tr,
                                            //                       'id': controller.product..value?.r_flash_id.toString(),
                                            //                       'type': 'category',
                                            //                     });
                                            //                   }
                                            //                 },
                                            //               ),
                                            //             ),
                                            // ),
                                            Obx(() => controller.similaritiesloading.value
                                                ? Container()
                                                : controller.Similarproducts!.isEmpty
                                                    ? Container(
                                                        height: 100,
                                                      )
                                                    : Padding(
                                                        padding: const EdgeInsets.only(bottom: 90.0),
                                                        child: ListView(
                                                          physics: const NeverScrollableScrollPhysics(),
                                                          shrinkWrap: true,
                                                          children: [
                                                            Container(
                                                              height: getVerticalSize(310),
                                                              width: MediaQuery.of(context).size.width,
                                                              margin: const EdgeInsets.only(top: spacing_standard_new),
                                                              child: ListView.builder(
                                                                  scrollDirection: Axis.horizontal,
                                                                  itemCount: controller.Similarproducts?.length,
                                                                  shrinkWrap: true,
                                                                  padding: const EdgeInsets.only(right: spacing_standard_new),
                                                                  itemBuilder: (context, index) {
                                                                    return Padding(
                                                                      padding: const EdgeInsets.only(right: 8.0, left: 8),
                                                                      child: ProductWidget(
                                                                        product: controller.Similarproducts![index],
                                                                      ),
                                                                    );
                                                                  }),
                                                            ),
                                                          ],
                                                        ),
                                                      ))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Obx(() => controller.freez.value
                                    ? Center(
                                        child: Progressor_indecator(),
                                      )
                                    : const SizedBox())
                              ],
                            ),
                          ),
                        ),
            ),
          )),
    );
  }

  Widget _buildMetalList(List<dynamic> metals) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: metals.map((metal) {
        List<Widget> properties = _getFilteredProperties(metal['properties']);
        if (properties.isEmpty) return SizedBox.shrink();
        return Padding(
          padding: getPadding(bottom: 8.0),
          child: _buildItem(metal['name'], properties, unit: metal['unit']),
        );
      }).toList(),
    );
  }

  Widget _buildGemstoneStyles(List<dynamic> gemstoneStyles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: gemstoneStyles.map((style) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(style['style_name'], style: TextStyle(fontSize: getFontSize(14), color: ColorConstant.logoFirstColor)),
            ),
            Wrap(
              spacing: 10.0, // Space between gemstones
              runSpacing: 8.0, // Space between rows
              children: (style['data'] as List).map((gemstone) {
                List<Widget> properties = _getFilteredProperties(gemstone['properties']);
                if (gemstone["isEdited"] == false) return const SizedBox.shrink();
                return _buildItem(
                  gemstone['name'],
                  properties,
                );
              }).toList(),
            ),
          ],
        );
      }).toList(),
    );
  }

  List<Widget> _getFilteredProperties(List<dynamic> properties) {
    return properties.expand<Widget>((property) {
      if (property['type'] == 'Number' || property['type'] == 'Text') {
        if (property['fieldValue'].toString().isNotEmpty) {
          return [
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black, // Default color for other text
                  fontSize: getFontSize(12),
                ),
                children: [
                  TextSpan(
                    text: "${property['field']}: ",
                    style: TextStyle(
                      color: ColorConstant.logoFirstColor,
                      fontSize: getFontSize(12), // Change this to your desired color
                    ),
                  ),
                  TextSpan(
                    text: "${property['fieldValue']} ",
                    style: TextStyle(
                      color: ColorConstant.logoFirstColor,
                      fontSize: getFontSize(12), // Change this to your desired color
                    ),
                  ),
                  TextSpan(
                    text: "${property['unit_of_measurement']}",
                    style: TextStyle(
                      color: ColorConstant.logoSecondColor, // Change this to your desired color
                      fontWeight: FontWeight.bold,
                      fontSize: getFontSize(12),
                    ),
                  ),
                ],
              ),
            ),
          ];
        }
      } else if (property['type'] == 'Select') {
        return property['values']
            .where((value) => value['isSelected'] == true)
            .map<Widget>((value) => Text(
                  "${property['field']}: ${value['value']}",
                  style: TextStyle(
                    color: ColorConstant.logoFirstColor, // Change this to your desired color
                    fontSize: getFontSize(12),
                  ),
                ))
            .toList(); // Fix: Ensures a List<Widget> is returned
      }
      return [];
    }).toList(); // Fix: Ensures the final output is a List<Widget>
  }

  Widget _buildItem(String title, List<Widget> properties, {String? unit}) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8),
      color: Color(0xFFf5f5f5),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Text(
                "$title ${unit != null ? unit : ''}",
                style: TextStyle(fontSize: getFontSize(12), color: ColorConstant.logoSecondColor),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Wrap(
                  spacing: 4.0, // Space between elements
                  runSpacing: 4.0, // Space between lines
                  children: _addCommaBetween(properties),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCategories(List<ProductCategories> categories) {
    return Padding(
      padding: getPadding(top: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: getPadding(
              bottom: 8,
            ),
            child: Text(
              "Categories",
              style: TextStyle(
                fontSize: getFontSize(16),
                fontWeight: FontWeight.bold,
                color: ColorConstant.logoSecondColor,
              ),
            ),
          ),
          GridView.builder(
            itemCount: categories.length,
            padding: getPadding(all: 0),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Two items per row
              mainAxisSpacing: 8, // Vertical spacing between rows
              crossAxisSpacing: 8, // Horizontal spacing between items
              childAspectRatio: 3.5, // Adjust aspect ratio for better alignment
            ),
            itemBuilder: (context, index) {
              ProductCategories productCat = categories[index];
              return Container(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    var f = {
                      "categories": [
                        productCat.id.toString(),
                      ],
                    };
                    String jsonString = jsonEncode(f);
                    Get.toNamed(AppRoutes.Filter_products, arguments: {
                      'title': productCat.categoryName ?? "",
                      'id': productCat.id,
                      'type': jsonString,
                    }, parameters: {
                      'tag': "${productCat.id}:${productCat.categoryName ?? ""}"
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 1),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: getPadding(right: 8.0),
                            child: Text(
                              productCat.categoryName ?? "",
                              style: TextStyle(color: ColorConstant.logoSecondColor, fontSize: getFontSize(12)),
                            ),
                          ),
                        ),
                        CustomImageView(
                          image: productCat.categoryImage,
                          width: getSize(35),
                          height: getSize(35),
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _addCommaBetween(List<Widget> properties) {
    List<Widget> formattedList = [];
    for (int i = 0; i < properties.length; i++) {
      formattedList.add(
        DefaultTextStyle(
          style: TextStyle(fontSize: getFontSize(12), color: ColorConstant.logoFirstColor), // Change color here
          child: properties[i],
        ),
      );

      if (i != properties.length - 1) {
        formattedList.add(
          Text(", ", style: TextStyle(fontSize: getFontSize(12), color: Colors.black54)),
        );
      }
    }
    return formattedList;
  }
}
