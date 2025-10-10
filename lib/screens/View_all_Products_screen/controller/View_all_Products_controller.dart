import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/main.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import '../../../models/HomeData.dart';
import '../../../widgets/ShWidget.dart';
import '../../Home_screen_fragment/controller/Home_screen_fragment_controller.dart';

class View_all_ProductsController extends GetxController {
  RxBool loading = true.obs;
  RxBool loader = false.obs;
  var scrollController = new ScrollController();
  var primaryColor;
  var category;
  var title;
  var type;
  var ChildsCategories;
  var flashSale;

  @override
  void onInit() {
    final arguments = Get.arguments;
    super.onInit();

    category = arguments['id'];
    title = arguments['title'];
    flashSale = arguments['flashSale'];
    type = arguments['type'];
    ChildsCategories = globalController.homeDataList.value.categories!.where((category1) => category1.parent.toString() == category.toString()).toList();

    GetProducts();
  }

  @override
  void onReady() {
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        loader.value = true;
        GetProducts();
      }
    });
    super.onReady();
  }
  @override

  void onClose(){
    scrollController.dispose();
    super.onClose();

  }


  RxList<Product>? Products = RxList<Product>.empty();
  RxInt page = 1.obs;

  Future<bool> GetProducts() async {
    bool success = false;

    try {
      Map<String, dynamic> response = await api.getData({
        'storeId': prefs!.getString("id") ?? "",
        'page': page.value.toString(),
        'token': prefs!.getString("token") ?? "",
        'filter': type,
      }, "products/get-products");

      if (response.isNotEmpty) {
        success = response["succeeded"];
        if (success) {
          List productsInfo = response["products"];
          Products!.addAll(productsInfo.map((productData) => Product.fromJson(productData)).toList());
          loading.value = false;
          loader.value = false;
          page++;
        }
        return success;
      } else {
        loading.value = false;
        loader.value = false;
        toaster(Get.context!, 'connection Error ');
      }
      loading.value = false;
      loader.value = false;
    } catch (e) {
      loading.value = false;
      loader.value = false;
    }
    return success;
  }

  // ImageProvider<Object> getImageProvider(dynamic filePath, String placeholderAsset) {
  //   if (filePath == null || filePath.toString() == 'null') {
  //     return AssetImage(placeholderAsset);
  //   }
  //
  //   return CachedNetworkImageProvider(filePath.toString());
  // }
}
