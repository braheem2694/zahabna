import 'package:iq_mall/screens/ContactUs_screen/controller/ContactUs_controller.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/utils/ShConstant.dart';
import 'package:iq_mall/utils/ShImages.dart';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../main.dart';
import '../../../widgets/ui.dart';
class WhatsAppWidget extends StatelessWidget {
  final String phoneNumber;

  const WhatsAppWidget({required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    final ContactUsController controller = Get.find();

    return InkWell(
      onTap: () async {
        Ui.launchWhatsApp( prefs?.getString('phone_number') ?? "",prefs!.getString('store_name')!);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: Image.asset(AssetPaths.whatsapp, width: 30),
            title: text(
              'WhatsApp'.tr,
              textColor: sh_textColorPrimary,
              fontSize: textSizeLargeMedium,
            ),
            subtitle: text(phoneNumber, fontSize: textSizeSMedium),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () async {
              var whatsappUrl = "https://wa.me/$phoneNumber";
              final Uri uri = Uri.parse(whatsappUrl);
              if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
              throw 'Could not launch $whatsappUrl';
              }
              // Handle tap event
            },
          ),
          divider(),
        ],
      ),
    );
  }
}
