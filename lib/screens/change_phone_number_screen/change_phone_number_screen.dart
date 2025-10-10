import 'dart:convert';
import 'package:iq_mall/routes/app_routes.dart';
import 'package:iq_mall/screens/Account_screen/controller/Account_controller.dart';
import 'package:iq_mall/screens/Account_screen/widgets/getRowItem.dart';

import 'package:iq_mall/screens/SignIn_screen/controller/SignIn_controller.dart';
import 'package:iq_mall/screens/change_phone_number_screen/controller/change_phone_number_screen_controller.dart';

import 'package:flutter/material.dart';
import 'package:iq_mall/cores/assets.dart';


import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/utils/ShConstant.dart';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'package:iq_mall/widgets/CommonWidget.dart';
import 'package:get/get.dart';
import 'package:iq_mall/utils/ShImages.dart';

class change_phone_number_screen extends GetView<change_phone_number_Controller> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar('Change Phone Number'.tr),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListView(
              physics: MediaQuery.of(context).viewInsets == EdgeInsets.zero
                  ? NeverScrollableScrollPhysics()
                  : null,
              padding: const EdgeInsets.all(32.0),
              shrinkWrap: true,
              children: [
                const SizedBox(height: kToolbarHeight),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 20),
                  child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.height * .30,
                      child: Image.asset(AssetPaths.change_password)),
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: controller.phone_number,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(color: Colors.black),
                  cursorColor: MainColor,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 32.0),
                    prefixIcon: CodePicker(context),
                    hintText: "New Phone Number".tr,
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Obx(()=>controller.loading.value
                    ? Progressor_indecator()
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(''),
                    GestureDetector(
                      onTap: () {
                        if (controller.phone_number.text.toString() == '') {
                          toaster(context,
                              "Enter Phone number first please".tr);
                        } else if (controller.phone_number.text.length != 8) {
                          toaster(context,
                              "Phone number must be of 8 digits".tr);
                        } else {
                            controller.loading.value = true;
                          controller.changePhoneNumber();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: MainColor,
                          borderRadius:
                          BorderRadius.all(Radius.circular(15)),
                        ),
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 45,
                        child: Center(
                          child: Text(
                            "Submit".tr,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const Text(''),
                  ],
                )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
