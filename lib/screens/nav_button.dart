import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:iq_mall/screens/Cart_List_screen/widgets/cartList.dart';
import '../cores/math_utils.dart';
import '../getxController.dart';
import 'Cart_List_screen/controller/Cart_List_controller.dart';

class NavButton extends GetView<GlobalController> {
  const NavButton({
    required this.navColor,
    required this.notSelectedColor,
    required this.label,
    required this.img,
    required this.isSelected,
    required this.onTap,
  });

  final Color navColor;
  final Color notSelectedColor;
  final String label;
  final String img;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: InkWell(
          onTap: onTap,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return SizeTransition(
                axis: Axis.horizontal,
                sizeFactor: animation,
                axisAlignment: -1.0,
                child: child,
              );
            },
            child: IntrinsicWidth(
              key: ValueKey<bool>(isSelected),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? navColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: getVerticalSize(7.0),
                  horizontal: getHorizontalSize(12.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  SvgPicture.asset(
                  img,
                    width: getSize(25.08),
                    height: getSize(25.08),
                    color: isSelected ? Colors.white : notSelectedColor,
                ),
                    // Image.asset(
                    //   img,
                    //   fit: BoxFit.fill,
                    //   color: isSelected ? Colors.white : notSelectedColor,
                    //   width: getSize(21.08),
                    //   height: getSize(21.08),
                    // ),
                    if (isSelected) SizedBox(width: getHorizontalSize(5.0)),
                    if (isSelected)
                      Text(
                        label,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: textstylepoppinsregular10.copyWith(
                          color: Colors.white,
                          fontSize: getFontSize(13.0),
                          fontWeight: FontWeight.w600,
                          height: 1.60,
                        ),
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

    ]);
  }

  static TextStyle textstylepoppinsregular10 = TextStyle(
    color: Colors.grey,
    fontSize: getFontSize(
      10,
    ),
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );
}
