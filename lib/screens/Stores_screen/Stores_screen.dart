import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:iq_mall/routes/app_routes.dart';
import 'package:iq_mall/screens/Stores_screen/widgets/StoreItemWidget.dart';
import 'package:iq_mall/screens/Stores_screen/widgets/my_store_widget.dart';
import 'package:iq_mall/widgets/custom_image_view.dart';
import 'package:iq_mall/widgets/ui.dart';
import 'package:photo_view/photo_view.dart';

import '../../cores/math_utils.dart';
import '../../main.dart';
import '../../models/HomeData.dart';
import '../../models/Stores.dart';
import '../../utils/ShColors.dart';
import '../../utils/ShImages.dart';
import '../../widgets/ShWidget.dart';
import '../../widgets/image_widget.dart';
import 'controller/Stores_screen_controller.dart';
import 'widgets/item_widget.dart';

class Storesscreen extends StatelessWidget {
  Storesscreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensure arguments exist
    final tag = Get.arguments?["tag"] ?? "main";

    // Ensure controller is registered
    if (!Get.isRegistered<StoreController>(tag: tag)) {
      Get.put(StoreController(), tag: tag);
    }

    // Retrieve controller instance
    final StoreController controller = Get.find<StoreController>(tag: tag);

    return Obx(() {
      if (controller.loading.isTrue) {
        return Scaffold(
          body: Center(child: Ui.circularIndicator(color: ColorConstant.logoFirstColorConstant)),
        );
      }

      return Scaffold(
        backgroundColor: const Color(0xFFf5f5f5),
        appBar: globalController.storeRoute.value != AppRoutes.tabsRoute
            ? AppBar(
          toolbarHeight: getSize(50),
          title: Text("All Stores".tr, style: const TextStyle(color: Colors.black)),
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),

        )
            : null,

        body: Column(
          children: [
            Obx(() {
              print("getTopPadding(): ${getTopPadding()}");
              return globalController.storeRoute.value == AppRoutes.tabsRoute
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text(
                    //   prefs!.getString('welcome_text')!,
                    //   style: const TextStyle(
                    //     color: Color(0xffE8A78A),
                    //     fontSize: 25,
                    //   ),
                    // ),
                    const SizedBox(height: 10),
                    Text(
                      // prefs!.getString('store_name')?.toUpperCase() ?? 'Zalzali',
                      "All Stores".tr,
                      style: const TextStyle(
                        color: Color(0xff494C57),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              )
                  : SizedBox();
            }),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: getPadding(
                  left: 16.0,
                  right: 16.0,
                  top: globalController.storeRoute.value == AppRoutes.tabsRoute
                      ?( AppBar().preferredSize.height):getVerticalSize(30),
                  bottom: 3
                ),
                child: Obx(
                      () =>
                      Container(
                        constraints: BoxConstraints(minWidth: Get.width / 3, maxWidth: Get.width),
                        height: getSize(50),
                        width: Get.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(color: Colors.white.withOpacity(0.5)),
                          color: sh_light_grey, // Use sh_light_grey here
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 1,
                              offset: const Offset(1, 2),
                            ),
                          ],
                        ),
                        padding: getPadding(left: 8, right: 12),
                        alignment: Alignment.bottomCenter,
                        child: DropdownButtonHideUnderline(
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              canvasColor: sh_light_grey, // Dropdown background color
                              popupMenuTheme: PopupMenuThemeData(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ),

                            child: Obx(() {
                              return DropdownButton<String>(
                                value: controller.selectedCity.value,

                                items: List.generate(
                                    controller.cities.length,
                                        (index) =>
                                        DropdownMenuItem(
                                          value: controller.cities[index].values.last,
                                          child: Text(
                                            controller.cities[index].values.last.tr,
                                            style: TextStyle(color: Colors.black87, fontSize: getFontSize(13)), // Text color
                                          ),
                                        )),
                                onChanged: (value) {
                                  controller.selectedCity.value = value != "Select City" ? value! : null;

                                  if (controller.selectedCity.value == null) {
                                    controller.selectedCityId.value = null;
                                  }
                                  else {
                                    controller.cities.forEach((element) {
                                      if (element.values.first == controller.selectedCity.value) {
                                        controller.selectedCityId.value = element.keys.first;
                                      }
                                    });
                                  }


                                  controller.fetchStores(false, false);

                                  // widget.controller.getProducts(1).then((value) {
                                  //   widget.controller.loader.value = false;
                                  //   Get.back();
                                  // });
                                  // ... Your existing onChanged logic ...
                                },
                                hint: Text(
                                  'Select City'.tr,
                                  style: TextStyle(color: Colors.black54), // Hint text style
                                ),
                                icon: const Icon(
                                  Icons.arrow_drop_down_sharp,
                                  color: Colors.black, // Icon color
                                ),
                                style: TextStyle(color: Colors.black),
                                // Selected item style
                                isExpanded: true,
                                dropdownColor: sh_light_grey,
                                elevation: 16,
                                // Shadow elevation
                                borderRadius: BorderRadius.circular(15),
                                // Border radius of dropdown
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), // Inner padding
                              );
                            }),
                          ),
                        ),
                      ),
                ),
              ),
            ),

            Expanded(
              child: Obx(() {
                if (controller.stores.isEmpty) {
                  return Center(child: Text("No stores available."));
                }
                RxList<Rx<StoreClass>> stores = (Get.arguments == null || Get.arguments["tag"] != "side_menu"
                    ? controller.stores
                    : controller.stores
                    .where((element) => element.value.ownerId.toString() == prefs?.getString("user_id"))
                    .map((store) => store) // Keep it as Rx<StoreClass>
                    .toList()).cast<Rx<StoreClass>>().obs;



                return RefreshIndicator(
                  onRefresh: () {
                   return controller.fetchStores(false,false);
                  },
                  child: GridView.builder(
                    padding: EdgeInsets.only(bottom: getBottomPadding() +  getSize(60),right: 12,left: 12,top: 12),
                    physics: const AlwaysScrollableScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    shrinkWrap: true,
                    controller: controller.scrollController,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: getVerticalSize(280.00),
                      crossAxisCount: 2,
                      mainAxisSpacing: getHorizontalSize(7.50),
                      crossAxisSpacing: getHorizontalSize(7.50),
                    ),
                    itemCount: stores.length,
                    itemBuilder: (context, index) {
                      final store = stores[index];
                      final storeName = store.value.store_name;
                      final mainImage = store.value.main_image ?? "";
                      var unescape = HtmlUnescape();
                      var text = unescape.convert(storeName??'No Name');
                      return GestureDetector(
                        onTap: () {
                          // Ui.flutterToast("Coming soon :)".tr, Toast.LENGTH_LONG, MainColor, whiteA700);

                          // Get.to(()=>MyStore());
                          controller.saveStoreView(store.value.id);

                          globalController.updateStoreRoute(AppRoutes.tabsRoute);
                          prefs?.setString("id", store.value.id.toString());
                          Get.offAllNamed(AppRoutes.tabsRoute);
                          // Get.toNamed(AppRoutes.myStore,arguments: {"store":store});

                          // controller.ChangeStroredStore(store, 'a');
                          // Handle onTap event
                        },
                        child: Container(
                          height: getVerticalSize(100),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.grey[200]!),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: ColorConstant.black900.withOpacity(0.15),
                                blurRadius: 4.0,
                                spreadRadius: 0.0,
                                offset: const Offset(0, 3.0),
                              ),
                            ],
                          ),
                          width: getHorizontalSize(175),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      ColorConstant.logoSecondColor.withOpacity(0.4),
                                      ColorConstant.logoSecondColor.withOpacity(0.6),
                                      ColorConstant.logoSecondColor.withOpacity(0.9),
                                    ],
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(7),
                                    topRight: Radius.circular(7),
                                  ),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 3),
                                    child: Text(
                                      text,
                                      style: TextStyle(color: ColorConstant.logoFirstColor.withOpacity(0.7), fontWeight: FontWeight.w700, fontSize: getFontSize(18)),
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              CustomImageView(

                                image: mainImage!=""?mainImage:AssetPaths.placeholder,
                                placeHolder: AssetPaths.placeholder,
                                height: getVerticalSize(100),
                                width: getVerticalSize(120),
                                fit: BoxFit.cover,
                              ),
                              Spacer(),
                              Container(
                                width: getHorizontalSize(190),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      ColorConstant.logoSecondColor.withOpacity(0.4),
                                      ColorConstant.logoSecondColor.withOpacity(0.6),
                                      ColorConstant.logoSecondColor.withOpacity(0.9),
                                    ],
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(7),
                                    bottomLeft: Radius.circular(7),
                                  ),
                                ),
                                padding: getPadding(top: 8, left: 10, right: 10, bottom: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 3),
                                      child: Container(
                                        decoration: BoxDecoration(color: fromHex('#996c22'), borderRadius: BorderRadius.circular(5)),
                                        width: getHorizontalSize(140),
                                        alignment: Alignment.center,
                                        padding: getPadding(top: 8, left: 15, right: 15, bottom: 8),
                                        child: Text(
                                          "Shop",
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: getFontSize(16)),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        // controller.saveStoreView(store.id);

                                        Get.toNamed(AppRoutes.soreDetails, arguments: {"store": store.value, "tag":tag})?.then((value) {
                                          controller.refreshStores.value = true;
                                          store.value.main_image= globalController.storeImage.value;
                                          store.refresh();
                                          controller.stores[index].value.main_image= globalController.storeImage.value;
                                          controller.stores[index].refresh();
                                          Future.delayed(const Duration(milliseconds: 500)).then((value) {
                                            controller.refreshStores.value = false;
                                          });
                                          controller.fetchStores(false, false, fromInfo: true);
                                        },);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 3),
                                        child: Container(
                                          decoration: BoxDecoration(color: ColorConstant.logoFirstColorConstant.withOpacity(0.8), borderRadius: BorderRadius.circular(5)),
                                          width: getHorizontalSize(140),
                                          alignment: Alignment.center,
                                          padding: getPadding(top: 8, left: 15, right: 15, bottom: 8),
                                          child: Text(
                                            "Info",
                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: getFontSize(16)),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      );
    });
  }
}
