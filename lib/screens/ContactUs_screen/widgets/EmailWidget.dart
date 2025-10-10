import 'package:flutter/material.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/utils/ShConstant.dart';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../main.dart';

class EmailWidget extends StatelessWidget {
  final String respondingTimeStatement;

  const EmailWidget({required this.respondingTimeStatement});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          leading: const Icon(
            Icons.mail_outline_outlined,
            color: Colors.blue,
          ),
          title: text(
            'Email'.tr,
            textColor: sh_textColorPrimary,
            fontSize: textSizeLargeMedium,
          ),
          subtitle: text(respondingTimeStatement, fontSize: textSizeSMedium),
          trailing: const Icon(Icons.keyboard_arrow_right),
          onTap: () async {



            final Uri uri = Uri(
              scheme: 'mailto',
              path: respondingTimeStatement,
              query: 'subject=&body=', // optional
            );

            if (!await launchUrl(uri)) {
              throw Exception('Could not launch $respondingTimeStatement');
            }

          },
        ),
      ],
    );
  }
}
