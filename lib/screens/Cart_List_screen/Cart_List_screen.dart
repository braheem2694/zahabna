import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/screens/Cart_List_screen/controller/Cart_List_controller.dart';
import 'package:iq_mall/screens/Cart_List_screen/widgets/AlertDaialogHandler.dart';
import 'package:iq_mall/screens/Cart_List_screen/widgets/BottomContainer.dart';
import 'package:iq_mall/screens/Cart_List_screen/widgets/CheckingData.dart';
import 'package:iq_mall/screens/Cart_List_screen/widgets/SelectionButton.dart';
import 'package:iq_mall/screens/Cart_List_screen/widgets/cartList.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/screens/ProductDetails_screen/ProductDetails_screen.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/widgets/CommonWidget.dart';
import 'package:iq_mall/main.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iq_mall/utils/ShImages.dart';
import '../../getxController.dart';
import '../../routes/app_routes.dart';
import '../../utils/ShConstant.dart';
import '../HomeScreenPage/ShHomeScreen.dart';
import '../tabs_screen/controller/tabs_controller.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:iq_mall/models/functions.dart';
import 'package:flutter/src/services/system_chrome.dart';

import '../tabs_screen/tabs_view_screen.dart';

// ignore_for_file: must_be_immutable
class Cart_Listscreen extends StatelessWidget {


  final Cart_ListController controller = Get.put(Cart_ListController(),);

  // final Cart_ListController controller = Get.put(Cart_ListController());

  Cart_Listscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return

      Obx(() {

        return
          globalController.cartListRoute.value != AppRoutes.tabsRoute ?

          WillPopScope(
          onWillPop: () {
            if(globalController.cartCount<3){
              globalController.cartBackCount++;
              Get.back();
            }
            else{
              if(globalController.cartBackCount>0){
                for (int i = 1; i < globalController.cartCount-1; i++) {
                  Get.back();
                }

                globalController.cartBackCount=0;
                globalController.cartCount=0;
              }
              else{
                globalController.cartBackCount++;
                globalController.cartCount--;
                Get.back();
              }

              // Get.until(ModalRoute.withName(globalController.cartFirstRoute??"/tabs"));
            }
            return Future(() => true);

          },
          child: Obx(() {
            return Scaffold(
              appBar:
              globalController.cartListRoute.value != AppRoutes.tabsRoute ?
              AppBar(
                toolbarHeight: getSize(50),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30), // Change the value to your desired radius
                  ),
                ),
                backgroundColor: Colors.white,
                foregroundColor: Colors.grey,
                shadowColor: Colors.white,
                elevation: 0.5,
                iconTheme: const IconThemeData(color: sh_textColorPrimary),
                centerTitle: false,
                leading: GestureDetector(
                  onTap: () {
                    if(globalController.cartCount<3){
                      globalController.cartBackCount++;
                      Get.back();
                    }
                    else{
                      if(globalController.cartBackCount>0){
                        for (int i = 1; i < globalController.cartCount-1; i++) {
                          Get.back();
                        }

                        globalController.cartBackCount=0;
                        globalController.cartCount=0;
                      }
                      else{
                        globalController.cartBackCount++;
                        globalController.cartCount--;
                        Get.back();
                      }

                      // Get.until(ModalRoute.withName(globalController.cartFirstRoute??"/tabs"));
                    }
                  },
                  child: SizedBox(
                    width: getSize(10), // Set the desired width
                    height: getSize(10), // Set the desired height
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(Icons.arrow_back_ios),
                    ),
                  ),
                ),
                title: Text("Cart List", style: TextStyle(color: Colors.black),),


              ) : null,
              body: GestureDetector(
                onTap: () {
                    
                },
                child: AbsorbPointer(
                  absorbing: controller.checking_data.value,


                  child: IgnorePointer(
                    ignoring: controller.deleting_items.value,
                    child: RefreshIndicator(
                      color: MainColor,
                      onRefresh: controller.handleRefresh,
                      child: Obx(
                            () =>
                        controller.loading.value
                            ? Align(alignment: Alignment.center, child: Progressor_indecator())
                            : cartlist!.isEmpty
                            ? Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 38.0, right: 38),
                            child: Image.asset(
                              AssetPaths.emptycart_image,
                            ),
                          ),
                        )
                            : Padding(
                          padding: EdgeInsets.only(top: globalController.refreshingHomeScreen.value ? 8.0 : 0.0),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Obx(() {
                                return controller.loading.value
                                    ? Align(alignment: Alignment.bottomCenter, child: Progressor_indecator())
                                    : Padding(
                                  padding: EdgeInsets.only(
                                      bottom: globalController.cartListRoute.value != AppRoutes.tabsRoute ? 0 : (getSize(40) + getBottomPadding()),
                                      left: spacing_standard_new,
                                      right: spacing_standard_new,
                                      top: globalController.cartListRoute.value != AppRoutes.tabsRoute ? 5 : (getSize(55) + getTopPadding())),
                                  child: cartList(),
                                );
                              }),
                              controller.checking_data.value ? const CheckingData() : const SizedBox(),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Obx(
                                      () =>
                                  controller.awesomeOpened.value ?
                                  const SizedBox() :
                                  controller.checking_data.value
                                      ? Container()
                                      : Align(
                                    alignment: Alignment.bottomCenter,
                                    child: cartlist!.isEmpty
                                        ? const SizedBox()
                                        : Padding(
                                      padding: EdgeInsets.only(bottom: globalController.cartListRoute.value != AppRoutes.tabsRoute ? getBottomPadding() : (getBottomPadding() + getSize(50))),
                                      child: BottomContainer(
                                        onTap: () {
                                          try {
                                            if (prefs?.getString('logged_in') == 'true') {
                                              Get.context!.read<Counter>().calculateTotal(0.0);
                                              controller.ContinueButtonMethod(context)
                                                  .then((value) =>
                                              {
                                                calculateTotalWithoutDelivery(),
                                                computeAdditionalCostSum(),
                                                controller.deleting_items.value = false,
                                                controller.checking_data.value = false,
                                              });
                                            } else {
                                              AwesomeDialog(
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width < 1000
                                                      ? 350
                                                      : 600,

                                                  context: context,
                                                  dialogType: DialogType.warning,
                                                  body: Stack(
                                                    alignment: Alignment.topCenter,
                                                    children: [
                                                      Container(
                                                        height: getSize(210),
                                                        child: Padding(
                                                          padding: const EdgeInsets.fromLTRB(
                                                              10, 30, 10, 10),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment.center,
                                                            children: [
                                                              Text(
                                                                'Warning'.tr,
                                                                style: TextStyle(
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: getFontSize(18)),
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              Text(
                                                                'You must login first to continue'.tr,
                                                                style: TextStyle(
                                                                    fontSize: getFontSize(18)),
                                                              ),
                                                              const SizedBox(
                                                                height: 20,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  const Text(''),
                                                                  dialogButton(
                                                                      'Login'.tr, handleLogin),
                                                                  dialogButton(
                                                                      'Cancel'.tr, handleCancel),
                                                                  const Text(''),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )).show();
                                            }
                                          } catch (ex) {
                                            controller.deleting_items.value = false;
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              floatingActionButton: Padding(
                padding: getPadding(bottom: 112.0),
                child: Obx(() =>
                    SpeedDial(
                      useRotationAnimation: true,
                      visible: controller.selectedProductIds.isNotEmpty,
                      backgroundColor: Button_color,
                      animationDuration: Duration(milliseconds: 300),
                      animationCurve: Curves.easeInOut,
                      curve: Curves.easeInOut,
                      // the type of animation curve you want

                      activeBackgroundColor: Button_color,
                      overlayColor: Colors.white,
                      label: Obx(() {
                        return Text(
                          "(${controller.selectedProductIds.length})",
                          style: TextStyle(color: Colors.white, fontSize: getFontSize(12)),
                        );
                      }),
                      // Set the overlay color to transparent
                      overlayOpacity: 0.5,
                      renderOverlay: false,
                      // Set the overlay opacity to 0
                      activeChild: Icon(Icons.close, color: Colors.white),
                      child: Icon(Icons.add, color: Colors.white),
                      animationAngle: 3.2,

                      openCloseDial: controller.myValue,
                      children: [
                        SpeedDialChild(
                          child: Icon(Icons.delete, color: Colors.white, size: getSize(20)),
                          backgroundColor: Colors.red[600],
                          shape: CircleBorder(),
                          label: 'Remove ${controller.selectedProductIds.length}'.tr,
                          labelStyle: TextStyle(fontSize: getFontSize(12), color: Colors.white),
                          labelBackgroundColor: MainColor,
                          onTap: () =>
                              AwesomeDialog(
                                  width: getHorizontalSize(350),
                                  context: context,
                                  dialogType: DialogType.info,
                                  body: Stack(
                                    alignment: Alignment.topCenter,
                                    children: [
                                      SizedBox(
                                        height: getSize(170),

                                        width: getHorizontalSize(300),

                                        child: Column(
                                          children: [
                                            Text(
                                              'Warning'.tr,
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: getFontSize(16)),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Center(
                                              child: Text(
                                                'Are you sure you want to delete ?'.tr,
                                                style: TextStyle(fontSize: getFontSize(16)),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text(''),
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                    backgroundColor: MainColor,
                                                    textStyle: TextStyle(fontSize: getFontSize(15)),
                                                  ),
                                                  onPressed: () {
                                                    if (!controller.deleting_items.value) {
                                                      controller.deleting_items.value = true;
                                                      Get.back();
                                                      var list =
                                                      <dynamic>[]; // Assuming the type of items in cartlist is dynamic. Replace <dynamic> with the actual type if known.

                                                      for (var selectedId in controller.selectedProductIds) {
                                                        for (var cartItem in cartlist!) {
                                                          if (cartItem.product_id.toString() == selectedId.toString()) {
                                                            list.add(cartItem);
                                                            break; // Break out of the inner loop once a match is found to avoid unnecessary iterations
                                                          }
                                                        }
                                                      }

                                                      function.RemoveFromCart(list).then((value) {
                                                        if (value) {
                                                          controller.selectedProductIds.clear();
                                                        }
                                                        controller.deleting_items.value = false;
                                                        controller.GetCart();
                                                      });
                                                    }
                                                  },
                                                  child: Text(
                                                    'Delete'.tr,
                                                    style: const TextStyle(color: Colors.white),
                                                  ),
                                                ),
                                                const Text(''),
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                    backgroundColor: MainColor,
                                                    textStyle: TextStyle(fontSize: getFontSize(15)),
                                                  ),
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  child: Text(
                                                    'Cancel'.tr,
                                                    style: const TextStyle(color: Colors.white),
                                                  ),
                                                ),
                                                const Text(''),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )).show(),
                        ),
                        SpeedDialChild(
                          child: const Icon(
                            Icons.select_all_rounded,
                            color: Colors.white,
                          ),
                          backgroundColor: ColorConstant.logoFirstColor.withOpacity(0.8),
                          label:
                          controller.selectedProductIds.length != cartlist?.length ? 'Select All'.tr : "Unselect All".tr,
                          labelStyle: TextStyle(fontSize: getFontSize(12), color: Colors.white),
                          labelBackgroundColor: MainColor,
                          shape: CircleBorder(),
                          onTap: () => controller.selectAll(),
                        ),
                      ],
                    )),
              ),
            );
          }),
        ):
          Obx(() {
            return Scaffold(
              appBar:
              globalController.cartListRoute.value != AppRoutes.tabsRoute ?
              AppBar(
                toolbarHeight: getSize(50),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30), // Change the value to your desired radius
                  ),
                ),
                backgroundColor: Colors.white,
                foregroundColor: Colors.grey,
                shadowColor: Colors.white,
                elevation: 0.5,
                iconTheme: const IconThemeData(color: sh_textColorPrimary),
                centerTitle: false,
                leading: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: SizedBox(
                    width: getSize(10), // Set the desired width
                    height: getSize(10), // Set the desired height
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(Icons.arrow_back_ios),
                    ),
                  ),
                ),
                title: Text("Cart List", style: TextStyle(color: Colors.black),),


              ) : null,
              body: GestureDetector(
                onTap: () {
                    
                },
                child: AbsorbPointer(
                  absorbing: controller.checking_data.value,


                  child: IgnorePointer(
                    ignoring: controller.deleting_items.value,
                    child: RefreshIndicator(
                      color: MainColor,
                      onRefresh: controller.handleRefresh,
                      child: Obx(
                            () =>
                        controller.loading.value
                            ? Align(alignment: Alignment.center, child: Progressor_indecator())
                            : cartlist!.isEmpty
                            ? Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 38.0, right: 38),
                            child: Image.asset(
                              AssetPaths.emptycart_image,
                            ),
                          ),
                        )
                            : Padding(
                          padding: EdgeInsets.only(top: globalController.refreshingHomeScreen.value ? 8.0 : 0.0),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Obx(() {
                                return controller.loading.value
                                    ? Align(alignment: Alignment.bottomCenter, child: Progressor_indecator())
                                    : Padding(
                                  padding: EdgeInsets.only(
                                      bottom: globalController.cartListRoute.value != AppRoutes.tabsRoute ? 0 : (getSize(40) + getBottomPadding()),
                                      left: spacing_standard_new,
                                      right: spacing_standard_new,
                                      top: globalController.cartListRoute.value != AppRoutes.tabsRoute ? 5 : (getSize(55) + getTopPadding())),
                                  child: cartList(),
                                );
                              }),
                              controller.checking_data.value ? const CheckingData() : const SizedBox(),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Obx(
                                      () =>
                                  controller.awesomeOpened.value ?
                                  const SizedBox() :
                                  controller.checking_data.value
                                      ? Container()
                                      : Align(
                                    alignment: Alignment.bottomCenter,
                                    child: cartlist!.isEmpty
                                        ? const SizedBox()
                                        : Padding(
                                      padding: EdgeInsets.only(bottom: globalController.cartListRoute.value != AppRoutes.tabsRoute ? getBottomPadding() : (getBottomPadding() + getSize(50))),
                                      child: BottomContainer(
                                        onTap: () {
                                          try {
                                            if (prefs?.getString('logged_in') == 'true') {
                                              Get.context!.read<Counter>().calculateTotal(0.0);
                                              controller.ContinueButtonMethod(context)
                                                  .then((value) =>
                                              {
                                                calculateTotalWithoutDelivery(),
                                                computeAdditionalCostSum(),
                                                controller.deleting_items.value = false,
                                                controller.checking_data.value = false,
                                              });
                                            } else {
                                              AwesomeDialog(
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width < 1000
                                                      ? 350
                                                      : 600,

                                                  context: context,
                                                  dialogType: DialogType.warning,
                                                  body: Stack(
                                                    alignment: Alignment.topCenter,
                                                    children: [
                                                      Container(
                                                        height: getSize(210),
                                                        child: Padding(
                                                          padding: const EdgeInsets.fromLTRB(
                                                              10, 30, 10, 10),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment.center,
                                                            children: [
                                                              Text(
                                                                'Warning'.tr,
                                                                style: TextStyle(
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: getFontSize(18)),
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              Text(
                                                                'You must login first to continue'.tr,
                                                                style: TextStyle(
                                                                    fontSize: getFontSize(18)),
                                                              ),
                                                              const SizedBox(
                                                                height: 20,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  const Text(''),
                                                                  dialogButton(
                                                                      'Login'.tr, handleLogin),
                                                                  dialogButton(
                                                                      'Cancel'.tr, handleCancel),
                                                                  const Text(''),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )).show();
                                            }
                                          } catch (ex) {
                                            controller.deleting_items.value = false;
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              floatingActionButton: Padding(
                padding: getPadding(bottom: 112.0),
                child: Obx(() =>
                    SpeedDial(
                      useRotationAnimation: true,
                      visible: controller.selectedProductIds.isNotEmpty,
                      backgroundColor: Button_color,
                      animationDuration: Duration(milliseconds: 300),
                      animationCurve: Curves.easeInOut,
                      curve: Curves.easeInOut,
                      // the type of animation curve you want

                      activeBackgroundColor: Button_color,
                      overlayColor: Colors.white,
                      label: Obx(() {
                        return Text(
                          "(${controller.selectedProductIds.length})",
                          style: TextStyle(color: Colors.white, fontSize: getFontSize(12)),
                        );
                      }),
                      // Set the overlay color to transparent
                      overlayOpacity: 0.5,
                      renderOverlay: false,
                      // Set the overlay opacity to 0
                      activeChild: Icon(Icons.close, color: Colors.white),
                      child: Icon(Icons.add, color: Colors.white),
                      animationAngle: 3.2,

                      openCloseDial: controller.myValue,
                      children: [
                        SpeedDialChild(
                          child: Icon(Icons.delete, color: Colors.white, size: getSize(20)),
                          backgroundColor: Colors.red[600],
                          shape: CircleBorder(),
                          label: 'Remove ${controller.selectedProductIds.length}'.tr,
                          labelStyle: TextStyle(fontSize: getFontSize(12), color: Colors.white),
                          labelBackgroundColor: MainColor,
                          onTap: () =>
                              AwesomeDialog(
                                  width: getHorizontalSize(350),
                                  context: context,
                                  dialogType: DialogType.info,
                                  body: Stack(
                                    alignment: Alignment.topCenter,
                                    children: [
                                      SizedBox(
                                        height: getSize(170),

                                        width: getHorizontalSize(300),

                                        child: Column(
                                          children: [
                                            Text(
                                              'Warning'.tr,
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: getFontSize(16)),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Center(
                                              child: Text(
                                                'Are you sure you want to delete ?'.tr,
                                                style: TextStyle(fontSize: getFontSize(16)),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                const Text(''),
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                    backgroundColor: MainColor,
                                                    textStyle: TextStyle(fontSize: getFontSize(15)),
                                                  ),
                                                  onPressed: () {
                                                    if (!controller.deleting_items.value) {
                                                      controller.deleting_items.value = true;
                                                      Get.back();
                                                      var list =
                                                      <dynamic>[]; // Assuming the type of items in cartlist is dynamic. Replace <dynamic> with the actual type if known.

                                                      for (var selectedId in controller.selectedProductIds) {
                                                        for (var cartItem in cartlist!) {
                                                          if (cartItem.product_id.toString() == selectedId.toString()) {
                                                            list.add(cartItem);
                                                            break; // Break out of the inner loop once a match is found to avoid unnecessary iterations
                                                          }
                                                        }
                                                      }

                                                      function.RemoveFromCart(list).then((value) {
                                                        if (value) {
                                                          controller.selectedProductIds.clear();
                                                        }
                                                        controller.deleting_items.value = false;
                                                        controller.GetCart();
                                                      });
                                                    }
                                                  },
                                                  child: Text(
                                                    'Delete'.tr,
                                                    style: const TextStyle(color: Colors.white),
                                                  ),
                                                ),
                                                const Text(''),
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                    backgroundColor: MainColor,
                                                    textStyle: TextStyle(fontSize: getFontSize(15)),
                                                  ),
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  child: Text(
                                                    'Cancel'.tr,
                                                    style: const TextStyle(color: Colors.white),
                                                  ),
                                                ),
                                                const Text(''),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )).show(),
                        ),
                        SpeedDialChild(
                          child: const Icon(
                            Icons.select_all_rounded,
                            color: Colors.white,
                          ),
                          backgroundColor: ColorConstant.logoFirstColor.withOpacity(0.8),
                          label:
                          controller.selectedProductIds.length != cartlist?.length ? 'Select All'.tr : "Unselect All".tr,
                          labelStyle: TextStyle(fontSize: getFontSize(12), color: Colors.white),
                          labelBackgroundColor: MainColor,
                          shape: CircleBorder(),
                          onTap: () => controller.selectAll(),
                        ),
                      ],
                    )),
              ),
            );
          });
      });
  }

  void handleLogin() {
    TabsController _controller = Get.find();
    _controller.currentIndex.value = 3;
    mainCurrentIndex.value = 3;

    Get.back();
    firebaseMessaging.deleteToken();
    Get.toNamed(AppRoutes.SignIn);
  }

  void handleCancel() {
    Get.back();
  }
}
