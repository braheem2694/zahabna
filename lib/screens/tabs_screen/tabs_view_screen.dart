import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:transitioned_indexed_stack/transitioned_indexed_stack.dart';
import 'package:bottom_navbar_with_indicator/bottom_navbar_with_indicator.dart';

import '../../main.dart';
import '../../cores/math_utils.dart';
import '../../getxController.dart';
import '../../routes/app_routes.dart';
import '../../utils/ShColors.dart';
import '../../utils/ShImages.dart';
import '../../widgets/CommonFunctions.dart';
import '../../widgets/CommonWidget.dart';
import '../../widgets/custom_image_view.dart';
import '../Cart_List_screen/controller/Cart_List_controller.dart';
import 'controller/tabs_controller.dart';

class TabsPage extends GetView<TabsController> {
  const TabsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (controller.currentIndex.value == 0) {
          ExitAlert(context);
        } else {
          controller.currentIndex.value = 0;
        }
        return Future(() => true);
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: sh_light_grey,
        extendBody: true,
        appBar: _buildAppBar(context),
        bottomNavigationBar: _buildBottomNavBar(context),
        body: _buildBody(context),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: getSize(50),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      backgroundColor: Colors.white,
      foregroundColor: Colors.grey,
      shadowColor: Colors.white,
      elevation: 0.5,
      iconTheme: const IconThemeData(color: sh_textColorPrimary),
      centerTitle: true,
      leading: GestureDetector(
        onTap: () {
          if (state?.isOpened ?? false) {
            state?.closeSideMenu();
          } else {
            state?.openSideMenu();
          }
        },
        child: SizedBox(
          width: getSize(10),
          height: getSize(10),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SvgPicture.asset(
              AssetPaths.menu,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
      title: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => controller.OnBottomNavTapPress(controller.currentIndex.value),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Obx(() {
            return CustomImageView(
              width: getSize(40),
              height: getSize(40),
              url: globalController.storeImage.value,
              svgUrl: globalController.storeImage.value,
              fit: BoxFit.cover,
              imagePath: AssetPaths.placeholder,
            );
          }),
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: getPadding(right: 8.0),
          child: IconButton(
            icon: SVG(AssetPaths.search_image, 27, 27, Button_color),
            onPressed: () {
              Get.toNamed(AppRoutes.Search)!.then((value) {
                cartlist = cartlist;
              });
            },
          ),
        ),
        if (prefs?.getString('logged_in') == 'true')
          Padding(
            padding: getPadding(right: 8.0),
            child: GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.NotificationsScreen, arguments: false);
              },
              child: InkWell(
                onTap: () {
                  Get.toNamed(AppRoutes.NotificationsScreen, arguments: false)!.then(
                    (value) => controller.unreadednotification(),
                  );
                },
                radius: getSize(35),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: getSize(30),
                      height: getSize(30),
                      child: SVG(AssetPaths.notification_image, 30, 30, Button_color),
                    ),
                    Obx(() => globalController.unreadednotifications.value != 0
                        ? Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              width: getSize(30),
                              margin: EdgeInsets.only(
                                left: MediaQuery.of(context).size.height * 0.02,
                                bottom: MediaQuery.of(context).size.height * 0.02,
                              ),
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(width: 3, color: MainColor),
                              ),
                              child: Text(
                                globalController.unreadednotifications.value.toString(),
                                style: TextStyle(color: MainColor, fontSize: 16),
                              ),
                            ),
                          )
                        : const SizedBox()),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Obx(() {
      // Listen to these observables to trigger rebuilds
      final _ = controller.rebuildTrigger.value;
      final __ = globalController.stores.length;
      final ___ = controller.pages.length;

      return IgnorePointer(
        ignoring: globalController.isSideMenuOpened.value,
        child: Container(
          alignment: Alignment.topCenter,
          height: getSize(50) + getBottomPadding(context: context),
          padding: EdgeInsets.zero,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: CustomLineIndicatorBottomNavbar(
            selectedColor: ColorConstant.logoSecondColor,
            unSelectedColor: ColorConstant.logoFirstColor,
            backgroundColor: Colors.white,
            currentIndex: controller.currentIndex.value,
            unselectedIconSize: getSize(18),
            selectedIconSize: getSize(23),
            onTap: (index) {
              globalController.updateStoreRoute(Get.currentRoute);
              if (index == 2) {
                globalController.updateIsNav(true);
              } else {
                globalController.updateIsNav(false);
              }
              controller.OnBottomNavTapPress(index);
            },
            enableLineIndicator: true,
            lineIndicatorWidth: 2,
            indicatorType: IndicatorType.top,
            selectedFontSize: getFontSize(15)!,
            unselectedFontSize: getFontSize(13)!,
            customBottomBarItems: controller.getBottomBarItems(),
          ),
        ),
      );
    });
  }

  Widget _buildBody(BuildContext context) {
    return Obx(() {
      // Listen to these observables to trigger rebuilds
      final _ = controller.rebuildTrigger.value;
      final __ = controller.pages.length;

      return AnimatedPadding(
        padding: EdgeInsets.only(
          top: globalController.refreshingHomeScreen.value
              ? (Platform.isIOS
                  ? AppBar().preferredSize.height / 2 + MediaQuery.of(context).padding.top
                  : AppBar().preferredSize.height)
              : 0,
        ),
        duration: const Duration(milliseconds: 300),
        child: InkWell(
          onTap: globalController.isSideMenuOpened.value
              ? () {
                  if (globalController.isSideMenuOpened.value) {
                    state?.closeSideMenu();
                  }
                }
              : null,
          child: IgnorePointer(
            ignoring: globalController.isSideMenuOpened.value,
            child: SizeFactorIndexedStack(
              beginSizeFactor: 0.9,
              endSizeFactor: 1.0,
              curve: Curves.easeInOut,
              axis: Axis.horizontal,
              duration: const Duration(milliseconds: 300),
              index: controller.currentIndex.value,
              children: controller.pages.toList(),
            ),
          ),
        ),
      );
    });
  }
}
