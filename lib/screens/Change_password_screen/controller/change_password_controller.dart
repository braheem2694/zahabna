import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/main.dart';
import 'package:iq_mall/widgets/ShWidget.dart';

class Change_password_screen_Controller extends GetxController {
  TextEditingController password = new TextEditingController();
  TextEditingController new_password = new TextEditingController();
  TextEditingController confirm_password = new TextEditingController();
  RxBool loading = false.obs;
  RxBool obscurePasswordText = true.obs;
  RxBool obscureNewPasswordText = true.obs;
  RxBool obscureConfirmPasswordText = true.obs;
  final formKey = GlobalKey<FormState>();


  @override
  void onInit() {
    prefs!.getString('main_color');
    super.onInit();
  }

  bool isValidPassword(String password) {
    // Regular expression for a password of at least 8 characters
    RegExp regex = RegExp(r'^.{8,}$');
    return regex.hasMatch(password);
  }


  void toggleObscurePasswordText() {
    obscurePasswordText.value = !obscurePasswordText.value;
  }

  void toggleObscureNewPasswordText() {
    obscureNewPasswordText.value = !obscureNewPasswordText.value;
  }

  void toggleObscureConfirmPasswordText() {
    obscureConfirmPasswordText.value = !obscureConfirmPasswordText.value;
  }

  Future<bool> ChangePassword(BuildContext context) async {
    bool success = false;
    loading.value = true;

    Map<String, dynamic> response = await api.getData({
      'token': prefs!.getString("token") ?? "",
      'current': password.text.toString(),
      'newPwd': new_password.text.toString(),
    }, "users/change-user-password");

    if (response.isNotEmpty) {
      success = response["succeeded"];
      if (success) {
        toaster(context, response["message"].toString().tr);
        Get.back();

      }else{
        toaster(context, response["message"].toString().tr);
      }

      loading.value = false;
    }
    loading.value = false;
    return success;
  }
}
