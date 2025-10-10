import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/cores/assets.dart';
import 'package:iq_mall/main.dart';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
class ReportsAndBugsController extends GetxController {
  TextEditingController text = new TextEditingController();
  var focusNode = FocusNode();
  RxInt value = RxInt(-1);
  RxBool loading = false.obs;
  @override
  void onInit() {
    Future.delayed(Duration(milliseconds: 500), () {
      FocusScope.of(Get.context!).requestFocus(focusNode);

    });
    super.onInit();
  }
  Future<int?> Insertdata() async {
      loading.value = true;
    var url =con! + "product/insert-data";
    final http.Response response = await http.post(
      Uri.parse(url),
      body: {
        'description': text.text.toString(),
        'type': value.toString(),
        'user_id': prefs?.getString('logged_in') == 'true' ? prefs?.getString('user_id').toString() : deviceId.toString().toString(),
      },
    );
    try {
      if (json.decode(response.body) == 0) {
        toaster(Get.context!, 'Something went wrong try again please'.tr);
          loading.value = false;
      } else {
        toaster(Get.context!, 'Successfully reported');
        Get.back();
          loading.value = false;
      }
    } catch (ex) {
        loading.value = false;
    }
  }
}

