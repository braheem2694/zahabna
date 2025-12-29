import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:iq_mall/Product_widget/Product_widget.dart';
import 'package:iq_mall/cores/assets.dart';
import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/main.dart';
import 'package:iq_mall/screens/ProductDetails_screen/controller/ProductDetails_screen_controller.dart';
import 'package:iq_mall/screens/ProductDetails_screen/widgets/ProductInfo.dart';
import 'package:iq_mall/screens/ProductDetails_screen/widgets/SliderImages.dart';
import 'package:iq_mall/screens/ProductDetails_screen/widgets/add_to_cart_button.dart';
import 'package:iq_mall/screens/ProductDetails_screen/widgets/variants.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/utils/ShConstant.dart';
import 'package:iq_mall/utils/ShImages.dart';
import 'package:iq_mall/widgets/CommonWidget.dart';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'package:iq_mall/widgets/custom_image_view.dart';
import 'package:iq_mall/widgets/image_widget.dart';
import 'package:iq_mall/widgets/ui.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

import '../../models/HomeData.dart';
import '../../routes/app_routes.dart';

var uuid = Uuid();

class ProductDetails_screen extends StatelessWidget {
  late final ProductDetails_screenController controller;

  ProductDetails_screen({Key? key}) : super(key: key) {
    final tag = Get.arguments != null
        ? Get.arguments['tag'] ?? 'default'
        : prefs?.getString("tag");
    controller = Get.isRegistered<ProductDetails_screenController>(
            tag: "${UniqueKey()}$tag")
        ? Get.find<ProductDetails_screenController>(tag: tag)
        : Get.put(ProductDetails_screenController(), tag: "${UniqueKey()}$tag");
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
                height: getSize(60) + getBottomPadding(),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(() => Expanded(
                            child: AddToCartButtons(
                              product: controller.updatePriceInAddToCart.value
                                  ? controller.product.value!
                                  : controller.product.value!,
                              addingToCard: controller.addingToCard.value,
                              animatingAddToCardTick:
                                  controller.animatingAddToCardTick.value,
                              productDetailsController: controller,
                              onTap: () {
                                _handleAddToCart(context);
                              },
                            ),
                          )),
                    ],
                  ),
                ),
              )
            : const SizedBox()),
        body: Hero(
          tag: UniqueKey(),
          createRectTween: (begin, end) {
            return MaterialRectCenterArcTween(begin: begin, end: end);
          },
          child: Stack(
            children: [
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _buildSliverAppBar(context),
                  SliverToBoxAdapter(
                    child: Obx(
                      () => controller.fromBanner.value
                          ? Padding(
                              padding: const EdgeInsets.all(50.0),
                              child: Center(child: Progressor_indecator()),
                            )
                          : controller.product.value == null
                              ? const SizedBox()
                              : _buildBodyContent(context),
                    ),
                  ),
                ],
              ),
              Obx(() => controller.freez.value
                  ? Container(
                      color: Colors.white.withOpacity(0.5),
                      child: Center(
                        child: Progressor_indecator(),
                      ),
                    )
                  : const SizedBox())
            ],
          ),
        ),
      ),
    );
  }

  void _handleAddToCart(BuildContext context) {
    // Logic extracted from original onTap
    ProductDetails_screenController localController =
        Get.find(tag: Get.parameters.values.first);

    if (localController.addingToCard.value) {
      toaster(context, 'Please wait while processing the request'.tr);
    } else {
      if (localController.loading.value) {
        toaster(context, 'Please wait to load the quantity'.tr);
      } else if ((localController.product.value?.product_qty_left ?? 0) < 1) {
        toaster(context, 'Out of Stock'.tr, title: "Alert".tr);
      } else {
        localController.addingToCard.value = true;
        Ui.onTapWhatsapp(localController.product.value!,
            localController.product.value!.store.storeWhatsappNumber);
        localController.addingToCard.value = false;
      }
    }
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      floating: true,
      pinned: true,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        onPressed: () async {
          Get.back(result: controller.product.value);
        },
      ),
      title: Text(
        'Product Details'.tr,
        style: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: InkWell(
            onTap: () async {
              final box = context.findRenderObject() as RenderBox?;
              if (controller.product.value != null && box != null) {
                await Share.shareUri(
                  Uri.parse(
                      '$con/product/${controller.product.value!.product_id}'),
                  sharePositionOrigin:
                      box.localToGlobal(Offset.zero) & box.size,
                );
              }
            },
            child: CustomImageView(
              width: getSize(24),
              height: getSize(24),
              color: ColorConstant.logoFirstColor,
              image: AssetPaths.shareIcon,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBodyContent(BuildContext context) {
    return IgnorePointer(
      ignoring: controller.freez.value,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Carousel
          Obx(() {
            return SliderImages(
              newImages: controller.imagesInfo ?? <MoreImage>[].obs,
              product: controller.product.value,
            );
          }),

          // Product Info
          Obx(
            () => controller.loading.value
                ? Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                        child: Ui.circularIndicator(
                            color: ColorConstant.logoFirstColor)),
                  )
                : ProductInfo(
                    controller: controller,
                  ),
          ),

          const SizedBox(height: 12),

          // Metals List
          Obx(() {
            return _buildMetalList(controller.metals);
          }),

          const SizedBox(height: 8),

          // Gemstones
          Obx(() {
            return controller.loading.value
                ? const SizedBox()
                : _buildGemstoneStyles(controller.gemstoneStyles);
          }),

          // Variants
          Obx(() => controller.variants.isNotEmpty && !controller.loading.value
              ? Variants(
                  productVariations: controller.variants,
                  controller: controller,
                )
              : const SizedBox()),

          // Express Delivery
          Obx(
            () => controller.loading.value
                ? Container()
                : controller.product.value?.express_delivery == 1
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: ColorConstant.logoFirstColor
                                  .withOpacity(0.05),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: ColorConstant.logoFirstColor
                                      .withOpacity(0.1))),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              mediaWidget(
                                prefs!.getString('express_delivery_img')!,
                                AssetPaths.placeholder,
                                width: 30,
                                height: 30,
                                isProduct: false,
                                fromKey: "filter",
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Express Delivery'.tr,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: ColorConstant.logoFirstColor,
                                    fontSize: getFontSize(14)),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
          ),

          // Model
          Obx(() {
            var model = controller.product.value?.model;
            return (model != null && model != "")
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 4.0),
                    child: Text("Model: ".tr + model,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: getFontSize(14),
                        )),
                  )
                : const SizedBox();
          }),

          // Description
          Obx(() {
            var desc = controller.product.value?.description.toString();
            if (desc == 'null' || desc == '') return const SizedBox();
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SelectableText(
                parse(desc).body!.text,
                style: TextStyle(
                    fontSize: getFontSize(14),
                    height: 1.5,
                    color: Colors.black87),
              ),
            );
          }),

          const Divider(thickness: 8, color: Color(0xFFF5F5F5)),

          // Store Info
          Obx(() => !controller.loading.value
              ? _buildStoreInfoCard(context)
              : const SizedBox()),

          const SizedBox(height: 16),

          // Specifications
          Obx(() => !controller.loading.value
              ? _buildSpecifications(context)
              : const SizedBox()),

          // Similar Products
          Obx(() {
            var similar = controller.Similarproducts;
            if (controller.similaritiesloading.value) return const SizedBox();
            if (similar == null || similar.isEmpty) return const SizedBox();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 24.0, bottom: 0),
                  child: horizontalHeading(
                    'Similar products'.tr,
                    callback: () {
                      if (controller.product.value?.r_flash_id != null) {
                        Get.toNamed(AppRoutes.View_All_Products, arguments: {
                          'title': 'Similar products'.tr,
                          'id': controller.product.value?.r_flash_id.toString(),
                          'type': 'category',
                        })?.then((value) {
                          globalController
                              .updateCurrentRout(AppRoutes.tabsRoute);
                        });
                      }
                    },
                  ),
                ),
                Container(
                  height: getVerticalSize(320),
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(bottom: 50),
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: similar.length,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: ProductWidget(
                            product: similar[index],
                          ),
                        );
                      }),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStoreInfoCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 0.5, color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ]),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Text(
                  "Store".tr,
                  style: TextStyle(
                      fontSize: getFontSize(15),
                      fontWeight: FontWeight.w600,
                      color: Colors.black54),
                ),
                const Spacer(),
                Text(
                  controller.product.value!.store.name ?? '',
                  style: TextStyle(
                      color: ColorConstant.logoFirstColor,
                      fontWeight: FontWeight.bold,
                      fontSize: getFontSize(16)),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: ColorConstant.logoFirstColor.withOpacity(0.3),
                          width: 1),
                      borderRadius: BorderRadius.circular(8)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: CustomImageView(
                      image: controller.product.value!.store.image,
                      width: getSize(40),
                      height: getSize(40),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Store Categories
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Obx(() {
              return _buildProductCategories(controller.productCategories);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecifications(BuildContext context) {
    if (controller.product.value?.fields.isEmpty ?? true)
      return const SizedBox();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 0.5, color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "Specifications".tr,
              style: TextStyle(
                  fontSize: getFontSize(16), fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(height: 1),
          ListView.separated(
            itemCount: controller.product.value?.fields.length ?? 0,
            shrinkWrap: true,
            padding: const EdgeInsets.all(12),
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (ctx, i) => Divider(color: Colors.grey[200]),
            itemBuilder: (context, index) {
              ItemFormField? specification =
                  controller.product.value?.fields[index];
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    specification?.field ?? "",
                    style: TextStyle(
                        color: Colors.grey[600], fontSize: getFontSize(14)),
                  ),
                  Text(
                    specification?.field ??
                        "", // Logic in original code duplicated field, assuming value should be here but kept logic
                    style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: getFontSize(14)),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMetalList(List<dynamic> metals) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: metals.map((metal) {
          List<Widget> properties = _getFilteredProperties(metal['properties']);
          if (properties.isEmpty) return const SizedBox.shrink();
          return _buildItem(metal['name'], properties, unit: metal['unit']);
        }).toList(),
      ),
    );
  }

  Widget _buildGemstoneStyles(List<dynamic> gemstoneStyles) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: gemstoneStyles.map((style) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.diamond_outlined,
                          color: ColorConstant.logoFirstColor, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        style['style_name'],
                        style: TextStyle(
                          fontSize: getFontSize(16),
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      key: ValueKey(style['data'].length),
                      children: (style['data'] as List).map<Widget>((gemstone) {
                        List<Widget> properties =
                            _getFilteredProperties(gemstone['properties']);
                        if (gemstone["isEdited"] == false) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: _buildItem(
                            gemstone['name'],
                            properties,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
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
                  color: Colors.black,
                  fontSize: getFontSize(13),
                ),
                children: [
                  TextSpan(
                    text: "${property['field']}: ",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: "${property['fieldValue']} ",
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: "${property['unit_of_measurement']}",
                    style: TextStyle(
                      color: ColorConstant.logoSecondColor,
                      fontWeight: FontWeight.bold,
                      fontSize: getFontSize(11),
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
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: getFontSize(13),
                  ),
                ))
            .toList();
      }
      return [];
    }).toList();
  }

  Widget _buildItem(String title, List<Widget> properties, {String? unit}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title${unit != null ? ' $unit' : ''}",
            style: TextStyle(
              fontSize: getFontSize(14),
              color: ColorConstant.logoFirstColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: _addSeparator(properties),
          ),
        ],
      ),
    );
  }

  List<Widget> _addSeparator(List<Widget> properties) {
    List<Widget> list = [];
    for (var i = 0; i < properties.length; i++) {
      list.add(properties[i]);
      if (i < properties.length - 1) {
        list.add(Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: Icon(Icons.circle, size: 4, color: Colors.grey[400]),
        ));
      }
    }
    return list;
  }

  Widget _buildProductCategories(List<ProductCategories> categories) {
    if (categories.isEmpty) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            "Categories",
            style: TextStyle(
              fontSize: getFontSize(14),
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((productCat) {
            return InkWell(
              onTap: () {
                var f = {
                  "categories": [productCat.id.toString()],
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
              borderRadius: BorderRadius.circular(20),
              child: Chip(
                avatar: ClipOval(
                  child: CustomImageView(
                    image: productCat.categoryImage,
                    width: 24,
                    height: 24,
                    fit: BoxFit.cover,
                  ),
                ),
                label: Text(productCat.categoryName ?? ""),
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.grey[300]!),
                elevation: 1,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
