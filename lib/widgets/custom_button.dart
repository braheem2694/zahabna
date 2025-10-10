import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:iq_mall/widgets/ui.dart';

import '../cores/math_utils.dart';
import '../utils/ShColors.dart';

class MyCustomButton extends StatelessWidget {
  MyCustomButton(
      {this.shape,
      this.padding,
      this.variant,
      this.fontStyle,
      this.alignment,
      this.margin,
      this.onTap,
      this.width,
      this.textColor = Colors.white,
      this.borderRadius,
      this.height,
      this.fontSize,
      this.buttonColor,
      this.text,
      this.borderColor,
      this.addShadow = false,
      this.borderWidth,
      this.circularIndicatorColor = Colors.white,
      this.prefixWidget,
      this.isExpanded = false,
      this.suffixWidget});

  ButtonShape? shape;

  ButtonPadding? padding;

  ButtonVariant? variant;

  ButtonFontStyle? fontStyle;

  Alignment? alignment;

  EdgeInsetsGeometry? margin;

  VoidCallback? onTap;

  double? width;
  double? fontSize;
  Color? textColor;

  double? height;
  double? borderRadius;
  Color circularIndicatorColor;
  Color? borderColor;
  Color? buttonColor;
  bool addShadow;
  double? borderWidth;

  String? text;

  Widget? prefixWidget;

  Widget? suffixWidget;

  bool isExpanded;
  final animationDuration = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment!,
            child: _buildButtonWidget(),
          )
        : _buildButtonWidget();
  }

  _buildButtonWidget() {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: TextButton(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.transparent), // This line
          splashFactory: NoSplash.splashFactory,
          // This line
        ),
        onPressed: isExpanded ? () => Ui.flutterToast("Please wait while processing your request".tr, Toast.LENGTH_LONG, _setColor(), circularIndicatorColor) : onTap,
        child: _buildButtonWithOrWithoutIcon(),
      ),
    );
  }

  _buildButtonWithOrWithoutIcon() {
    if (prefixWidget != null || suffixWidget != null) {
      return AnimatedContainer(
        duration: animationDuration,
        width: !isExpanded ? width : getSize(50),
        height: height ?? getSize(50),
        decoration: BoxDecoration(
            color: buttonColor ?? MainColor,
            boxShadow: addShadow ? [BoxShadow(color: Colors.black45, blurRadius: 5, spreadRadius: 0.2, offset: const Offset(0, 2))] : null,
            borderRadius: BorderRadius.circular(borderRadius ?? 40),
            border: Border.all(width: borderWidth ?? 1, color: borderColor ?? MainColor)),
        child: !isExpanded
            ? Center(
                child: Text(
                  text ?? "",
                  textAlign: TextAlign.center,
                  style: _setFontStyle(),
                ),
              )
            : Ui.circularIndicatorDefault(color: circularIndicatorColor),
      );
    } else {
      return AnimatedContainer(
        duration: animationDuration,
        width: !isExpanded ? width : getSize(50),
        height: height ?? getSize(50),
        decoration: BoxDecoration(
            color: buttonColor ?? MainColor,
            boxShadow: addShadow ? [BoxShadow(color: Colors.black45, blurRadius: 5, spreadRadius: 0.2, offset: const Offset(0, 2))] : null,
            borderRadius: BorderRadius.circular(borderRadius ?? 40),
            border: Border.all(width: borderWidth ?? 1, color: borderColor ?? MainColor)),
        child: !isExpanded
            ? Center(
                child: Text(
                  text ?? "",
                  textAlign: TextAlign.center,
                  style: _setFontStyle(),
                ),
              )
            : Ui.circularIndicatorDefault(color: circularIndicatorColor),
      );
    }
  }

  _buildTextButtonStyle() {
    return TextButton.styleFrom(
      fixedSize: Size(
        width ?? double.maxFinite,
        height ?? getVerticalSize(40),
      ),
      padding: _setPadding(),
      backgroundColor: _setColor(),
      side: _setTextButtonBorder(),
      shadowColor: _setTextButtonShadowColor(),
      shape: RoundedRectangleBorder(
        borderRadius: _setBorderRadius(),
      ),
    );
  }

  _setPadding() {
    switch (padding) {
      case ButtonPadding.PaddingT15:
        return getPadding(
          top: 15,
          right: 15,
          bottom: 15,
        );
      case ButtonPadding.PaddingAll12:
        return getPadding(
          all: 12,
        );
      case ButtonPadding.PaddingNone:
        return getPadding(
          all: 0,
        );
      case ButtonPadding.PaddingAll8:
        return getPadding(
          all: 8,
        );
      case ButtonPadding.PaddingAll4:
        return getPadding(
          all: 4,
        );
      default:
        return getPadding(
          all: 15,
        );
    }
  }

  _setColor() {
    switch (variant) {
      case ButtonVariant.FillWhiteA700:
        return ColorConstant.whiteA700;
      case ButtonVariant.OutlineBlueA700:
        return null;
      case ButtonVariant.FillDeeporange300:
        return Button_color;
      case ButtonVariant.outLineBlackFillWhite:
        return ColorConstant.white;
      default:
        return MainColor;
    }
  }

  _setTextButtonBorder() {
    switch (variant) {
      case ButtonVariant.OutlineBlueA700:
        return BorderSide(
          color: MainColor,
          width: getHorizontalSize(
            1.00,
          ),
        );
      case ButtonVariant.outLineBlackFillWhite:
        return BorderSide(
          color: MainColor,
          width: getHorizontalSize(
            1.00,
          ),
        );
      default:
        return null;
    }
  }

  _setTextButtonShadowColor() {
    switch (variant) {
      case ButtonVariant.OutlineBlueA7003f:
        return ColorConstant.blueA7003f;

      default:
        return null;
    }
  }

  _setBorderRadius() {
    switch (shape) {
      case ButtonShape.CircleBorder20:
        return BorderRadius.circular(
          getHorizontalSize(
            20.00,
          ),
        );
      case ButtonShape.CircleBorder15:
        return BorderRadius.circular(
          getHorizontalSize(
            15.00,
          ),
        );
      case ButtonShape.RoundedBorder5:
        return BorderRadius.circular(
          getHorizontalSize(
            5.00,
          ),
        );
      case ButtonShape.RoundedBorder10:
        return BorderRadius.circular(
          getHorizontalSize(
            10.00,
          ),
        );
      case ButtonShape.Square:
        return BorderRadius.circular(0);
      default:
        return BorderRadius.circular(
          getHorizontalSize(
            25.00,
          ),
        );
    }
  }

  _setFontStyle() {
    switch (fontStyle) {
      case ButtonFontStyle.PoppinsMedium16:
        return TextStyle(
          color: textColor ?? ColorConstant.whiteA700,
          fontSize: getFontSize(
            fontSize ?? 16,
          ),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
          height: getVerticalSize(
            1.56,
          ),
        );
      case ButtonFontStyle.PoppinsBold15:
        return TextStyle(
          color: textColor ?? ColorConstant.whiteA700,
          fontSize: getFontSize(
            fontSize ?? 15,
          ),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
          height: getVerticalSize(
            1.53,
          ),
        );
      case ButtonFontStyle.PoppinsMedium12:
        return TextStyle(
          color: textColor ?? ColorConstant.blueA700,
          fontSize: getFontSize(
            fontSize ?? 12,
          ),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
          height: getVerticalSize(
            1.50,
          ),
        );
      case ButtonFontStyle.PoppinsRegular9:
        return TextStyle(
          color: textColor ?? ColorConstant.whiteA700,
          fontSize: getFontSize(
            fontSize ?? 9,
          ),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          height: getVerticalSize(
            1.56,
          ),
        );
      case ButtonFontStyle.PoppinsMedium11:
        return TextStyle(
          color: textColor ?? ColorConstant.whiteA700,
          fontSize: getFontSize(
            fontSize ?? 11,
          ),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
          height: getVerticalSize(
            1.55,
          ),
        );
      case ButtonFontStyle.PoppinsMedium11WhiteA700:
        return TextStyle(
          color: textColor ?? ColorConstant.whiteA700,
          fontSize: getFontSize(
            fontSize ?? 11,
          ),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
          height: getVerticalSize(
            1.27,
          ),
        );
      case ButtonFontStyle.PoppinsSemiBold13BlueA700:
        return TextStyle(
          color: textColor ?? ColorConstant.blueA700,
          fontSize: getFontSize(
            fontSize ?? 13,
          ),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          height: getVerticalSize(
            1.54,
          ),
        );
      case ButtonFontStyle.PoppinsMedium12WhiteA700:
        return TextStyle(
          color: textColor ?? ColorConstant.whiteA700,
          fontSize: getFontSize(
            fontSize ?? 12,
          ),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
          height: getVerticalSize(
            1.50,
          ),
        );
      default:
        return TextStyle(
          color: textColor ?? ColorConstant.whiteA700,
          fontSize: getFontSize(
            fontSize ?? 13,
          ),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          height: getVerticalSize(
            1.54,
          ),
        );
    }
  }
}

enum ButtonShape {
  Square,
  CircleBorder25,
  CircleBorder20,
  CircleBorder15,
  RoundedBorder5,
  RoundedBorder10,
}

enum ButtonPadding {
  PaddingAll15,
  PaddingT15,
  PaddingAll12,
  PaddingAll8,
  PaddingAll4,
  PaddingNone,
}

enum ButtonVariant {
  FillBlueA700,
  OutlineBlueA7003f,
  FillIndigoA700,
  FillWhiteA700,
  outLineBlackFillWhite,
  FillIndigoA100,
  FillDeeporange300,
  FillOrange300,
  OutlineIndigoA100cc,
  FillBlueA70026,
  OutlineBlueA700,
}

enum ButtonFontStyle {
  PoppinsSemiBold13,
  PoppinsMedium16,
  PoppinsBold15,
  PoppinsMedium12,
  PoppinsRegular9,
  PoppinsMedium11,
  PoppinsMedium11WhiteA700,
  PoppinsSemiBold13BlueA700,
  PoppinsMedium12WhiteA700,
}
