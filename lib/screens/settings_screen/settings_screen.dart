import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../cores/language_model.dart';
import '../../cores/math_utils.dart';
import '../../main.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_style.dart';
import '../../utils/ShColors.dart';
import '../../widgets/CommonWidget.dart';
import '../../widgets/ui.dart';
import '../ProductDetails_screen/widgets/AppBar.dart';
import 'controller/settings_controller.dart';
import 'package:flutter/material.dart';

import 'models/settings_model.dart';

class SettingsScreen extends GetWidget<SettingsController> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: ColorConstant.gray100,
            appBar:

            AppBar(
              backgroundColor: Colors.white,
              title: Text('Languages'.tr),
              leading: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Padding(
                  padding: EdgeInsets.all(15.0), // You can adjust the padding value
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
                ),
              )
              ,
            ),

            body: Obx(() => !controller.loading.value
                ? ListView(

                    children: [
                        // Padding(
                        //     padding: getPadding(left: 15, top: 28, right: 15),
                        //     child: Row(
                        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //         crossAxisAlignment: CrossAxisAlignment.center,
                        //         mainAxisSize: MainAxisSize.max,
                        //         children: [
                        //           Text("lbl_notifications".tr,
                        //               overflow: TextOverflow.ellipsis,
                        //               textAlign: TextAlign.left,
                        //               style: AppStyle.txtPoppinsSemiBold16.copyWith(height: 1.50,color: ColorConstant.black900)),
                        //           Obx(() => Switch(
                        //                 value: controller.enableNot.value,
                        //                 inactiveTrackColor: ColorConstant.unitBackground,
                        //                 activeTrackColor: ColorConstant.gray300,
                        //                 activeColor: ColorConstant.mainColor,
                        //                 inactiveThumbColor: ColorConstant.gray500,
                        //                 onChanged: (value) {
                        //                   controller.enableNot.value = !controller.enableNot.value;
                        //                   prefs.setString("notifications", value ? "1" : "0");
                        //                 },
                        //               ))
                        //         ])),
                        // Container(
                        //     height: getVerticalSize(1.00),
                        //     width: getHorizontalSize(360.00),
                        //     margin: getMargin(left: 15, top: 17, right: 15),
                        //     decoration: BoxDecoration(color: ColorConstant.gray500)),
                        Padding(
                            padding: getPadding(left: 15, top: 16, right: 15),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                      padding: getPadding(top: 4),
                                      child: Text("Languages".tr,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[700],
                                          ).copyWith(height: 1.50,color: ColorConstant.black900))),
                                  Padding(
                                      padding: getPadding(left: 8, top: 10, right: 10, bottom: 1),
                                      child: Text(controller.selectedLanguage.value.languageName?.tr ?? "",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[700],
                                          )))
                                ])),
                        ListView(
                          shrinkWrap: true,
                          primary: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                              decoration: Ui.getBoxDecoration().copyWith(color: Colors.white),
                              child: Column(
                                children: List.generate(languages.length, (index) {

                                  return RadioListTile<String>(
                                    value: languages[index].shortcut!,

                                    groupValue: controller.selectedLanguage.value.shortcut,
                                    activeColor: MainColor,
                                    onChanged: (String? value) {
                                      if (kDebugMode) {
                                        print(value.toString());
                                      }
                                      controller.selectedLanguage.value = languages[index];
                                      Get.updateLocale(Locale(value!));
                                      // controller.locale = Locale(value);
                                      prefs?.setString('locale', value);
                                      Get.back();
                                    },
                                    title: Text(
                                      languages[index].languageName!.tr,
                                      style: Get.textTheme.bodyMedium,
                                    ),
                                  );

                                }).toList(),
                              ),
                            )
                          ],
                        ),
                        Container(
                            height: getVerticalSize(1.00),
                            width: getHorizontalSize(360.00),
                            margin: getMargin(left: 15, top: 14, right: 15, bottom: 5),
                            decoration: BoxDecoration(color: ColorConstant.gray500))
                      ])
                : Progressor_indecator())));
  }


}
