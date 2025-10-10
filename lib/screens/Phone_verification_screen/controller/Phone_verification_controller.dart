import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/main.dart';
import 'package:iq_mall/screens/Forget_password_verification_screen/controller/Forget_password_verification_controller.dart';
import 'package:iq_mall/routes/app_routes.dart';
import 'package:iq_mall/screens/HomeScreenPage/ShHomeScreen.dart';
import 'package:iq_mall/screens/SignIn_screen/controller/SignIn_controller.dart';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iq_mall/screens/SignUp_screen/controller/SignUp_controller.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../../utils/device_data.dart';

RxInt start = 60.obs; // Making it an observable

class Phone_verificationController extends GetxController with CodeAutoFill, WidgetsBindingObserver {
  String? codeEntered;
  RxBool loading = false.obs;
  String? idstore;
  var controller;
  Rx<TextEditingController> otpController = TextEditingController().obs;

  StreamController<ErrorAnimationType> pinErrorController = StreamController<ErrorAnimationType>.broadcast();

  TextEditingController? textEditingController;
  Timer? _timer;

  RxBool isClickable = false.obs;
  RxBool verifyingCode = false.obs;
  RxDouble boxHeight = 100.0.obs;
  ScrollController mainController = ScrollController();

  @override
  void codeUpdated() {
    otpController.value.text = code!;
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

  String? code;
  String? change_password;
  Map arguments = {};

  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);

    startTimer();
    arguments = Get.arguments;
    code = arguments['code'].toString();
    change_password = arguments['change_password'].toString();
    listenForCode();
    super.onInit();
  }

  OnVerify() {
    try {
      if (codeEntered != null ? (codeEntered!.length < 6) : false) {
        toaster(Get.context!, 'Enter secrete  code then try again');
      } else {
        checkcode(Get.context!);
      }
    } catch (e) {
      toaster(Get.context!, 'Enter secrete  code then try again');
    }
  }

  String? client_token;

  Future<bool> CheckActivationCode() async {
    verifyingCode.value = true;
    bool success = false;

    try{
      var PhoneController = Get.find<Forget_password_verificationController>();
      Map<String, dynamic> response = await api.getData({
        'phone_number': PhoneController.phoneNumberController.text.toString(),
        'country_code': country_code.toString().replaceAll('+', ''),
        'code': codeEntered.toString(),
      }, "users/check-reset-code");
      if (response.isNotEmpty) {
        success = response["succeeded"];
        if (success) {
          final Forget_password_verificationController controllerVerification = Get.put(Forget_password_verificationController());
          Get.toNamed(AppRoutes.ForgetPasswordscreen, arguments: {'phone_number': controllerVerification.phoneNumberController.text.toString(), 'country_code': country_code.value, "otp_code":codeEntered.toString()});
        } else {
          toaster(Get.context!, response["message"]);
        }
      }
      if (success) {
        prefs?.setString('logged_in', 'true');
      } else {}
    }catch(e){
      verifyingCode.value = false;

      print(e);
    }
    verifyingCode.value = false;

    return success;
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (start.value == 0) {
        timer.cancel();
        isClickable.value = true;
      } else {
        start.value--;
      }
    });
  }

  Future<bool?> ActivateUser() async {
    var signupScreen = Get.find<SignUpController>();
    bool success = false;
    loading.value = true;
    verifyingCode.value = true;

    try{
      var data = json.encode(await getDeviceInfo());
      Map<String, dynamic> response = await api.getData({
        'country_code': country_code.value.toString().replaceAll('+', ''),
        'phone_number': signupScreen.phone_number.text.toString(),
        'code': codeEntered.toString(),
        'password': signupScreen.userpasswordcontroller.text.toString(),
        'device_data': data.toString(),
        'token': prefs!.getString("token") ?? "",
      }, "users/activate-user");

      if (response.isNotEmpty) {
        if (response["succeeded"]) {
          var info = response["user"];
          prefs?.setString('logged_in', 'true');
          prefs?.setString("user_id", info['id'].toString());
          prefs?.setInt('selectedaddress', 0);
          Get.offAllNamed(AppRoutes.tabsRoute);
        } else {
          loading.value = false;
          verifyingCode.value = false;
          toaster(Get.context!, response["message"]);
          prefs?.setString('logged_in', 'false');
        }
        return success;
      }
    }catch(e){
      verifyingCode.value = false;

    }
  }

  Future<bool?> SendActivationCode(context) async {
    bool success = false;

    Map<String, dynamic> response = await api.getData({
      'country_code': arguments["country_code"],
      'phone_number': arguments["number"],
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
    return success;
  }

  checkcode(BuildContext context) async {
    try {
      if (change_password == 'forgetpassword') {
        CheckActivationCode();
      } else if (change_password == 'ShSignUp') {
        ActivateUser();
      } else if (change_password == 'changephonenumber') {
        Get.toNamed(AppRoutes.changephonenumberscreen);
      }
    } on FirebaseAuthException catch (e) {
      toaster(context, 'The code you entered is incorrect');
    }
  }
}
