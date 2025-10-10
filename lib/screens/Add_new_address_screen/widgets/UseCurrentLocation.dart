import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iq_mall/screens/Add_new_address_screen/controller/Add_new_address_screen_controller.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/utils/ShConstant.dart';

class UseCurrentLocationButton extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    Add_new_address_screenController controller = Get.find();
    return Container(
      alignment: Alignment.center,
      child: MaterialButton(
        color: sh_light_gray,
        elevation: 0,
        padding: EdgeInsets.only(top: spacing_middle, bottom: spacing_middle),
        onPressed: controller.getLocation,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.my_location,
              color: controller.primaryColor,
              size: 16,
            ),
            SizedBox(width: 10),
            Text(
              'Use Current Location'.tr,
              style: TextStyle(color: sh_textColorPrimary),
            )
          ],
        ),
      ),
    );
  }
}
