import 'package:flutter/material.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/utils/ShImages.dart';
import 'package:iq_mall/widgets/CommonWidget.dart';
import 'package:get/get.dart';
import '../../cores/math_utils.dart';
import '../../utils/validation_functions.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_image_view.dart';
import 'controller/change_password_controller.dart';

class Change_password_screen extends GetView<Change_password_screen_Controller> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar('Change Password'.tr),
      backgroundColor: const Color(0xFFF8F7F7),
      body: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: ListView(
                      physics: MediaQuery.of(context).viewInsets == EdgeInsets.zero ? NeverScrollableScrollPhysics() : null,
                      padding: const EdgeInsets.only(left: 32.0, right: 32),
                      shrinkWrap: true,
                      children: [
                        const SizedBox(height: kToolbarHeight),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, bottom: 20),
                          child:               SizedBox(
                            width:Get.width * 0.7,
                            height:Get.width * 0.7,
                            child: CustomImageView(
                              image: AssetPaths.change_password,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Obx(() => TextFormField(
                              obscureText: controller.obscurePasswordText.value,
                              controller: controller.password,
                              style: TextStyle(color: MainColor),
                              cursorColor: MainColor,
                              decoration: InputDecoration(
                                focusColor: MainColor,
                                contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                                suffixIcon: Obx(() => IconButton(
                                    onPressed: () {
                                      controller.toggleObscurePasswordText();
                                    },
                                    icon: Icon(
                                      !controller.obscurePasswordText.value ? Icons.remove_red_eye : Icons.visibility_off,
                                      color: MainColor,
                                    ))),
                                hintText: "Current Password".tr,
                                hintStyle: const TextStyle(color: sh_textColorSecondary),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: sh_textColorSecondary),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'required*'.tr;
                                } else if (value.length < 8) {
                                  return 'Password must be 8+ characters'.tr;
                                }
                                return null;
                              },
                            )),
                        const SizedBox(height: 10.0),
                        Obx(() => TextFormField(
                              controller: controller.new_password,
                              style: TextStyle(color: MainColor),
                              obscureText: controller.obscureNewPasswordText.value,
                              cursorColor: MainColor,
                              decoration: InputDecoration(
                                focusColor: MainColor,
                                contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                                suffixIcon: Obx(() => IconButton(
                                    onPressed: () {
                                      controller.toggleObscureNewPasswordText();
                                    },
                                    icon: Icon(
                                      !controller.obscureNewPasswordText.value ? Icons.remove_red_eye : Icons.visibility_off,
                                      color: MainColor,
                                    ))),
                                hintText: "New Password".tr,
                                hintStyle: const TextStyle(color: sh_textColorSecondary),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: sh_textColorSecondary),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'New password is required'.tr;
                                } else if (value == controller.password.text) {
                                  return 'New password cannot be the same as the old password.'.tr;
                                } else if (value.length < 8) {
                                  return 'Password must be 8+ characters'.tr;
                                }
                                return null;
                              },
                            )),
                        const SizedBox(height: 10.0),
                        Obx(() => TextFormField(
                            controller: controller.confirm_password,
                            obscureText: controller.obscureConfirmPasswordText.value,
                            style: TextStyle(color: MainColor),
                            cursorColor: MainColor,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                              suffixIcon: Obx(() => IconButton(
                                  onPressed: () {
                                    controller.toggleObscureConfirmPasswordText();
                                  },
                                  icon: Icon(
                                    !controller.obscureConfirmPasswordText.value ? Icons.remove_red_eye : Icons.visibility_off,
                                    color: MainColor,
                                  ))),
                              hintText: "Confirm Password".tr,
                              hintStyle: const TextStyle(color: sh_textColorSecondary),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: sh_textColorSecondary),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Password Confirmation is required'.tr;
                              } else if (value == controller.password.text) {
                                return 'New password cannot be the same as the old password.'.tr;
                              } else if (value.length < 8) {
                                return 'Password must be 8+ characters'.tr;
                              }
                              return null;
                            })),
                        const SizedBox(height: 20.0),
                        Align(
                          alignment: Alignment.center,
                          child: Obx(() => MyCustomButton(
                                height: getVerticalSize(50),
                                text: "Change".tr,
                                margin: getMargin(bottom: 20),
                                width: 280,
                                isExpanded: controller.loading.value,
                                onTap: () {
                                  if (controller.formKey.currentState!.validate()) {
                                    controller.ChangePassword(context);
                                  }
                                },
                              )),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
