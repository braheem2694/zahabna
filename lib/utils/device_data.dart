import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:io';
Future<Map<String, dynamic>> getDeviceInfo() async {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  String os = "N/A";
  String brand = "N/A";
  String device = "N/A";
  String deviceId = "N/A";
  String manufacturer = "N/A";
  String model = "N/A";
  String product = "N/A";
  double heightPx = 0.0;
  double widthPx = 0.0;
  bool isPhysical = false;

  try {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      os = "android";
      brand = androidInfo.brand;
      device = androidInfo.device;
      deviceId = androidInfo.id;
      manufacturer = androidInfo.manufacturer;
      model = androidInfo.model;
      product = androidInfo.product;
      // heightPx = androidInfo.display.;
      // widthPx = androidInfo.displayMetrics.widthPx;
      isPhysical = androidInfo.isPhysicalDevice;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

      os = "ios";
      brand = iosInfo.model ?? brand;
      device = iosInfo.name ?? device;
      deviceId = iosInfo.identifierForVendor ?? deviceId;
      manufacturer = "Apple";
      model = iosInfo.name ?? device;
      product = iosInfo.systemVersion ?? product;
      heightPx = Get.context == null ? heightPx : Get.height * Get.pixelRatio;
      widthPx = Get.context == null ? widthPx : Get.width * Get.pixelRatio;
      isPhysical = iosInfo.isPhysicalDevice;
    }
  } on PlatformException catch (_) {
    debugPrint('Failed to get device id');
  }

  return {
    "os": os,
    "brand": brand,
    "device": device,
    "deviceId": deviceId,
    "manufacturer": manufacturer,
    "model": model,
    "product": product,
    "heightPx": heightPx,
    "widthPx": widthPx,
    "isPhysical": isPhysical,
  };
}