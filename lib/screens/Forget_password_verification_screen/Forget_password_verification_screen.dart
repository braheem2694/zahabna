import 'package:iq_mall/routes/app_routes.dart';
import 'package:iq_mall/screens/Forget_password_verification_screen/controller/Forget_password_verification_controller.dart';
import 'package:iq_mall/screens/SignIn_screen/controller/SignIn_controller.dart';
import 'package:flutter/material.dart';

import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/utils/ShImages.dart';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'package:iq_mall/widgets/CommonWidget.dart';
import 'package:get/get.dart';

import '../../cores/math_utils.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_image_view.dart';

class Forget_password_verificationscreen extends GetView<Forget_password_verificationController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Forget Password'.tr),
      ),
      body: ListView(
        controller: controller.mainController,
        padding: const EdgeInsets.all(32.0),
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
          TextField(
            controller: controller.phoneNumberController,
            keyboardType: TextInputType.phone,
            style: const TextStyle(color: Colors.black),
            cursorColor: MainColor,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
              prefixIcon: CodePicker(context),
              hintText: "Phone Number".tr,
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Obx(() => AnimatedContainer(
                duration: Duration(milliseconds: 350), // duration of the animation
                curve: Curves.easeInOut, // the type of animation curve you want
                height: getVerticalSize(controller.boxHeight.value),
                child: SizedBox(), // or you can just leave the child out if you don't need it
              )),
          Align(
            alignment: Alignment.center,
            child: Obx(() => MyCustomButton(
                  height: getVerticalSize(50),
                  text: "Continue".tr,
                  margin: getMargin(bottom: 20),
                  width: 280,
                  isExpanded: controller.loading.value,
                  onTap: () {
                    if (controller.phoneNumberController.text.toString() == '') {
                      toaster(context, "Enter Phone number first please".tr);
                    } else if (controller.phoneNumberController.text.length != 8) {
                      toaster(context, "Phone number must be of 8 digits".tr);
                    } else {
                      controller.loading.value = true;
                      controller.SendActivationCode(context);
                    }
                  },
                )),
          ),
        ],
      ),
    );
  }
}
