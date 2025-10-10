import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/screens/SignIn_screen/controller/SignIn_controller.dart';
import 'dart:ui' as ui;


class BackgroundWidget extends StatelessWidget {
  final Widget child;

  BackgroundWidget({required this.child});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(()=>SignInController());
    var controller = Get.find<SignInController>();
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Container(
            height: controller.height,
            child: child,
          ),
          Obx(() => controller.signing.value
              ? Container(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: ClipRect(
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(
                    sigmaX: 8.0,
                    sigmaY: 8.0,
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(''),
                        Column(
                          children: [
                            Container(
                                width: 100,
                                height: 100,
                                child: Image.asset(
                                  'assets/images/loader2.gif',
                                  color: MainColor,
                                )),
                            Text(
                              'signing you in'.tr,
                              style: TextStyle(color: MainColor, fontSize: 18, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Text(''),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
              : SizedBox()),
        ],
      ),
    );
  }
}
