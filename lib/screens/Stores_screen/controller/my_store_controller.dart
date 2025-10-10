import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/main.dart';

import '../../../models/HomeData.dart';
import '../../../models/Stores.dart';
import '../../../widgets/ShWidget.dart';
import '../../Home_screen_fragment/controller/Home_screen_fragment_controller.dart';

class MyStoreController extends GetxController {
  RxString? sortbyprice = 'null'.obs;

  List brands222 = [];
  String? brandschoosen = 'null,';
  RxBool reload = false.obs;
  RxString? newest = 'null'.obs;
  RxString? oldest = 'null'.obs;
  RxString? most_in_wishlist = 'null'.obs;
  RxString? most_in_cart = 'null'.obs;
  RxString? most_reviewed = 'null'.obs;
  RxString? highest_rate = 'null'.obs;

  TextEditingController from = new TextEditingController();
  TextEditingController to = new TextEditingController();
  var sortType = -1;
  RxBool loading = true.obs;
  RxBool loader = true.obs;
  List AllproductsInfo = [];
  var isListViewSelected = true;
  var errorMsg = '';
  var scrollController =  ScrollController();
  bool isLoading = false;
  bool isLoadingMoreData = false;
  RxInt page = 1.obs;
  RxInt selectedCategoryIndex = (-1).obs;
  bool isLastPage = false;
  var primaryColor;
  int limit = 15;
  int offset = 0;
  List brandInfo = [];
  bool loading2 = true;
  RxList subcategoriesInfo = [].obs;
  RxBool webloading = true.obs;
  var temp;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  int limitsubcategories = 20;
  int offsetsubcategories = 0;
  int nbOfImages = 0;
  int previousNbOfImages = 0;
  int countImages = 0;
  RxBool loadmore = false.obs;
  String? filter_by = 'null';
  int? selectedCategoryIds;
  int? selectedBrandIds;
  RxList<Category> categories = <Category>[].obs;
  RxList<Brand> brands = <Brand>[].obs;
  Rx<Category>? selectedCategory;
  RangeValues priceRange = RangeValues(0, 1000);
  RxString category = ''.obs;
  RxString title = ''.obs;
  String? type;
  var ChildsCategories;
  RxInt selectedValueInt = 0.obs;
  bool isFetching = false;
  RxBool animateSubCategories = false.obs;
  RxDouble pinnedTopPad = 0.0.obs;
  Map arguments = {};
  RxString count = ''.obs;
  RxList<Product>? Products = RxList<Product>.empty();
  Rx<StoreClass> store = StoreClass().obs;


  @override
  void onInit() {
    arguments = Get.arguments;
    store.value = arguments["store"];

    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    initialize();
    super.onReady();
  }

  initialize() {
    title.value = store.value.store_name??'';

    scrollController.addListener(() {
      pinnedTopPad.value = min(getVerticalSize(150), scrollController.offset) * (getTopPadding()) / getVerticalSize(150);

      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !loadmore.value) {

        getProducts(page.value);
      }
    });

    // try{
    //
    //
    //   everListener = ever(globalController.fetchedImagesCount, (value) {
    //     Future.delayed(Duration(seconds: 3)).then((value) => {
    //       if (scrollController.position.pixels == scrollController.position.maxScrollExtent)
    //         {
    //           if ((nbOfImages - globalController.fetchedImagesCount.value).abs() < 20 && !loadmore.value && scrollController.position.pixels == scrollController.position.maxScrollExtent)
    //             {getProducts(page.value)}
    //         }
    //     });
    //
    //     // call your function here
    //     // any code in here will be called any time index changes
    //   });
    // }catch(e){
    //   everListener?.dispose();
    // }

    brands = RxList<Brand>(globalController.homeDataList.value.brands!.toList());
    categories = RxList<Category>(globalController.homeDataList.value.categories!.where((category) => category.parent == null).toList());
    //
    for (int i = 0; i < globalController.homeDataList.value.categories!.length; i++) {
      Category cat = globalController.homeDataList.value.categories![i];
      if (cat.id.toString() == arguments["id"].toString()) {
        selectedCategory?.value = cat;
      }
    }
    getProducts(page.value);

    // selectedCategory = globalController.homeDataList.value.categories!.firstWhere((element) => element.id.toString() == arguments["id"].toString()).obs;
  }

  @override
  void onClose() {

    super.onClose();
    // TODO: implement onClose
    from.dispose();
    to.dispose();
    scrollController.dispose();
  }



  Future<bool?> getProducts(int pageNumber,{bool isRefresh=false}) async {
    countImages = 0;
    if (isFetching) {
      return null; // Exit if a fetch is already in progress.
    }

    isFetching = true;
    if (pageNumber != 1) {
      loadmore.value = true;
      try{
        await Future.delayed(const Duration(milliseconds: 50)).then((value) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        });
      }catch(e){

      }
    }
    else{
      loader.value=true;
    }

    try {
      print("before globalController.fetchedImagesCount.value: ${globalController.fetchedImagesCount.value}");

      // Fetch products for the specified page number
      Map<String, dynamic> response = await api.getData({
        'storeId': arguments["store"].id,
        'page': pageNumber.toString(),
        "my_store": 1,
        'token': prefs!.getString("token") ?? "",
        if(type!=null)
        'filter': type,
      }, "products/get-products");

      if (response.isNotEmpty) {
        bool success = response["succeeded"];
        if (success) {
          List productsInfo = response["products"];
          count.value = response["products_count"].toString();
          if(pageNumber==1){
            Products?.clear();

          }

          Products?.value = List<Product>.from(Products ?? [])..addAll(productsInfo.map((productData) => Product.fromJson(productData)));

          for (int i = previousNbOfImages; i < Products!.length; i++) {
            if (Products![i].more_images != null) {
              Products![i].more_images!.length < 5 ? nbOfImages += Products![i].more_images!.length : nbOfImages += 4;
              nbOfImages += Products![i].more_images!.length;
            }
          }
          previousNbOfImages = nbOfImages;

          // Products?.addAll(productsInfo.map((productData) => Product.fromJson(productData)));
          if (pageNumber != 1) {
            loadmore.value = false;
          }
          // Products!.addAll(productsInfo
          //     .map((productData) => Product.fromJson(productData))
          //     .toList());
          // Increment page number for the next request
          page++;
          loader.value = false;

        }
        return success;
      } else {
        loader.value = false;

        toaster(Get.context!, 'Request Failed');
        return false;
      }
    } catch (e) {
      loader.value = false;

      // Handle any errors that occur during the fetch operation
      print('Error fetching products: $e');
      toaster(scaffoldKey.currentContext!, 'An error occurred while fetching products',title: "Error".tr,iconColor: Colors.red,titleColor: Colors.red);
      return false;
    } finally {
      // Reset flags and indicators after the fetch operation completes
      isFetching = false;
      loading.value = false;
      loader.value = false;
    }
  }
}

// Create a service class to manage your data
