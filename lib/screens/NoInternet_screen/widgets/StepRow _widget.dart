import 'package:iq_mall/screens/SignIn_screen/controller/SignIn_controller.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/screens/SignUp_screen/controller/SignUp_controller.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/utils/ShConstant.dart';
import 'package:iq_mall/utils/ShImages.dart';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'package:get/get.dart';
import 'package:iq_mall/widgets/CommonWidget.dart';
class StepRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const StepRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(''),
        Row(
          children: [
            Icon(
              icon,
              color: qIBus_dark_gray,
              size: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(color: qIBus_dark_gray),
                ),
              ),
            ),
          ],
        ),
        Text(''),
        Text(''),
      ],
    );
  }
}