import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iq_mall/cores/assets.dart';
import 'package:iq_mall/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../models/HomeData.dart';
import '../../../widgets/ShWidget.dart';

class OffersScreenController extends GetxController {
  RxBool loading = true.obs;
  List offersInfo = [];
  int limit = 20;
  int limitoffers = 20;
  int offset = 0;
  int page = 1;
  int offsetoffer = 0;
  ScrollController ScrollListener = new ScrollController();
  String? offer;
  String? store_id;
  RxList<Product>? MyOffers = RxList<Product>.empty();

  @override
  void onInit() {
    final arguments = Get.arguments;
    offer = arguments['offer'].toString();
    store_id = arguments['store_id'].toString();
    offersInfo.clear();

    GetOffers();
    ScrollListener.addListener(() async {
      print('ScrollListener position: ${ScrollListener.position.pixels}');
      print('ScrollListener maxScrollExtent: ${ScrollListener.position.maxScrollExtent}');
      if (ScrollListener.position.pixels == ScrollListener.position.maxScrollExtent) {
        print('Reached the bottom of the scroll');
        GetOffers();
      }
    });
    super.onInit();
  }

  Future<bool?> GetOffers() async {
    var f = {
      "flash_sales": [
        '1',
      ],
    };
    String jsonString = jsonEncode(f);
    bool success = false;
    Map<String, dynamic> response = await api.getData({
      'storeId': prefs!.getString("id") ?? "",
      'page': page.toString(),
      'token': prefs!.getString("token") ?? "",
      'filter': jsonString.toString(),
    }, "products/get-products");

    if (response.isNotEmpty) {
      success = response["succeeded"];
      if (success) {
        List productsInfo = response["products"];
        MyOffers!.addAll(productsInfo.map((productData) => Product.fromJson(productData)).toList());
        loading.value = false;
        page++;
      }
      return success;
    } else {
      loading.value = false;
      toaster(Get.context!, 'Request Failed');
    }
    loading.value = false;
  }
}
