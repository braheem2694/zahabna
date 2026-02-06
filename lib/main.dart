import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iq_mall/screens/Home_screen_fragment/widgets/social_media_item.dart';
import 'package:iq_mall/screens/OrderSummaryScreen/widgets/PaymentMethodsWidets/PaymentMethodsWidget.dart';
import 'package:iq_mall/screens/ProductDetails_screen/ProductDetails_screen.dart';
import 'package:iq_mall/screens/ProductDetails_screen/controller/ProductDetails_screen_controller.dart';
import 'package:iq_mall/screens/Stores_screen/controller/Stores_screen_controller.dart';
import 'package:iq_mall/screens/tabs_screen/binding/tabs_binding.dart';
import 'package:iq_mall/widgets/CommonWidget.dart';
import 'package:iq_mall/widgets/applink.dart';
import 'package:iq_mall/widgets/custom_image_view.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/models/HomeData.dart';
import 'package:iq_mall/routes/app_routes.dart';
import 'package:iq_mall/screens/Cart_List_screen/controller/Cart_List_controller.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/utils/ShConstant.dart';
import 'package:iq_mall/utils/ShImages.dart';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'API.dart';
import 'cores/app_localization.dart';
import 'getxController.dart';
import 'initialBinding.dart';
import 'models/Stores.dart';
import 'models/firebase.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'services/background_upload_service.dart';
import 'firebase_options.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

GlobalController globalController = Get.put(GlobalController());
RxString sign = '\$'.obs;
RxDouble drawerSize = 200.0.obs;
RxDouble? balance = 0.0.obs;
RxInt mainCurrentIndex = 0.obs;
API api = Get.put(API());
var idselected = 1;
newsLetter? news;
Counter notificationState = new Counter();
SharedPreferences? prefs;
String? deviceId;
int newCounter = 0;
RxBool LoadingDrawer = true.obs;
final List<Locale> supportedLocales = [const Locale("en", "US")];
AppLocalization appLocalization = AppLocalization();
String? country_currency_id = '1';
RxDouble? total = 0.0.obs;
RxInt index2 = 0.obs;
List addressesInfo = [];
List SingleproductInfo = [];
RxDouble? amount2 = 0.0.obs;
FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
FirebaseInitialize firebaseInitialize = new FirebaseInitialize();
RxBool loading = true.obs;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}

/// Initialize the [FlutterLocalNotificationsPlugin] package.
var subscription;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  prefs?.setString("is_main", "1");
  // 3️⃣ Debug: Ensure the app starts with the correct locale

  globalController.updateFullName();

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }

    // Register background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }

  // 1️⃣ Load translations before launching the app
  try {
    await api.getDataaa({'date': getTranslationPref() ?? "1970-01-01 00:00:00"},
        "master/get-translations", true).then((value) async {
      try {
        appLocalization = AppLocalization();
        await appLocalization.loadTranslations(value);
        Get.put(appLocalization); // ✅ Register in GetX
      } catch (e) {
        debugPrint("Error loading translations: $e");
      }
    });
  } catch (e) {
    debugPrint("Error fetching translations: $e");
  }

  // 2️⃣ Fetch the locale before running the app
  Locale initialLocale;
  try {
    initialLocale = await getInitialLocale();
    Get.updateLocale(initialLocale);
  } catch (e) {
    debugPrint("Error getting initial locale: $e");
    initialLocale = const Locale('en', 'US');
  }

  try {
    await initializeApp();
  } catch (e) {
    debugPrint("App initialization failed: $e");
  }

  runApp(MyApp(initialLocale: initialLocale));
}

Future<Locale> getInitialLocale() async {
  prefs = await SharedPreferences.getInstance();

  // Fetch the stored locale or use the system locale
  String? storedLocale = prefs?.getString("locale");

  if (storedLocale != null && storedLocale.isNotEmpty) {
    return Locale(storedLocale);
  } else {
    Locale deviceLocale = Get.deviceLocale ?? const Locale('EN');
    await prefs?.setString("locale", deviceLocale.languageCode);
    return deviceLocale;
  }
}

ChangeStroredStore(store, newsLetterChoosen, String fromKey) async {
  try {
    prefs!.setString('id', store.id);
    if (newsLetterChoosen != null) {
      List<newsLetter> newsLetters = List<newsLetter>.from(
          newsLetterChoosen.map((x) => newsLetter.fromJson(x)));

      // news = newsLetters.firstWhere(
      //   (n) => n.r_store_id.toString() == prefs!.getString('id'),
      // );
    }
    prefs!.setString('show_add_to_cart', store.show_add_to_cart.toString());
    prefs!.setString('store_name', store.store_name);
    prefs!.setString('delivery_cost', store.delivery_amount);
    prefs!.setString('store_type', store.store_type);
    prefs!.setString('phone_number', store.phone_number);
    prefs!.setString('whatsapp_number', store.whatsapp_number);
    prefs!.setString('email', store.email);
    prefs!.setString('address', store.address);
    prefs!.setString('slug', store.slug);
    prefs!.setString('description', store.description);
    prefs!.setString('longitude', store.longitude);
    prefs!.setString('latitude', store.latitude);
    prefs!.setString('main_image', store.main_image);
    prefs!.setString('country_name', store.country_name);
    prefs!.setString('button_background_color', store.button_background_color);
    prefs!.setString('button_color', store.button_color);
    prefs!.setString('price_color', store.price_color);
    prefs!.setString('discount_price_color', store.dicount_price_color);
    prefs!.setString('grid_type', store.grid_type);
    prefs!.setString('main_color', store.main_color);
    prefs!.setString('icon_color', store.icon_color);
    prefs!.setString('slider_type', store.slider_type);
    prefs!.setString('setting_image', store.setting_image);
    prefs!.setString('privacy_policy', store.privacy_policy);
    prefs!.setString('terms_conditions', store.terms_conditions);
    // globalController.updateStoreImage(fromKey);
    changeColorsAndDisplay(
        store.button_color, store.main_color, store.dicount_price_color);
  } on Exception catch (_) {}
}

Future<bool> CheckAutoLogin() async {
  bool success = false;

  Map<String, dynamic> response = await api.getData({
    'token': prefs?.getString("token") ?? "",
  }, "users/auto-login");

  if (response.isNotEmpty) {
    success = response["succeeded"];
    loading.value = false;
  }
  if (success) {
  } else {}
  return success;
}

Future<bool> FetchStores() async {
  bool success = false;

  Map<String, dynamic> response = await api.getData({
    'token': prefs!.getString("token") ?? "",
  }, "stores/get-stores");

  try {
    if (response.isNotEmpty) {
      success = response["succeeded"] ?? false;
      if (success) {
        List? StoresInfo = response["stores"];
        if (StoresInfo == null || StoresInfo.isEmpty) {
          debugPrint("No stores found in response");
          loading.value = false;
          return false;
        }

        prefs!.setString('stp_key', response["stp_key"].toString());

        prefs!.setBool('multi_store', true);
        branches_countries = response["branches_countries"] ?? [];

        if (response['section'] != null &&
            (response['section'] as List).isNotEmpty) {
          prefs!.setString('Stores_page_background',
              response['section'][0]['main_image'] ?? "");
          prefs!.setString('welcome_text',
              response['section'][0]['welcome_text'].toString());
          prefs!.setString(
              'brief_text', response['section'][0]['brief_text'].toString());
          prefs!.setString(
              'gif_image', response['section'][0]['gif_image'].toString());
        }

        payment_methods = response["payment_types"] ?? [];
        GiftCards_payment_methods = response["gift_cards_payment_types"] ?? [];
        storeList.clear();

        for (int i = 0; i < StoresInfo.length; i++) {
          StoreClass.fromJson(StoresInfo[i]);
        }

        if (storeList.isNotEmpty) {
          try {
            var currentStore = storeList.firstWhere(
              (element) => element.id == globalController.currentStoreId,
              orElse: () => storeList[0],
            );
            prefs!.setString('main_image', currentStore.main_image ?? '');
          } catch (e) {
            debugPrint("Error setting main_image: $e");
          }
        }

        globalController.updateStoreImage("fetchstoresmainfirst");

        if (response["company_settings"] != null &&
            (response["company_settings"] as List).isNotEmpty) {
          globalController.companySettings.value = CompanySettings.fromJson(
            (response["company_settings"] as List<dynamic>).first
                as Map<String, dynamic>,
          );
        }

        globalController.stores.clear();
        globalController.stores.addAll(storeList.where((element) =>
            element.ownerId == int.parse(prefs!.getString("user_id") ?? '0')));

        prefs!.setBool('multi_store', true);
        prefs!.setString('cart_btn', response['cart_btn'].toString());
        prefs!.setString('has_gift_card', response['has_gift_card'].toString());
        prefs!.setString('has_shipping', response['has_shipping'].toString());
        prefs!.setString('express_delivery_img',
            response['express_delivery_img'].toString());

        if (storeList.isNotEmpty) {
          ChangeStroredStore(
              storeList[0], response["newsLetters"], "fetchstoresmain");
        }
        loading.value = false;
        try {
          globalController.stores.firstWhere(
            (element) => element.ownerId.toString() == prefs?.getString("id"),
          );
        } catch (_) {
          // No matching store found, ignore
        }
      }
    } else {}
  } catch (e) {
    print(e);
  }

  return success;
}

Future<bool> initializeApp() async {
  try {
    // Initialize background upload service (lives for app lifetime)
    await BackgroundUploadService.init();

    // Perform necessary initializations here (e.g., API calls, reading SharedPreferences, etc.)
    await Future.wait([
      CheckAutoLogin(),
      FetchStores(),

      firebaseInitialize.initializeFirebase(),

      initPackageInfo(),
      // Add other initializations here
    ]);

    // Indicate that the initialization is complete
    return true;
  } catch (e) {
    debugPrint('Initialization failed: $e');
    return false;
  }
}

final GlobalKey<SideMenuState> sideMenuKey = GlobalKey<SideMenuState>();

Widget buildMenu(context) {
  String? version = '';

  PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
    version = packageInfo.version;
  });
  return Obx(() => !LoadingDrawer.value
      ? Container(
          color: Colors.white10,
          key: UniqueKey(),
          height: MediaQuery.of(context).size.height -
              (AppBar().preferredSize.height),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: getPadding(left: 24.0, right: 10.0),
                    child: Row(
                      children: <Widget>[
                        CustomImageView(
                            image: prefs!.getString('Profile_image'),
                            imagePath: AssetPaths.placeholder,
                            height: getSize(60),
                            width: getSize(60),
                            notOpen: false,
                            onTap: () {
                              if (prefs!.getString('logged_in') == 'true') {
                                state?.closeSideMenu();

                                Get.toNamed(AppRoutes.AccountsScreen);
                              }
                            },
                            fit: BoxFit.cover,
                            radius: BorderRadius.circular(getSize(20))),

                        Padding(
                          padding: getPadding(left: 8.0),
                          child: Column(
                            children: [
                              Obx(() {
                                return Text(
                                  globalController.fullName.value,
                                  style: TextStyle(fontSize: getFontSize(15)),
                                );
                              }),
                              // if (prefs != null && prefs!.getString('logged_in') == 'true' && prefs!.getString('has_gift_card') == '1') ...[
                              //   Obx(
                              //     () => Text(
                              //       '${'Balance: '.tr}${balance!.value} \$',
                              //       style: TextStyle(color: MainColor, fontSize: getFontSize(15), fontWeight: FontWeight.w400),
                              //     ),
                              //   ),
                              // ],
                            ],
                          ),
                        ),

                        // Check for logged_in
                      ],
                    ),
                  ),

                  prefs?.getString('logged_in') == 'true'
                      ? getDrawerItem(AssetPaths.account_image, 'Account'.tr,
                          callback: () {
                          state?.closeSideMenu();
                          Get.toNamed(AppRoutes.AccountsScreen)
                              ?.then((value) => {});
                        })
                      : const SizedBox(),
                  globalController.stores.isNotEmpty &&
                          prefs?.getString('logged_in') == 'true'
                      ? getDrawerItem(AssetPaths.stores, 'My Store'.tr,
                          callback: () {
                          state?.closeSideMenu();
                          globalController
                              .updateStoreRoute(AppRoutes.soreDetails);

                          // StoreController _controller = Get.find();
                          // _controller.selectedCity.value = null;
                          // _controller.selectedCityId.value = null;
                          // _controller.fetchStores(false, true);

                          Get.toNamed(AppRoutes.Stores,
                              arguments: {"tag": "side_menu"})?.then((value) {
                            globalController
                                .updateStoreRoute(AppRoutes.tabsRoute);
                          });
                        })
                      : const SizedBox(),
                  getDrawerItem(AssetPaths.terms, 'Terms and Conditions'.tr,
                      callback: () {
                    state?.closeSideMenu();
                    Get.toNamed(AppRoutes
                        .TermsAndConditionsScreen); // This should match the name in GetPage
                  }),

                  // getDrawerItem(AssetPaths.terms, 'Store Request'.tr, callback: () {
                  //   state?.closeSideMenu();
                  //   Get.toNamed(AppRoutes.storeRequest);
                  // }),

                  prefs?.getString('logged_in') == 'true'
                      ? getDrawerItem(AssetPaths.addStore, 'Store Request'.tr,
                          callback: () {
                          state?.closeSideMenu();
                          Get.toNamed(AppRoutes.storeRequests);
                        })
                      : const SizedBox(),
                  globalController.stores.isNotEmpty &&
                          prefs?.getString('logged_in') == 'true'
                      ? getDrawerItem(AssetPaths.transaction, 'Transactions'.tr,
                          callback: () {
                          state?.closeSideMenu();
                          Get.toNamed(AppRoutes.transactionsScreen, arguments: {
                            'isStoreRequest': false,
                          });
                          Get.toNamed(AppRoutes.transactionsScreen);
                        })
                      : const SizedBox(),

                  // prefs?.getString('logged_in') == 'true'
                  //     ? getDrawerItem(AssetPaths.notification_image, 'Notifications'.tr, callback: () {
                  //         state?.closeSideMenu();
                  //         Get.toNamed(AppRoutes.NotificationsScreen, arguments: false);
                  //       })
                  //     : const SizedBox(),
                  // prefs?.getString('logged_in') == 'true' && prefs!.getString('has_gift_card') == '1'
                  //     ? getDrawerItem(AssetPaths.wallet, 'Gift Cards'.tr, callback: () {
                  //         state?.closeSideMenu();
                  //         Get.toNamed(AppRoutes.wallet);
                  //       })
                  //     : const SizedBox(),
                  getDrawerItem(AssetPaths.contactus_image, 'Contact us'.tr,
                      callback: () {
                    state?.closeSideMenu();
                    Get.toNamed(
                      AppRoutes.ContactusScreen,
                    );
                  }),
                  getDrawerItem(AssetPaths.language, 'Languages'.tr,
                      callback: () {
                    state?.closeSideMenu();
                    Get.toNamed(AppRoutes.settings);
                  }),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Container(
                      color: Colors.white,
                      child: prefs?.getString('logged_in') != 'true'
                          ? getDrawerItem(AssetPaths.logout, "Login".tr,
                              callback: () {
                              state?.closeSideMenu();

                              Get.toNamed(AppRoutes.SignIn);
                            })
                          : getDrawerItem(AssetPaths.logout, "Logout".tr,
                              callback: () {
                              showLogoutAlert(context);
                            }),
                    ),
                  ),
                  SizedBox(),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: getPadding(bottom: getTopPadding() + 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SocialMediaScreen(
                        sideMenu: true,
                        padding: getPadding(left: 8, right: 8, top: 20),
                        isStore: false,
                      ),
                      Padding(
                        padding: getPadding(top: 8.0),
                        child: InkWell(
                          onTap: () async {
                            const String url = "https://brainkets.com";
                            final Uri uri = Uri.parse(url);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri,
                                  mode: LaunchMode.externalApplication);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: SvgPicture.asset(
                            AssetPaths.powered_v,
                          ),
                        ),
                      ),
                      Padding(
                        padding: getPadding(top: 8.0),
                        child: Text(
                            "Version ${globalController.appVersion.value}",
                            style: TextStyle(fontSize: getFontSize(12))),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      : SizedBox());
}

showLogoutAlert(context) {
  AlertDialog alert = AlertDialog(
    contentPadding: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    backgroundColor: Colors.white,
    content: Container(
      padding: getPadding(all: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Adjust the height to fit content
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Directionality(
            textDirection: prefs?.getString("locale") == "en"
                ? TextDirection.ltr
                : TextDirection.rtl,
            child: Text(
              'Alert'.tr,
              style: TextStyle(
                color: ColorConstant.logoSecondColor,
                fontSize: getFontSize(20),
              ),
            ),
          ),
          Directionality(
            textDirection: prefs?.getString("locale") != "ar"
                ? TextDirection.ltr
                : TextDirection.rtl,
            child: Text(
              "Are you sure you want to log out?".tr,
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: ColorConstant.black900,
                fontSize: getFontSize(16),
              ),
            ),
          ),
        ],
      ),
    ),
    actions: [
      GestureDetector(
        onTap: () {
          state?.closeSideMenu();
          prefs?.setString('logged_in', 'false');
          prefs!.remove("first_name");
          prefs!.remove("last_name");
          prefs!.remove("user_name");
          prefs!.remove("country_code");
          prefs!.remove("user_id");
          prefs!.remove("user_role");
          prefs!.remove("phone_number");
          prefs!.remove("login_method");
          prefs!.remove("token");
          prefs!.remove("Profile_image");
          globalController.resetUserData();
          firebaseMessaging.deleteToken();
          prefs?.setString('seen', 'true');
          favoritelist?.clear();
          cartlist?.clear();
          Get.offAllNamed(AppRoutes.SignIn);
        },
        behavior: HitTestBehavior.translucent,
        child: Padding(
          padding: getPadding(left: 8, top: 5, right: 8, bottom: 5),
          child: Container(
            width: 100,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorConstant.logoSecondColor,
            ),
            alignment: Alignment.center,
            child: Text(
              "Yes".tr,
              style: TextStyle(
                  fontSize: getFontSize(16), color: ColorConstant.whiteA700),
            ),
          ),
        ),
      ),
      GestureDetector(
        onTap: () {
          Get.back();
        },
        behavior: HitTestBehavior.translucent,
        child: Padding(
          padding: getPadding(left: 8, top: 5, right: 8, bottom: 5),
          child: Container(
            width: 100,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorConstant.whiteA700,
              border:
                  Border.all(color: ColorConstant.logoSecondColor, width: 1),
            ),
            alignment: Alignment.center,
            child: Text(
              "No".tr,
              style: TextStyle(
                  fontSize: getFontSize(16),
                  color: ColorConstant.logoSecondColor),
            ),
          ),
        ),
      )
    ],
    actionsAlignment: MainAxisAlignment.spaceAround,
  );

  showDialog(
    context: Get.context!,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Widget getDrawerItem(String? icon, String? name, {VoidCallback? callback}) {
  return Padding(
    padding: getPadding(top: 12.0),
    child: InkWell(
      onTap: () {
        callback!();
      },
      child: Container(
        color: sh_white,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Row(
          children: <Widget>[
            icon != null
                ? SVG(icon, 27, 27, Button_color)
                : Container(width: 20),
            const SizedBox(width: 20),
            Expanded(
              child: text(
                name,
                textColor: sh_textColorPrimary,
                fontSize: textSizeSMedium,
                fontFamily: 'Poppins',
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Future<void> initPackageInfo() async {
  final info = await PackageInfo.fromPlatform();
  globalController.appVersion.value = info.version;
}

class SideMenuObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);

    // Check if the SideMenu is open, and if yes, close it.
    if (sideMenuKey.currentState?.isOpened ?? false) {
      state?.closeSideMenu();
    }
  }
}

class MyApp extends StatefulWidget {
  final Locale initialLocale;

  const MyApp({Key? key, required this.initialLocale}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Clear to avoid loops
      TabsBinding().dependencies();
      await DeepLinkService().init();
      try {
        final link = prefs?.getString("pending_deep_link");
        print(link);
        if (link != null) {
          prefs?.remove("pending_deep_link");
          Restart.restartApp();
          return;
        }
      } catch (e) {
        print("link is $e");
      }
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      scrollBehavior: const MaterialScrollBehavior(),

      theme: ThemeData(
        primarySwatch: Colors.grey,
        scaffoldBackgroundColor: sh_light_grey,
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        }),
      ),
      navigatorObservers: [SideMenuObserver()],
      getPages: AppRoutes.routes,
      initialRoute: AppRoutes.tabsRoute,
      debugShowCheckedModeBanner: false,
      // ✅ Ensure translations are set
      translations: appLocalization,

      // ✅ Set the locale before the UI loads
      locale: widget.initialLocale,

      // ✅ Fallback to English if the locale is missing
      fallbackLocale: const Locale('EN'),

      supportedLocales: const [Locale('en', 'US')],
      unknownRoute: GetPage(
        name: AppRoutes.Productdetails_screen,
        page: () => ProductDetails_screen(),
        binding: BindingsBuilder(() async {
          prefs = await SharedPreferences.getInstance();
          String? tag =
              prefs?.getString("tag") ?? Get.parameters['tag'] ?? 'default';
          if (!Get.isRegistered<ProductDetails_screenController>(tag: tag)) {
            Get.lazyPut(() => ProductDetails_screenController(), tag: tag);
          }
        }),
      ),
      onUnknownRoute: (settings) {
        // 🔄 Restart app
        Restart.restartApp();
        return null;
      },

      initialBinding: InitialBindings(),
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 200),
      builder: (context, child) {
        print("GetX Available Translations: ${Get.translations}");

        if (child == null) return const SizedBox.shrink();

        return Directionality(
          textDirection: TextDirection.ltr,
          child: Stack(
            children: [
              GestureDetector(
                onTap: () {
                  if (sideMenuKey.currentState?.isOpened ?? false) {
                    state?.closeSideMenu();
                  }
                },
                child: Container(color: Colors.transparent),
              ),
              Builder(
                builder: (context) => SideMenu(
                  background: Colors.white,
                  closeIcon: Icon(
                    Icons.close,
                    color: MainColor,
                  ),
                  onChange: (isOpened) {
                    globalController.updateSideMenuStatus(isOpened);
                  },
                  key: sideMenuKey,
                  menu: buildMenu(context),
                  type: SideMenuType.slide,
                  maxMenuWidth: getHorizontalSize(230.0),
                  child: child,
                ),
              ),
            ],
          ),
        );
      },
    );

    // return
    // MaterialApp(
    //   scrollBehavior: const MaterialScrollBehavior(),
    //   theme: ThemeData(
    //     primarySwatch: Colors.grey,
    //     scaffoldBackgroundColor: sh_light_grey,
    //     pageTransitionsTheme: const PageTransitionsTheme(builders: {
    //       TargetPlatform.android: CupertinoPageTransitionsBuilder(),
    //       TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    //     }),
    //   ),
    //   debugShowCheckedModeBanner: false,
    //   locale: widget.initialLocale,
    //   home: TabsPage(),
    //   supportedLocales: const [Locale('en', 'US')],
    //   // builder: (context, child) {
    //   //   if (child == null) return const SizedBox.shrink();
    //   //
    //   //   return Directionality(
    //   //     textDirection: TextDirection.ltr,
    //   //     child: Stack(
    //   //       children: [
    //   //         GestureDetector(
    //   //           onTap: () {
    //   //             if (sideMenuKey.currentState?.isOpened ?? false) {
    //   //               state?.closeSideMenu();
    //   //             }
    //   //           },
    //   //           child: Container(color: Colors.transparent),
    //   //         ),
    //   //         Builder(
    //   //           builder: (context) => SideMenu(
    //   //             background: Colors.white,
    //   //             closeIcon: Icon(
    //   //               Icons.close,
    //   //               color: MainColor,
    //   //             ),
    //   //             onChange: (isOpened) {
    //   //               globalController.updateSideMenuStatus(isOpened);
    //   //             },
    //   //             key: sideMenuKey,
    //   //             menu: buildMenu(context),
    //   //             type: SideMenuType.slide,
    //   //             maxMenuWidth: getHorizontalSize(230.0),
    //   //             child: child,
    //   //           ),
    //   //         ),
    //   //       ],
    //   //     ),
    //   //   );
    //   // },
    //   // onGenerateRoute: (settings) => GetPageRoute(
    //   //   settings: settings,
    //   //   page: () => TabsPage(), // Or use a custom route logic here
    //   // ),
    //   navigatorObservers: [SideMenuObserver()],
    // );
  }
}

class Counter with ChangeNotifier, DiagnosticableTreeMixin {
  int _counter = prefs?.getInt('counter') ?? 0;
  String? _srtingprice = 'RAND';
  int _value = 0;

  int get counter => _counter;

  RxList<Product>? get cartliststate => cartlist;

  String? get sortingprice => _srtingprice;

  int get value => _value;

  double calculateTotal(double couponPercentage) {
    double totalAmount = 0.0;

    for (int i = 0; i < cartlist!.length; i++) {
      if (cartlist![i].price_after_discount == null ||
          cartlist![i].price_after_discount.toString() == 'null') {
        totalAmount += (double.parse(cartlist![i].product_price.toString()) *
            int.parse(cartlist![i].quantity!));
      } else {
        totalAmount +=
            (double.parse(cartlist![i].price_after_discount.toString()) *
                int.parse(cartlist![i].quantity!));
      }
    }

    double discount = totalAmount * (couponPercentage / 100.0);
    if (prefs != null) {
      String? deliveryCostString = prefs!.getString('delivery_cost');
      if (deliveryCostString != null) {
        totalAmount =
            ((totalAmount - discount) + double.parse(deliveryCostString));
      }
    }
    // globalController.updateCartPrice(totalAmount);

    return double.parse(totalAmount.toStringAsFixed(2));
  }

  incrementIndex(int index) {
    _value = index;
    notifyListeners();
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String? host, int port) => true;
  }
}

void computeAdditionalCostSum() {
  if (prefs!.getString('has_shipping') == '1' && cartlist != null) {
    Set<String> flatRateProductsProcessed =
        {}; // to track items with flat rate already added

    for (var product in cartlist!) {
      // If the product has free shipping
      if (product.free_shipping == 1) continue;

      // If the product has multi shipping
      if (product.multi_shipping != null && product.multi_shipping == 1) {
        int? quantity;
        try {
          quantity = int.parse(product.quantity!);
        } catch (e) {
          quantity =
              null; // or provide a default value if you want, e.g., quantity = 1;
        }

        globalController.updateAdditionalPrice(globalController.sum.value +
            (product.shipping_cost ?? 0.0) * (quantity ?? 1));
      }

      // If the product has a flat rate and has not been processed yet
      else if (product.flat_rate == 1 &&
          !flatRateProductsProcessed.contains(product.product_id)) {
        globalController.updateAdditionalPrice(
            globalController.sum.value + (product.shipping_cost ?? 0.0));

        flatRateProductsProcessed.add(
            product.product_id.toString()); // mark the product as processed
      }
    }
  }
}

void calculateTotalWithoutDelivery() {
  // Initialize total to 0
  RxDouble totalAmounnt = RxDouble(0);

  for (int i = 0; i < cartlist!.length; i++) {
    if (cartlist![i].price_after_discount == null ||
        cartlist![i].price_after_discount.toString() == 'null') {
      totalAmounnt.value +=
          (double.parse(cartlist![i].product_price.toString()) *
              int.parse(cartlist![i].quantity!));
    } else {
      totalAmounnt.value +=
          (double.parse(cartlist![i].price_after_discount.toString()) *
              int.parse(cartlist![i].quantity.toString()));
    }
  }

  double discount = totalAmounnt * (0 / 100);

  if (prefs != null) {
    String? deliveryCostString = prefs!.getString('delivery_cost');
    if (deliveryCostString != null) {
      globalController.result.value = (totalAmounnt.value - discount);
    }
  }

  // Round to 2 decimal places
  double roundedResult = (double.parse(
              (globalController.result.value + 0.004).toStringAsFixed(3)) *
          100 /
          100)
      .toDouble();

  totalAmounnt.value = double.parse(roundedResult.toStringAsFixed(2));
  total!.value = totalAmounnt.value;

  globalController.updateCartPrice(total!.value);
}
