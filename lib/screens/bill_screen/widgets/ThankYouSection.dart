import 'package:iq_mall/main.dart';
import 'package:iq_mall/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cores/math_utils.dart';
import '../../../widgets/custom_button.dart';
import '../../tabs_screen/controller/tabs_controller.dart';

class ThankYouSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 8.0, bottom: 18),
          child: Center(
            child: Icon(
              Icons.check_circle,
              size: 60,
              color: MainColor,
            ),
          ),
        ),
        Center(
          child: Text(
            'Thank You'.tr,
            style: TextStyle(fontSize: 18, color: Colors.black.withOpacity(0.7)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, top: 4),
          child: Center(
            child: Text(
              'Thank you for your purchase! Please track your order, which will be confirmed shortly.'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.black.withOpacity(0.7)),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.toNamed(AppRoutes.Orderslistscreen);
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10.0, top: 5),
            child: Center(
                child: MyCustomButton(
              height: getSize(35),
              text: 'My Orders'.tr,
              buttonColor: ColorConstant.logoFirstColor,
              borderColor: Colors.transparent,
              fontSize: 15,
              borderRadius: 10,
              width: 340,
              isExpanded: false,
              onTap: () => {Get.toNamed(AppRoutes.Orderslistscreen)},
            )),
          ),
        ),
        GestureDetector(
          onTap: () {
            TabsController _controller = Get.find();
            _controller.currentIndex.value = 0;
            Get.back();
          },
          child: Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20, bottom: 10, top: 10),
            child: Center(
              child: Text(
                'CONTINUE SHOPPING'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: MainColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
