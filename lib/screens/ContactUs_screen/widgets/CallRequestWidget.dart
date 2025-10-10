
import 'package:flutter/material.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/utils/ShConstant.dart';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
class CallRequestWidget extends StatelessWidget {
  final String phoneNumber;

  const CallRequestWidget({required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          leading: const Icon(
            Icons.phone,
            color: Colors.green,
          ),
          title: text(
            'Call Request'.tr,
            textColor: sh_textColorPrimary,
            fontSize: textSizeLargeMedium,
          ),
          subtitle: text(phoneNumber, fontSize: textSizeSMedium),
          trailing: const Icon(Icons.keyboard_arrow_right),
          onTap: () async {
            if (await canLaunch("tel:$phoneNumber")) {
            await launch("tel:$phoneNumber");
            } else {
            print('Could not launch tel:$phoneNumber');
            }
          },
        ),
      ],
    );
  }
}
