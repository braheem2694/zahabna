import 'dart:async';

import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:intl/intl.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:mime_type/mime_type.dart';
import 'package:iq_mall/models/HomeData.dart';
import 'package:iq_mall/models/Review.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'package:http/http.dart' as http;
import 'package:iq_mall/cores/assets.dart';
import 'package:quickalert/models/quickalert_type.dart';
import '../../../cores/math_utils.dart';
import '../../../models/Variations.dart';
import '../../../utils/ShImages.dart';
import '../../../widgets/Alert.dart';
import '../../../widgets/custom_image_view.dart';
import '../../Cart_List_screen/controller/Cart_List_controller.dart';
import '../ProductDetails_screen.dart';

// final DateFormat serverFormater = DateFormat('yyyy-MM-dd hh:mm');

class ProductDetails_screenController extends GetxController with GetTickerProviderStateMixin{



  RxList<MoreImage>? imagesInfo = <MoreImage>[].obs;
  RxBool loading = true.obs;
  RxBool loadingImages = true.obs;
  RxBool updatingProductInfo = true.obs;
  RxBool freez = false.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxBool naviagte = true.obs;
  TextEditingController Reviewcontroller = TextEditingController();
  bool hasrated = false;
  RxBool fromBanner = false.obs;
  RxBool initializing = true.obs;
  var rateNumber;
  RxBool liked = false.obs;
  RxBool addingToCard = false.obs;
  RxBool updatePriceInAddToCart = false.obs;

  RxBool similaritiesloading = true.obs;
  Rxn<Product> product = Rxn<Product>();
  Rxn<Product> tempProduct = Rxn<Product>();
  RxList<ProductCategories> productCategories = <ProductCategories>[].obs;

  RxInt rating = 0.obs;

  RxList<VariationElement> variants = <VariationElement>[].obs;
  List availableKeys = [];
  String? isbought;
  RxList<Product>? Similarproducts = <Product>[].obs;
  var variationChoosen;
  var arguments;
  late OverlayEntry overlayEntry;
  late AnimationController controller;
  late Animation<Offset> animation;

  final GlobalKey endPointKey = GlobalKey();
  final GlobalKey startPointKey = GlobalKey();

  RxBool animatingAddToCardTick = false.obs;

  RxList<dynamic> metals = <dynamic>[].obs;
  RxList<dynamic> gemstoneStyles = <dynamic>[].obs;

  String? productId;

  @override
  void onInit() {

    arguments = Get.arguments;
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 900));
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        overlayEntry.remove();
        controller.reset();// Remove the overlay entry when animation is completed
      }
    });

    super.onInit();
  }

  void applyTickAnimation(){
    animatingAddToCardTick.value=true;
    Future.delayed(const Duration(seconds: 1)).then((value) {
      animatingAddToCardTick.value=false;


    });
  }

  void createOverlayEntry(BuildContext context) {

    RenderBox startRenderBox = startPointKey.currentContext!.findRenderObject() as RenderBox;
    Offset start = startRenderBox.localToGlobal(Offset(startRenderBox.size.width-getSize(40), 0));
    RenderBox endBarBox = endPointKey.currentContext!.findRenderObject() as RenderBox;
    Offset end = endBarBox.localToGlobal(Offset.zero);
    Offset startPosition = Offset(start.dx + startRenderBox.size.width, start.dy + startRenderBox.size.height / 2);
    Offset endPosition = Offset(end.dx + endBarBox.size.width / 2, end.dy + endBarBox.size.height / 2);
    animation = Tween<Offset>(begin: startPosition, end: endPosition).animate(controller)
      ..addListener(() {
        overlayEntry.markNeedsBuild();
      });





      animation = Tween<Offset>(begin: start, end: end).animate(controller);

    overlayEntry = OverlayEntry(
      builder: (context) => AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Positioned(
            left: animation.value.dx,
            top: animation.value.dy,
            child: CustomImageView(
              width: getSize(30),
              height: getSize(30),
              color: ColorConstant.logoSecondColor,
              svgPath: AssetPaths.cartIcon,
            ),
          );
        },
      ),
    );

    Overlay.of(context).insert(overlayEntry);
    controller.forward().then((value) {
      Future.delayed(Duration(milliseconds: 900)).then((value) {
        controller.reset();
      });
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    Reviewcontroller.dispose();
    controller.dispose();
   try{
     overlayEntry.remove();
   }catch(e){
     print(e);
   }

    super.onClose();
  }

  @override
  void onReady() {
    // TODO: implement onClose
    try {
      if(arguments==null){
        GetProductDetails(prefs?.getString("tag"));
        return;

      }
      if (arguments["from_banner"] ?? false) {
        fromBanner.value = true;
        GetProductDetails(arguments['productSlug']).then((value) {
          // imagesInfo?.clear();
          // imagesInfo?.add(MoreImage(id: 0, file_path: product.value!.main_image!, type: 0, isVideo: 0));
          // product.value?.moreImages?.forEach((element) {
          //   imagesInfo?.add(element);
          // });
          fromBanner.value = false;

          // getsimilarproducts();
        });
      } else {
        product.value = (arguments['product'] as Product);
        // imagesInfo?.add(MoreImage(id: 0, file_path: product.value!.main_image!, type: 0, isVideo: 0));
        // product.value?.moreImages?.forEach((element) {
        //   imagesInfo?.add(element);
        // });
        tempProduct.value = (arguments['product'] as Product);
        GetProductDetails(product.value?.product_id);
        // getsimilarproducts();
      }
    } catch (e) {

      print(e);
    }
    imagesInfo?.clear();
    if (product.value?.main_image != null) {
      imagesInfo?.add(MoreImage(id: 0, file_path: product.value!.main_image!, type: 0, isVideo: 0));
    }
    product.value?.more_images?.forEach((element) {
      if (product.value?.main_image.toString() != element.file_path.toString() && element.file_path.toString() != "") {
        imagesInfo?.add(element);
      }
    });
    super.onReady();
    globalController.updateCurrentRout(Get.currentRoute);

  }

  Future<bool> GetProductDetails(slug) async {
    bool success = false;
    loading.value = true;

    Map<String, dynamic> response = await api.getData({
      'token': prefs!.getString("token") ?? "",
      'productId': slug,
    }, "products/get-product-by-id");
    if (response.isNotEmpty) {
      updatingProductInfo.value = true;

      success = response["succeeded"];
      // try {
      //   product.value?.moreImages?.clear();
      // } catch (e) {
      //
      // }
      // product.moreImages;
      metals.value=response["metals"];
      gemstoneStyles.value=response["gemstones_styles"]??[];
      product.value = Product.fromJson(response["product"]);
      Similarproducts?.clear();
      response["related_products"].forEach((item) {
        Similarproducts?.add(Product.fromJson(item));
      });

      productCategories.clear();
      response["product_categories"].forEach((item) {
        productCategories.add(ProductCategories.fromJson(item));
      });
      // productCategories = json["product_categories"] != null ? List<ProductCategories>.from(json["product_categories"].map((x) => ProductCategories.fromJson(x))) : [],



      product.value = Product.fromJson(response["product"]);
      rating.value= product.value?.rate??0;
      if (tempProduct.value?.product_id != null) {
        product.value?.more_images?.add(MoreImage(id: 0, file_path: tempProduct.value?.main_image ?? '', type: 1, isVideo: 0));
      }
      imagesInfo?.clear();
      if (product.value!.main_image != null) {
        imagesInfo?.add(MoreImage(id: 0, file_path: product.value!.main_image!, type: 0, isVideo: 0));
      }
      product.value?.more_images?.forEach((element) {
        if (product.value?.main_image.toString().split("/").last != element.file_path.toString().split("/").last) {
          imagesInfo?.add(element);
        }
      });
      variants.value = (response["variations"] as List)
          .map((item) {
            // Ensure 'item' is of the correct type before using it
            return item is Map<String, dynamic> ? VariationElement.fromJson(item) : null;
          })
          .where((element) => element != null)
          .cast<VariationElement>()
          .toList();

      if(product.value?.has_option==1){
        product.value?.product_qty_left = variants.first.quantity;
      }
    }
    if (success) {
      updatingProductInfo.value = false;
      loading.value = false;
      fromBanner.value = false;
      loadingImages.value = false;
    } else {
      loading.value = false;
      fromBanner.value = false;
      loadingImages.value = false;
    }
    return success;
  }

  Review_Rate() async {
    bool success = false;

    similaritiesloading.value = true;
    Map<String, dynamic> response = await api.getData({
      'token': prefs!.getString("token") ?? "",
      'rating': rateNumber.toString(),
      'text': Reviewcontroller.text.toString(),
      'product_id': product.value?.product_id,
    }, "products/set-review");

    if (response.isNotEmpty) {
      success = response["succeeded"];
    }
    if (success) {
      rating.value = rateNumber!.toInt();
      product.value!.rate = rating.toInt();
      toaster(Get.context!, response["message"].toString().tr);
      similaritiesloading.value = false;
    } else {
      toaster(Get.context!, response["message"].toString().tr);
      similaritiesloading.value = false;
    }
    return success;
  }

  // getsimilarproducts() async {
  //   bool success = false;
  //
  //   similaritiesloading.value = true;
  //   Map<String, dynamic> response = await api.getData({
  //     'token': prefs!.getString("token") ?? "",
  //     'productId': product.value?.product_id,
  //   }, "products/get-related-products");
  //
  //   if (response.isNotEmpty) {
  //     success = response["succeeded"];
  //     List<dynamic>? relatedProductsList = response["related_products"] as List<dynamic>?;
  //
  //     // Transform each map to a Product object
  //     Similarproducts = relatedProductsList?.map((dynamic item) {
  //       return Product.fromJson(item as Map<String, dynamic>);
  //     }).toList();
  //   }
  //   if (success) {
  //     similaritiesloading.value = false;
  //   } else {
  //     similaritiesloading.value = false;
  //   }
  //   return success;
  // }

  Future<bool?> AddToCart(Product? product, quantity, BuildContext context) async {
    bool success = false;
    Map<String, dynamic> data = {
      'token': prefs!.getString("token") ?? "",
      'product_id': product?.product_id ?? "",
      'qty': quantity,
      'variant_id': variationChoosen.toString(),
    };

    final sessionId = prefs!.getString("session_id");
    if (sessionId != null && sessionId.isNotEmpty) {
      data['session_id'] = sessionId;
    }
    Map<String, dynamic> response = await api.getData(data, "cart/add-to-cart");
    if (response.isNotEmpty) {
      success = response["succeeded"];
      if (success) {
        loading.value = true;

        String? sessionId = prefs!.getString("session_id");

        // Check if it's empty or null
        if (sessionId == null || sessionId.isEmpty) {
          // If empty, set the new value
          String? session_id = response["session_id"];
          if (session_id != null) {
            await prefs!.setString("session_id", session_id);
          }
        }



        loading.value = false;
        // customToaster(context, "This is a custom toast message with an icon!");
        // toaster(context, response["message"].toString().tr);
      } else {
        loading.value = false;
        CustomAlert.show(
          context: Get.context!,
          content: response["message"].toString().tr,
          type: QuickAlertType.warning,

        );
      }

      return success;
    } else {
      loading.value = false;
      CustomAlert.show(
        context: Get.context!,
        content: "Failed to add to cart".tr,
        type: QuickAlertType.error,
      );
    }
    loading.value = false;
  }






}

bool isVideo(String? url) {
  final mimeType = mime(url);
  return mimeType != null && mimeType.startsWith('video/');
}
