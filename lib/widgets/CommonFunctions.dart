import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:get/get.dart';
import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/main.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/ShColors.dart';
 ExitAlert(context) {
  var alert = AwesomeDialog(width: MediaQuery.of(context).size.width<1000?350:600,
      context: context,
      dialogType: DialogType.info,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: getSize(170),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: Column(
                children: [
                  Text(
                    'Warning'.tr,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "${'Are you sure you want to exit '.tr}IQ Mall?",
                    style: const TextStyle(fontSize: 15),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(''),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: MainColor,
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            Get.back();
                            SystemNavigator.pop();
                          },
                          child: Text('Yes'.tr,
                              style: const TextStyle( color: Colors.white)),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: MainColor,
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text(
                            'No',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                    
                        Text(''),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )).show();
}

seen2() {
  try {
    prefs?.setString('seen', "true");
  } catch (ex) {}
}
