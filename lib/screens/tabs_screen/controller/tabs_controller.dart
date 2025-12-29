import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bottom_navbar_with_indicator/bottom_navbar_with_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:iq_mall/screens/ProductDetails_screen/ProductDetails_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../cores/assets.dart';
import '../../../main.dart';
import '../../../models/CurrencyEx.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/ShColors.dart';
import '../../Home_screen_fragment/Home_screen_fragment.dart';
import '../../Home_screen_fragment/controller/Home_screen_fragment_controller.dart';
import '../../ProductDetails_screen/controller/ProductDetails_screen_controller.dart';
import '../../Stores_screen/Stores_screen.dart';
import '../../Stores_screen/controller/Stores_screen_controller.dart';
import '../../Stores_screen/widgets/item_widget.dart';
import '../../Wishlist_screen/controller/Wishlist_controller.dart';
import '../../Wishlist_screen/wish_list_screen.dart';
import '../../categories_screen/categories_screen.dart';
import '../binding/tabs_binding.dart';

String uuidForCartList = "";
var arabicFont;

class TabsController extends GetxController {
  RxInt currentIndex = 0.obs;
  RxInt countHomeClicks = 0.obs;
  RxInt countMyLearningClicks = 0.obs;
  RxInt countAllGradesClicks = 0.obs;
  int connectionRetryCount = 0;
  int maxRetryAttempts = 5;
  late PageController pageController;
  RxBool colorful = true.obs;
  RxBool hasStore = false.obs;

  // Trigger for UI rebuilds
  RxInt rebuildTrigger = 0.obs;

  final iconList = <IconData>[
    Icons.brightness_5,
    Icons.brightness_4,
    Icons.brightness_6,
    Icons.brightness_7,
  ];

  late RxList<Map<String, Object?>>? downloadListFinal = <Map<String, Object?>>[].obs;
  RxList<Widget> pages = <Widget>[].obs;
  RxBool load = false.obs;
  String? version = '';
  bool balanceloading = true;
  int drawercount = 10;
  var subscription;
  List cartInfo = [];
  Locale? initialLocale;

  void onButtonPressed(int index) {
    currentIndex.value = index;
  }

  /// Check if user has store access
  bool get hasStoreAccess =>
      globalController.stores.isNotEmpty && prefs?.getString('logged_in') == 'true';

  /// Get the bottom bar items based on current state
  List<CustomBottomBarItems> getBottomBarItems() {
    final items = <CustomBottomBarItems>[
      CustomBottomBarItems(
        label: 'Home'.tr,
        icon: Icons.home_outlined,
        isAssetsImage: false,
      ),
      CustomBottomBarItems(
        label: 'Categories'.tr,
        icon: Icons.category_outlined,
        isAssetsImage: false,
      ),
    ];

    // Add "Add Item" only if user has store access
    if (hasStoreAccess) {
      items.add(CustomBottomBarItems(
        label: 'Add Item'.tr,
        icon: Icons.add_circle_outlined,
        isAssetsImage: false,
      ));
    }

    items.addAll([
      CustomBottomBarItems(
        label: 'Favorites'.tr,
        icon: Icons.favorite_border,
        isAssetsImage: false,
      ),
      CustomBottomBarItems(
        label: 'Stores'.tr,
        icon: Icons.store_outlined,
        isAssetsImage: false,
      ),
    ]);

    return items;
  }

  /// Get pages list based on current state
  List<Widget> getPages() {
    if (hasStoreAccess) {
      return [
        Home_screen_fragmentscreen(),
        CategoriesScreen(),
        AddNewItemScreen(),
        Wishlistscreen(),
        Storesscreen(),
      ];
    } else {
      return [
        Home_screen_fragmentscreen(),
        CategoriesScreen(),
        Wishlistscreen(),
        Storesscreen(),
      ];
    }
  }

  /// Rebuilds the pages and bottom bar items
  /// Called after store deletion or any store-related changes
  void rebuildPages() {
    debugPrint('TabsController: rebuildPages called');
    debugPrint('TabsController: hasStoreAccess = $hasStoreAccess');
    debugPrint('TabsController: stores count = ${globalController.stores.length}');

    // Update pages
    pages.value = getPages();
    pages.refresh();

    // Reset to home if current index is invalid
    if (currentIndex.value >= pages.length) {
      currentIndex.value = 0;
    }

    // Trigger UI rebuild
    rebuildTrigger.value++;

    update();
    refresh();
  }

  loadArabicFont() async {
    arabicFont = await rootBundle.load("assets/fonts/NotoSansArabic-Regular.ttf");
  }

  checkDeepLink() async {
    final prefs = await SharedPreferences.getInstance();
    final link = prefs.getString("pending_deep_link");

    if (link != null) {
      prefs.remove("pending_deep_link");

      Uri uri = Uri.parse(link);
      final productId = uri.pathSegments.last;

      Future.delayed(const Duration(milliseconds: 500), () {
        Get.lazyPut(() => ProductDetails_screenController(), tag: "$productId");
        prefs.remove("pending_deep_link");
        Get.toNamed(
          AppRoutes.Productdetails_screen,
          arguments: {
            'product': null,
            'fromCart': false,
            'productSlug': productId,
            'from_banner': true,
            'tag': "${UniqueKey()}$productId",
          },
          parameters: {'tag': "$productId"},
        );
      });
    }
  }

  @override
  void onInit() async {
    uuidForCartList = uuid.v4().toString();

    // Fetch stores and rebuild when done
    FetchStores().then((value) {
      rebuildPages();
    });

    initialLocale = await getInitialLocale();

    if (!Get.isRegistered<StoreController>(tag: "main")) {
      Get.put(StoreController(), tag: "main");
    }

    // Initial pages setup
    pages.value = getPages();

    super.onInit();
  }

  getsettings() async {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      version = packageInfo.version;
    });
  }

  InitStateFucntion() {
    currentIndex.value = mainCurrentIndex.value;
    mainCurrentIndex.value = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LoadingDrawer.value = false;
    });
    try {
      changeColorsAndDisplay(
        prefs!.getString('button_color').toString(),
        prefs!.getString('main_color').toString(),
        prefs!.getString('discount_price_color').toString(),
      );
      load.value = true;
    } catch (e) {
      print(e);
      load.value = true;
    }

    getsettings();

    if (prefs?.getString('currency').toString() == 'null') {
      prefs?.setString('currency', 'Lebanese Lira');
      prefs?.setString('idselected', country_currency_id!);
      idselected = int.parse(prefs?.getString('idselected') ?? "");
      prefs?.setString('sign', sign.value.toString());
      for (int i = 0; i < currencyExlist.length; i++) {
        if (currencyExlist[i].from_currency == country_currency_id &&
            currencyExlist[i].to_currency == idselected.toString()) {
          prefs?.setString('currency_rate', currencyExlist[i].Rate);
        }
      }
    } else {
      idselected = int.parse(prefs?.getString('idselected') ?? "");
      prefs?.setString('sign', sign.value.toString());
      Future.delayed(Duration.zero, () {});
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      unreadednotification();
      LoadingDrawer.value = false;
    });

    Future.delayed(Duration.zero, () async {
      drawerSize.value = Get.size.height - 200;
    });
  }

  unreadednotification() async {
    try {
      var url = "${con!}notification/get-count";
      final http.Response response = await http.post(
        Uri.parse(url),
        body: {'user_id': prefs?.getString('user_id')},
      );
      var count = json.decode(response.body) as List;
      globalController.refreshUnreadNotification(int.parse(count[0]['unreaded']));
    } catch (ex) {}
  }

  OnBottomNavTapPress(index) {
    if (currentIndex.value != index) {
      currentIndex.value = index;
    } else {
      if (currentIndex.value == 2) {
        WishlistController controller = Get.find();
        Gototop(controller.ScrollListenerFAVORITE.value);
      } else if (currentIndex.value == 0) {
        Home_screen_fragmentController controller = Get.find();
        Gototop(controller.ScrollListenerHOME);
      } else if (currentIndex.value == 1) {
        WishlistController controller = Get.find();
        Gototop(controller.ScrollListenerFAVORITE.value);
      } else if (currentIndex.value == 3) {
        // MyStoreController _controller = Get.find();
        // Gototop(_controller.ScrollListenerCART);
      }
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void onReady() async {
    InitStateFucntion();
    LoadingDrawer.value = false;

    globalController.updateCurrentRout(Get.currentRoute);

    super.onReady();
    if (Platform.isAndroid) {
      checkDeepLink();
    }
  }

  Gototop(ScrollController s) {
    try {
      if (s.hasClients) {
        s.animateTo(
          s.position.minScrollExtent,
          duration: const Duration(milliseconds: 750),
          curve: Curves.fastLinearToSlowEaseIn,
        );
      }
    } catch (ex) {}
  }

  Widget get currentPage => pages[currentIndex.value];

  Future<int> changePageInRoot(int _index) async {
    int index = _index;
    currentIndex.value = _index;
    return index;
  }

  void changePageOutRoot(int _index) {
    currentIndex.value = _index;
    Get.offNamedUntil("/tab", (Route route) {
      if (route.settings.name == "/tab") {
        return true;
      }
      return false;
    }, arguments: _index);
  }

  void changePage(int _index) {
    TabsBinding().dependencies();

    if (Get.currentRoute == "/tab") {
      changePageInRoot(_index);
    } else {
      changePageOutRoot(_index);
    }
  }
}
