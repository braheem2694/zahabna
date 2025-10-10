import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/main.dart';
import 'package:iq_mall/screens/bill_screen/widgets/AddressDetailsSection.dart';
import 'package:iq_mall/screens/bill_screen/widgets/ProductDetailsSection.dart';
import 'package:iq_mall/screens/bill_screen/widgets/ThankYouSection.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/utils/ShColors.dart';

import '../../../widgets/ui.dart';

class PaymentDetailsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: MainColor, width: 3)),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            prefs!.getString('store_name').toString(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: getFontSize(20), color: MainColor),
          ),
          Divider(
            color: MainColor,
            thickness: 3,
          ),
          ThankYouSection(),
          AddressDetailsSection(),
          ProductDetailsSection(),
        ],
      ),
    );
  }
}
