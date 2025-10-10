import 'package:get/get.dart';
import '../../../main.dart';
import '../../../models/HomeData.dart';
import '../../Home_screen_fragment/controller/Home_screen_fragment_controller.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class BrandsScreenController extends GetxController {
  final RxBool loading = false.obs;
  final RxBool loadingMore = false.obs;

  String? tag = '/brandsscreen';
  Rx<ScrollController> ScrollListener = ScrollController().obs;
  int page = 0;
  RxList<Brand> brands = <Brand>[].obs;

  @override
  void onInit() {
    super.onInit();
    GetBrands(false);
  }

  @override
  void onReady() {
    ScrollListener.value.addListener(() async {
      if (ScrollListener.value.position.pixels == ScrollListener.value.position.maxScrollExtent) {
        GetBrands(true);
      }
    });
    super.onReady();
  }

  Future<bool> GetBrands(bool isScroll) async {
    bool success = false;
    page++;

    if (isScroll) {
      loadingMore.value = true;
    } else {
      loading.value = true;
    }

    try {
      await api.getData({
        'store_id': prefs!.getString('id'),
        'page': page,
      }, "stores/get-brands").then((response) {
        if (response.isNotEmpty) {
          success = response["succeeded"];

          if (success) {
            // Create a new list from the response
            List<Brand> newBrands = List<Brand>.from(response["brands"].map((x) => Brand.fromJson(x)));

            // Assuming 'globalController.homeDataList.value.brands' is a list of Brand objects
            for (var newBrand in newBrands) {
              brands.add(newBrand);
            }

            if (isScroll) {
              loadingMore.value = false;
            } else {
              loading.value = false;
            }
          } else {
            page--;
          }
        }
      });
    } catch (e) {
      page--;
      if (isScroll) {
        loadingMore.value = false;
      } else {
        loading.value = false;
      }
    }

    if (isScroll) {
      loadingMore.value = false;
    } else {
      loading.value = false;
    }

    return success;
  }
}
