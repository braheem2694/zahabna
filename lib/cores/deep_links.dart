import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:uuid/uuid.dart';
import 'package:app_links/app_links.dart';

import '../routes/app_routes.dart';

String? propertyId;
int? deepLinkId;
late AppLinks _appLinks;
StreamSubscription<Uri>? _linkSubscription;

Future<void> initDeepLinks(StreamSubscription? deepLinkSubscription) async {
  _appLinks = AppLinks();

  // Handle links
  _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
    debugPrint('onAppLink: $uri');
    openAppLink(uri);
  });
}

void openAppLink(Uri uri) {
  if (uri.pathSegments.isNotEmpty && uri.host == 'samana.land') {
    propertyId = uri.path.split("/").last;
    final productId = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : null;

    Future.delayed(const Duration(milliseconds: 600)).then((value) {
      Uuid uuid = const Uuid();
      Get.toNamed(
        AppRoutes.Productdetails_screen,
        arguments: {
          'product': null,
          'fromCart': false,
          'productSlug': productId,
          'from_banner': true,
          'tag': "$productId"
        },
        parameters: {'tag': "$productId"},
      );
    });
  }
}

// void extractID(String? link, TickerProvider vsync) {
//   if (link != null) {
//     Uri uri = Uri.parse(link);
//     if (uri.pathSegments.isNotEmpty && uri.host == 'samana.land') {
//       // propertyId = int.tryParse(uri.pathSegments.last);
//
//       if (propertyId == null) {
//         return;
//       }
//
//       const Uuid uuid = Uuid();
//       String tag = "$propertyId-${uuid.v4()}";
//
//       if (!Get.isRegistered<HomeController>()) {
//         Get.offAllNamed(AppRoutes.initialScreen);
//         NavModel.initialize(vsync);
//         NavModel.instance.show();
//       }
//
//       Future.delayed(const Duration(milliseconds: 500)).then((value) {
//         Get.toNamed(
//           AppRoutes.propertyScreen,
//           arguments: {"id": propertyId},
//           parameters: {'tag': tag},
//         );
//       });
//     }
//   }
// }
