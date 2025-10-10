import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/main.dart';
import 'dart:convert';
import 'package:iq_mall/cores/assets.dart';
import 'package:http/http.dart' as http;

import 'package:iq_mall/screens/Cart_List_screen/controller/Cart_List_controller.dart';
import '../../../models/HomeData.dart';
import '../../../widgets/ShWidget.dart';

class WishlistController extends GetxController {
  List favoriteInfo = [];

  Rx<ScrollController> ScrollListenerFAVORITE = ScrollController().obs;
  List suggestionsInfo = [];
  int limit = 5;
  RxBool loading = true.obs;
  int offset = 0;
  int offsetsug = 0;
  int limitsug = 8;
  RxBool removing_items = false.obs;

  @override
  void onInit() {
    try {
      limit = 5;
      loading = true.obs;
      offset = 0;
      offsetsug = 0;
      GetFavorite();
    } catch (ex) {
      print(ex);
    }

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    try {
      ScrollListenerFAVORITE.value.addListener(() {
        if (ScrollListenerFAVORITE.value.position.pixels == ScrollListenerFAVORITE.value.position.maxScrollExtent) {}
      });
    } catch (ex) {}
  }

  Future<bool> GetFavorite() async {
    bool success = false;
    try{
      await api.getData({
        'storeId': prefs?.getString("id") ?? "",
        'page': '1',
        'token': prefs?.getString("token") ?? "",
      }, "products/get-favorite").then((response) {
        success = response["succeeded"];

        if (response.isNotEmpty) {
          if (success) {
            favoritelist?.clear();
            List productsInfo = response["products"];
            print(favoritelist?.length);
            favoritelist!.addAll(productsInfo.map((productData) => Product.fromJson(productData)).toList());
            print(favoritelist?.length);
          }
          loading.value = false;
          globalController.refreshHomeScreen(false);
        } else {
          favoritelist?.clear();
          loading.value = false;
          toaster(Get.context!, 'Request Failed');
          globalController.refreshHomeScreen(false);
        }
      });
    }catch(e){
      loading.value = false;
      globalController.refreshHomeScreen(false);
    }

    loading.value = false;
    return success;
  }
}
