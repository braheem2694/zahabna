// import 'dart:async';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:uuid/uuid.dart';
// import 'package:app_links/app_links.dart';
// import '../routes/app_routes.dart';
//
// int? propertyId;
//
// Future<void> initUniLinks(StreamSubscription? sub, bool mounted, TickerProvider vsync) async {
//   // Stream for incoming links
//   sub = linkStream.listen((String? link) {
//     if (!mounted) return;
//     extractID(link, vsync);
//   }, onError: (err) {
//     if (!mounted) return;
//     // setState(() {
//     //   _linkMessage = 'Failed to get latest link: $err';
//     // });
//     if (kDebugMode) {
//       print("Failed to get latest link: $err");
//     }
//   });
//
//   // Initial link
//   String? initialLink;
//   try {
//     initialLink = await getInitialLink();
//     extractID(initialLink, vsync);
//   } catch (err) {
//     // setState(() {
//     //   _linkMessage = 'Failed to get initial link: $err';
//     // });
//
//     if (kDebugMode) {
//       print("Failed to get initial link: $err");
//     }
//   }
// }
//
// void extractID(String? link, TickerProvider vsync) {
//   if (link != null) {
//     Uri uri = Uri.parse(link);
//     if (uri.pathSegments.isNotEmpty && uri.host == 'samana.land') {
//       // propertyId = int.tryParse(uri.pathSegments.last);
//       //
//       // if (propertyId == null) {
//       //   return;
//       // }
//       //
//       // const Uuid uuid = Uuid();
//       // String tag = "$propertyId-${uuid.v4()}";
//       //
//       //
//       //
//       // Future.delayed(const Duration(milliseconds: 500)).then((value) {
//       //   Get.toNamed(
//       //     AppRoutes.propertyScreen,
//       //     arguments: {"id": propertyId},
//       //     parameters: {'tag': tag},
//       //   );
//       // });
//     }
//   }
// }