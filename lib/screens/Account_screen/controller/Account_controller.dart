import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/main.dart';

class AccountController extends GetxController {
  var firstNamecontroller = TextEditingController();

RxBool Deleting=false.obs;
  @override
  void onInit() {
    firstNamecontroller.text = prefs?.getString('phone_number') ?? "";
    super.onInit();
  }
}
