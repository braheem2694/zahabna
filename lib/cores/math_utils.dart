import 'package:flutter/material.dart';
import 'package:get/get.dart';

Rx<Size> size = (WidgetsBinding.instance.window.physicalSize / WidgetsBinding.instance.window.devicePixelRatio).obs;

///This method is used to set padding/margin (for the left and Right side) & width of the screen or widget according to the Viewport width.
double getHorizontalSize(double? px) {
  return (px ?? 0) * (size.value.width / 390);
}

///This method is used to set padding/margin (for the top and bottom side) & height of the screen or widget according to the Viewport height.
double getVerticalSize(double? px) {
  num statusBar = MediaQueryData.fromWindow(WidgetsBinding.instance.window).viewPadding.top;
  num screenHeight = size.value.height - statusBar;
  return (px ?? 0) * (screenHeight / 800.0);
}

double getTopPadding() {
  double topPadding = 20.0;
  if (MediaQuery.of(Get.context!).padding.top < 10) {
    topPadding = 20.0 + MediaQuery.of(Get.context!).padding.top;
  } else {
    topPadding = MediaQuery.of(Get.context!).padding.top;
  }

  return topPadding;
}

double getBottomPadding({BuildContext? context}) {
  double bottomPadding = 0.0;
  if (MediaQuery.of(context??Get.context!).padding.bottom < 10) {
    bottomPadding = 20.0 + MediaQuery.of(context??Get.context!).padding.bottom;
  } else {
    bottomPadding = MediaQuery.of(context??Get.context!).padding.bottom;
  }

  return bottomPadding;
}

///This method is used to set text font size according to Viewport
double? getFontSize(double? px) {
  var height = getVerticalSize(px);
  var width = getHorizontalSize(px);
  if (height < width) {
    return height.toInt().toDouble();
  } else {
    return width.toInt().toDouble();
  }
}

///This method is used to set smallest px in image height and width
double getSize(double? px) {
  var height = getVerticalSize(px);
  var width = getHorizontalSize(px);
  if (height < width) {
    return height.toInt().toDouble();
  } else {
    return width.toInt().toDouble();
  }
}

///This method is used to set smallest px in image height and width
double getScreenWidth() {
  return MediaQuery.of(Get.context!).size.width;
}

///This method is used to set smallest px in image height and width
double getScreenHeight() {
  return MediaQuery.of(Get.context!).size.height;
}

double getScreenRatio() {
  return MediaQuery.of(Get.context!).size.height / MediaQuery.of(Get.context!).size.width;
}

///This method is used to set padding responsively
EdgeInsetsGeometry getPadding({
  double? all,
  double? left,
  double? top,
  double? right,
  double? bottom,
}) {
  if (all != null) {
    left = all;
    top = all;
    right = all;
    bottom = all;
  }
  return EdgeInsets.only(
    left: getHorizontalSize(
      left ?? 0,
    ),
    top: getVerticalSize(
      top ?? 0,
    ),
    right: getHorizontalSize(
      right ?? 0,
    ),
    bottom: getVerticalSize(
      bottom ?? 0,
    ),
  );
}

///This method is used to set margin responsively
EdgeInsetsGeometry getMargin({
  double? all,
  double? left,
  double? top,
  double? right,
  double? bottom,
}) {
  if (all != null) {
    left = all;
    top = all;
    right = all;
    bottom = all;
  }
  return EdgeInsets.only(
    left: getHorizontalSize(
      left ?? 0,
    ),
    top: getVerticalSize(
      top ?? 0,
    ),
    right: getHorizontalSize(
      right ?? 0,
    ),
    bottom: getVerticalSize(
      bottom ?? 0,
    ),
  );
}
