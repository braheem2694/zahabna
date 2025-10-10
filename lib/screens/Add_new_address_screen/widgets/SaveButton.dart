import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iq_mall/cores/assets.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/utils/ShConstant.dart';
import 'package:iq_mall/widgets/ShWidget.dart';

import '../controller/Add_new_address_screen_controller.dart';

class SaveButton extends StatelessWidget {
  Add_new_address_screenController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 50,
      minWidth: double.infinity,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
      onPressed: () async {
        if (controller.formKey.currentState?.validate() ?? false) {
            controller.AddUpdateAddress(context);

        }
      },
      color: MainColor,
      child: Text(
        controller.edit ? 'Update'.tr : 'Save Address'.tr,
        style: const TextStyle(fontSize: textSizeLargeMedium, color: sh_white),
      ),
    );
  }
}
