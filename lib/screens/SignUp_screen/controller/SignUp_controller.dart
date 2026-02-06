import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/routes/app_routes.dart';
import 'package:iq_mall/screens/SignIn_screen/controller/SignIn_controller.dart';
import 'package:iq_mall/utils/device_data.dart';
import 'dart:convert';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'package:http/http.dart' as http;
import 'package:iq_mall/cores/assets.dart';
import 'dart:async';

import '../../../main.dart';
import '../../../utils/ShColors.dart';
import '../../../widgets/ui.dart';

class SignUpController extends GetxController with WidgetsBindingObserver {
  var phone_number = TextEditingController();
  var userpasswordcontroller = TextEditingController();
  var confirmPasswordcontroller = TextEditingController();
  var lastNamecontroller = TextEditingController();
  var first_namecontroller = TextEditingController();
  var last_namecontroller = TextEditingController();
  var code;
  RxBool signing = false.obs;
  RxBool obscurePass = true.obs;
  RxBool obscureConfirm = true.obs;
  String? client_token;
  final GlobalKey<FormState> formkey = new GlobalKey<FormState>();
  RxBool obscureText = true.obs;
  RxBool loggin_in = false.obs;
  RxDouble boxHeight = 180.0.obs;
  ScrollController mainController = ScrollController();

  @override
  void onInit() {
    // WidgetsBinding.instance.addObserver(this);

    phone_number.clear();
    userpasswordcontroller.clear();
    confirmPasswordcontroller.clear();
    lastNamecontroller.clear();
    first_namecontroller.clear();
    last_namecontroller.clear();

    super.onInit();
  }

  @override
  void onClose() {
    // WidgetsBinding.instance.removeObserver(this);
    // TODO: implement onClose
    super.onClose();
  }

  @override
  void didChangeMetrics() {
    final value = WidgetsBinding.instance.window.viewInsets.bottom;
    if (value == 0) {
      boxHeight.value = 180.0;

      Future.delayed(Duration(milliseconds: 200)).then((value) {
        mainController.animateTo(
          mainController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn,
        );
      });

      print('keyboard closed');
    } else {
      mainController.animateTo(
        mainController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
      );

      boxHeight.value = 0.0;

      print('keyboard opened');
    }
  }

  Future<bool> CheckUser(context) async {
    bool success = false;
    Map<String, dynamic> response = await api.getData({
      'phone_number': phone_number.text.toString(),
      'country_code': country_code.toString().replaceAll('+', ''),
    }, "users/check-user");
    if (response.isNotEmpty) {
      success = response["succeeded"];
      if (success) {
        Ui.flutterToast(response["message"].toString().tr, Toast.LENGTH_LONG,
            MainColor, whiteA700);

        SignUp(context);
      } else {
        signing.value = false;
        Ui.flutterToast(response["message"].toString().tr, Toast.LENGTH_LONG,
            MainColor, whiteA700);
      }
    } else {
      signing.value = false;
    }
    if (kDebugMode) {
      signing.value = false;
      print("s");
    }
    return success;
  }

  Future<bool?> SignUp(context) async {
    bool success = false;

    Get.toNamed(AppRoutes.Phoneverificationscreen, arguments: {
      'change_password': 'ShSignUp',
      "country_code": country_code.value.toString().replaceAll('+', ''),
      "number": phone_number.text.toString()
    })?.then((value) {
      signing.value = false;
      loggin_in.value = false;
    });

    try {
      await firebaseMessaging.getToken().then((String? token1) async {
        client_token = token1;
        prefs?.setString("token", client_token!);
      }).catchError((e) {
        debugPrint("Error getting token: $e");
        prefs?.setString("token", "");
      });
    } catch (e) {
      debugPrint("Error getting token: $e");
      prefs?.setString("token", "");
    }
    var data = json.encode(await getDeviceInfo());
    Map<String, dynamic> response = await api.getData({
      'firstName': first_namecontroller.text.toString(),
      'lastName': last_namecontroller.text.toString(),
      'number': phone_number.text.toString(),
      'countryCode': country_code.value.toString().replaceAll('+', ''),
      'user_password': userpasswordcontroller.text.toString(),
      'device_data': data.toString(),
      'token': prefs!.getString("token") ?? "",
    }, "users/sign-up");

    if (response.isNotEmpty) {
      if (response["succeeded"]) {
        prefs?.setString('logged_in', 'true');
        prefs?.setString("first_name", first_namecontroller.text.toString());
        prefs?.setString("last_name", lastNamecontroller.text.toString());
        prefs?.setInt('selectedaddress', 0);
        loggin_in.value = false;
        Get.toNamed(AppRoutes.Phoneverificationscreen, arguments: {
          'change_password': 'ShSignUp',
          "country_code": country_code.value.toString().replaceAll('+', ''),
          "number": phone_number.text.toString()
        })?.then((value) {
          signing.value = false;
          loggin_in.value = false;
        });
      } else {
        toaster(context, response["message"]);
        loggin_in.value = false;
        signing.value = false;
        prefs?.setString('logged_in', 'false');
      }
      loggin_in.value = false;
      signing.value = false;
      return success;
    }
    return success;
  }
}
