import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/main.dart';

import '../../../models/HomeData.dart';
import '../../../widgets/ShWidget.dart';
import '../../Home_screen_fragment/controller/Home_screen_fragment_controller.dart';

class Filter_ProductsController extends GetxController {
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
  RxnString? selectedType =RxnString();
  Rx<ProductType>? selectedTypeObject = ProductType(items: []).obs;
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
  RxList<Brand> brands = <Brand>[].obs;

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
  RxList<Map<String,String>> cities = <Map<String,String>>[].obs;
  Rx<Category>? selectedCategory = Category(id: 0, categoryName: "categoryName", slug: "slug", parent: 0, main_image: "main_image", showInNavbar: 0, productCount: 0, isSelected: false,hasProduct: false).obs;
  RangeValues priceRange = RangeValues(0, 1000);
  RxString category = ''.obs;
  RxString title = ''.obs;
  var type;
  String? selectedCategoryForFilter;
  RxList<Category>subCategoriesList = RxList<Category>();

  var ChildsCategories;
  RxString? selectedValue = 'newest'.obs;
  Rx<String?> selectedCity= Rxn();
  Rx<String?> selectedCityId= Rxn();
  RxInt selectedValueInt = 0.obs;
  bool isFetching = false;
  RxBool animateSubCategories = false.obs;
  RxDouble pinnedTopPad = 0.0.obs;
  Map arguments = {};
  RxString count = ''.obs;
  RxList<Product>? Products = RxList<Product>.empty();
    Rx<RangeValues> iniPrices =const RangeValues(0,0).obs ;
    RxInt priceDivider= 0.obs;
    Rx<RangeValues> priceValues= const RangeValues(0,0).obs;
    TextEditingController minPriceController= TextEditingController();
    TextEditingController maxPriceController=  TextEditingController();
   FocusNode minPriceNode = FocusNode();
   FocusNode maxPriceNode = FocusNode();
  RxDouble maxPriceFinal = 0.0.obs;
  RxDouble minPriceFinal = 0.0.obs;
  var tag;
  @override
  void onInit() {
    arguments = Get.arguments;
    tag = Get.parameters["tag"];
    bool? isFound = false;

    globalController.homeDataList.value.productTypes?.forEach((element) {
      if(element.name=="All"){
        isFound=true;
      }
    },);

    if(!isFound!){
       globalController.homeDataList.value.productTypes?.insert(0, ProductType(id: "00", name: "All", items: [],type: "Metal"));

    }
    scrollController = ScrollController()
      ..addListener(() {
        pinnedTopPad.value = min(getVerticalSize(150), scrollController.offset) * (getTopPadding()) / getVerticalSize(150);
      });

    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    initialize();
    super.onReady();
  }

  initialize() {
    category.value = arguments['id'].toString();

    selectedCategoryIds = int.parse(arguments['id'].toString());
    type = arguments['type'];
    subCategoriesList.addAll(globalController.homeDataList.value.categories!.where((element) => element.parent.toString() == category.value.toString()));

    print(arguments['type']);
    var temp = jsonDecode(arguments['type']);
    selectedCategoryForFilter = temp["categories"][0];

    title.value = arguments['title'];
    for (int i = 0; i < globalController.homeDataList.value.categories!.length; i++) {
      if (category.value.toString() == globalController.homeDataList.value.categories![i].id.toString()) {
        globalController.homeDataList.value.categories![i].isSelected = true;
      }
    }

    scrollController.addListener(() {
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

  Future<bool?> getProducts(int pageNumber) async {
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

    try {
      print("before globalController.fetchedImagesCount.value: ${globalController.fetchedImagesCount.value}");
      print("storeID: ${ arguments["store_id"]??globalController.currentStoreId}");

      // Fetch products for the specified page number
      Map<String, dynamic> param= {
        'storeId': arguments["store_id"]??globalController.currentStoreId,
        'page': pageNumber.toString(),
        'token': prefs!.getString("token") ?? "",
        'sort': selectedValue!.value,
        "type":  selectedTypeObject?.value.id!="00"?selectedTypeObject?.value.id:null,
        'filter': type,
      };
      print(param);

      Map<String, dynamic> response = await api.getData({
        'storeId': arguments["store_id"]??globalController.currentStoreId,
        'page': pageNumber.toString(),
        'token': prefs!.getString("token") ?? "",
        'sort': selectedValue!.value,
        "type":  selectedTypeObject?.value.id!="00"?selectedTypeObject?.value.id:null,
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
          Products?.forEach((element) {
            bool isFound= false;
            for(int i=0; i<cities.length; i++){
              if(element.cityId.toString()==cities[i].keys.first..toString()){
                isFound=true;

              }

            }
            if(!isFound){
              cities.add({element.cityId??"":element.cityName??""});

            }

          });

          bool isAddFound =  cities.any((map) => map.containsValue("All"));

          if(!isAddFound){
            cities.insert(0, {"10000":"All"});

          }

          for (int i = previousNbOfImages; i < Products!.length; i++) {
            if (Products![i].more_images != null) {
              Products![i].more_images!.length < 5 ? nbOfImages += Products![i].more_images!.length : nbOfImages += 4;
              nbOfImages += Products![i].more_images!.length;
            }
          }
          previousNbOfImages = nbOfImages;
          priceDivider.value = 1;
          globalController.homeDataList.value.products?.forEach((element) {
            if(element.product_price>maxPriceFinal.value){
              maxPriceFinal.value=element.product_price;
            }
          });
          priceValues.value = RangeValues(
              0,maxPriceFinal.value )
              ;

          minPriceController = TextEditingController(text: pretifier(priceValues.value.start.toString()));
          maxPriceController = TextEditingController(text: pretifier(priceValues.value.end.toString()));

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
  String pretifier(String amount, {bool addTrailingZeros = true}) {
    String result = "";
    String sign = "";

    if (amount.startsWith('-')) {
      sign = "-";
      amount = amount.substring(1);
    }

    if (amount.endsWith(".0")) {
      amount = amount.substring(0, amount.length - 2);
    }

    int x = amount.indexOf('.');

    if (x > 0) {
      result = amount.substring(x);
      amount = amount.substring(0, x);

      if (addTrailingZeros && result.length < 3) {
        result = "${result}0";
      }
    }

    for (int i = amount.length; i >= 0; i -= 3) {
      if (i - 3 > 0) {
        result = ",${amount.substring(i - 3, i)}$result";
      } else {
        result = amount.substring(0, i) + result;
      }
    }

    return sign + result;
  }

}

// Create a service class to manage your data
