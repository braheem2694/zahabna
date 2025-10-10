import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/cores/assets.dart';
import 'package:iq_mall/main.dart';
import 'package:iq_mall/screens/HomeScreenPage/ShHomeScreen.dart';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

import '../../../getxController.dart';
class EmailScreenController extends GetxController {
  var emailCont = TextEditingController();
  var descriptionCont = TextEditingController();
  RxBool sending = false.obs;
  @override
  void onInit() {
      emailCont.text = settings[0]['contact_email'];
    super.onInit();
  }
  Future send_email() async {
      sending.value = true;
    var url = con! + "product/send-email-contact";
    final http.Response response = await http.post(
      Uri.parse(url),
      body: {
        'user_id': prefs?.getString('user_id').toString(),
        'message': descriptionCont.text.toString(),
      },
    );
    if (response.statusCode == 200) {
      if (json.decode(response.body) == 0) {
        toaster(Get.context!, 'ERROR');
      } else if (json.decode(response.body) == 1) {
        Get.back();
        toaster(Get.context!, 'email sent successfully');
      } else {
        toaster(Get.context!, 'Something went wrong try again later');
      }
        sending.value = false;
    } else {
        sending.value = false;
      toaster(Get.context!, 'Connection error, try again or contact us please');
    }
  }
}

