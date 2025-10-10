import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:iq_mall/screens/Home_screen_fragment/controller/Home_screen_fragment_controller.dart';
import 'package:iq_mall/screens/ProductDetails_screen/controller/ProductDetails_screen_controller.dart';

import 'package:iq_mall/screens/tabs_screen/controller/tabs_controller.dart';

import 'main.dart';
import 'models/HomeData.dart';
import 'models/Stores.dart';

final state = sideMenuKey.currentState;
RxBool Updatecounter = false.obs;
RxString ItemsCount = ''.obs;
List settings = [];
List settings2 = [];
String? language = 'English';
RxList<Widget> fragments = <Widget>[].obs;

class GlobalController extends GetxController {
  var searchFocusNode = FocusNode();
  RxBool finishLoading = false.obs;
  RxBool isDrawerOpened = false.obs;
  RxBool fromHomeSearch = false.obs;
  RxBool noInternet = false.obs;
  RxBool isSideMenuOpened = false.obs;
  RxBool showBuyButton = true.obs;
  RxBool hideGoogle = true.obs;
  RxBool isLiked = false.obs;
  RxBool isNav = true.obs;
  RxBool isRequiredCheck = false.obs;
  RxBool refreshingHomeScreen = false.obs;
  late HtmlEditorController descriptionController;
  RxBool paymentAgreedToTerms = false.obs;
  RxString countryName = 'Lebanon'.tr.obs;
  RxString countryFlag = "🇱🇧".obs;

  RxString description = "".obs;
  RxString fullName = "".obs;
  List<StoreClass> myStores = <StoreClass>[];
  RxList<List<ProductType>> gemstonStylesDropList = <List<ProductType>>[].obs;
  RxList<String?> selectedGemstoneStyle = RxList<String?>.empty();

  RxMap<int, List<ProductType>> gemstonesDropDownMap = <int, List<ProductType>>{}.obs;
  RxList<ProductType> metals = <ProductType>[].obs;
  RxList<ProductType> selectedMetals = <ProductType>[].obs;
  RxList<ProductType> selectedGemstones = <ProductType>[].obs;
  RxList<List<ProductType>> selectedGemstonStylesDropList = <List<ProductType>>[].obs;
  RxList<ProductType> gemstones = <ProductType>[].obs;

  Rx<ProductType> itemMetal = ProductType().obs;
  Rx<ProductType> itemGemstone = ProductType().obs;
  RxList<ProductType> itemGemstoneStyles = <ProductType>[].obs;

  RxDouble screenWidth = 0.0.obs;
  RxInt notCount = 0.obs;
  int cartCount = 0;
  int cartBackCount = 0;
  String? cartFirstRoute = Get.currentRoute;

  // Rx<StreamController<int>>fetchedImagesCount = StreamController<int>().obs;
  RxInt fetchedImagesCount = 0.obs;
  User? fireBaseUser;
  Map userObjFacebook = {};
  RxBool guestUser = false.obs;
  RxBool isSigned = false.obs;
  RxString snackBarKey = "".obs;
  RxString appVersion = "".obs;
  RxString timeSpent = "".obs;
  Timer? timer;
  Rx<int> counterDuration = 3.obs;
  Rx<bool> loading = true.obs;
  Rx<Product>? bannerProduct;

  RxBool profileSelected = false.obs;
  RxBool playGeneralVideo = true.obs;
  RxString selectedQuality = "360".obs;
  RxString storeImage = (prefs!.getString('main_image') ?? "").obs;
  RxBool profileUpdated = false.obs;
  RxBool updateVideoBool = false.obs;
  RxBool returnFromFullScreen = false.obs;
  final RxBool isFullScreen = false.obs;
  late Rx<Duration> currentPosition;
  RxBool updateVideoIndicator = false.obs;
  RxBool backgroundUpdated = false.obs;
  RxBool backgroundSelected = false.obs;
  RxBool isAppInReview = false.obs;
  RxBool loadingMore = false.obs;
  RxBool refreshingPrice = false.obs;
  RxInt unreadednotifications = 0.obs;
  RxDouble result = 0.0.obs; // Initialize result to 0
  RxDouble sum = 0.0.obs;
  String currentStoreId = "1";
  Rx<HomeData> homeDataList = HomeData().obs;
  Rx<CompanySettings> companySettings = CompanySettings().obs;
  Rxn<String?> cartListRoute = Rxn();
  Rxn<String?> storeRoute = Rxn();
  Rxn<String?> detailsTag = Rxn();
  late ProductDetails_screenController productDetails_screenController;

  RxList<StoreClass> stores = <StoreClass>[].obs;

  RxMap<String, double> filesPercent = <String, double>{}.obs;

  Rx<CancelToken> cancelToken = CancelToken().obs;

  refreshHomeScreen(bool newValue, {Map<String, dynamic>? response}) {
    if (response != null) {
      try {
        globalController.homeDataList.value = (HomeData.fromJson(response));
        updateAddItemDropDownLists();
      } catch (e) {
        print(e);
      }

      // sections().createState().initState();
    }

    refreshingHomeScreen.value = newValue;
    globalController.homeDataList.refresh();
    globalController.update();
    globalController.refresh();
  }

  updateAddItemDropDownLists() {
    gemstonStylesDropList.clear();
    selectedGemstoneStyle.clear();
    gemstonStylesDropList.add(globalController.homeDataList.value.gemstoneStyles!);
    selectedGemstoneStyle.add(null);
    try {
      metals.clear();
      gemstones.clear();
      metals.addAll(globalController.homeDataList.value.productTypes!.where(
        (element) => element.type == 'Metal',
      ));
      gemstones.addAll(globalController.homeDataList.value.productTypes!.where(
        (element) => element.type == 'Gemstone',
      ));
    } catch (e) {
      print(e);
    }
    // globalController.update();
    // globalController.refresh();
  }

  resetUserData() {
    globalController.fullName.value = "";
  }

  void resetMetalFields(RxList<ProductType> metals, RxList<ProductType> gemstones) {
    for (var product in metals) {
      if (product.items != null) {
        for (var field in product.items!) {
          field.fieldValue = ""; // Reset field value
          field.isEdited = false; // Reset edited flag

          if (field.options != null) {
            for (var option in field.options!) {
              option.isSelected = false; // Reset selection
            }
          }
        }
      }
    }
    for (var product in gemstones) {
      if (product.items != null) {
        for (var field in product.items!) {
          field.fieldValue = ""; // Reset field value
          field.isEdited = false; // Reset edited flag

          if (field.options != null) {
            for (var option in field.options!) {
              option.isSelected = false; // Reset selection
            }
          }
        }
      }
    }

    metals.refresh(); // ✅ Refresh to update UI
    gemstones.refresh(); // ✅ Refresh to update UI
  }

  void resetGemstonStylesDropList() {
    for (int i = 0; i < gemstonStylesDropList.length; i++) {
      gemstonStylesDropList[i] = gemstonStylesDropList[i]
          .map((product) => product.copyWith(
                isEdited: false,
                items: product.items
                        ?.map((item) => item.copyWith(
                              fieldValue: "",
                              isEdited: false,
                              options: item.options
                                      ?.map((option) => option.copyWith(
                                            isSelected: false,
                                          ))
                                      .toList() ??
                                  [],
                            ))
                        .toList() ??
                    [],
              ))
          .toList();
    }
  }

  void resetgemstonesDropDownMap() {
    gemstonesDropDownMap.updateAll((key, productList) => productList
        .map((product) => product.copyWith(
              isEdited: false,
              items: product.items
                      ?.map((item) => item.copyWith(
                            fieldValue: "",
                            isEdited: false,
                            options: item.options
                                    ?.map((option) => option.copyWith(
                                          isSelected: false,
                                        ))
                                    .toList() ??
                                [],
                          ))
                      .toList() ??
                  [],
            ))
        .toList());
    print("s");
  }

  updateEditItemStyleList() {
    gemstonStylesDropList.clear();
    selectedGemstoneStyle.clear();
    gemstonStylesDropList.add(globalController.homeDataList.value.gemstoneStyles!);
    selectedGemstoneStyle.add(null);

    globalController.update();
    globalController.refresh();
  }

  updateStoreImage(String fromKey) {
    print(fromKey);
    storeImage.value = prefs!.getString('main_image') ?? "";
    globalController.update();
    globalController.refresh();
  }

  updateFullName() {
    fullName.value = "${prefs?.getString('first_name') ?? ''} ${prefs?.getString('last_name') ?? ''}";
    globalController.update();
    globalController.refresh();
  }

  updateFlag(String newValue) {
    countryFlag.value = newValue;
    globalController.update();
    globalController.refresh();
  }

  updateCartPrice(double newValue) {
    result.value = newValue;
    globalController.update();
    globalController.refresh();
  }

  updateIsNav(bool newValue) {
    isNav.value = newValue;
    globalController.update();
    globalController.refresh();
  }

  updateFavoriteProduct(int id, int newValue) {
    try {
      homeDataList.value.products?.firstWhere((element) => element.product_id == id).is_liked = newValue;
    } catch (e) {
      print(e);
    }
    globalController.homeDataList.refresh();
    globalController.update();
    globalController.refresh();
  }

  updateAdditionalPrice(double newValue) {
    sum.value = newValue;
    globalController.update();
    globalController.refresh();
  }

  updateImageFetchingNumber() {
    fetchedImagesCount.value++;
  }

  resetImageFetchingNumber() {
    fetchedImagesCount.value = 0;
  }

  refreshProductPrice(bool newValue) {
    refreshingPrice.value = newValue;
    globalController.update();
    globalController.refresh();
  }

  refreshUnreadNotification(int newValue) {
    unreadednotifications.value = newValue;
    globalController.update();
    globalController.refresh();
  }

  Future<void> refreshFunctions() async {
    try {
      globalController.refreshHomeScreen(true);
      Home_screen_fragmentController _homeController = Get.find();
      TabsController _tabsController = Get.find();
      _tabsController.unreadednotification();
      await _homeController.GetHomeData();

      globalController.refreshHomeScreen(false);
    } catch (ex) {
      // Handle the exception
      print('An error occurred: $ex');
    }
  }

  updateBanner(Product newValue) {
    bannerProduct = newValue.obs;
    globalController.update();
    globalController.refresh();
  }

  updateCurrentRout(String newValue) {
    cartListRoute.value = newValue;
    globalController.update();
    globalController.refresh();
  }

  updateStoreRoute(String newValue) {
    storeRoute.value = newValue;
    globalController.update();
    globalController.refresh();
  }

  updateSideMenuStatus(bool newValue) {
    isSideMenuOpened.value = newValue;
    globalController.update();
    globalController.refresh();
  }

  loadMoreSections(bool newValue, {Map<String, dynamic>? response}) {
    if (response != null) {
      globalController.homeDataList.value.productSections?.addAll((response["product_sections"] as List<dynamic>?)?.map((productData) => ProductSection.fromJson(productData)) ?? []);

      // globalController.homeDataList.value.productSections?.addAll(List<ProductSection>.from(response["product_sections"]?.map((x) => ProductSection.fromJson(x)) ?? []));
      // Future.delayed(Duration(milliseconds: 600)).then((value) {
      globalController.homeDataList.value.products?.addAll((response["products"] as List<dynamic>?)?.map((productData) => Product.fromJson(productData)) ?? []);
      // });

      // globalController.homeDataList.value.products?.addAll(List<Product>.from(response["products"]?.map((x) => Product.fromJson(x)) ?? []));
    }
    // loadingMore.value = newValue;

    // globalController.update();
    // globalController.refresh();
  }

  updateProductLike(bool newValue) {
    isLiked.value = newValue;
    // globalController.update();
    // globalController.refresh();
  }

  @override
  void onClose() {
    // TODO: implement onClose

    super.onClose();
  }

  /// change page in route

  @override
  void onReady() {
    super.onReady();
  }
}
