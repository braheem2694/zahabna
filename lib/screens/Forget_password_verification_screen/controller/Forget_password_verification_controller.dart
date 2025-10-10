import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/main.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/routes/app_routes.dart';
import 'package:iq_mall/screens/Phone_verification_screen/controller/Phone_verification_controller.dart';
import 'package:iq_mall/screens/SignIn_screen/controller/SignIn_controller.dart';
import 'dart:convert';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'package:http/http.dart' as http;
import 'package:iq_mall/cores/assets.dart';
import 'dart:async';

import '../../../main.dart';
import '../../../utils/device_data.dart';
import '../../SignUp_screen/controller/SignUp_controller.dart';

class Forget_password_verificationController extends GetxController with WidgetsBindingObserver {
  RxBool loading = false.obs;
  TextEditingController phoneNumberController = new TextEditingController();
  RxBool checking = false.obs;
  RxDouble boxHeight = 100.0.obs;
  ScrollController mainController = ScrollController();
  int unreadednotifications = 0;

  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);

    super.onInit();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    // TODO: implement onClose
    super.onClose();
  }

  @override
  void didChangeMetrics() {
    final value = WidgetsBinding.instance.window.viewInsets.bottom;
    if (value == 0) {
      boxHeight.value = 100.0;

      Future.delayed(Duration(milliseconds: 500)).then((value) {
        mainController.animateTo(
          mainController.position.maxScrollExtent,
          duration: Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
        );
      });

      print('keyboard closed');
    } else {
      mainController.animateTo(
        mainController.position.maxScrollExtent,
        duration: Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );

      boxHeight.value = 10.0;

      print('keyboard opened');
    }
  }

  Future<bool?> SendActivationCode(context) async {
    bool success = false;

    var data = json.encode(await getDeviceInfo());
    Map<String, dynamic> response = await api.getData({
      'country_code': country_code.value.toString().replaceAll('+', ''),
      'phone_number': phoneNumberController.text.toString(),
    }, "users/send-activation-code");

    if (response.isNotEmpty) {
      if (response["succeeded"]) {
        start.value = int.parse(response["resend_time"].toString());
        Get.toNamed(AppRoutes.Phoneverificationscreen, arguments: {'change_password': 'forgetpassword'})!.then((value) {
          loading.value = false;
        });
      } else {
        toaster(context, response["message"]);
        loading.value = false;
        prefs?.setString('logged_in', 'false');
      }
      toaster(context, response["message"]);
      loading.value = false;
      return success;
    } else {
      toaster(context, response["message"]);
      loading.value = false;
    }
  }
}
