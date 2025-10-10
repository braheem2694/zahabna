import 'package:iq_mall/screens/NoInternet_screen/controller/NoInternet_controller.dart';
import 'package:iq_mall/screens/NoInternet_screen/widgets/StepRow%20_widget.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:get/get.dart';

bool addressfill = false;

class NoInternetScreen extends GetView<NoInternetController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 208.0),
        child: GestureDetector(
          onTap: () {},
          child: ListView(
            padding: const EdgeInsets.all(12.0),
            children: <Widget>[
              GestureDetector(
                onTap: controller.checkConnectivity,
                child: const Icon(
                  Icons.wifi_off,
                  size: 80,
                  color: qIBus_dark_gray,
                ),
              ),
               Padding(
                padding: EdgeInsets.all(5.0),
                child: Center(
                  child: Text(
                    'No internet connection'.tr,
                    style: TextStyle(fontWeight: FontWeight.bold, color: qIBus_textChild, fontSize: 16),
                  ),
                ),
              ),
               Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Center(
                  child: Text(
                    'Try these steps to get back online'.tr+":",
                    style: TextStyle(color: qIBus_dark_gray),
                  ),
                ),
              ),
               StepRow(
                icon: Icons.check_circle,
                text: 'Check your modem and router'.tr,
              ),
               StepRow(
                icon: Icons.check_circle,
                text: 'Reconnect to wifi'.tr,
              ),
              GestureDetector(
                onTap: controller.checkConnectivity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(2.0),
                      height: 22,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0),
                        color: Colors.blue,
                      ),
                      child:  Text("    ${'Reload'.tr}    "),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
