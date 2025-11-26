import 'package:flutter/material.dart';
import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/screens/Home_screen_fragment/widgets/CategoriesWidget.dart';
import 'package:iq_mall/screens/Home_screen_fragment/widgets/Specialitems.dart';
import 'package:get/get.dart';
import 'package:iq_mall/widgets/CommonWidget.dart';
import 'package:iq_mall/widgets/gold_price_indicator.dart';
import 'package:iq_mall/widgets/ui.dart';
import '../../routes/app_routes.dart';
import '../../utils/ShColors.dart';
import '../../main.dart';
import '../../utils/ShImages.dart';
import '../../widgets/Grid_Widget.dart';
import '../../widgets/custom_image_view.dart';
import '../tabs_screen/controller/tabs_controller.dart';
import 'controller/Home_screen_fragment_controller.dart';

// ignore_for_file: must_be_immutable

class Home_screen_fragmentscreen extends StatelessWidget {
  Home_screen_fragmentController controller =
      Get.put(Home_screen_fragmentController());

  Home_screen_fragmentscreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Future.delayed(Duration(seconds: 3)).then((value) {
    //   showAlert(context);
    //
    // });
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        TabsController _controller = Get.find();

        if (_controller.currentIndex.value != 0) {
          _controller.currentIndex.value = 0;
        }
        return Future.value(true);
      },
      child: Scaffold(
          key: controller.homeScaffoldKey,
          body: GestureDetector(
            onTap: () {},
            child: Obx(() => controller.errorOccurred.value
                ? Center(
                    child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: CustomImageView(
                          image: AssetPaths.noresultsfound,
                          height: Get.width * 0.8,
                          width: Get.width * 0.8,
                          fit: BoxFit.cover,
                        )))
                : controller.loading.value
                    ? Center(child: Progressor_indecator())
                    : RefreshIndicator(
                        color: MainColor,
                        onRefresh: controller.refreshFunctions,
                        child: CustomScrollView(
                          controller: controller.ScrollListenerHOME,
                          shrinkWrap: true,
                          slivers: <Widget>[
                            SliverPadding(
                              padding: EdgeInsets.only(
                                  top: AppBar().preferredSize.height +
                                      getTopPadding()),
                              sliver: SliverToBoxAdapter(
                                child: Obx(() {
                                  return BannerWidget(
                                    gridElements: globalController
                                            .homeDataList.value.gridElements ??
                                        [],
                                  );
                                }),
                              ),
                            ),
                            const SliverPadding(
                              padding: EdgeInsets.only(top: 0.0),
                              sliver: SliverToBoxAdapter(
                                child: CategoriesWidget(),
                              ),
                            ),
                            SliverPadding(
                              padding: EdgeInsets.only(top: 16.0),
                              sliver: SliverToBoxAdapter(
                                child: MiniGoldPriceCard(
                                  title: 'Gold (XAU/USD)',
                                  refreshEvery: const Duration(seconds: 58),
                                  fetchPrice: controller.fetchGoldPrice,
                                ),
                              ),
                            ),
                            // SliverToBoxAdapter(
                            //   child: FlashSalesscreen(),
                            // ),

                            SliverToBoxAdapter(
                                child: SpecialList(
                              loading: controller.loading,
                            )
                                // Obx(() {
                                //   return
                                //
                                //     Padding(
                                //     padding:  EdgeInsets.only(bottom:  globalController.loadingMore.value ?0:getSize(45) + getBottomPadding()),
                                //     child: SpecialList(
                                //       loading: controller.loading,
                                //     ),
                                //   );
                                // }),
                                ),

                            SliverToBoxAdapter(
                              child: Obx(
                                () => controller.loadingMore.value
                                    ? Container(
                                        padding: getPadding(top: 10),
                                        height:
                                            getSize(90) + getBottomPadding(),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Ui.circularIndicator(
                                                color: ColorConstant
                                                    .logoFirstColor),
                                          ],
                                        ))
                                    : const SizedBox(),
                              ),
                            ),
                            // Add your other widgets as SliverToBoxAdapter or SliverList
                            // based on their content (static or dynamic)
                          ],
                        )

                        // ListView(
                        //         controller: controller.ScrollListenerHOME,
                        //         shrinkWrap: true,
                        //         physics: AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                        //         children: [
                        //           SingleChildScrollView(
                        //             child: Column(
                        //               crossAxisAlignment: CrossAxisAlignment.center,
                        //               children: <Widget>[
                        //                 if (globalController.homeDataList.value.gridElements != null) BannerWidget(gridElements: globalController.homeDataList.value.gridElements!),
                        //                 const Padding(
                        //                   padding: EdgeInsets.only(top: 16.0),
                        //                   child: CategoriesWidget(),
                        //                 ),
                        //                 Padding(
                        //                   padding: getPadding(top: 8.0),
                        //                   child: FlashSalesscreen(),
                        //                 ),
                        //                 SpecialList(),
                        //                 Obx(
                        //                   () =>
                        //                   globalController.loadingMore.value?
                        //                   SizedBox(height: getSize(55), child: Ui.circularIndicator(color: MainColor)):SizedBox(),
                        //                 )
                        //                 // const BrandsWidget(),
                        //                 // TopStores(),
                        //               ],
                        //             ),
                        //           ),
                        //         ],
                        //       )

                        )),
          ),
          floatingActionButton: globalController.currentStoreId != "1"
              ? Padding(
                  padding: getPadding(bottom: getBottomPadding() + getSize(50)),
                  child: FloatingActionButton(
                    onPressed: () {
                      showStoreAlert(context);
                    },
                    shape: const CircleBorder(),
                    backgroundColor: ColorConstant.logoSecondColor,
                    child: Icon(Icons.store,
                        color: ColorConstant.whiteA700, size: getSize(25)),
                  ))
              : const SizedBox()),
    );
  }

  showStoreAlert(context) {
    AlertDialog alert = AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.white,
      content: Container(
        padding: getPadding(left: 5, right: 5, top: 10, bottom: 10),
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
                "Do you want to return to main store?".tr,
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
            globalController.updateStoreRoute(AppRoutes.tabsRoute);
            prefs?.setString("id", '1');
            globalController.currentStoreId = "1";
            Get.offAllNamed(AppRoutes.tabsRoute);
          },
          behavior: HitTestBehavior.translucent,
          child: Padding(
            padding: getPadding(left: 8, top: 5, right: 8, bottom: 5),
            child: Container(
              width: getHorizontalSize(70),
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
              width: getHorizontalSize(70),
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

  showAlert(context) {
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
                'تحذير'.tr,
                style: TextStyle(
                  color: ColorConstant.logoSecondColor,
                  fontSize: getFontSize(20),
                ),
              ),
            ),
            Directionality(
              textDirection: prefs?.getString("locale") == "en"
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              child: Text(
                'lbl_terms_and_conditions'.tr,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: ColorConstant.black900,
                  fontSize: getFontSize(18),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () => Get.back(),
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
                "تم".tr,
                style: TextStyle(fontSize: getFontSize(16)),
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
}

// class LanguageController extends GetxController {
//   var selectedLanguage = (languages.isNotEmpty) ? languages[0].obs : Language().obs;
//
//   void changeLanguage(Language newLang) {
//     selectedLanguage.value = newLang;
//     update();
//     // Here you can call OnLanguageChanged function to perform any action when language is changed.
//     // OnLanguageChanged(newLang.shortcut);
//   }
// }
