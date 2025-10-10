import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:animated_icon/animated_icon.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iq_mall/models/HomeData.dart';
import 'package:iq_mall/screens/ProductDetails_screen/widgets/animated_icon_widget.dart';
import 'package:iq_mall/widgets/ui.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../cores/math_utils.dart';
import '../../../main.dart';
import '../../../utils/ShColors.dart';
import '../../../utils/ShImages.dart';
import '../../../widgets/custom_image_view.dart';
import '../controller/ProductDetails_screen_controller.dart';

class AddToCartButtons extends StatefulWidget {
  final VoidCallback onTap;
  final bool? isText;
  final String? text;
  final Product? product;
  final bool addingToCard;
  final bool animatingAddToCardTick;
  final ProductDetails_screenController productDetailsController;

  AddToCartButtons({required this.onTap, this.isText = true, this.text = "Continue", this.product, this.addingToCard = false, required this.animatingAddToCardTick, required this.productDetailsController});

  @override
  _ContinueButtonWidgetState createState() => _ContinueButtonWidgetState();
}

class _ContinueButtonWidgetState extends State<AddToCartButtons> with TickerProviderStateMixin {
  late AnimationController _buttonAnimationController;
  late Animation<double> _buttonAnimation;
  late AnimationController _iconAnimationController;
  late Animation<double> _iconAnimation;

  // late ProductDetails_screenController controller = Get.find(tag: Get.arguments.isNotEmpty ? Get.arguments['tag'] : globalController.detailsTag.value);

  @override
  void initState() {
    super.initState();
    _buttonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _buttonAnimation = Tween<double>(begin: 1, end: 1).animate(_buttonAnimationController)..addListener(() {});

    _iconAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
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
      child: AnimatedContainer(
        duration: Duration(seconds: 2),
        curve: Curves.easeInOut,
        transform: Matrix4.diagonal3Values(_buttonAnimation.value, _buttonAnimation.value, 1),
        decoration: BoxDecoration(
          color: ColorConstant.logoSecondColor,
          borderRadius: BorderRadius.circular(0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        alignment: Alignment.topCenter,
        padding: getPadding(top: getSize(10)),
        height: getSize(55) + getBottomPadding(),
        child: Row(
          key: widget.productDetailsController.startPointKey,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (widget.isText ?? true)
              Padding(
                padding: getPadding(left: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: getHorizontalSize(200),
                      child: Text(
                        "Store: ${widget.productDetailsController.product.value!.store.name ?? prefs!.getString('store_name')}",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: getFontSize(16),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Obx(() => Text(
                    //       "$sign${widget.product?.priceAfterDiscount ?? widget.product?.product_price}",
                    //       style: TextStyle(
                    //         fontWeight: FontWeight.w600,
                    //         fontSize: getFontSize(16),
                    //         color: Colors.white,
                    //       ),
                    //     )),
                  ],
                ),
              ),
            Padding(
              padding: getPadding(right: 16.0),
              child: SizedBox(
                width: getHorizontalSize(150),
                child: InkWell(
                  onTap: widget.onTap,
                  child: Container(
                    decoration: BoxDecoration(shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(15.0), color: ColorConstant.whiteA700),
                    height: getSize(30),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Contact Store".tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: getFontSize(16), fontWeight: FontWeight.bold, color: ColorConstant.logoFirstColor),
                          ),
                          Obx(() {
                            return widget.addingToCard
                                ? Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Ui.circularIndicatorDefault(
                                      color: ColorConstant.logoSecondColor,
                                      width: getSize(20),
                                      height: getSize(20),
                                    ),
                                  )
                                : widget.animatingAddToCardTick
                                    ? AnimatedSwitcher(
                                        duration: const Duration(milliseconds: 300),
                                        transitionBuilder: (Widget child, Animation<double> animation) {
                                          return ScaleTransition(scale: animation, child: child);
                                        },
                                        child: CustomAnimateIcon(
                                          key: UniqueKey(),
                                          duration: 1500,
                                          onTap: () {},
                                          iconType: IconType.continueAnimation,
                                          width: getSize(25),
                                          height: getSize(25),
                                          color: Colors.green,
                                          animateIcon: AnimateIcons.checkbox,
                                        ),
                                      )
                                    : AnimatedBuilder(
                                        animation: _iconAnimationController,
                                        builder: (context, child) {
                                          return Transform.translate(
                                            offset: Offset(_iconAnimation.value, 0),
                                            child: child,
                                          );
                                        },
                                        child:

                                            // CustomImageView(
                                            //   image: AssetPaths.whatsapp,
                                            //   color: ColorConstant.logoSecondColor,
                                            //   width: getSize(20),
                                            //   height: getSize(20),
                                            //   // imagePath: AssetPaths.FacebookImage,
                                            // )
                                            Icon(
                                          FontAwesomeIcons.whatsapp,
                                          color: ColorConstant.logoFirstColor,
                                          size: getSize(18),
                                        ));
                          })
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TickPainter extends CustomPainter {
  final double progress;

  TickPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 5 // Reduced stroke width for smaller size
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    // Adjust path to fit within the 20x20 pixel area
    path.moveTo(size.width * 0.25, size.height * 0.6);
    path.lineTo(size.width * 0.45, size.height * 0.8);
    path.lineTo(size.width * 0.75, size.height * 0.4);

    // Animate the path drawing
    PathMetric pathMetric = path.computeMetrics().first;
    Path extractPath = pathMetric.extractPath(0, pathMetric.length * progress);

    canvas.drawPath(extractPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
