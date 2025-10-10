import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/ShColors.dart';
import '../../../utils/ShConstant.dart';
import '../../SignIn_screen/controller/SignIn_controller.dart';
import '../controller/GiftCardDetailScreen_controller.dart';

class MyForm extends GetView<GiftCardDetailScreenController> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Phone Number Field
          Text(
            "Phone Number:".tr,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Obx(() => controller.deliveryMethod.value == 'Email'
              ? TextField(
                  controller: controller.EmailController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter Email".tr,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    autofocus: false,
                    controller: controller.phoneNumberController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      prefixIcon: CodePicker(context),
                      hintText: 'Phone number'.tr,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'fill phone number please'.tr;
                      }
                      if (value.length < 8) {
                        return 'Phone number must be of 8 digits'.tr;
                      }
                      return null;
                    },
                  ),
                )),
          SizedBox(height: 16.0),

          // Sender Name Field
          Text(
            "Sender Name:".tr,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          TextFormField(
            controller: controller.senderNameController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: "Enter sender's name".tr,
            ),
          ),
          const SizedBox(height: 16.0),

          // Message Field
          Text(
            "Message:".tr,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          TextFormField(
            controller: controller.messageController,
            maxLines: 3,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter your message".tr,
            ),
          ),
        ],
      ),
    );
  }
}
