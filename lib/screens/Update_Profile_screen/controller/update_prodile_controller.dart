import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'dart:io';

import '../../../cores/assets.dart';
import '../../../main.dart';
import '../../../utils/ShColors.dart';
import '../../../utils/device_data.dart';
import '../../../widgets/ShWidget.dart';
import 'package:dio/dio.dart' as dio;
import 'package:path/path.dart';

class update_profile_screen_Controller extends GetxController {
  Rx<File?> profileImage = Rx<File?>(null);
  File? image;



  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  Rx<String?> selectedGender = Rx<String?>('Male');
  final ImagePicker picker = ImagePicker();
  String? webimageString;

  UploadImage(row_id) async {
    File imageFile = File(image!.path);
    String fileName = basename(imageFile.path);
    dio.FormData data = dio.FormData.fromMap({
      "file": await dio.MultipartFile.fromFile(
        image!.path.toString(),
        filename: fileName.toString(),
      ).catchError((e) {}),
      "file_name": fileName,
      "token": prefs!.getString('token') ?? "", // Sending token
      "table_name": '156', // Using passed table name
      "row_id": row_id.toString() // Using passed row id
    });

    dio.Dio dio2 = dio.Dio();

    try {
      var response = await dio2.post(
        "${con!}side/upload-images",
        data: data,
        options: dio.Options(
          headers: {
            'Accept': "application/json",
            'Authorization': 'Bearer ${prefs!.getString("token") ?? ""}',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('response.statusCode');
        print(response.statusCode);
        print(response.data);

        // Handle 200 status code response
        var responseData = response.data;

        if (responseData['succeeded'] == true) {
          print(responseData['path']);
          print(responseData['path']);
          LoadingDrawer.value = true;
          prefs!.setString('Profile_image', responseData['path']);
          LoadingDrawer.value = false;
          // Assuming there is a 'succeeded' key in the response to check for success.
          // You can adapt this based on the actual structure of your response.

          var results = responseData['results']; // Accessing results, adapt key as needed
          // Handle the results here as per your needs
        } else {
          var errorMessage = responseData['message']; // Assuming 'message' key contains error details
          print('Error: $errorMessage');
        }
      } else {
        print('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error while uploading: $e');
    }
  }

  _loadPrefs() async {
    firstNameController.text = prefs!.getString('first_name') ?? '';
    lastNameController.text = prefs!.getString('last_name') ?? '';
    emailController.text = prefs!.getString('user_email') ?? '';
    if (prefs!.getString('gender').toString() != 'null' && prefs!.getString('gender').toString() != '' && prefs!.getString('gender').toString() != ' ')
      selectedGender.value = prefs!.getString('gender') ?? '';
  }

  @override
  void onInit() {
    super.onInit();
    _loadPrefs();
  }

  RxBool loading = false.obs;

  Future<bool?> UpdateProfile() async {
    bool success = false;
    loading.value = true;

    Map<String, dynamic> response = await api.getData({
      'token': prefs!.getString("token") ?? "",
      'first_name': firstNameController.text.toString(),
      'last_name': lastNameController.text.toString(),
      'email': emailController.text.toString(),
      'gender': selectedGender.value.toString() != 'null' ? selectedGender.value.toString() : "",
    }, "users/update-user-profile");

    if (response.isNotEmpty) {
      success = response["succeeded"];
      if (success) {
        if (image != null) {
          UploadImage(prefs!.getString('user_id'));
        }
        prefs?.setString("gender", selectedGender.value.toString());
        prefs?.setString("first_name", firstNameController.text.toString());
        prefs?.setString("last_name", lastNameController.text.toString());
        prefs?.setString("user_email", emailController.text.toString());
        globalController.updateFullName();
        loading.value = false;
        if (success) {
          toaster(Get.context!, response["message"]);
          Get.back();
          prefs?.setString('logged_in', 'true');
        } else {}
        loading.value = false;
        return success;
      } else {
        loading.value = false;
        toaster(Get.context!, response["message"]);
      }
    } else {
      loading.value = false;

      // toaster(Get.context!, 'Error occurred');
    }
  }

  @override
  void onClose() {
    // Clean up controllers when the widget is disposed.
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
