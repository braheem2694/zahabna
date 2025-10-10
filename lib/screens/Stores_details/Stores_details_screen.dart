import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iq_mall/routes/app_routes.dart';
import 'package:iq_mall/screens/Stores_details/widgets/store_category_widget.dart';
import 'package:iq_mall/screens/Stores_screen/widgets/LocationWidget.dart';
import 'package:iq_mall/widgets/custom_image_view.dart';
import 'package:iq_mall/widgets/ui.dart';
import 'package:smooth_page_indicator/src/effects/scrolling_dots_effect.dart';
import 'package:smooth_page_indicator/src/smooth_page_indicator.dart';

import '../../cores/math_utils.dart';
import '../../main.dart';
import '../../models/HomeData.dart';
import '../../models/functions.dart';
import '../../utils/ShColors.dart';
import '../../utils/ShImages.dart';
import '../../widgets/ViewAllButton.dart';
import '../../widgets/html_widget.dart';
import '../Home_screen_fragment/widgets/social_media_item.dart';
import '../Stores_screen/controller/Stores_screen_controller.dart';
import '../Stores_screen/widgets/work_time_widget.dart';
import 'controller/store_detail_controller.dart';

class StoreDetails extends StatelessWidget {
  StoreDetailController controller = Get.put(StoreDetailController());

  StoreDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (controller.isEdit.value && controller.store.value.ownerId.toString() == prefs?.getString("user_id")) {
          showAlert(context);
          return false;
        }
        else {
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFf5f5f5),
        appBar: AppBar(
          leading: Ui.backArrowIcon(
            iconColor: ColorConstant.logoFirstColor,
            onTap: () {
              if (controller.isEdit.value && controller.store.value.ownerId.toString() == prefs?.getString("user_id")) {
                showAlert(context);
              } else {
                Get.back();
              }
            },
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Column(
            children: [
              Text(
                controller.store.value.store_name ?? '',
                style: TextStyle(
                  color: ColorConstant.logoFirstColor,
                  fontSize: getFontSize(20),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Obx(() {
                return controller.isOwner.value
                    ? Container(
                        margin: EdgeInsets.only(top: 4),
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: ColorConstant.logoSecondColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "Owner",
                          style: TextStyle(
                            color: ColorConstant.logoSecondColor,
                            fontSize: getFontSize(12),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : SizedBox();
              }),
            ],
          ),
          actions: [
            Obx(() {
              return controller.isOwner.value
                  ? IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: ColorConstant.logoSecondColor,
                        size: getSize(24),
                      ),
                      onPressed: () {
                        Get.toNamed(AppRoutes.myStore, arguments: {
                          'store': controller.store.value,
                        });
                      },
                    )
                  : SizedBox();
            }),
            
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Container(
              height: 1,
              color: Colors.grey[200],
            ),
          ),
        ),
        body: Obx(() {
          return controller.loading.value
              ? Ui.circularIndicator(color: ColorConstant.logoFirstColor)
              : SingleChildScrollView(
            padding: EdgeInsets.only(top: 8, bottom: getBottomPadding() + getSize(45)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    children: [
                      Obx(
                            () =>
                        controller.loading.value
                            ? SizedBox(height: controller.categories.isNotEmpty ? getVerticalSize(200) : 0, child: Ui.circularIndicator(width: 40, height: 40, color: ColorConstant.logoFirstColor))
                            :
                        // controller.store.value.storeSliderImages!.isNotEmpty
                        //     ? ClipRRect(
                        //   borderRadius: BorderRadius.circular(10),
                        //   child: CarouselSlider.builder(
                        //     options: CarouselOptions(
                        //       height: controller.categories.isNotEmpty ? getVerticalSize(200) : 0,
                        //       initialPage: 0,
                        //       autoPlay: true,
                        //       viewportFraction: 1,
                        //       animateToClosest: true,
                        //       enlargeCenterPage: true,
                        //       enableInfiniteScroll: false,
                        //       scrollDirection: Axis.horizontal,
                        //       onPageChanged: (index, reason) {
                        //         controller.sliderIndex.value = index;
                        //       },
                        //     ),
                        //     itemCount: controller.store.value.storeSliderImages?.length,
                        //     itemBuilder: (context, index, realIndex) {
                        //       StoreSliderImage model = controller.store.value.storeSliderImages![index];
                        //
                        //       return Padding(
                        //         padding: getPadding(left: 8.0, right: 8),
                        //         child: GestureDetector(
                        //           behavior: HitTestBehavior.translucent,
                        //           onTap: () {
                        //             Uuid uuid = Uuid();
                        //             String userID = uuid.v4();
                        //             // Get.toNamed(AppRoutes.newsDetails, arguments: model, parameters: {"tag": "$userID${model.id}", "fromKey": 'news_hor'});
                        //           },
                        //           child: sliderItem(
                        //             model,
                        //           ),
                        //         ),
                        //       );
                        //     },
                        //   ),
                        // )
                        //     :
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            ClipRRect(
                              child: CustomImageView(
                                image: controller.store.value.main_image,
                                height: getVerticalSize(180),
                                placeHolder: AssetPaths.placeholder,
                                width: getHorizontalSize(390),
                                fit: BoxFit.cover,
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                            Obx(() {
                              return controller.store.value.ownerId.toString() == prefs?.getString("user_id")
                                  ? Padding(
                                padding: getPadding(right: 8.0, top: 8.0),
                                child: InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      _pickMainImage();
                                      // updateWorkingTime();
                                    },
                                    child: Obx(() {
                                      return AnimatedSwitcher(
                                        duration: const Duration(milliseconds: 200),
                                        transitionBuilder: (Widget child, Animation<double> animation) {
                                          return ScaleTransition(scale: animation, child: child);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.white,
                                            border: Border.all(
                                              color: ColorConstant.logoSecondColor,
                                            ),
                                          ),
                                          padding: getPadding(all: 2),
                                          child: Icon(
                                            Icons.image,
                                            color: ColorConstant.logoSecondColor,
                                            size: getSize(25),
                                          ),
                                        ),
                                      );
                                    })),
                              )
                                  : SizedBox();
                            })
                          ],
                        ),
                      ),
                      Padding(
                        padding: getPadding(bottom: 5.0, left: 10, top: 10),
                        child: Obx(
                              () =>
                          controller.loading.value
                              ? SizedBox()
                              : controller.storeImages.length > 1
                              ? Container(
                            height: getVerticalSize(9),
                            margin: getPadding(bottom: 5),
                            child: AnimatedSmoothIndicator(
                              activeIndex: controller.sliderIndex.value,
                              count: controller.store.value.storeSliderImages!.length > 5 ? 5 : controller.storeImages.length,
                              axisDirection: Axis.horizontal,
                              effect: ScrollingDotsEffect(
                                spacing: 7,
                                activeDotColor: ColorConstant.logoSecondColor,
                                dotColor: ColorConstant.logoFirstColor,
                                dotHeight: 6,
                                dotWidth: 6,
                              ),
                            ),
                          )
                              : SizedBox(),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                    height: controller.categories.isNotEmpty ? Get.height * 0.17 : 0,
                    child: Obx(() {
                      return controller.loading.value
                          ? SizedBox()
                          : ListView.builder(
                          padding: getPadding(left: 8, top: 11, bottom: 0),
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: controller.categories.length,
                          itemBuilder: (context, index) {
                            Category model = controller.categories[index];
                            return Padding(
                              padding: getPadding(right: 10.0),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  var f = {
                                    "categories": [
                                      model.id.toString(),
                                    ],
                                  };

                                  String jsonString = jsonEncode(f);
                                  Get.toNamed(AppRoutes.Filter_products, arguments: {
                                    'title': model.categoryName,
                                    'id': model.id,
                                    'type': jsonString,
                                    'store_id': controller.store.value.id.toString(),
                                  }, parameters: {
                                    'tag': "${int.parse(model.id.toString())}:${model.categoryName.toString()}"
                                  })?.then((value) async {});
                                },
                                child: storeCategory(model: model),
                              ),
                            );
                          });
                    })),
                SocialMediaScreen(
                  sideMenu: false,
                  padding: getPadding(
                    left: 8,
                    right: 8,
                  ),
                  isStore: true,
                ),
                Padding(
                  padding: getPadding(left: 12.0, right: 12),
                  child: Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: ColorConstant.black900.withOpacity(0.15),
                        blurRadius: 4.0,
                        spreadRadius: 0.0,
                        offset: const Offset(0, 3.0),
                      )
                    ], color: Colors.white, borderRadius: BorderRadius.circular(5)),
                    padding: getPadding(all: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: ColorConstant.logoSecondColor,
                          size: getSize(25),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            "${controller.store.value.address}",
                            style: TextStyle(fontSize: getFontSize(18)),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Obx(() {
                  return Padding(
                    padding: getPadding(
                      left: 12.0,
                      right: 12,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: LocationWidget(
                        store: controller.store.value,
                      ),
                    ),
                  );
                }),
                Obx(() {
                  return controller.store.value.storeWorkingDays!.isEmpty
                      ? SizedBox(
                    height: 10,
                  )
                      : Padding(
                    padding: getPadding(left: 12.0, right: 12, top: 10, bottom: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: ExpansionPanelList(
                        dividerColor: ColorConstant.whiteA700,
                        elevation: 2,
                        expansionCallback: (int index, bool isExpanded) {
                          controller.toggleExpand(isExpanded);
                        },
                        children: List<ExpansionPanel>.generate(1, (int mainIndex) {
                          return ExpansionPanel(
                            canTapOnHeader: true,
                            backgroundColor: ColorConstant.whiteA700,
                            headerBuilder: (BuildContext context, bool isExpanded) {
                              return Padding(
                                padding: getPadding(left: 8.0),
                                child: SizedBox(
                                  width: getHorizontalSize(344),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.calendar_month,
                                        color: ColorConstant.logoSecondColor,
                                        size: getSize(25),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      RichText(
                                          text: TextSpan(children: [
                                            TextSpan(text: "Work Days".tr, style: TextStyle(fontSize: getFontSize(18), color: ColorConstant.logoFirstColor)),
                                          ]),
                                          textAlign: TextAlign.left),
                                      Spacer(),
                                      Obx(() {
                                        return controller.store.value.ownerId.toString() == prefs?.getString("user_id")
                                            ? InkWell(
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () {
                                              updateWorkingTime();
                                            },
                                            child: Obx(() {
                                              return AnimatedSwitcher(
                                                duration: const Duration(milliseconds: 200),
                                                transitionBuilder: (Widget child, Animation<double> animation) {
                                                  return ScaleTransition(scale: animation, child: child);
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    border: Border.all(
                                                      color: ColorConstant.logoSecondColor,
                                                    ),
                                                  ),
                                                  padding: getPadding(all: 2),
                                                  child: Icon(
                                                    controller.isEdit.value ? Icons.check : Icons.edit,
                                                    color: ColorConstant.logoSecondColor,
                                                    size: getSize(25),
                                                  ),
                                                ),
                                              );
                                            }))
                                            : SizedBox();
                                      })
                                    ],
                                  ),
                                ),
                              );
                            },
                            body: ListView(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                Padding(
                                  padding: getPadding(bottom: 12.0),
                                  child: SizedBox(
                                      height: Get.height * 0.17,
                                      child: Obx(() {
                                        return controller.loading.value
                                            ? SizedBox()
                                            : ListView.builder(
                                            padding: getPadding(left: 8, top: 11),
                                            scrollDirection: Axis.horizontal,
                                            physics: const BouncingScrollPhysics(),
                                            itemCount: controller.store.value.storeWorkingDays?.length,
                                            itemBuilder: (context, index) {
                                              controller.store.value.storeWorkingDays![index];

                                              return Padding(
                                                padding: getPadding(right: 10.0),
                                                child: InkWell(
                                                  splashColor: Colors.transparent,
                                                  focusColor: Colors.transparent,
                                                  highlightColor: Colors.transparent,
                                                  onTap: () {},
                                                  child: Stack(
                                                    alignment: Alignment.topCenter,
                                                    children: [
                                                      storeWorkTime(index: index),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      })),
                                ),
                              ],
                            ),
                            isExpanded: controller.isExpanded.value,
                          );
                        }).toList(),
                      ),
                    ),
                  );
                }),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Ui.launchWhatsApp(controller.store.value.phone_number.toString(), controller.store.value.store_name ?? '');
                  },
                  child: Padding(
                    padding: getPadding(left: 12.0, right: 12),
                    child: Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: ColorConstant.black900.withOpacity(0.15),
                          blurRadius: 4.0,
                          spreadRadius: 0.0,
                          offset: const Offset(0, 3.0),
                        )
                      ], color: Colors.white, borderRadius: BorderRadius.circular(5)),
                      padding: getPadding(all: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.phone_android,
                            color: ColorConstant.logoSecondColor,
                            size: getSize(25),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            controller.store.value.phone_number.toString(),
                            style: TextStyle(fontSize: getFontSize(18)),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: getPadding(left: 12.0, right: 12),
                  child: Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: ColorConstant.black900.withOpacity(0.15),
                        blurRadius: 4.0,
                        spreadRadius: 0.0,
                        offset: const Offset(0, 3.0),
                      )
                    ], color: Colors.white, borderRadius: BorderRadius.circular(5)),
                    padding: getPadding(all: 8),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "About Store",
                              style: TextStyle(fontSize: getFontSize(18), color: ColorConstant.logoSecondColor),
                            )
                          ],
                        ),
                        Padding(
                          padding: getPadding(top: 12),
                          child: Container(
                              padding: getPadding(all: 5),
                              width: Get.width,
                              child: HtmlWidget(
                                data: controller.store.value.description,
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
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
              textDirection: prefs?.getString("locale") == "en" ? TextDirection.ltr : TextDirection.rtl,
              child: Text(
                'تحذير'.tr,
                style: TextStyle(
                  color: ColorConstant.logoSecondColor,
                  fontSize: getFontSize(20),
                ),
              ),
            ),
            Directionality(
              textDirection: prefs?.getString("locale") != "ar" ? TextDirection.ltr : TextDirection.rtl,
              child: Text(
                "Do you want to save your changes?".tr,
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
          onTap: () {
            updateWorkingTime();
            Get.back();
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
                color: ColorConstant.logoSecondColor,
              ),
              alignment: Alignment.center,
              child: Text(
                "Yes".tr,
                style: TextStyle(fontSize: getFontSize(16)),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.back();
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
                color: ColorConstant.logoSecondColor,
              ),
              alignment: Alignment.center,
              child: Text(
                "No".tr,
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

  // showImageAlert(context) {
  //   AlertDialog alert = AlertDialog(
  //     contentPadding: EdgeInsets.zero,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(10.0),
  //     ),
  //     backgroundColor: Colors.white,
  //     content: Container(
  //       padding: getPadding(all: 10),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(10.0),
  //         border: Border.all(color: Colors.white),
  //       ),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min, // Adjust the height to fit content
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: <Widget>[
  //           Directionality(
  //             textDirection: prefs?.getString("locale") == "en" ? TextDirection.ltr : TextDirection.rtl,
  //             child: Text(
  //               'تحذير'.tr,
  //               style: TextStyle(
  //                 color: ColorConstant.logoSecondColor,
  //                 fontSize: getFontSize(20),
  //               ),
  //             ),
  //           ),
  //           Directionality(
  //             textDirection: prefs?.getString("locale") != "ar" ? TextDirection.ltr : TextDirection.rtl,
  //             child: Text(
  //               "Do you want to save your image?".tr,
  //               textAlign: TextAlign.justify,
  //               style: TextStyle(
  //                 color: ColorConstant.black900,
  //                 fontSize: getFontSize(18),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //     actions: [
  //       GestureDetector(
  //         onTap: () async {
  //           if (!controller.savingImage.value) {
  //             controller.savingImage.value = true;
  //             await controller.uploadImage("141", controller.store.value.id, controller.store.value.main_image
  //                 ?.split("/")
  //                 .last, controller.store.value.main_image, 1);
  //
  //             if (globalController.currentStoreId == controller.store.value.id) {
  //               prefs!.setString('main_image', controller.store.value.main_image ?? '');
  //               globalController.updateStoreImage("storedetails");
  //               StoreController storeController = Get.find(tag: controller.args['tag']);
  //
  //               // storeController.stores.firstWhere((element) => element.value.id==controller.store.value.id,).update((val) => val?..main_image =  controller.store.value.main_image);
  //               storeController.stores
  //                   .firstWhere(
  //                     (element) => element.value.id == controller.store.value.id,
  //               )
  //                   .value
  //                   .main_image = controller.store.value.main_image;
  //             }
  //             controller.savingImage.value = false;
  //
  //             Get.back();
  //             Get.back();
  //           }
  //         },
  //         behavior: HitTestBehavior.translucent,
  //         child: Padding(
  //           padding: getPadding(left: 8, top: 5, right: 8, bottom: 5),
  //           child: Container(
  //             width: 100,
  //             height: 40,
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(10),
  //               color: ColorConstant.logoSecondColor,
  //             ),
  //             alignment: Alignment.center,
  //             child: Obx(() {
  //               return !controller.savingImage.value
  //                   ? Text(
  //                 "Yes".tr,
  //                 style: TextStyle(fontSize: getFontSize(16)),
  //               )
  //                   : Ui.circularIndicator();
  //             }),
  //           ),
  //         ),
  //       ),
  //       GestureDetector(
  //         onTap: () {
  //           prefs!.setString('main_image', controller.tempStoreImage);
  //           controller.store.value.main_image = controller.tempStoreImage;
  //           globalController.updateStoreImage("storedetails");
  //           Get.back();
  //           Get.back();
  //         },
  //         behavior: HitTestBehavior.translucent,
  //         child: Padding(
  //           padding: getPadding(left: 8, top: 5, right: 8, bottom: 5),
  //           child: Container(
  //             width: 100,
  //             height: 40,
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(10),
  //               color: ColorConstant.logoSecondColor,
  //             ),
  //             alignment: Alignment.center,
  //             child: Text(
  //               "No".tr,
  //               style: TextStyle(fontSize: getFontSize(16)),
  //             ),
  //           ),
  //         ),
  //       )
  //     ],
  //     actionsAlignment: MainAxisAlignment.spaceAround,
  //   );
  //
  //   showDialog(
  //     context: Get.context!,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }

  updateWorkingTime() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.isEdit.value = !controller.isEdit.value;
      if (!controller.isEdit.value) {
        controller.workingTime = jsonEncode(
          controller.store.value.storeWorkingDays!
              .map((workDay) => workDay.toJson()) // Convert each object to JSON
              .toList(),
        );
        controller.saveWorkingTime();

        print(controller.workingTime);
      }
    });
  }

  Future<void> _pickMainImage() async {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        height: getVerticalSize(120),
        width: Get.width,
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                function.SingleImagePicker(ImageSource.gallery).then((value) async {
                  if (value != null) {
                    Get.dialog(
                      Center(
                        child: Material(
                          color: Colors.transparent, // needed to avoid yellow underline
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(getHorizontalSize(16.0)),
                            ),
                            constraints: BoxConstraints(
                              maxWidth: 300,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Are you sure you want to change the image?".tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: getFontSize(14),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          Get.back();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: ColorConstant.logoFirstColor.withOpacity(0.5),
                                          ),
                                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "No".tr,
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () async {
                                          controller.store.value.main_image = value.path;
                                          controller.store.update((val) => val?..main_image = value.path);
                                          if (!controller.savingImage.value) {
                                            controller.savingImage.value = true;
                                            await controller.uploadImage("141", controller.store.value.id, controller.store.value.main_image
                                                ?.split("/")
                                                .last, controller.store.value.main_image, 1);

                                            if (globalController.currentStoreId == controller.store.value.id) {
                                              prefs!.setString('main_image', controller.store.value.main_image ?? '');
                                              globalController.updateStoreImage("storedetails");
                                              // StoreController storeController = Get.find(tag: controller.args['tag']);
                                              //
                                              // // storeController.stores.firstWhere((element) => element.value.id==controller.store.value.id,).update((val) => val?..main_image =  controller.store.value.main_image);
                                              // storeController.stores
                                              //     .firstWhere(
                                              //       (element) => element.value.id == controller.store.value.id,
                                              // )
                                              //     .value
                                              //     .main_image = controller.store.value.main_image;
                                            }
                                            controller.savingImage.value = false;
                                          }
                                          Get.back();
                                          Get.back();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: ColorConstant.logoFirstColor,
                                          ),
                                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                          alignment: Alignment.center,
                                          child: Obx(() {
                                            return
                                              controller.savingImage.value?Ui.circularIndicator():
                                              Text(
                                              "Yes".tr,
                                              style: TextStyle(color: Colors.white),
                                            );
                                          }),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      barrierDismissible: true,
                      barrierColor: Colors.black.withOpacity(0.3),
                    );


                    // Get.dialog(AlertDialog(
                    //   title: Text("Are you sure you want to change the image?".tr),
                    //   content: Text("This will change the image for your store".tr),
                    //   actions: [
                    //     TextButton(
                    //       onPressed: () {
                    //         Get.back();
                    //       },
                    //       child: Text("Cancel".tr),
                    //     ),
                    //     TextButton(
                    //       onPressed: () async {
                    //         controller.store.value.main_image = value.path;
                    //         controller.store.update((val) => val?..main_image = value.path);
                    //         if (!controller.savingImage.value) {
                    //           controller.savingImage.value = true;
                    //           await controller.uploadImage("141", controller.store.value.id, controller.store.value.main_image
                    //               ?.split("/")
                    //               .last, controller.store.value.main_image, 1);
                    //
                    //           if (globalController.currentStoreId == controller.store.value.id) {
                    //             prefs!.setString('main_image', controller.store.value.main_image ?? '');
                    //             globalController.updateStoreImage("storedetails");
                    //             // StoreController storeController = Get.find(tag: controller.args['tag']);
                    //             //
                    //             // // storeController.stores.firstWhere((element) => element.value.id==controller.store.value.id,).update((val) => val?..main_image =  controller.store.value.main_image);
                    //             // storeController.stores
                    //             //     .firstWhere(
                    //             //       (element) => element.value.id == controller.store.value.id,
                    //             // )
                    //             //     .value
                    //             //     .main_image = controller.store.value.main_image;
                    //           }
                    //           controller.savingImage.value = false;
                    //         }
                    //         Get.back();
                    //       },
                    //       child: Obx(() {
                    //         return
                    //           controller.savingImage.value?SizedBox(
                    //
                    //               width: 20,
                    //               height: 20,
                    //               child: Ui.circularIndicator()):
                    //           Text("Yes".tr);
                    //       }),
                    //     ),
                    //   ],
                    // ));
                  }
                });
              },
              child: Text(
                "Select Image",
                style: TextStyle(color: Colors.black),
              ),
            ),
            Divider(
              color: ColorConstant.black900,
            ),
            TextButton(
              onPressed: () {
                function.SingleImagePicker(ImageSource.camera).then((value) async {
                  if (value != null) {
                    Get.dialog(
                      Center(
                        child: Material(
                          color: Colors.transparent, // needed to avoid yellow underline
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(getHorizontalSize(16.0)),
                            ),
                            constraints: BoxConstraints(
                              maxWidth: 300,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Are you sure you want to change the image?".tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: getFontSize(14),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          Get.back();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: ColorConstant.logoFirstColor.withOpacity(0.5),
                                          ),
                                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "No".tr,
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () async {
                                          controller.store.value.main_image = value.path;
                                          controller.store.update((val) => val?..main_image = value.path);
                                          if (!controller.savingImage.value) {
                                            controller.savingImage.value = true;
                                            await controller.uploadImage("141", controller.store.value.id, controller.store.value.main_image
                                                ?.split("/")
                                                .last, controller.store.value.main_image, 1);

                                            if (globalController.currentStoreId == controller.store.value.id) {
                                              prefs!.setString('main_image', controller.store.value.main_image ?? '');
                                              globalController.updateStoreImage("storedetails");
                                              // StoreController storeController = Get.find(tag: controller.args['tag']);
                                              //
                                              // // storeController.stores.firstWhere((element) => element.value.id==controller.store.value.id,).update((val) => val?..main_image =  controller.store.value.main_image);
                                              // storeController.stores
                                              //     .firstWhere(
                                              //       (element) => element.value.id == controller.store.value.id,
                                              // )
                                              //     .value
                                              //     .main_image = controller.store.value.main_image;
                                            }
                                            controller.savingImage.value = false;
                                          }
                                          Get.back();
                                          Get.back();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: ColorConstant.logoFirstColor,
                                          ),
                                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                          alignment: Alignment.center,
                                          child: Obx(() {
                                            return
                                              controller.savingImage.value?Ui.circularIndicator():
                                              Text(
                                                "Yes".tr,
                                                style: TextStyle(color: Colors.white),
                                              );
                                          }),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      barrierDismissible: true,
                      barrierColor: Colors.black.withOpacity(0.3),
                    );
                  }
                });
              },
              child: Text(
                "Take Photo",
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
    );
  }
}
