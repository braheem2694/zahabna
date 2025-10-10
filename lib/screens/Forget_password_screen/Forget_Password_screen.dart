import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/screens/Forget_password_screen/controller/Forget_Password_controller.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'package:iq_mall/widgets/CommonWidget.dart';
import 'package:get/get.dart';
import 'package:iq_mall/utils/ShImages.dart';

import '../../utils/validation_functions.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_image_view.dart';

class Forget_Password_screen extends GetView<Forget_Password_Controller> {
  @override
  Widget build(BuildContext context) {
    // controller.loading.value = false;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CommonAppBar('Forget Password'.tr),
      backgroundColor: const Color(0xFFF8F7F7),
      body: Form(
        key: controller.formKey,
        child: Align(
          alignment: Alignment.center,
          child: ListView(
            controller: controller.mainController,
            physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
            shrinkWrap: true,
            children: [
              SizedBox(
                width:Get.width * 0.7,
                height:Get.width * 0.7,
                child: CustomImageView(
                  image: AssetPaths.change_password,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20.0),
              Obx(() => Padding(
                    padding: getPadding(left: 24.0, right: 24, bottom: 16, top: 16),
                    child: TextFormField(
                        controller: controller.new_password,
                        style: TextStyle(color: MainColor),
                        obscureText: controller.obscurePass.value,
                        cursorColor: MainColor,
                        decoration: InputDecoration(
                          focusColor: MainColor,
                          contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                          suffixIcon: InkWell(
                            splashColor: Colors.transparent,
                            onTap: () {
                              controller.togglePass();
                            },
                            child: Obx(() => Icon(
                                  !controller.obscurePass.value ? Icons.lock_open : Icons.lock,
                                  color: controller.obscurePass.value ? sh_textColorSecondary : MainColor,
                                )),
                          ),
                          hintText: "New password".tr,
                          hintStyle: const TextStyle(color: sh_textColorSecondary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: sh_textColorSecondary),
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'New password is required'.tr;
                          } else if (controller.new_password.text.toString() != controller.confirm_password.text.toString()) {
                            return 'Password Mismatch'.tr;
                          } else if (value.length < 8) {
                            return 'Password must be 8+ characters'.tr;
                          }
                          return null;
                        }),
                  )),
              Obx(() => Padding(
                  padding: getPadding(left: 24.0, right: 24, bottom: 16, top: 16),
                  child: TextFormField(
                      controller: controller.confirm_password,
                      style: TextStyle(color: MainColor),
                      obscureText: controller.obscurePass.value,
                      cursorColor: MainColor,
                      decoration: InputDecoration(
                        focusColor: MainColor,
                        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                        suffixIcon: InkWell(
                          splashColor: Colors.transparent,
                          onTap: () {
                            controller.toggleConfPass();
                          },
                          child: Obx(() => Icon(
                                !controller.obscurePass.value ? Icons.lock_open : Icons.lock,
                                color: controller.obscurePass.value ? sh_textColorSecondary : MainColor,
                              )),
                        ),
                        hintText: "Confirm Password".tr,
                        hintStyle: const TextStyle(color: sh_textColorSecondary),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: sh_textColorSecondary),
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'New password is required'.tr;
                        } else if (controller.new_password.text.toString() != controller.confirm_password.text.toString()) {
                          return 'Password Mismatch'.tr;
                        } else if (value.length < 8) {
                          return 'Password must be 8+ characters'.tr;
                        }
                        return null;
                      }))),
              Obx(() => AnimatedContainer(
                    duration: Duration(milliseconds: 300), // duration of the animation
                    curve: Curves.easeInOut, // the type of animation curve you want
                    height: getVerticalSize(controller.boxHeight.value),
                    child: SizedBox(), // or you can just leave the child out if you don't need it
                  )),
              Obx(() => MyCustomButton(
                    height: getVerticalSize(50),
                    text: "Change".tr,
                    fontSize: getFontSize(20),
                    circularIndicatorColor: Colors.white,
                    margin: getMargin(bottom: 20),
                    width: getHorizontalSize(280),
                    isExpanded: controller.loading.value,
                    onTap: () {
                      if (controller.formKey.currentState!.validate()) {
                        controller.ForgetPassword();
                      }
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
