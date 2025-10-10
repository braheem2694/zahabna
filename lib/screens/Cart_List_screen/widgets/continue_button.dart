import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../cores/math_utils.dart';
import '../../../main.dart';
import '../../../utils/ShColors.dart';

class ContinueButtonWidget extends StatefulWidget {
  final VoidCallback onTap;
  final bool? isText;
  final String? text;
  final Color? buttonColor;

  ContinueButtonWidget({required this.onTap, this.isText = true,this.buttonColor, this.text = "Continue"});

  @override
  _ContinueButtonWidgetState createState() => _ContinueButtonWidgetState();
}

class _ContinueButtonWidgetState extends State<ContinueButtonWidget> with TickerProviderStateMixin {
  late AnimationController _buttonAnimationController;
  late Animation<double> _buttonAnimation;
  late AnimationController _iconAnimationController;
  late Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();
    _buttonAnimationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _buttonAnimation = Tween<double>(begin: 1, end: 1.05).animate(_buttonAnimationController)..addListener(() {});

    _iconAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..repeat(reverse: true);

    _iconAnimation = Tween<double>(begin: 0, end: 6).animate(_iconAnimationController);
  }

  @override
  void dispose() {
    _buttonAnimationController.dispose();
    _iconAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: Duration(seconds: 2),
          curve: Curves.easeInOut,
          transform: Matrix4.diagonal3Values(_buttonAnimation.value, _buttonAnimation.value, 1),
          decoration: BoxDecoration(
            color: widget.buttonColor??MainColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              if (widget.isText ?? true)
                Padding(
                  padding: getPadding(left: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Total Amount: ',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: getFontSize(14),
                          color: Colors.white,
                        ),
                      ),
                      Obx(() => Text(
                            "$sign${(double.parse(globalController.result.value.toString()) + double.parse((globalController.sum.value.toString())))}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: getFontSize(14),
                              color: Colors.white,
                            ),
                          )),
                    ],
                  ),
                ),
              if (widget.isText ?? true)

              Expanded(child: SizedBox()),
              Padding(
                padding: getPadding(left: widget.isText??true?0.0:10),
                child: Text(
                  widget.text ?? 'Continue'.tr,
                  style: TextStyle(fontSize: getFontSize(15), fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              SizedBox(width: 1),
              Expanded(
                child: Padding(
                  padding: getPadding(right: 16.0),
                  child: AnimatedBuilder(
                    animation: _iconAnimationController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(_iconAnimation.value, 0),
                        child: child,
                      );
                    },
                    child: Icon(
                      widget.isText??true?
                      Icons.arrow_forward_ios:Icons.category_outlined,
                      color: Colors.white,
                      size: getSize(19),
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
