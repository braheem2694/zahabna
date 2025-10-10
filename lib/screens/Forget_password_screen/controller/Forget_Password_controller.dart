import 'dart:ffi';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/screens/Phone_verification_screen/controller/Phone_verification_controller.dart';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'dart:convert';
import '../../../main.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/device_data.dart';
import '../../SignIn_screen/controller/SignIn_controller.dart';

class Forget_Password_Controller extends GetxController with WidgetsBindingObserver {
  TextEditingController new_password = new TextEditingController();
  TextEditingController confirm_password = new TextEditingController();
  RxBool loading = false.obs;
  RxBool obscurePass = true.obs;
  RxBool obscureConfPass = true.obs;
  Color? iconColor = Colors.white;
  final formKey = GlobalKey<FormState>();
  var phone_number;
  ScrollController mainController = ScrollController();
  Rx<TextEditingController> otpController = TextEditingController().obs;

  RxString code="".obs;
  RxString countryCode="".obs;
  RxDouble boxHeight = 150.0.obs;

  @override
  void onInit() {
    final arguments = Get.arguments;
    phone_number = arguments['phone_number'];
    code.value = arguments['otp_code'];
    countryCode.value = arguments['country_code'];
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

  }

  @override
  void onReady() {

    // TODO: implement onReady
    super.onReady();
  }
  @override
  void onClose() {
    mainController.dispose();
    WidgetsBinding.instance.removeObserver(this);

    // TODO: implement onClose
    super.onClose();
  }


  @override
  void didChangeMetrics() {
    final value = WidgetsBinding.instance.window.viewInsets.bottom;
    if (value == 0) {
      boxHeight.value=150.0;

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

      boxHeight.value=10.0;

      print('keyboard opened');
    }
  }

  Future<bool?> ForgetPassword() async {
    bool success = false;
    loading.value = true;
    try {
      Map<String, dynamic> response = await api.getData({
        'password': new_password.text.toString(),
        'phone_number': phone_number.toString(),
        'country_code': countryCode.value.replaceAll('+', '').toString(),
        'code': code.value.toString(),
      }, "users/reset-password");

      if (response.isNotEmpty) {
        success = response["succeeded"];
        if (success) {
          if (success) {
            Get.offAndToNamed(AppRoutes.SignIn);
            toaster(Get.context!, 'message');
            prefs?.setString('logged_in', 'true');
          } else {
            loading.value = false;

          }
          loading.value = true;
          return success;
        } else {
          loading.value = false;
          // toaster(Get.context!, 'Error occurred');
        }
      } else {
        loading.value = false;
        // toaster(Get.context!, 'Error Occurred');
      }
    } catch (e) {
      loading.value = false;

      print(e);
    }
    return null;
  }

  void togglePass() {
    obscurePass.value = !obscurePass.value;
    update();
    refresh();
  }

  void toggleConfPass() {
    obscureConfPass.value = !obscureConfPass.value;
    update();
    refresh();
  }
}
