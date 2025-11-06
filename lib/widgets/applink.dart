import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iq_mall/cores/assets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../cores/deep_links.dart';
import '../routes/app_routes.dart';
import '../screens/ProductDetails_screen/controller/ProductDetails_screen_controller.dart';
import 'package:restart_app/restart_app.dart';

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();

  factory DeepLinkService() => _instance;

  final AppLinks _appLinks = AppLinks();

  DeepLinkService._internal();

  Future<void> init() async {
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        print("🌐 Cold start via deep link: $initialUri");
        extractID(initialUri);
      }

      _appLinks.uriLinkStream.listen((uri) {
        print("🔄 Deep link received while app running: $uri");
        extractID(uri);
      });
    } catch (e) {
      print("❌ Error handling deep link: $e");
    }
  }

  void _handleLink(Uri uri, {required bool fromColdStart}) async {
    final productId = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : null;

    if (productId != null && uri.host == '$con') {
      // Make sure app is ready
      if (fromColdStart) {
        // Wait until GetMaterialApp is initialized
        // WidgetsBinding.instance.addPostFrameCallback((_) {
        //   Future.delayed(Duration(milliseconds: 500), () {
        //     if (Get.key.currentContext != null) {
        //       Get.toNamed(
        //         AppRoutes.Productdetails_screen,
        //         arguments: {
        //           'product': null,
        //           'fromCart': false,
        //           'productSlug': productId,
        //           'from_banner': true,
        //           'tag': "$productId"
        //         },
        //         parameters: {'tag': "$productId"},
        //       );
        //     } else {
        //       print("⚠️ Get.key.currentContext is still null");
        //     }
        //   });
        // });
      } else {
        // App is running already
        Future.delayed(Duration(milliseconds: 500), () {
          Get.offNamed(
            AppRoutes.Productdetails_screen,
            arguments: {'product': null, 'fromCart': false, 'productSlug': productId, 'from_banner': true, 'tag': "$productId"},
            parameters: {'tag': "$productId"},
          );
        });
      }
    }
  }

  void extractID(Uri? uri) async {
    if (uri != null && uri.pathSegments.isNotEmpty && uri.host == 'cms.zahabna.com') {
      print("askfghbkasdbflhd${deepLinkId}");
      final productId = uri.pathSegments.last;

      final prefs = await SharedPreferences.getInstance();
      prefs.setString("tag", "$productId");
      if (prefs.getString("is_main") == "1") {
        prefs.setString("is_main", "0");
        await prefs.setString('pending_deep_link', productId.toString());
        Restart.restartApp();
      }
      deepLinkId = int.tryParse(productId);

      if (deepLinkId == null) return;

      try {
        if (Platform.isAndroid) {
          // 🔁 Attempt to put and navigate
          Get.put(ProductDetails_screenController(), tag: "$productId");
          Get.toNamed(
            AppRoutes.Productdetails_screen,
            arguments: {'product': null, 'fromCart': false, 'productSlug': productId, 'from_banner': true, 'tag': "$productId"},
            parameters: {'tag': "$productId"},
          );
        }
      } catch (e) {
        // 💾 Save the deep link
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('pending_deep_link', uri.toString());

        // 🔄 Restart app
        Restart.restartApp();
      }
    }
  }
}
