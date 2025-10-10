import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iq_mall/routes/app_routes.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/utils/ShConstant.dart';
import 'package:iq_mall/utils/ShImages.dart';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iq_mall/main.dart';
import 'package:iq_mall/widgets/CommonWidget.dart';

import '../../../getxController.dart';
import '../../tabs_screen/controller/tabs_controller.dart';
import '../ShHomeScreen.dart';

class RowButtons extends StatefulWidget {
  const RowButtons({Key? key}) : super(key: key);

  @override
  _RowButtonsState createState() => _RowButtonsState();
}

class _RowButtonsState extends State<RowButtons> {
  @override
  Widget build(BuildContext context) {
    return Container(

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(),
          Container(
            decoration: BoxDecoration(
              color: Button_color.withOpacity(0.15),
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            ),
            width: 90,
            child: InkWell(
              onTap: () {
                if (prefs?.getString('logged_in') == 'true') {
                  

                  Get.toNamed(AppRoutes.Orderslistscreen);
                } else {
                  
                  Get.toNamed(AppRoutes.SignIn);
                }
              },
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 2),
                  SVG(AssetPaths.truck, 28, 28, Button_color),
                  const SizedBox(height: spacing_control),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: Text(
                      "My Orders".tr,
                      style: TextStyle(color: sh_black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Button_color.withOpacity(0.15),
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            ),
            width: 90,
            child: InkWell(
              onTap: () {
                Get.back();
                setState(() {
                  

                  TabsController _controller = Get.find();
                  _controller.currentIndex.value=2;
                });
              },
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 2),
                  SVG(AssetPaths.fav, 28, 28, Button_color),
                  const SizedBox(height: spacing_control),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: Text(
                      "Favorite".tr,
                      style: TextStyle(color: sh_black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(),
        ],
      ),
    );
  }
}
