import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:app_links/app_links.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/cores/assets.dart';
import 'package:iq_mall/main.dart';
import 'package:iq_mall/screens/tabs_screen/controller/tabs_controller.dart';
import 'package:iq_mall/widgets/CommonFunctions.dart';
import 'package:iq_mall/models/online_adds.dart';
import '../../../models/Address.dart';
import '../../../models/Stores.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/ShColors.dart';
import '../../TermsAndConditions_screen/terms_widget.dart';
import '../../tabs_screen/models/SocialMedia.dart';
import '../widgets/NewsLetter.dart';
import 'package:iq_mall/widgets/gold_price_indicator.dart';

// Rx<HomeData> globalController.homeDataList = HomeData().obs;

class Home_screen_fragmentController extends GetxController {
  RxBool load = true.obs;
  RxBool loading = true.obs;
  RxBool errorOccurred = false.obs;
  RxBool Expandedlist = false.obs;
  int limit = 5;
  int offset = 0;
  int page = 1;
  ScrollController ScrollListenerHOME = new ScrollController();
  RxBool loadingMore = false.obs;

  static Home_screen_fragmentController get to => Get.find();
  var isInitialized = false.obs;
  late RxList<SocialMedia> socialMedia = <SocialMedia>[].obs;
  final GlobalKey<ScaffoldState> homeScaffoldKey = GlobalKey<ScaffoldState>();
  double? lastGoldPrice;
  double? lastSilverPrice;

  @override
  void onInit() {
    super.onInit();
  }

  final _navigatorKey = GlobalKey<NavigatorState>();
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  String? propertyId;

  Future<void> waitForInitialization() async {
    // Wait until the app is initialized
    while (loading.value) {
      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  void openAppLink(Uri uri) {
    if (uri.pathSegments.isNotEmpty && uri.host == '$con') {
      propertyId = uri.path.split("/").last;

      // if (propertyId == null) {
      //   return;
      // }

      // const Uuid uuid = Uuid();
      // String tag = "$propertyId-${uuid.v4()}";

      // while (loading.value) {
      //
      // }

      waitForInitialization().then((_) {
        Future.delayed(Duration(milliseconds: 600)).then((value) {
          Get.offNamed(
            AppRoutes.Productdetails_screen,
            arguments: {
              'product': null,
              'fromCart': false,
              'productSlug': propertyId,
              'from_banner': true,
              'tag': "${UniqueKey()}$propertyId"
            },
            parameters: {'tag': "$propertyId"},
          );
        });
      });

      // Get.put(() => ProductDetails_screenController(), tag: "$propertyId");
      // _navigatorKey.currentState?.pushNamed(AppRoutes.Productdetails_screen,arguments: {
      //   'product': null,
      //   'fromCart': false,
      //   'productSlug': propertyId,
      //   'from_banner': true,
      //   'tag': "$propertyId"
      // },);
    }
  }

  @override
  Future<void> onReady() async {
    // TODO: implement onReady
    LoadingDrawer.value = false;
    await GetHomeData();
    Future.delayed(const Duration(seconds: 15), () {
      if (news?.show_hide == 1 &&
          prefs!.getString('seen').toString() != 'true') {
        prefs?.setString('seen', 'true');
        showNewsLetterDetails(Get.context!, news!);
      }
    });

    ScrollListenerHOME.addListener(() async {
      if (ScrollListenerHOME.position.pixels >
              (ScrollListenerHOME.position.maxScrollExtent - 450) &&
          !loadingMore.value) {
        getProductSections();
      }
    });
    globalController.updateFullName();

    globalController.updateCurrentRout(Get.currentRoute);

    super.onReady();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ever(globalController.pendingDeepLink, (Uri? uri) {
    //     if (uri != null) {
    //       DeepLinkService().init(); // ✅ navigate after first layout
    //       globalController.pendingDeepLink.value = null;   // prevent re-trigger
    //     }
    //   });
    // });

    // await DeepLinkService().init();
  }

  void _handle(Uri uri) {
    final productId =
        uri.pathSegments.isNotEmpty ? uri.pathSegments.last : null;
    if (productId != null && uri.pathSegments.first == 'product') {
      Future.delayed(Duration(seconds: 10)).then(
        (value) {
          Get.toNamed(
            AppRoutes.Productdetails_screen,
            arguments: {
              'product': null,
              'fromCart': false,
              'productSlug': productId,
              'from_banner': true,
              'tag': productId,
            },
            parameters: {'tag': productId},
          );
        },
      );
    }
  }

  @override
  void onClose() {
    _linkSubscription?.cancel();

    super.onClose();
  }

  Future<bool> GetHomeData() async {
    bool success = false;
    errorOccurred.value = false;

    try {
      Map<String, dynamic> response = await api.getData({
        'token': prefs!.getString("token") ?? "",
        'store_id': globalController.currentStoreId,
      }, "stores/home-store-data");

      if (response.isNotEmpty) {
        success = response["succeeded"];
        prefs?.setString("category_grid", response["category_grid"]);
        loading.value = true;
        await globalController.refreshHomeScreen(false, response: response);
        socialMedia.value =
            globalController.homeDataList.value.socialMedia ?? <SocialMedia>[];
        // globalController.homeDataList = (HomeData.fromJson(response)).obs;
        onlineaddslist.clear();
        ChangeStroredStore(
            storeList.firstWhere(
              (element) => element.id == globalController.currentStoreId,
            ),
            response["newsLetters"],
            "homedatacontroller");

        loading.value = false;
      }
      if (success) {
      } else {}
      Map<String, dynamic> addressesResponse = await api.getData({
        'token': prefs!.getString("token") ?? "",
      }, "addresses/get-addresses");

      if (addressesResponse.isNotEmpty) {
        success = addressesResponse["succeeded"];
        if (success) {
          List productsInfo = addressesResponse["addresses"];
          addresseslist.clear();
          for (int i = 0; i < productsInfo.length; i++) {
            addressesclass.fromJson(productsInfo[i]);
          }
        }
        loading.value = false;

// Call this function where you need
        await updateLocaleAndShowDialog();

        return success;
      }
    } catch (e) {
// Call this function where you need
      await updateLocaleAndShowDialog();

      // errorOccurred.value = true;
      loading.value = false;
      load.value = false;
    }
    loading.value = false;
    load.value = false;
    // if( globalController.pendingDeepLink.value !=null){
    //   _handle(globalController.pendingDeepLink.value!);
    // }
    return success;
  }

  Future<void> updateLocaleAndShowDialog() async {
    // String? locale = (prefs?.getString("locale") != null && prefs?.getString("locale") != "")
    //     ? prefs?.getString("locale")!
    //     : "en";
    //
    // Get.updateLocale(Locale(locale??'en')); // ✅ Update Locale
    //
    // // ✅ Wait for the translation update to apply before showing the dialog
    // await Future.delayed(const Duration(milliseconds: 2000));

    // ✅ Open the dialog AFTER ensuring translations are updated
    if (prefs?.getString('terms_accepted') != 'true') {
      _showTermsDialog();
    }
  }

  void _showTermsDialog() {
    AwesomeDialog(
      width: Get.width < 1000 ? 350 : 600,
      context: Get.context!,
      dismissOnBackKeyPress: true,
      dismissOnTouchOutside: false,
      dialogType: DialogType.info,
      body: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight:
              Get.height * 0.7, // Increased max height to prevent cut-off
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          'Warning'.tr,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      TermsWidget()
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: MainColor,
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      prefs?.setString('terms_accepted', 'true');
                      Get.back();
                    },
                    child: Text('Accept'.tr,
                        style: const TextStyle(color: Colors.white)),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: MainColor,
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      exit(0);
                    },
                    child: Text(
                      'Decline'.tr,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    ).show();
// ✅ Call `.show()` after the dialog setup
  }

  Future<bool> getProductSections() async {
    bool success = false;
    page++;
    loadingMore.value = true;
    // globalController.loadMoreSections(true);
    // await Future.delayed(const Duration(milliseconds: 50)).then((value) {
    //   ScrollListenerHOME.animateTo(
    //     ScrollListenerHOME.position.maxScrollExtent,
    //     duration: Duration(milliseconds: 300),
    //     curve: Curves.easeInOut,
    //   );
    // });

    try {
      api.getData({
        'token': prefs!.getString("token") ?? "",
        'store_id': prefs!.getString("id") ?? "",
        'page': page,
      }, "stores/get-products-sections").then((response) {
        if (response.isNotEmpty) {
          success = response["succeeded"];
          loadingMore.value = false;

          globalController.loadMoreSections(false, response: response);
        } else {
          page--;
          // globalController.loadMoreSections(false);
          loadingMore.value = false;
        }
      });
    } catch (e) {
      page--;
      // globalController.loadMoreSections(false);
      loadingMore.value = false;

      if (kDebugMode) {
        print(e);
      }
    }
    return success;
  }

  // Future<String> getCountryDialCode() async {
  //   // Get current location
  //   Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //
  //   // Get country code from location
  //   List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
  //   String? countryCode = placemarks[0].isoCountryCode;
  //
  //   // Get dial code for country
  //  // RegionInfo regionInfo = await PhoneNumberUtil.getRegionInfo(regionCode: countryCode);
  //  // String dialCode = regionInfo.dialCode;
  //
  //   return dialCode;
  // }

  Future<void> refreshFunctions() async {
    try {
      globalController.refreshHomeScreen(true);
      await GetHomeData();
      TabsController _controller = Get.find();
      _controller.unreadednotification();
      await seen2();
      globalController.refreshHomeScreen(false);
      FetchStores();
    } catch (ex) {
      // Handle the exception
      // print('An error occurred: $ex');
    }
  }

  Future<GoldPriceData> fetchGoldPrice() async {
    try {
      // Use the new sync-metals-prices endpoint
      Map<String, dynamic> response = await api.getData({
        'token': prefs!.getString("token") ?? "",
      }, "stores/sync-metals-prices");

      if (response.isNotEmpty && response["current"] != null) {
        final current = response["current"];
        final diff = response["diff"];
        
        if (current != null && diff != null) {
          double currentGoldPrice = 0.0;
          double currentSilverPrice = 0.0;
          double goldDiff = 0.0;
          double silverDiff = 0.0;

          // Parse gold price
          if (current['XAUUSD'] != null) {
            var xauValue = current['XAUUSD'];
            currentGoldPrice = xauValue is String 
                ? double.tryParse(xauValue) ?? 0.0 
                : (xauValue as num).toDouble();
          }

          // Parse silver price
          if (current['XAGUSD'] != null) {
            var xagValue = current['XAGUSD'];
            currentSilverPrice = xagValue is String 
                ? double.tryParse(xagValue) ?? 0.0 
                : (xagValue as num).toDouble();
          }

          // Parse gold diff
          if (diff['XAUUSD'] != null) {
            var diffValue = diff['XAUUSD'];
            goldDiff = diffValue is String 
                ? double.tryParse(diffValue) ?? 0.0 
                : (diffValue as num).toDouble();
          }

          // Parse silver diff
          if (diff['XAGUSD'] != null) {
            var diffValue = diff['XAGUSD'];
            silverDiff = diffValue is String 
                ? double.tryParse(diffValue) ?? 0.0 
                : (diffValue as num).toDouble();
          }

          return GoldPriceData(
            price: currentGoldPrice,
            change: goldDiff,
            silverPrice: currentSilverPrice,
            silverChange: silverDiff,
          );
        }
      }
      
      // Fallback to old endpoint if new one fails
      final fallbackResponse = await http.get(
        Uri.parse('http://zahabna.com/priceData/prices.json')
      );
      
      if (fallbackResponse.statusCode == 200) {
        final data = json.decode(fallbackResponse.body);
        if (data != null) {
          double currentPrice = 0.0;
          double currentSilverPrice = 0.0;

          if (data['XAUUSD'] != null) {
            var xauValue = data['XAUUSD'];
            currentPrice = xauValue is String 
                ? double.tryParse(xauValue) ?? 0.0 
                : (xauValue as num).toDouble();
          }
          if (data['XAGUSD'] != null) {
            var xagValue = data['XAGUSD'];
            currentSilverPrice = xagValue is String 
                ? double.tryParse(xagValue) ?? 0.0 
                : (xagValue as num).toDouble();
          }

          double change = 0.0;
          if (lastGoldPrice != null) {
            change = currentPrice - lastGoldPrice!;
          }
          lastGoldPrice = currentPrice;

          double silverChange = 0.0;
          if (lastSilverPrice != null) {
            silverChange = currentSilverPrice - lastSilverPrice!;
          }
          lastSilverPrice = currentSilverPrice;

          return GoldPriceData(
            price: currentPrice,
            change: change,
            silverPrice: currentSilverPrice,
            silverChange: silverChange,
          );
        }
      }
      
      return GoldPriceData(
        price: 0.0, 
        change: 0.0, 
        silverPrice: 0.0, 
        silverChange: 0.0
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching gold price: $e');
      }
      return GoldPriceData(
        price: 0.0, 
        change: 0.0, 
        silverPrice: 0.0, 
        silverChange: 0.0
      );
    }
  }
}
