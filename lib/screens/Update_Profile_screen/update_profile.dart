import 'package:flutter/material.dart';
import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/models/functions.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:get/get.dart';

import '../../main.dart';
import '../../widgets/CommonWidget.dart';
import '../../widgets/custom_button.dart';
import 'controller/update_prodile_controller.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';

class update_profile_screen extends GetView<update_profile_screen_Controller> {
  final update_profile_screen_Controller _controller = Get.put(update_profile_screen_Controller());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Update Profile'.tr),
        leading:                                   InkWell(
          onTap: () async {
            Get.back();
          },
          child: Padding(
            padding: getPadding(left: 16.0),
            child: SizedBox(
              width: getSize(30),
              height: getSize(30),
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () async {


                    Get.bottomSheet(
                      Container(
                        color: Colors.white,
                        height: getVerticalSize(120),
                        width: Get.width,
                        child: Column(
                          children: [
                            TextButton(
                              onPressed: () {
                                function.SingleImagePicker(ImageSource.gallery).then((value) {
                                  if (value!=null) {
                                    controller.image = File(value.path);
                                    if (_controller.image != null) {
                                      _controller.profileImage.value = File(_controller.image!.path);
                                    }
                                  }
                                });

                              },
                              child: Text(
                                "Select Image",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            Divider(color: ColorConstant.black900,),
                            TextButton(
                              onPressed: () {
                                function.SingleImagePicker(ImageSource.camera).then((value) {
                                  if (value!=null) {
                                    controller.image = File(value.path);
                                    if (_controller.image != null) {
                                      _controller.profileImage.value = File(_controller.image!.path);
                                    }
                                  }
                                });
                              },
                              child: Text(
                                "Take Photo",
                                style: TextStyle(color: Colors.black),
                              ),
                            )
                          ],
                        ),
                      ),
                    );








                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Obx(() => CircleAvatar(
                            radius: 50,
                            backgroundImage: _controller.profileImage.value == null
                                ? (prefs!.getString('Profile_image') != null ? NetworkImage(prefs!.getString('Profile_image')!) : const AssetImage('assets/images/user.png') as ImageProvider)
                                : FileImage(_controller.profileImage.value!) as ImageProvider,
                          )),
                      const Positioned(
                        right: 0,
                        bottom: 0,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: getHorizontalSize(300),
                  child: TextFormField(
                    controller: _controller.firstNameController,
                    decoration: InputDecoration(
                      labelText: 'First Name'.tr,
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name'.tr;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: getHorizontalSize(300),
                  child: TextFormField(
                    controller: _controller.lastNameController,
                    decoration: InputDecoration(
                      labelText: 'Last Name'.tr,
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name'.tr;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: getHorizontalSize(300),
                  child: TextFormField(
                    controller: _controller.emailController,
                    style: TextStyle(fontSize: getFontSize(15)),
                    decoration: InputDecoration(
                      labelText: 'Email Address'.tr,
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please enter your email'.tr;
                    //   }
                    //   if (!value.contains('@')) {
                    //     return 'Enter a valid email'.tr;
                    //   }
                    //   return null;
                    // },
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: getHorizontalSize(300),
                  child: DropdownButtonFormField<String>(
                    value: _controller.selectedGender.value,
                    hint: Text('Select Gender'.tr),
                    isExpanded: true,
                    isDense: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.people),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    items: ['Male', 'Female']
                        .map((label) => DropdownMenuItem(
                              value: label,
                              child: Text(label),
                            ))
                        .toList(),
                    onChanged: (value) {
                      _controller.selectedGender.value = value!;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Obx(() => MyCustomButton(
                      height: getVerticalSize(50),
                      text: "save".tr,
                      fontSize: 20,
                      variant: ButtonVariant.FillDeeporange300,
                      circularIndicatorColor: Colors.white,
                      margin: getMargin(bottom: 20),
                      width: 280,
                      isExpanded: controller.loading.value,
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          _controller.UpdateProfile();
                        }
                      },
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
