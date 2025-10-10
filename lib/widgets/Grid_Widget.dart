import 'dart:convert';
import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart' as slider;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'package:iq_mall/widgets/ui.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../Product_widget/Product_widget.dart';
import '../main.dart';
import '../models/HomeData.dart';
import '../routes/app_routes.dart';
import '../screens/Home_screen_fragment/controller/Home_screen_fragment_controller.dart';
import '../screens/ProductDetails_screen/ProductDetails_screen.dart';
import '../screens/ProductDetails_screen/widgets/better_player.dart';
import '../screens/Stores_details/widgets/slider_item_widget.dart';
import '../utils/ShColors.dart';
import '../utils/ShImages.dart';
import 'chewie_player.dart';
import 'custom_image_view.dart';
import 'image_widget.dart';
import 'media_widget.dart';

class BannerWidget extends StatefulWidget {
  final List<GridElement>? gridElements;

  BannerWidget({this.gridElements});

  @override
  _BannerWidgetState createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    super.initState();
  }

  RxBool loading = false.obs;
  Product? product;
  RxInt sliderIndex = 0.obs;

  Get_product(slug) async {
    bool success = false;
    loading.value = true;

    Map<String, dynamic> response = await api.getData({
      'token': prefs!.getString("token") ?? "",
      'productId': slug,
    }, "products/get-product-by-id");

    if (response.isNotEmpty) {
      success = response["succeeded"];
      if (response["product"] != null) {
        product = Product.fromJson(response["product"]);

        Get.toNamed(AppRoutes.Productdetails_screen, arguments: {
          'product': product,
          'fromCart': false,
          'productSlug': null,
          'from_banner': true,
          'tag': "${UniqueKey()}${product?.product_id}"
        }, parameters: {
          'tag': "${product?.product_id}"
        })?.then((value) {
          globalController.updateCurrentRout(AppRoutes.tabsRoute);
          globalController.cartCount = 0;
        });

        // Get.to(
        //   () => ProductDetails_screen(
        //     product: product,
        //     fromCart: false,
        //     productSlug: null,
        //     from_banner: true,
        //   ),
        //
        // );
        // Get.toNamed(AppRoutes.Productdetails_screen, arguments: {'product': product, 'from_cart': false, "from_banner": true});
      } else {
        toaster(context, response["message"]);
      }
    }
    if (success) {
      loading.value = false;
    } else {
      loading.value = false;
    }
    return success;
  }

  double scale = 1; // adjust this value as needed

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double screenHeight = 270;
    double spaceHeight = 10; // height of the space between each row

    // Initialize to 0
    double totalHeight = 0;

    // Calculate the totalHeight by finding the max 'y + h'
    for (var element in widget.gridElements!) {
      // print("elementasdasdas  ${element.main_image}");
      double y = scale * (double.parse(element.y) / 12) * screenHeight;
      double h = ((double.parse(element.h))) * 13;

      int numberOfRows = int.parse(element.h);
      double extraSpace = (numberOfRows - 1) * spaceHeight;

      h += extraSpace;

      if (y + h > totalHeight) {
        totalHeight = element.main_image.toString() != "null" && !element.main_image.toString().toLowerCase().endsWith(".webp") ? (y + h) : 0;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 4, right: 2),
      child: SizedBox(
        height: totalHeight, // Use the calculated total height here
        child: Stack(
          children: widget.gridElements!.map((element) {
            double x = scale * (double.parse(element.x) / 12) * screenWidth;
            double y = scale * (double.parse(element.y) / 12) * screenHeight;
            double w = scale * (double.parse(element.w) / 12) * screenWidth;
            double h = ((double.parse(element.h))) * 22;

            return Positioned(
              left: x,
              top: y,
              child: SizedBox(
                width: w - 8, // Reduced width by 8 to account for padding
                height: element.main_image.toString() != "null" ? h : 0,
                child: GestureDetector(
                  onTap: () async {
                    if (element.actions[0].target_type == 'product') {
                      Get.toNamed(AppRoutes.Productdetails_screen, arguments: {
                        'product': null,
                        'fromCart': false,
                        'productSlug': element.actions[0].targetId,
                        'from_banner': true,
                        'tag': "${UniqueKey()}${product?.product_id}"
                      }, parameters: {
                        'tag': "${UniqueKey()}${product?.product_id}"
                      })?.then((value) {
                        globalController.updateCurrentRout(Get.currentRoute);
                        globalController.cartCount = 0;
                      });

                      // Get.to(
                      //   () => ProductDetails_screen(
                      //     product: null,
                      //     fromCart: false,
                      //     productSlug: element.actions[0].slug,
                      //     from_banner: true,
                      //   ),
                      // );
                      // Get.toNamed(AppRoutes.Productdetails_screen, arguments: {'product': null, 'from_cart': false, "product_slug": element.actions[0].slug,"from_banner": true});

                      // Get_product(element.actions[0].slug);
                    } else if (element.actions[0].target_type == 'external_link') {
                      String url = element.actions[0].slug;
                      final Uri uri = Uri.parse(url);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      } else {
                        throw 'Could not launch $url';
                      }
                    } else if (element.actions[0].target_type == 'category') {
                      Category? foundCategory = globalController.homeDataList.value.categories?.firstWhere(
                            (category) => category.slug == element.actions[0].slug,
                      );
                      var f = {
                        "categories": [
                          foundCategory?.id.toString(),
                        ],
                      };
                      String jsonString = jsonEncode(f);
                      Get.toNamed(AppRoutes.Filter_products, arguments: {
                        'title': foundCategory?.categoryName,
                        'id': foundCategory?.id,
                        'type': jsonString,
                      }, parameters: {
                        'tag': "${foundCategory?.id}:${foundCategory?.categoryName}"
                      })?.then((value) {
                        globalController.updateCurrentRout(Get.currentRoute);
                      });
                    } else if (element.actions[0].target_type == 'brand') {
                      Brand? foundBrand = globalController.homeDataList.value.brands?.firstWhere(
                            (brand) => brand.slug == element.actions[0].slug,
                      );
                      var f = {
                        "flash_sales": [
                          foundBrand!.id.toString(),
                        ],
                      };
                      String jsonString = jsonEncode(f);

                      Get.toNamed(AppRoutes.View_All_Products, arguments: {
                        'title': foundBrand.brandName.toString(),
                        'id': foundBrand.id.toString(),
                        'type': jsonString,
                      })?.then((value) {
                        globalController.updateCurrentRout(Get.currentRoute);
                      });
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: element.more_images.length > 1
                        ? Container(
                      width: double.maxFinite,
                      child:


                      Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          slider.CarouselSlider.builder(
                            options: CarouselOptions(
                              height: getVerticalSize(200),
                              initialPage: 0,
                              autoPlay: false,
                              viewportFraction: 1.0,
                              animateToClosest: true,
                              enlargeCenterPage: true,
                              enableInfiniteScroll: false,
                              scrollDirection: Axis.horizontal,
                              onPageChanged: (index, reason) {
                                sliderIndex.value = index;
                              },
                            ),
                            itemCount: element.more_images.length,
                            itemBuilder: (context, index, realIndex) {
                              MoreImage model = element.more_images[index];

                              return Container(
                                  child: element.more_images[index].file_path
                                      .toString()
                                      .isVideoFileName
                                      ? mediaVideoWidget(
                                    "https://schooltube.online/schooltube/web/img/default.png",
                                    isTextOnImage: false,
                                    AssetPaths.placeholder,
                                    isAutoPlay: true,
                                    isMuted: true,
                                    fit: BoxFit.cover,
                                    width: w - 8,
                                    // Reduced width by 8 to account for padding
                                    height: element.main_image.toString() != "null" ? h : 0,
                                    isVideo: true,
                                    videoUrl: element.more_images[index].file_path,
                                  ) :

                                  mediaWidget(
                                    element.more_images[index].file_path,
                                    AssetPaths.placeholder,
                                    isProduct: false,
                                    fit: BoxFit.cover,
                                    placeholderFit: true,
                                    height: totalHeight,
                                    width: Get.size.width, // Adjust width if necessary
                                  )
                              );
                            },
                          ),
                          Padding(
                            padding: getPadding(bottom: 5.0, left: 10),
                            child: Obx(() {
                              return Container(
                                height: getVerticalSize(9),
                                margin: getPadding(bottom: 5),
                                child: AnimatedSmoothIndicator(
                                  activeIndex: sliderIndex.value,
                                  count: element.more_images.length,
                                  axisDirection: Axis.horizontal,
                                  effect: ScrollingDotsEffect(
                                    spacing: 7,
                                    activeDotColor: ColorConstant.logoSecondColorConstant,
                                    dotColor: ColorConstant.blueGray100,
                                    dotHeight: getVerticalSize(6),
                                    dotWidth: getHorizontalSize(6),
                                  ),
                                ),
                              );
                            }),
                          )
                        ],
                      ),
                    )
                        :

                    // ProgressiveImage(
                    //   placeholder: AssetImage(AssetPaths.placeholder),
                    //   // size: 1.87KB
                    //   thumbnail: NetworkImage(convertToThumbnailUrl(element.main_image??'',isBlurred: true)),
                    //   // size: 1.29MB
                    //   image: CachedNetworkImageProvider(convertToThumbnailUrl(element.main_image??'',isBlurred: false)),
                    //   height: getVerticalSize(180),
                    //   fit: BoxFit.cover,
                    //   fadeDuration: Duration(milliseconds: 200),
                    //
                    //
                    //   width: getSize(240),
                    // ),
                    element.main_image
                        .toString()
                        .isVideoFileName
                        ?
                    // mediaVideoWidget(
                    //         "https://schooltube.online/schooltube/web/img/default.png",
                    //         isTextOnImage: false,
                    //         AssetPaths.placeholder,
                    //         isAutoPlay: true,
                    //         isMuted: true,
                    //         fit: BoxFit.fitWidth,
                    //         width: w - 8,
                    //         // Reduced width by 8 to account for padding
                    //         height: element.main_image.toString() != "null" ? h : 0,
                    //         isVideo: true,
                    //         videoUrl: element.main_image,
                    //
                    //       )
                    ChewieVideoPlayer(
                      initialQuality: element.main_image,
                      isMuted: false,
                      videoQualities :  {
                        "360": element.main_image.toString(),
                        "720":  element.main_image.toString(),
                      },
                    )
                    // CustomVideoPlayer(
                    //   videoUrl: element.main_image,
                    //   isAutoPlay: false,
                    //   isMuted: false,
                    //   imageUrl: "https://schooltube.online/schooltube/web/img/default.png",
                    // )
                        :
                    // CustomImageView(
                    //         height: totalHeight,
                    //         width: Get.size.width,
                    //         // color: ColorConstant.logoFirstColor,
                    //         fit: BoxFit.cover,
                    //         url: element.main_image,
                    //       )
                    mediaWidget(
                      element.main_image,
                      isHomeBanner: true,
                      AssetPaths.placeholder,
                      height: totalHeight,
                      width: Get.size.width,
                      bottomLeftBorder: 5,
                      topLeftBorder: 5,
                      placeholderFit: true,

                      topRightBorder: 5,
                      bottomRightBorder: 5,
                      // Adjust width if necessary
                      fromKey: "",
                      isProduct: false,
                      fit: BoxFit.cover,
                    ),

                    // CachedNetworkImage(
                    //   imageUrl: element.main_image,
                    //   fit: BoxFit.fill,
                    //   placeholder: (context, url) => Container(),
                    //   errorWidget: (context, url, error) => Icon(Icons.error),
                    // ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
