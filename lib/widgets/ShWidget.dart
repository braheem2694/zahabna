import 'package:animated_icon/animated_icon.dart';
import 'package:flutter/foundation.dart';
import 'package:iq_mall/utils/ShConstant.dart';
import 'package:toastification/toastification.dart';
import 'package:vibration/vibration.dart';
import 'package:iq_mall/widgets/CommonWidget.dart';
import 'package:iq_mall/widgets/ui.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:iq_mall/models/CurrencyEx.dart';

import 'package:iq_mall/cores/assets.dart';

import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/main.dart';

import '../cores/math_utils.dart';
import '../screens/ProductDetails_screen/widgets/animated_icon_widget.dart';
import '../utils/ShImages.dart';
import 'custom_image_view.dart';

Widget text(var text,
    {var fontSize = textSizeMedium,
    textColor = sh_textColorSecondary,
    var fontFamily = fontRegular,
    var isCentered = false,
    var maxLine = 1,
    TextOverflow textOverflow = TextOverflow.ellipsis,
    var latterSpacing = 0.2,
    var isLongText = false,
    var isJustify = false,
    var aDecoration}) {
  return Text(
    text,
    textAlign: isCentered
        ? TextAlign.center
        : isJustify
            ? TextAlign.justify
            : TextAlign.start,
    maxLines: isLongText ? 20 : maxLine,
    overflow: textOverflow,
    style: TextStyle(
        fontFamily: fontFamily,
        decoration: aDecoration,
        fontSize: double.parse(fontSize.toString()).toDouble(),
        height: 1.5,
        color: textColor.toString().isNotEmpty ? textColor : null,
        letterSpacing: latterSpacing),
  );
}

InputDecoration formFieldDecoration(String? hintText) {
  return InputDecoration(
    labelText: hintText,
    fillColor: Colors.white,
    counterText: "",
    labelStyle: const TextStyle(fontSize: textSizeMedium),
    contentPadding: const EdgeInsets.only(bottom: 2.0),
  );
}

Widget divider() {
  return const Divider(
    height: 0.5,
    color: sh_view_color,
  );
}

Widget horizontalHeading(var title, {var callback, String? categorylist}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        const Divider(
          height: 20,
          thickness: 0.6,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              title,
            ),
            // GestureDetector(
            //   onTap: () {
            //     callback();
            //   },
            //   child: Container(
            //     padding: const EdgeInsets.only(
            //         left: spacing_standard_new, top: spacing_control, bottom: spacing_control),
            //     child: Text(
            //       'View all'.tr,
            //     ),
            //   ),
            // ),
          ],
        ),
        const Divider(
          height: 20,
          thickness: 0.6,
        ),
      ],
    ),
  );
}

vibrationMethod() async {
  HapticFeedback.heavyImpact();
}

Widget percent(percent) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const Text(''),
      Padding(
        padding: const EdgeInsets.only(left: 3.0, right: 3),
        child: Container(
            height: 32,
            decoration: BoxDecoration(shape: BoxShape.circle, color: MainColor),
            child: Center(
                child: RotationTransition(
                    turns: AlwaysStoppedAnimation(-20 / 360),
                    child: Text(
                      ' -${percent.salesDiscount}%',
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                    )))),
      ),
    ],
  );
}

Widget productcategory(BuildContext context, product, type) {
  return Container(
    decoration: BoxDecoration(
      color: product.author_recommendations == '1'
          ? const Color(0xffd90428)
          : product.featured_products == '1'
              ? const Color(0xfffd6400)
              : product.new_arrivals == '1'
                  ? const Color(0xff408f01)
                  : const Color(0xff4c6a9f),
    ),
    height: 18.0,
    child: Center(child: Text(type, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold))),
  );
}

void toaster(BuildContext context, String? text, {int? d, String? title, ToastificationType? toastType, AnimateIcons? iconAnimation, Color? iconColor,Color? titleColor}) {

  Ui.flutterToast(text, Toast.LENGTH_LONG, iconColor, titleColor);

  // toastification.show(
  //   context: context,
  //   type: toastType ?? ToastificationType.success,
  //   style: ToastificationStyle.flat,
  //
  //   autoCloseDuration: const Duration(seconds: 5),
  //   // title: title!=null?Text(title):null,
  //   title: title != null
  //       ? Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             Text(
  //               title,
  //               style: TextStyle(color: titleColor??ColorConstant.whiteA700, fontWeight: FontWeight.w600, fontSize: getFontSize(18)),
  //             ),
  //             CustomAnimateIcon(
  //               key: UniqueKey(),
  //               duration: 1500,
  //               onTap: () {},
  //               iconType: IconType.continueAnimation,
  //               width: getSize(25),
  //               height: getSize(25),
  //               color: iconColor ?? ColorConstant.white,
  //               animateIcon: iconAnimation ?? AnimateIcons.bell,
  //             )
  //           ],
  //         )
  //       : null,
  //   // you can also use RichText widget for title and description parameters
  //   description: Padding(
  //     padding: getPadding(bottom: 8.0),
  //     child: RichText(text: TextSpan(text: text.toString().tr, style: TextStyle(color: ColorConstant.white, fontSize: getFontSize(15), fontWeight: FontWeight.w400))),
  //   ),
  //   alignment: Alignment.bottomCenter,
  //   direction: TextDirection.ltr,
  //   animationDuration: const Duration(milliseconds: 300),
  //   animationBuilder: (context, animation, alignment, child) {
  //     return FadeTransition(
  //       opacity: AlwaysStoppedAnimation<double>(0.9),
  //       child: child,
  //     );
  //   },
  //   icon: Padding(
  //     padding: getPadding(left: 8.0),
  //     child: Container(
  //       decoration: BoxDecoration(shape: BoxShape.circle, color: ColorConstant.whiteA700),
  //       padding: getPadding(all: 5),
  //       child: CustomImageView(
  //         width: getSize(30),
  //         height: getSize(30),
  //         url: prefs!.getString('main_image'),
  //         svgUrl: prefs!.getString('main_image'),
  //         imagePath: AssetPaths.placeholder,
  //       ),
  //     ),
  //   ),
  //   primaryColor: ColorConstant.white,
  //   backgroundColor: ColorConstant.logoFirstColor,
  //   foregroundColor: ColorConstant.white,
  //   padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
  //   margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 4),
  //   borderRadius: BorderRadius.circular(10),
  //
  //   showProgressBar: false,
  //   closeButtonShowType: CloseButtonShowType.none,
  //   closeOnClick: true,
  //   pauseOnHover: true,
  //   dragToClose: true,
  //   applyBlurEffect: false,
  //   progressBarTheme: ProgressIndicatorThemeData(
  //     color: ColorConstant.whiteA700,
  //   ),
  //   dismissDirection: DismissDirection.horizontal,
  //   callbacks: ToastificationCallbacks(
  //     onTap: (toastItem) => print('Toast ${toastItem.id} tapped'),
  //     onCloseButtonTap: (toastItem) => print('Toast ${toastItem.id} close button tapped'),
  //     onAutoCompleteCompleted: (toastItem) => print('Toast ${toastItem.id} auto complete completed'),
  //     onDismissed: (toastItem) => print('Toast ${toastItem.id} dismissed'),
  //   ),
  // );
}

Widget Linear_Progressor_indecator() {
  return Center(
    child: LinearProgressIndicator(
      color: MainColor,
      backgroundColor: MainColor,
      semanticsLabel: 'Linear progress indicator',
    ),
  );
}
