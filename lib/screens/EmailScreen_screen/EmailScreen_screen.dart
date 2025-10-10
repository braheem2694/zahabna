import 'package:iq_mall/screens/EmailScreen_screen/controller/EmailScreen_controller.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'package:get/get.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/utils/ShConstant.dart';
import 'package:iq_mall/widgets/CommonWidget.dart';

class EmailScreenscreen extends GetView<EmailScreenController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar('Email'.tr),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: controller.emailCont,
              enabled: false,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              style: const TextStyle(fontSize: textSizeMedium),
              autofocus: false,
              decoration: formFieldDecoration('Email to inbox'.tr),
            ),
            const SizedBox(
              height: spacing_standard_new,
            ),
            TextFormField(
              controller: controller.descriptionCont,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              style: const TextStyle(fontSize: textSizeMedium),
              autofocus: false,
              decoration: formFieldDecoration('Description'.tr),
            ),
            const SizedBox(
              height: 50,
            ),
            MaterialButton(
                height: 50,
                minWidth: double.infinity,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
                onPressed: () {
                  controller.send_email();
                },
                color: MainColor,
                child: Obx(
                  () => controller.sending.value
                      ? const Center(
                          child: Center(
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            )),
                          ),
                        )
                      : text('Send mail'.tr, fontSize: textSizeLargeMedium, textColor: sh_white),
                ))
          ],
        ),
      ),
    );
  }
}
