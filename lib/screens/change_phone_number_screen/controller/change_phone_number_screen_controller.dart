import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/main.dart';
import 'package:iq_mall/cores/assets.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/screens/HomeScreenPage/ShHomeScreen.dart';
import 'package:iq_mall/screens/SignIn_screen/controller/SignIn_controller.dart';
import 'package:iq_mall/widgets/CommonWidget.dart';
import 'package:http/http.dart' as http;
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/utils/ShImages.dart';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'dart:convert';

import '../../../routes/app_routes.dart';
class change_phone_number_Controller extends GetxController {

  RxBool loading = false.obs;
   TextEditingController phone_number = new TextEditingController();
  @override
  void onInit() {

    super.onInit();
  }
  changePhoneNumber() async {
      loading.value = true;
    var url ="${con!}users/change-phone-number";
    final http.Response response = await http.post(
      Uri.parse(url),
      body: {
        'phone_number': country_code! + phone_number.text.toString(),
        'user_id': prefs?.getString('user_id'),
      },
    );
      loading.value = false;
    if (json.decode(response.body) == 1) {
      toaster(Get.context!, "Phone Number Changed Successfully".tr);
      prefs?.setString(
          'phone_number', country_code+ phone_number.text.toString());
      Get.off(AppRoutes.Stores, arguments: {"tag":"change_pass"},);

    } else if (json.decode(response.body) == 2) {
      toaster(Get.context!, "Phone number is already related to an account".tr);
    } else if (json.decode(response.body) == 0) {
      toaster(Get.context!, "User not found".tr);
        loading.value = false;
    } else {
      toaster(
          Get.context!,
          "error occurred, please contact us if you think its a server error"
              .tr
              .tr);

        loading.value = false;

    }
  }

}
