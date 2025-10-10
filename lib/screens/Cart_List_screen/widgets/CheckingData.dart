import 'package:iq_mall/utils/ShColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;

class CheckingData extends StatelessWidget {
  const CheckingData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 250.0),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(
            sigmaX: 8.0,
            sigmaY: 8.0,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  width: 70,
                  height: 70,
                  color: Colors.transparent,
                  child: Image.asset(
                    'assets/images/loader2.gif',
                    color: MainColor,
                  ),
                ),
              ),
              Text(
                'Checking data for updates'.tr,
                style: TextStyle(
                  color: MainColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
