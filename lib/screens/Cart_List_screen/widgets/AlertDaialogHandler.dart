import 'package:iq_mall/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/main.dart';
import 'package:get/get.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../../../utils/ShColors.dart';
import '../../tabs_screen/controller/tabs_controller.dart';

class AlertDialogHandler {
  final BuildContext context;

  AlertDialogHandler(this.context);

  void showAlertDialog() {
    AwesomeDialog(
        width: MediaQuery.of(context).size.width < 1000 ? 350 : 600,
        context: context,
        dialogType: DialogType.warning,
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Warning'.tr,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'You must login first to continue'.tr,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(''),
                        dialogButton('Login'.tr, handleLogin),
                        dialogButton('Cancel'.tr, handleCancel),
                        const Text(''),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        )).show();
  }

  void handleLogin() {
    TabsController _controller = Get.find();
    _controller.currentIndex.value=0;

    Get.back();
    firebaseMessaging.deleteToken();
    Get.toNamed(AppRoutes.SignIn);
  }

  void handleCancel() {
    Get.back();
  }
}

TextButton dialogButton(String text, VoidCallback onPressed) {
  return TextButton(
    style: TextButton.styleFrom(
      backgroundColor: Button_color,
      textStyle: const TextStyle(fontSize: 20),
    ),
    onPressed: onPressed,
    child: Text(
      text,
      style: const TextStyle(color: Colors.white),
    ),
  );
}
