import 'package:flutter_html/flutter_html.dart';
import 'package:iq_mall/cores/language_model.dart';
import 'package:iq_mall/screens/HomeScreenPage/ShHomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/screens/TermsAndConditions_screen/controller/TermsAndConditions_controller.dart';

import 'package:iq_mall/widgets/CommonWidget.dart';
import 'package:get/get.dart';

import '../../cores/math_utils.dart';
import '../../getxController.dart';
import '../../main.dart';

class TermsWidget extends StatelessWidget {

  final String? terms;
  TermsWidget({this.terms, });
  @override
  Widget build(BuildContext context) {
    final selectedLanguage = languages.isNotEmpty
        ? languages.firstWhere(
          (element) =>
      element.shortcut?.toLowerCase() ==
          (prefs?.getString("locale")?.toLowerCase() ?? "en"),
      orElse: () => languages.first,
    )
        : null;

    final termsTemp = selectedLanguage?.termsAndConditions ?? "Terms not available";

    return Directionality(
      textDirection: prefs?.getString("locale").toString().toLowerCase() == "ar" ? TextDirection.rtl : TextDirection.ltr,
      child: Html(
        data: terms??termsTemp,
        shrinkWrap: true,
        style: {
          "body": Style(
            padding: HtmlPaddings.zero, // Remove unnecessary padding
            margin: Margins.zero, // Remove unnecessary margins
          ),
        },
      ),
    );
  }
}
