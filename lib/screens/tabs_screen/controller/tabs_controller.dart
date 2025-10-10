import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:app_links/app_links.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:iq_mall/screens/ProductDetails_screen/ProductDetails_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../cores/assets.dart';
import '../../../cores/math_utils.dart';
import '../../../main.dart';
import '../../../models/CurrencyEx.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/ShColors.dart';
import '../../../widgets/applink.dart';
import '../../Cart_List_screen/Cart_List_screen.dart';
import '../../Cart_List_screen/controller/Cart_List_controller.dart';
import '../../HomeScreenPage/ShHomeScreen.dart';
import '../../Home_screen_fragment/Home_screen_fragment.dart';
import '../../Home_screen_fragment/controller/Home_screen_fragment_controller.dart';
import '../../ProductDetails_screen/controller/ProductDetails_screen_controller.dart';
import '../../Stores_screen/Stores_screen.dart';
import '../../Stores_screen/controller/Stores_screen_controller.dart';
import '../../Stores_screen/controller/my_store_controller.dart';
import '../../Stores_screen/widgets/item_widget.dart';
import '../../Wishlist_screen/controller/Wishlist_controller.dart';
import '../../Wishlist_screen/wish_list_screen.dart';
import '../../categories_screen/categories_screen.dart';
import '../binding/tabs_binding.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

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

  void onButtonPressed(int index) {
    currentIndex.value = index;
  }

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

  // late final PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  loadArabicFont() async {
    arabicFont = await rootBundle.load("assets/fonts/NotoSansArabic-Regular.ttf");
  }

  checkDeepLink() async {
    final prefs = await SharedPreferences.getInstance();
    final link = prefs.getString("pending_deep_link");

    if (link != null) {
      prefs.remove("pending_deep_link"); // Clear to avoid loops

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
    FetchStores().then((value) {
      // globalController.refreshFunctions();
    });
    initialLocale = await getInitialLocale();

    if (!Get.isRegistered<StoreController>(tag: "main")) {
      Get.put(StoreController(), tag: "main"); // Ensure the main tab screen controller exists
    }

    if (globalController.stores.isNotEmpty && prefs?.getString('logged_in') == 'true') {
      pages.value = [
        Home_screen_fragmentscreen(),
        CategoriesScreen(),
        AddNewItemScreen(),
        Wishlistscreen(),
        Storesscreen(), // This uses tag "main"
      ];
    } else {
      pages.value = [
        Home_screen_fragmentscreen(),
        CategoriesScreen(),
        Wishlistscreen(),
        Storesscreen(), // This uses tag "main"
      ];
    }

    super.onInit();
  }

  getsettings() async {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      version = packageInfo.version;
    });
  }

  void _handle(Uri uri) {
    final productId = uri.pathSegments.last;
    if (productId.isNotEmpty) {
      Future.delayed(Duration(seconds: 10)).then((value) {
        Get.offNamed(
          AppRoutes.Productdetails_screen,
          arguments: {
            'product': null,
            'fromCart': false,
            'productSlug': productId,
            'from_banner': true,
            'tag': "${UniqueKey()}$productId",
          },
          parameters: {'tag': productId},
        );
      });
    }
  }

  InitStateFucntion() {
    currentIndex.value = mainCurrentIndex.value;
    mainCurrentIndex.value = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LoadingDrawer.value = false;
    });
    try {
      changeColorsAndDisplay(prefs!.getString('button_color').toString(), prefs!.getString('main_color').toString(), prefs!.getString('discount_price_color').toString());
      load.value = true;
    } catch (e) {
      print(e);
      load.value = true;
    }
    // Future.delayed(Duration.zero, () {
    //   Get.to(() => ShHomeScreen(), routeName: '/ShHomeScreen');
    // });
    getsettings();

    if (prefs?.getString('currency').toString() == 'null') {
      prefs?.setString('currency', 'Lebanese Lira');
      prefs?.setString('idselected', country_currency_id!);
      idselected = int.parse(prefs?.getString('idselected') ?? "");
      prefs?.setString('sign', sign.value.toString() ?? "");
      for (int i = 0; i < currencyExlist.length; i++) {
        if (currencyExlist[i].from_currency == country_currency_id && currencyExlist[i].to_currency == idselected.toString()) {
          prefs?.setString('currency_rate', currencyExlist[i].Rate);
        }
      }
    } else {
      idselected = int.parse(prefs?.getString('idselected') ?? "");
      prefs?.setString('sign', sign.value.toString() ?? "");
      Future.delayed(Duration.zero, () {});
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unreadednotification();
      LoadingDrawer.value = false;
    });
    Future.delayed(Duration.zero, () async {
      drawerSize.value = Get.size.height - 200;
      // globalController.selectedTab.value = 0;
    });
  }

  unreadednotification() async {
    try {
      var url = "${con!}notification/get-count";
      final http.Response response = await http.post(
        Uri.parse(url),
        body: {
          'user_id': prefs?.getString('user_id'),
        },
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
        WishlistController _controller = Get.find();
        Gototop(_controller.ScrollListenerFAVORITE.value);
      } else if (currentIndex.value == 0) {
        Home_screen_fragmentController _controller = Get.find();

        Gototop(_controller.ScrollListenerHOME);
      } else if (currentIndex.value == 1) {
        WishlistController _controller = Get.find();
        Gototop(_controller.ScrollListenerFAVORITE.value);
      } else if (currentIndex.value == 3) {
        // MyStoreController _controller = Get.find();
        //
        // Gototop(_controller.ScrollListenerCART);
      }
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  @override
  void onReady() async {
    InitStateFucntion();
    LoadingDrawer.value = false;

    // controller.locale = Locale(value);

    globalController.updateCurrentRout(Get.currentRoute);
    // if (prefs?.getString('terms_accepted') != 'true') {
    // _showTermsDialog(Get.context!);
    // }

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

  // void showRestartAppAlert(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text("Connection Error"),
  //         content: Text("Failed to establish a connection to the server."),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               exit(0); // Close the alert
  //               // You can add any additional actions here if needed
  //             },
  //             child: Text("OK"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Widget get currentPage => pages[currentIndex.value];

  /// change page in route

  Future<int> changePageInRoot(int _index) async {
    int index = _index;
    // isTab="tab";
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
