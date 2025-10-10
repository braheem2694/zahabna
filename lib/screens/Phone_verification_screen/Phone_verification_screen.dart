import 'package:iq_mall/screens/Phone_verification_screen/controller/Phone_verification_controller.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/widgets/CommonWidget.dart';
import 'package:iq_mall/main.dart';
import 'package:get/get.dart';
import 'package:iq_mall/utils/ShImages.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../cores/math_utils.dart';
import '../../widgets/custom_button.dart';
import '../Forget_password_verification_screen/controller/Forget_password_verification_controller.dart';
import '../SignUp_screen/controller/SignUp_controller.dart';

class Phone_verificationscreen extends GetView<Phone_verificationController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: verificationColor,
      appBar: CommonAppBar(''),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                controller: controller.mainController,
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      AssetPaths.email,
                      height: 200,
                    ),
                    Text(
                      "Phone Number Verification".tr,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const Text(
                      "Enter the code sent to your mobile",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0, right: 30, top: 50),
                      child: PinCodeTextField(
                        errorAnimationController: controller.pinErrorController,
                        appContext: context,
                        controller: controller.otpController.value,
                        length: 6,
                        onCompleted: (code) {},
                        obscureText: false,
                        enablePinAutofill: true,
                        obscuringCharacter: '*',
                        keyboardType: TextInputType.number,
                        autoDismissKeyboard: true,
                        enableActiveFill: true,
                        onChanged: (value) {
                          controller.codeEntered = value.toString();
                        },
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          selectedFillColor: Colors.white,
                          borderWidth: 2,
                          borderRadius: BorderRadius.circular(5),
                          activeFillColor: Colors.white,
                          inactiveFillColor: Colors.white,
                          inactiveColor: MainColor,
                          selectedColor: Colors.grey,
                          activeColor: MainColor,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Center(
                      child: InkWell(
                        onTap: () {
                          if (start.value.toString() == '0') {
                            if (controller.isClickable.value) {
                              if (controller.change_password == 'forgetpassword' || controller.change_password == 'ShSignUp') {
                                controller.SendActivationCode(context);
                              } else if (controller.change_password == 'changephonenumber') {}
                            }
                          }
                          print('Text clicked!');
                        },
                        child: Obx(() => Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                start.value.toString() == '0'
                                    ?  Text(
                                        'Resend Code',
                                        style: TextStyle(color: ColorConstant.logoSecondColor),
                                      )
                                    : Text(
                                        "Resend Code after ${start.value} seconds",
                                        style: TextStyle(fontSize: 18),
                                      ),
                              ],
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Center(
                        child: Obx(() => MyCustomButton(
                              height: getVerticalSize(50),
                              text: "Verify".tr,
                              fontSize: getFontSize(20),
                              circularIndicatorColor: Colors.white,
                              width: getHorizontalSize(280),
                              buttonColor: ColorConstant.logoFirstColor,
                              isExpanded: controller.verifyingCode.value,
                              onTap: () {
                                controller.OnVerify();
                              },
                            ))),
                    Obx(() => AnimatedContainer(
                          duration: const Duration(milliseconds: 350), // duration of the animation
                          curve: Curves.easeInOut, // the type of animation curve you want
                          height: getVerticalSize(controller.boxHeight.value),
                          child: const SizedBox(), // or you can just leave the child out if you don't need it
                        )),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
