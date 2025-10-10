import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/screens/Cart_List_screen/controller/Cart_List_controller.dart';
import 'package:iq_mall/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../routes/app_routes.dart';
import '../../tabs_screen/controller/tabs_controller.dart';
import 'AlertDaialogHandler.dart';
import 'continue_button.dart';

class BottomContainer extends StatefulWidget {

  final VoidCallback onTap;

  const BottomContainer({super.key, required this.onTap});

  @override
  State<BottomContainer> createState() => _BottomContainerState();
}

class _BottomContainerState extends State<BottomContainer> {
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,

        children: <Widget>[
          SizedBox(
              width: getHorizontalSize(310),
              height: getSize(50),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ContinueButtonWidget(onTap: widget.onTap),
                ],
              )),
        ],
      ),
    );
  }


}

