import 'package:flutter_html/flutter_html.dart';
import 'package:iq_mall/cores/language_model.dart';
import 'package:iq_mall/screens/HomeScreenPage/ShHomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/screens/TermsAndConditions_screen/controller/TermsAndConditions_controller.dart';
import 'package:iq_mall/screens/TermsAndConditions_screen/terms_widget.dart';

import 'package:iq_mall/widgets/CommonWidget.dart';
import 'package:get/get.dart';

import '../../cores/math_utils.dart';
import '../../getxController.dart';
import '../../main.dart';

class TermsAndConditionsscreen extends GetView<TermsAndConditionsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar('Terms and Conditions'.tr),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:

          TermsWidget()
        ),
      ),
    );
  }
}
