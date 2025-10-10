import 'dart:async';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/main.dart';
import 'package:flutter/services.dart';
import 'package:iq_mall/cores/assets.dart';
import 'package:iq_mall/models/HomeData.dart';

import 'package:iq_mall/widgets/ShWidget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import '../../../utils/ShColors.dart';
import 'package:dio/dio.dart' as dio;

class Searchcontroller extends GetxController {
  TextEditingController searchController = TextEditingController();
  List searchinfo = [];
  RxBool loading = false.obs;
  RxBool updateList = false.obs;
  var searchText = "";
  List brandInfo = [];
  List categoriesInfo = [];
  List productsInfo = [];
  List brandslist = [];
  var brands;
  RxInt page = 1.obs;
  ScrollController ScrollListener = new ScrollController();
  String? scanBarcode = 'Unknown';
  bool? barcode;
  Timer debounce = Timer(Duration.zero, () {});
  bool searchbarcode = true;
  RxBool loadMore = false.obs;
  Timer? searchOnStoppedTyping;
  CancelToken _cancelToken = CancelToken();
  CancelToken searchToken = CancelToken();
  RxList<Product>? SearchList = <Product>[].obs;
  var focusNode = FocusNode();

  @override
  void onClose() {
    ScrollListener.dispose();
    super.onClose();
  }

  void performSearch(String query, bool isScroll) async {
    if (query.isNotEmpty) {
      // Cancel the previous request
      if (!_cancelToken.isCancelled) {
        _cancelToken.cancel("Cancelled the old request");
      }

      if (isScroll) {
        loadMore.value = true;
        await Future.delayed(const Duration(milliseconds: 50)).then((value) {
          ScrollListener.animateTo(
            ScrollListener.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        });
      } else {
        loading.value = true;
      }

      // Create a new CancelToken for the new request
      _cancelToken = CancelToken();
      final _dio = dio.Dio();
      bool success = false;

      try {
        if (isScroll) {
          await _dio.post(
            '${con}products/get-products',
            data: dio.FormData.fromMap({
              'storeId': globalController.currentStoreId,
              'page': page.value,
              'token': prefs!.getString("token") ?? "",
              'q': query,
            }),
            queryParameters: {
              'storeId':  globalController.currentStoreId,
              'page': page.value,
              'token': prefs!.getString("token") ?? "",
              'q': query,
            },
          ).then((response) {
            success = response.data["succeeded"];
            if (success) {
              page.value+=1;

              loadMore.value = true;
              List productsInfo = response.data["products"];
              SearchList?.value = List<Product>.from(SearchList?.value ?? [])
                ..addAll(productsInfo
                    .map((productData) => Product.fromJson(productData)));
              SearchList?.refresh();

              loadMore.value = false;
            } else {
              loadMore.value = false;

              toaster(Get.context!, 'Request Failed');
            }
          });
        }
        else {
          print(globalController.currentStoreId);
          await _dio
              .post('${con}products/get-products',
              data: dio.FormData.fromMap({
                'storeId':  globalController.currentStoreId,
                'page': page.value,
                'token': prefs!.getString("token") ?? "",
                'q': query,
              }),
              queryParameters: {
                'storeId': globalController.currentStoreId,
                'page': page.value,
                'token': prefs!.getString("token") ?? "",
                'q': query,
              },
              cancelToken: !isScroll ? _cancelToken : null)
              .then((response) {
            success = response.data["succeeded"];
            if (success) {
              page.value+=1;
              loading.value = true;
              SearchList?.clear();
              List productsInfo = response.data["products"];
              SearchList!.addAll(productsInfo
                  .map((productData) => Product.fromJson(productData))
                  .toList());
              SearchList?.refresh();

              loading.value = false;
            } else {
              loading.value = false;

              toaster(Get.context!, 'Request Failed');
            }
          });
        }

        // Handle the response as needed
      } catch (e) {
        print('Request cancelled: $e');
      }
    }
  }
  @override
  void onReady() {
    globalController.cancelToken.value = CancelToken();

    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onInit() {
    print(MainColor);
    searchToken = CancelToken();
    ScrollListener.addListener(() async {
      if (ScrollListener.position.pixels == ScrollListener.position.maxScrollExtent) {
        performSearch(searchController.text, true);
      }
    });
    Future.delayed(Duration(milliseconds: 500), () {
      FocusScope.of(Get.context!).requestFocus(focusNode);
    });

    super.onInit();
  }

  // scanBarcodeNormal() async {
  //   barcode = true;
  //   String? barcodeScanRes;
  //   try {
  //     barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
  //       '#CA4123',
  //       'Cancel',
  //       false,
  //       ScanMode.BARCODE,
  //     );
  //   } on PlatformException {
  //     barcodeScanRes = 'Failed to get platform version.';
  //   }
  //   scanBarcode = barcodeScanRes;
  //   if (scanBarcode.toString() != '-1') searchbybarcode(scanBarcode);
  // }

  searchbybarcode(barcode) async {
    searchbarcode = true;
    loading.value = true;
    searchText = searchController.text.toString();
    var url = "${con!}product/search-by-barcode";
    final http.Response response = await http.post(
      Uri.parse(url),
      body: {
        'user_id': prefs?.getString('logged_in') == 'true' ? prefs?.getString('user_id').toString() : deviceId.toString(),
        'barcode': barcode.toString(),
      },
    );
    if (response.statusCode == 200) {
      if (json.decode(response.body).toString() != '0') {
        searchbarcode = true;
        SearchList!.clear();
        searchController.clear();
        searchinfo.clear();
        searchinfo = json.decode(response.body) as List;
        SearchList!.clear();
        // for (int i = 0; i < searchinfo.length; i++) {
        //   productsclass.fromJson(searchinfo[i], 'search');
        // }
        loading.value = false;
      } else {
        SearchList!.clear();
        searchController.clear();
        loading.value = false;
      }
    } else {
      toaster(Get.context!, 'error');
    }
  }

  ImageProvider<Object> getImageProvider(dynamic filePath, String placeholderAsset) {
    if (filePath == null || filePath.toString() == 'null') {
      return AssetImage(placeholderAsset);
    }
    return NetworkImage(filePath.toString());
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    return !isLiked;
  }
}
