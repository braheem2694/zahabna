import 'dart:math';
import 'package:flutter_avif/flutter_avif.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:iq_mall/cores/assets.dart';
import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/routes/app_routes.dart';
import 'package:iq_mall/utils/ShImages.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:iq_mall/main.dart';
import 'package:iq_mall/widgets/ui.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../models/HomeData.dart';
import '../screens/ProductDetails_screen/ProductDetails_screen.dart';
import '../screens/ProductDetails_screen/controller/ProductDetails_screen_controller.dart';
import '../screens/Stores_screen/controller/my_store_controller.dart';
import '../screens/Stores_screen/widgets/item_widget.dart';
import '../screens/Wishlist_screen/controller/Wishlist_controller.dart';
import 'package:iq_mall/models/functions.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:get/get.dart';

RxBool recheck = false.obs;

class ProductWidget extends StatefulWidget {
  final String? tag;

  final Product product;
  final String? fromKey;
  final int? index;

  ProductWidget(
      {required this.product,
      this.fromKey,
      this.tag = '/ShProductDetail',
      this.index});

  @override
  ProductWidgetState createState() => ProductWidgetState();
}

class ProductWidgetState extends State<ProductWidget>
    with TickerProviderStateMixin {
  final random = Random();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // late ProductWidgetController productWidgetController;
  RxBool refreshing = false.obs;
  RxBool isReallyLiked = false.obs;
  RxBool isLiked = false.obs;
  RxInt imageCount = 0.obs;
  int count = 0;
  RxBool _loadImage = true.obs;
  final GlobalKey _widgetKey = GlobalKey();
  List<CachedNetworkImageProvider> images = <CachedNetworkImageProvider>[];

  var key = UniqueKey();

  @override
  void initState() {
    // TODO: implement initState
    // if(widget.fromKey=="filter"){
    //   _getBytesFromCachedImage(CachedNetworkImageProvider(widget.product.main_image!));
    //
    // }
    // Ensure the visibility is checked after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Check visibility after the first frame is built
      checkIfVisible();

      // Delay execution slightly to ensure the layout is processed
      Future.delayed(const Duration(milliseconds: 300), () {
        VisibilityDetectorController.instance.notifyNow();
      });
    });

    super.initState();
  }

  /// Manually checks if the widget is within the visible viewport
  void checkIfVisible() {
    RenderObject? renderObject = _widgetKey.currentContext?.findRenderObject();

    if (renderObject != null) {
      final viewportHeight = MediaQuery.of(context).size.height;
      final renderBox = renderObject as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero).dy;

      if (position >= 0 && position < viewportHeight) {
        _loadImage.value = true; // Load immediately if within screen
      }
    }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,

      enableDrag: true,

      isScrollControlled: true,
      transitionAnimationController: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 250)),
      // Set this to true to make the sheet full-screen.
      builder: (BuildContext context) {
        // Return the screen you want to show as a bottom sheet
        return ProductDetails_screen();
      },
    ).then((product) {
      refreshing.value = true;
      // globalController.productDetails_screenController.dispose();
      // GetInstance().delete(tag: globalController.productDetails_screenController);
      Get.delete<ProductDetails_screenController>(
          tag: "${widget.product.product_id}");
      Future.delayed(const Duration(milliseconds: 350)).then((value) {
        globalController.isLiked.value;

        refreshing.value = false;
      });
    });
  }

  void removeRouteByName(String name) {
    final navigator = Navigator.of(Get.context!);

    navigator.popUntil((route) {
      if (route.settings.name == name) {
        navigator.removeRoute(route);
      }
      return true; // keep going through the stack
    });
  }

  @override
  Widget build(BuildContext context) {
    isLiked.value = widget.product.is_liked == 0 ? false : true;
    print("widget.product.product_name");
    print(widget.product.product_name);
    print(isLiked.value);
    isReallyLiked.value = widget.product.is_liked == 0 ? false : true;
    imageCount.value = (widget.product.more_images?.length ??
                0 + (widget.product.main_image != null ? 1 : 0)) <
            4
        ? (widget.product.more_images?.length ??
            0 + (widget.product.main_image != null ? 1 : 0))
        : 4;
    return InkWell(
      key: scaffoldKey,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () async {
        // Assuming you have a controller named MyController
        if (Get.isRegistered<ProductDetails_screenController>()) {
          await Get.delete<ProductDetails_screenController>();
          print("MyController is initialized");
        }
        // images.clear();
        // images.add(CachedNetworkImageProvider(widget.product.main_image!));
        //
        // for(int i=0; i<widget.product.more_images!.length;i++){
        //
        //   images.add(CachedNetworkImageProvider(widget.product.more_images![i].file_path));
        //
        // }
        globalController
            .updateProductLike(widget.product.is_liked == 1 ? true : false);

        // if (Platform.isAndroid) {
        // await  Get.delete<ProductDetails_screenController>(tag: "${widget.product.product_id}").then((value) {
        //     globalController.detailsTag.value= "${widget.product.product_id}";
        //     globalController.productDetails_screenController = Get.put(ProductDetails_screenController(), tag: "${widget.product.product_id}");
        //     globalController.productDetails_screenController.arguments = {
        //       "product": widget.product,
        //       "fromCart": false,
        //       "productSlug": null,
        //       "tag": "${widget.product.product_id}",
        //     };
        //
        //   });
        //
        //   _showBottomSheet(context);
        // }
        // else {
        // if(Get.isRegistered<ProductDetails_screenController>(tag: "${widget.product.product_id}")){
        //   Get.delete<ProductDetails_screenController>(tag: "${widget.product.product_id}");
        //
        //   removeRouteByName(AppRoutes.Productdetails_screen);
        //
        // }

        Get.toNamed(AppRoutes.Productdetails_screen, arguments: {
          'product': widget.product,
          'fromCart': false,
          'productSlug': null,
          'tag': "${widget.product.product_id}"
        }, parameters: {
          'tag': "${UniqueKey()}${widget.product.product_id}"
        })?.then((value) {
          refreshing.value = true;
          globalController.updateCurrentRout(AppRoutes.tabsRoute);
          globalController.cartCount = 0;
          // Get.delete<ProductDetails_screenController>();

          Future.delayed(const Duration(milliseconds: 200)).then((value) {
            widget.product.is_liked = globalController.isLiked.value ? 1 : 0;
            globalController.updateFavoriteProduct(widget.product.product_id,
                globalController.isLiked.value ? 1 : 0);
            refreshing.value = false;
          });
        });

        // Get.to(
        //   () => ProductDetails_screen(
        //     product: widget.product,
        //     fromCart: false,
        //     productSlug: null,
        //   ),
        // )?.then((product) {
        //   refreshing.value = true;
        //
        //   // Get.delete<ProductDetails_screenController>();
        //
        //   Future.delayed(const Duration(milliseconds: 200)).then((value) {
        //     isLiked.value = globalController.isLiked.value;
        //
        //     refreshing.value = false;
        //   });
        // });
        // }
      },
      child: Obx(() {
        return Container(
          height: getScreenRatio() > 1
              ? (Get.height / getScreenRatio()) / 1.3
              : (Get.height / getScreenRatio()) / 2,
          width: getHorizontalSize(187),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8.0),
              topRight: Radius.circular(8.0),
              bottomRight: Radius.zero,
              bottomLeft: Radius.zero,
            ),
            border: Border.all(color: Colors.transparent),
            color: Colors.transparent,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    alignment: Alignment.topCenter,
                    height: getScreenRatio() > 1
                        ? (Get.height / getScreenRatio()) / 1.7
                        : (Get.height / getScreenRatio()) / 2.5,

                    // set height

                    child: !Ui.isValidUri(widget.product.main_image)
                        ? ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                                bottomLeft: Radius.zero,
                                bottomRight: Radius.zero),
                            child: Image.asset(
                              AssetPaths.placeholder,
                              fit: BoxFit.cover,
                              height: (Get.height / getScreenRatio()) / 1.3,
                              width: Get.width,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                                bottomLeft: Radius.zero,
                                bottomRight: Radius.zero),
                            child: (widget.product.main_image!
                                    .toLowerCase()
                                    .endsWith('avif'))
                                ? Container(
                                    height:
                                        (Get.height / getScreenRatio()) / 1.3,
                                    width: Get.width,
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                AssetPaths.placeholder))),
                                    child:
                                        Ui.isValidUri(widget.product.main_image)
                                            ? AvifImage.network(
                                                widget.product.main_image!,
                                                fit: BoxFit.cover,
                                                height: (Get.height /
                                                        getScreenRatio()) /
                                                    1.3,
                                                width: Get.width,
                                              )
                                            : Image.asset(
                                                AssetPaths.placeholder,
                                                fit: BoxFit.cover,
                                                height: (Get.height /
                                                        getScreenRatio()) /
                                                    1.3,
                                                width: Get.width,
                                              ),
                                  )
                                : ProgressiveImage(
                                    placeholder: const AssetImage(
                                        AssetPaths.placeholder),
                                    thumbnail: Ui.isValidUri(
                                            convertToThumbnailUrl(
                                                widget.product.main_image!,
                                                isBlurred: true))
                                        ? CachedNetworkImageProvider(
                                            convertToThumbnailUrl(
                                                widget.product.main_image!,
                                                isBlurred: true),
                                            scale: 1,
                                            cacheManager: CacheManager(
                                              Config(
                                                widget.product.product_id
                                                    .toString(),
                                                stalePeriod:
                                                    const Duration(seconds: 10),
                                                maxNrOfCacheObjects: 50,
                                              ),
                                            ),
                                          )
                                        : const AssetImage(
                                                AssetPaths.placeholder)
                                            as ImageProvider,
                                    blur: 1,
                                    image: Ui.isValidUri(convertToThumbnailUrl(
                                            widget.product.main_image!,
                                            isBlurred: false))
                                        ? CachedNetworkImageProvider(
                                            convertToThumbnailUrl(
                                                    widget.product.main_image!,
                                                    isBlurred: false) ??
                                                '',
                                            scale: 1,
                                            cacheManager: CacheManager(
                                              Config(
                                                widget.product.product_id
                                                    .toString(),
                                                stalePeriod:
                                                    const Duration(seconds: 10),
                                                maxNrOfCacheObjects: 50,
                                              ),
                                            ),
                                            errorListener: (p0) {},
                                          )
                                        : const AssetImage(
                                                AssetPaths.placeholder)
                                            as ImageProvider,
                                    height:
                                        (Get.height / getScreenRatio()) / 1.3,
                                    width: Get.width,
                                    fit: BoxFit.cover,
                                    fadeDuration:
                                        const Duration(milliseconds: 200),
                                    key: Key(
                                        widget.product.product_id.toString()),
                                  ),
                          ),
                  ),
                  widget.product.product_qty_left.toInt() < 1
                      ? Container()
                      : Positioned(
                          top:
                              0, // Adjust the value as needed for spacing from the top
                          right: 0,
                          child: widget.fromKey == "my_store"
                              ? GestureDetector(
                                  onTap: () {
                                    globalController.updateIsNav(false);
                                    prefs?.setString("is_nav", "0");
                                    Get.to(() => AddNewItemScreen(
                                          fromKey: "edit",
                                          product: widget.product,
                                        ))?.then(
                                      (value) {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          globalController.selectedGemstoneStyle
                                              .clear();
                                          globalController.itemGemstoneStyles
                                              .clear();
                                          globalController.gemstonesDropDownMap
                                              .clear();
                                          globalController.gemstonStylesDropList
                                              .removeRange(
                                                  1,
                                                  globalController
                                                      .gemstonStylesDropList
                                                      .length);
                                          globalController.resetMetalFields(
                                              globalController.metals,
                                              globalController.gemstones);
                                          globalController
                                              .resetGemstonStylesDropList();
                                          globalController
                                              .resetgemstonesDropDownMap();
                                          globalController
                                              .updateAddItemDropDownLists();
                                          globalController.description.value =
                                              "";
                                          try {
                                            MyStoreController controller =
                                                Get.find();
                                            controller.getProducts(1);
                                          } catch (e) {
                                            print(e);
                                          }
                                        });
                                      },
                                    );
                                  },
                                  behavior: HitTestBehavior.translucent,
                                  child: Container(
                                      padding: getPadding(
                                          top: 14,
                                          right: 10,
                                          left: 10,
                                          bottom: 10),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.blue.withOpacity(
                                                0.5), // Lighter black at the top left
                                            Colors.blue.withOpacity(
                                                0.6), // Darker black at the bottom right
                                            Colors.blue.withOpacity(
                                                0.7), // Darker black at the bottom right
                                            Colors.blue.withOpacity(
                                                0.8), // Darker black at the bottom right
                                          ],
                                        ),
                                        borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            topRight: Radius.circular(10)),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black12
                                                  .withOpacity(0.1),
                                              blurRadius: 3,
                                              offset: const Offset(0, 2)),
                                        ],
                                      ),
                                      child: Icon(
                                        FontAwesomeIcons.edit,
                                        color: Colors.white,
                                        size: getFontSize(20),
                                      )
                                      // CustomImageView(
                                      //   imagePath: AssetPaths.whatsapp,
                                      //   height: getSize(30.00),
                                      //   width: getSize(30.00),
                                      //   fit: BoxFit.cover,
                                      //   radius: BorderRadius.circular(5),
                                      // ),
                                      ),
                                )
                              : Container(
                                  width: getSize(50),
                                  height: getSize(50),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.green.withOpacity(
                                            0.5), // Lighter black at the top left
                                        Colors.green.withOpacity(
                                            0.6), // Darker black at the bottom right
                                        Colors.green.withOpacity(
                                            0.7), // Darker black at the bottom right
                                        Colors.green.withOpacity(
                                            0.8), // Darker black at the bottom right
                                      ],
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      Ui.onTapWhatsapp(
                                          widget.product,
                                          // widget.product.store.storeWhatsappNumber
                                          "+96176600252");
                                    },
                                    behavior: HitTestBehavior.translucent,
                                    child: Container(
                                        alignment: Alignment.center,
                                        child: Icon(
                                          FontAwesomeIcons.whatsapp,
                                          color: Colors.white,
                                          size: getFontSize(20),
                                        )
                                        // CustomImageView(
                                        //   imagePath: AssetPaths.whatsapp,
                                        //   height: getSize(30.00),
                                        //   width: getSize(30.00),
                                        //   fit: BoxFit.cover,
                                        //   radius: BorderRadius.circular(5),
                                        // ),
                                        ),
                                  ),
                                ),
                          // AddToCartButton(product: widget.product)
                        ),
                ],
              ),
              Padding(
                padding: getPadding(left: 0.0, right: 0, top: 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    widget.product.product_price == 0
                        ? Text(
                            'Contact us for price'.tr,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: price_color,
                              fontSize: getFontSize(15),
                              decoration: TextDecoration.none,
                            ),
                          )
                        : Container(
                            width: getHorizontalSize(130),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  widget.product.price_after_discount != null &&
                                          widget.product.price_after_discount !=
                                              widget.product.product_price
                                      ? Text(
                                          sign.toString() +
                                              widget
                                                  .product.price_after_discount
                                                  .toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: price_color,
                                            fontSize: getFontSize(15),
                                            decoration: TextDecoration.none,
                                          ),
                                        )
                                      : Container(),
                                  Expanded(
                                    child: Padding(
                                      padding: getPadding(left: 4.0),
                                      child: Text(
                                        sign.toString() +
                                            widget.product.product_price
                                                .toString(),
                                        style: TextStyle(
                                          fontWeight: (widget.product
                                                              .price_after_discount !=
                                                          null &&
                                                      widget.product
                                                              .price_after_discount !=
                                                          widget.product
                                                              .product_price) ||
                                                  widget.product
                                                          .price_after_discount
                                                          .toString() ==
                                                      'null'
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: (widget.product
                                                          .price_after_discount !=
                                                      null &&
                                                  widget.product
                                                          .price_after_discount !=
                                                      widget.product
                                                          .product_price)
                                              ? discount_price_color
                                              : price_color,
                                          fontSize: (widget.product
                                                              .price_after_discount !=
                                                          null &&
                                                      widget.product
                                                              .price_after_discount !=
                                                          widget.product
                                                              .product_price) ||
                                                  widget.product
                                                          .price_after_discount
                                                          .toString() ==
                                                      'null'
                                              ? getFontSize(14)
                                              : getFontSize(12),
                                          decoration: (widget.product
                                                          .price_after_discount !=
                                                      null &&
                                                  widget.product
                                                          .price_after_discount !=
                                                      widget.product
                                                          .product_price)
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    const Expanded(child: SizedBox()),
                    prefs!.getString("token").toString() == 'null'
                        ? Container()
                        : Padding(
                            padding: getPadding(right: 3, left: 0, top: 3),
                            child: Obx(() => GestureDetector(
                                      onTap: () {
                                        isLiked.value = !isLiked.value;
                                        widget.product.is_liked =
                                            isLiked.value ? 1 : 0;
                                        globalController
                                            .homeDataList.value.products
                                            ?.firstWhere((element) =>
                                                element.product_id ==
                                                widget.product.product_id)
                                            .is_liked = isLiked.value ? 1 : 0;
                                        globalController.update();
                                        globalController.refresh();
                                        function
                                            .setFavorite(widget.product, false,
                                                isLiked.value)
                                            .then((value) {
                                          widget.product.is_liked =
                                              isLiked.value ? 1 : 0;
                                          WishlistController _controller =
                                              Get.find();
                                          _controller.GetFavorite().then(
                                            (value) {
                                              widget.product.is_liked =
                                                  isLiked.value ? 1 : 0;
                                            },
                                          );
                                        });
                                      },
                                      child: AnimatedSwitcher(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          transitionBuilder: (Widget child,
                                              Animation<double> animation) {
                                            return ScaleTransition(
                                                scale: animation, child: child);
                                          },
                                          child: Icon(
                                            widget.product.is_liked == 1
                                                ? Icons.favorite_rounded
                                                : Icons.favorite_border_rounded,
                                            key: ValueKey<bool>(isLiked.value),
                                            color:
                                                ColorConstant.logoSecondColor,
                                            size: getSize(27),
                                          )),
                                    )

                                // IconButton(
                                //   iconSize: getSize(30),
                                //   icon: Obx(() =>
                                //       Icon(
                                //         isLiked.value ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                //         size: getSize(30),
                                //       )),
                                //   color: ColorConstant.logoSecondColor,
                                //   onPressed: () {
                                //     isLiked.value = !isLiked.value;
                                //
                                //     function.setFavorite(widget.product, false, isLiked.value).then((value) {
                                //       widget.product.isLiked = isLiked.value ? 1 : 0;
                                //       WishlistController _controller = Get.find();
                                //       _controller.GetFavorite().then((value) {
                                //         if (!value) {
                                //           isLiked.value = !isLiked.value;
                                //         }
                                //       });
                                //     });
                                //   },
                                // ),
                                ),
                          )
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8, top: 0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      widget.product.product_name ?? '',
                      style: TextStyle(
                          color: Colors.black, fontSize: getFontSize(12)),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  onTapWhatsapp(Product product) {
    makeWhatsappContact('+96176600252',
        text:
            "I want to ask about this product: ${product.product_name}\n${Uri.parse(product.main_image.toString().replaceAll(" ", "%20"))}\n${product.description}\n"
            "$conVersion/product/${product.slug}");
  }
}

Future<void> makeWhatsappContact(String phone, {required String text}) async {
  // normalize phone (remove spaces/plus if your API expects digits only)
  final normalized = phone.replaceAll(' ', '').replaceAll('+', '');
  final uri =
      Uri.https('wa.me', '/$normalized', {'text': text}); // auto-encodes
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

String? progImages(String? image, fromKey) {
  List<String> newImageList = [];

  String? newImage = "";
  if (fromKey == "blur") {
    newImageList = image!.split("/");
    newImageList.insert(newImageList.length - 1, "blures");
  } else if (fromKey == "thumbnails") {
    newImageList = image!.split("/");
    newImageList.insert(newImageList.length - 1, "thumbnails");
  }

  for (int i = 0; i < newImageList.length; i++) {
    newImage ??= newImageList[i];
    newImage += "/${newImageList[i]}";
  }
  return newImage;
}

String convertToThumbnailUrl(String originalUrl, {bool isBlurred = false}) {
  if (originalUrl.isEmpty) return "";

  // Check if it's a valid URL with a host if it starts with http
  if (originalUrl.toLowerCase().startsWith("http")) {
    try {
      final uri = Uri.parse(originalUrl);
      if (!uri.hasAuthority || uri.host.isEmpty) {
        return "";
      }
    } catch (_) {
      return "";
    }
  }

  // Find the last dot to get the file extension
  int lastDot = originalUrl.lastIndexOf('.');

  if (lastDot != -1) {
    // Get the URL without the extension and the extension separately
    String urlWithoutExtension = originalUrl.substring(0, lastDot);
    String extension = originalUrl.substring(lastDot);

    // Choose the appropriate suffix based on whether it's a blurred thumbnail or not
    String suffix = isBlurred ? '_blr' : '_tmb';
    return '${urlWithoutExtension}$suffix$extension';
  } else {
    // Handle URLs without an extension, if needed
    return originalUrl;
  }
}

class ProductWidgetController extends GetxController {
  RxDouble borderWidth = 0.0.obs;
}
