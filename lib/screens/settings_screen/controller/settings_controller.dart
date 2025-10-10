import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../cores/language_model.dart';
import '../../../main.dart';
import '../../../routes/app_routes.dart';
import '../models/settings_model.dart';

class SettingsController extends GetxController {

  RxBool enableNot = true.obs;
  RxBool deleteAccountSwitch = false.obs;
  RxBool loading = true.obs;
  RxBool deletingAccount = false.obs;
  // Locale locale = Get.find<Locale>();

  Rx<Language> selectedLanguage = Language().obs;
  RxList<Language> appLanguages = <Language>[].obs;
  Language? temp;
  Locale locale = Get.put(Locale('en'));

  @override
  void onReady() {
    try {
      if (kDebugMode) {
        print(locale.languageCode);
      }

      temp = languages.firstWhere(
              (element) => element.shortcut == (prefs?.getString("locale")??locale.languageCode),
          orElse: () => languages[0]);
      selectedLanguage.value = temp ?? languages[0];


      for (int i = 0; i < languages.length; i++) {
        Language? temp2;
        try {
          temp2 = languages.firstWhere(
                (element) => element.shortcut == languages[i],
          );
        } catch (_) {}
        if (temp2 != null) {
          appLanguages.add(temp2);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    loading.value = false;

    super.onReady();
    update();
    refresh();
  }
  // Future<bool> deleteAccount() async {
  //
  //   bool success = false;
  //   deletingAccount.value=true;
  //   deleteAccountSwitch.value=true;
  //   await api.getData({
  //     'token':prefs.getString("token")??"",
  //   }, "users/disable-user").then((value) async {
  //     deletingAccount.value=false;
  //
  //     success=value[0]["succeeded"];
  //     // teachersModelObj.value = Teacher.fromJson(value[0]);
  //     deletingAccount.value=false;
  //     if (success) {
  //       Ui.flutterToast(
  //           value[0]["message"].toString().tr,
  //           Toast.LENGTH_LONG,
  //           ColorConstant.mainColor,
  //           ColorConstant.white);
  //       await FirebaseMessaging.instance.deleteToken();
  //       globalController.updateUserState(false,"set-time-spent");
  //       prefs.setString("workThrough", "1");
  //       Get.offAllNamed(AppRoutes.loginScreen);
  //
  //     } else {
  //       deleteAccountSwitch.value=false;
  //
  //       Ui.flutterToast(
  //           value[0]["message"].toString().tr,
  //           Toast.LENGTH_LONG,
  //           ColorConstant.redA700,
  //           ColorConstant.white);
  //     }
  //
  //     if (kDebugMode) {
  //       print("s");
  //
  //     }
  //   });
  //   return
  //     success;
  // }


  @override
  void onClose() {
    super.onClose();
  }
}
