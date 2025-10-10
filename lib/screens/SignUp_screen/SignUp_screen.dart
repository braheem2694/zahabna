import 'package:iq_mall/screens/SignIn_screen/controller/SignIn_controller.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/screens/SignUp_screen/controller/SignUp_controller.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/utils/ShConstant.dart';
import 'package:iq_mall/utils/ShImages.dart';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'package:get/get.dart';
import 'package:iq_mall/widgets/CommonWidget.dart';
import 'package:iq_mall/widgets/custom_image_view.dart';
import '../../cores/math_utils.dart';
import '../../main.dart';
import '../../utils/validation_functions.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/image_widget.dart';
import '../../widgets/ui.dart';
import 'package:flutter/src/services/text_formatter.dart';

bool addressfill = false;

class SignUpScreen extends GetView<SignUpController> {
  @override
  Widget build(BuildContext context) {
    // controller.signing.value = false;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Obx(
          () => Stack(
            alignment: Alignment.center,
            children: [
              // CustomImageView(
              //   imagePath: AssetPaths.iqMallBackgroundPng,
              //   height: Get.height,
              //   width: Get.width,
              //   fit: BoxFit.cover,
              // ),
              IgnorePointer(
                ignoring: controller.signing.value,
                child: SingleChildScrollView(
                  controller: controller.mainController,
                  child: Form(
                    key: controller.formkey,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CustomImageView(
                            height: getSize(200),
                            width: getSize(250),
                            svgPath: AssetPaths.Sign_up,
                            imagePath: AssetPaths.placeholder,
                          ),
                          SizedBox(
                            height: getVerticalSize(30),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomTextFormField(
                                controller: controller.first_namecontroller,
                                textInputAction: TextInputAction.next,
                                width: MediaQuery.of(context).size.width * 0.39,
                                autofocus: false,
                                hintText: 'First Name',
                                prefix: const Icon(Icons.person),
                                variant: TextFormFieldVariant.OutlineGray300,
                                shape: TextFormFieldShape.RoundedBorder10,
                                padding: TextFormFieldPadding.PaddingT4,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'First Name is Required'.tr;
                                  }
                                  return null;
                                },
                              ),
                              CustomTextFormField(
                                controller: controller.last_namecontroller,
                                textInputAction: TextInputAction.next,
                                textInputType: TextInputType.emailAddress,
                                width: MediaQuery.of(context).size.width * 0.39,
                                autofocus: false,
                                hintText: 'Last Name',
                                prefix: const Icon(Icons.person),
                                variant: TextFormFieldVariant.OutlineGray300,
                                shape: TextFormFieldShape.RoundedBorder10,
                                padding: TextFormFieldPadding.PaddingT4,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'First Name is Required'.tr;
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: spacing_standard_new,
                          ),
                          CustomTextFormField(
                            controller: controller.phone_number,
                            textInputAction: TextInputAction.next,
                            textInputType: TextInputType.number,
                            width: MediaQuery.of(context).size.width,
                            autofocus: false,
                            hintText: 'Phone number',
                            prefix: CodePicker(context),
                            variant: TextFormFieldVariant.OutlineGray300,
                            shape: TextFormFieldShape.RoundedBorder10,
                            padding: TextFormFieldPadding.PaddingT4,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'required'.tr;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: spacing_standard_new,
                          ),
                          Obx(
                            () => CustomTextFormField(
                              controller: controller.userpasswordcontroller,
                              textInputAction: TextInputAction.next,
                              textInputType: TextInputType.visiblePassword,
                              width: MediaQuery.of(context).size.width,
                              isObscureText: controller.obscurePass.value,
                              autofocus: false,
                              hintText: 'Password',
                              prefix: const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Icon(Icons.lock),
                              ),
                              suffix: IconButton(
                                  onPressed: () {
                                    controller.obscurePass.value = !controller.obscurePass.value;
                                  },
                                  icon: Icon(
                                    !controller.obscurePass.value ? Icons.remove_red_eye : Icons.visibility_off,
                                    color: MainColor,
                                    size: 18,
                                  )),
                              variant: TextFormFieldVariant.OutlineGray300,
                              shape: TextFormFieldShape.RoundedBorder10,
                              padding: TextFormFieldPadding.PaddingT4,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'required*'.tr;
                                } else if (value.length < 8) {
                                  return 'Password must be 8+ characters'.tr;
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: spacing_standard_new,
                          ),
                          CustomTextFormField(
                            controller: controller.confirmPasswordcontroller,
                            textInputAction: TextInputAction.next,
                            textInputType: TextInputType.visiblePassword,
                            isObscureText: controller.obscureConfirm.value,
                            width: MediaQuery.of(context).size.width,
                            autofocus: false,
                            hintText: 'Confirm Password',
                            prefix: const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Icon(Icons.lock),
                            ),
                            suffix: IconButton(
                                onPressed: () {
                                  controller.obscureConfirm.value = !controller.obscureConfirm.value;
                                },
                                icon: Icon(
                                  !controller.obscureConfirm.value ? Icons.remove_red_eye : Icons.visibility_off,
                                  color: MainColor,
                                  size: 18,
                                )),
                            variant: TextFormFieldVariant.OutlineGray300,
                            shape: TextFormFieldShape.RoundedBorder10,
                            padding: TextFormFieldPadding.PaddingT4,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'required*'.tr;
                              } else if (value.length < 8) {
                                return 'Password must be 8+ characters'.tr;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: spacing_xlarge,
                          ),
                          Obx(() => MyCustomButton(
                                height: getVerticalSize(50),
                                text: "Sign Up".tr,
                                fontSize: 20,
                                borderRadius: 10,
                                width: 280,
                                buttonColor: ColorConstant.logoSecondColor,
                                borderColor: Colors.transparent,

                                isExpanded: controller.signing.value,
                                onTap: () => {
                                  if (controller.formkey.currentState!.validate())
                                    {
                                      controller.formkey.currentState!.save(),
                                      if (controller.userpasswordcontroller.text.toString() == controller.confirmPasswordcontroller.text.toString())
                                        {
                                          controller.signing.value = true,
                                          controller.CheckUser(context),
                                        }
                                    }
                                },
                              )),

                          Obx(() => IgnorePointer(
                                ignoring: controller.signing.value,
                                child: MyCustomButton(
                                  height: getVerticalSize(50),
                                  text: "Sign In".tr,
                                  fontSize: 20,
                                  borderRadius: 10,
                                  textColor: Colors.white,
                                  buttonColor: ColorConstant.logoSecondColor,
                                  borderColor: Colors.transparent,
                                  width: 280,
                                  padding: ButtonPadding.PaddingNone,
                                  variant: ButtonVariant.outLineBlackFillWhite,
                                  onTap: () {
                                    Get.back();
                                  },
                                ),
                              ))
                          // Obx(() => AnimatedContainer(
                          //       duration: Duration(milliseconds: 500), // duration of the animation
                          //       curve: Curves.easeInOut, // the type of animation curve you want
                          //       height: getVerticalSize(controller.boxHeight.value),
                          //       child: SizedBox(), // or you can just leave the child out if you don't need it
                          //     )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
