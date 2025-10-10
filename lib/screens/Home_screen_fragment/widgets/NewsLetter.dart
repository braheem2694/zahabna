import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iq_mall/widgets/ShWidget.dart';

import '../../../main.dart';
import '../../../models/Stores.dart';
import '../../../utils/ShColors.dart';
import '../../../utils/ShImages.dart';
import '../../OrderSummaryScreen/OrderSummaryScreen.dart';

void showNewsLetterDetails(BuildContext context, newsLetter item) {
  final formKey = GlobalKey<FormState>();
  bool isEmailValid(String email) {
    // A simple regex to validate basic email structures
    final RegExp regex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}");
    return regex.hasMatch(email);
  }
  RxBool loading = false.obs;
  var EmailController = TextEditingController();
  Future<bool?> AddSubscriber(context) async {
    loading.value = true;
    bool success = false;

    Map<String, dynamic> response = await api.getData({
      'storeId': prefs!.getString("id") ?? "",
      'email': EmailController.text.toString(),
    }, "stores/add-subscriber");
    if (response.isNotEmpty) {
      success = response["succeeded"];
      loading.value = false;
      if (success) {
        toaster(context, response["message"]);
        Get.back();
      } else {}

      return success;
    } else {
      toaster(context, response["message"]);
    }
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.close)),
          ],
        ),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: ListBody(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(item.main_image),
                  ),
                ),
                Center(
                    child: Text(
                  item.title,
                  textAlign: TextAlign.center,
                )),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Center(
                      child: Text(
                    item.subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                  child: Center(
                      child: Text(
                        convertHtmlToPlainText(item.short_description),
                    textAlign: TextAlign.center,
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email.'.tr;
                      }
                      if (!isEmailValid(value)) {
                        return 'Please enter a valid email.'.tr;
                      }
                      return null;
                    },
                    onChanged: (value) {},
                    controller: EmailController,
                    style: const TextStyle(fontSize: 16, color: sh_textColorPrimary),
                    decoration: InputDecoration(
                      hintText: "Write your email here".tr,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0), // Adjust the border radius as needed
                        borderSide: const BorderSide(
                          color: Colors.grey, // Set the border color to grey
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // This is the background color of the button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0), // Rounded corners for the button
                        ),
                      ),
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          AddSubscriber(context);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                        child: Obx(
                          () => loading.value
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  "Subscribe".tr,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ),
      );
    },
  );
}
