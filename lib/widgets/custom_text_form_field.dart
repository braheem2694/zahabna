import 'package:flutter/material.dart';
import '../cores/math_utils.dart';
import '../utils/ShColors.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField(
      {this.padding,
      this.shape,
      this.variant,
      this.fontStyle,
      this.alignment,
      this.width,
      this.margin,
      this.controller,
      this.focusNode,
      this.inputFormatters,
      this.autofocus = false,
      this.isObscureText = false,
      this.textInputAction = TextInputAction.next,
      this.textInputType = TextInputType.text,
      this.maxLines,
      this.hintText,
      this.prefix,
      this.prefixConstraints,
      this.suffix,
      this.suffixConstraints,
      this.validator});

  TextFormFieldPadding? padding;

  TextFormFieldShape? shape;

  TextFormFieldVariant? variant;

  TextFormFieldFontStyle? fontStyle;

  Alignment? alignment;

  double? width;

  EdgeInsetsGeometry? margin;

  TextEditingController? controller;


  FocusNode? focusNode;

  bool? autofocus;

  List<TextInputFormatter>? inputFormatters;

  bool? isObscureText;

  TextInputAction? textInputAction;

  TextInputType? textInputType;

  int? maxLines;

  String? hintText;

  Widget? prefix;

  BoxConstraints? prefixConstraints;

  Widget? suffix;

  BoxConstraints? suffixConstraints;

  FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: _buildTextFormFieldWidget(),
          )
        : _buildTextFormFieldWidget();
  }

  _buildTextFormFieldWidget() {
    return Container(
      width: width ?? double.maxFinite,
      margin: margin,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        autofocus: autofocus!,
        inputFormatters: inputFormatters,
        style: _setFontStyle(),
        obscureText: isObscureText!,
        textInputAction: textInputAction,
        keyboardType: textInputType,
        maxLines: maxLines ?? 1,
        decoration: _buildDecoration(),
        validator: validator,
      ),
    );
  }

  _buildDecoration() {
    return InputDecoration(
      hintText: hintText ?? "",
      hintStyle: _setFontStyle(),
      border: _setBorderStyle(),
      enabledBorder: _setBorderStyle(),
      focusedBorder: _setBorderStyle(),
      disabledBorder: _setBorderStyle(),
      prefixIcon: prefix,
      prefixIconConstraints: prefixConstraints,
      suffixIcon: suffix,
      suffixIconConstraints: suffixConstraints,
      fillColor: _setFillColor(),
      filled: _setFilled(),
      isDense: true,
      contentPadding: _setPadding(),
    );
  }

  _setFontStyle() {
    switch (fontStyle) {
      case TextFormFieldFontStyle.PoppinsMedium16:
        return TextStyle(
          color: ColorConstant.black900,
          fontSize: getFontSize(
            16,
          ),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        );
      case TextFormFieldFontStyle.InterSemiBold18:
        return TextStyle(
          color: ColorConstant.orange800,
          fontSize: getFontSize(
            18,
          ),
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
        );
      case TextFormFieldFontStyle.PoppinsSemiBold16:
        return TextStyle(
          color: ColorConstant.orange800,
          fontSize: getFontSize(
            16,
          ),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        );
      case TextFormFieldFontStyle.PoppinsMedium10:
        return TextStyle(
          color: ColorConstant.black900,
          fontSize: getFontSize(
            10,
          ),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        );
      case TextFormFieldFontStyle.PoppinsMedium20:
        return TextStyle(
          color: ColorConstant.black900,
          fontSize: getFontSize(
            20,
          ),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        );
      case TextFormFieldFontStyle.PoppinsMedium12:
        return TextStyle(
          color: ColorConstant.gray500,
          fontSize: getFontSize(
            12,
          ),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        );
      default:
        return TextStyle(
          color: ColorConstant.black90001,
          fontSize: getFontSize(
            13,
          ),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        );
    }
  }

  _setOutlineBorderRadius() {
    switch (shape) {
      default:
        return BorderRadius.circular(
          getHorizontalSize(
            10.00,
          ),
        );
    }
  }

  _setBorderStyle() {
    switch (variant) {
      case TextFormFieldVariant.OutlineGray300:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: BorderSide(
            color: ColorConstant.gray300,
            width: 1,
          ),
        );
      case TextFormFieldVariant.logoSecondColor:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: BorderSide(
            color: ColorConstant.logoFirstColor,
            width: 1,
          ),
        );
        case TextFormFieldVariant.OutlineGray200:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: BorderSide(
            color: ColorConstant.gray300,
            width: 1,
          ),
        );
      case TextFormFieldVariant.OutlineBlack90019:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: BorderSide.none,
        );
      case TextFormFieldVariant.UnderLineGray300:
        return UnderlineInputBorder(
          borderSide: BorderSide(
            color: ColorConstant.gray300,
          ),
        ); case TextFormFieldVariant.logoSecondColor:
        return UnderlineInputBorder(
          borderSide: BorderSide(
            color:  ColorConstant.logoSecondColor,
          ),
        );
      case TextFormFieldVariant.UnderLineBlack90001:
        return UnderlineInputBorder(
          borderSide: BorderSide(
            color: ColorConstant.black90001,
          ),
        );
      case TextFormFieldVariant.OutlineGray400:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: BorderSide(
            color: ColorConstant.gray400,
            width: 1,
          ),
        );
      case TextFormFieldVariant.None:
        return InputBorder.none;
      default:
        return UnderlineInputBorder(
          borderSide: BorderSide(
            color: ColorConstant.gray400,
          ),
        );
    }
  }

  _setFillColor() {
    switch (variant) {
      case TextFormFieldVariant.OutlineGray300:
        return ColorConstant.gray100;
      case TextFormFieldVariant.logoSecondColor:
        return ColorConstant.gray100;
      case TextFormFieldVariant.OutlineBlack90019:
        return ColorConstant.whiteA700;
      case TextFormFieldVariant.OutlineGray400:
        return ColorConstant.whiteA700;
      default:
        return null;
    }
  }

  _setFilled() {
    switch (variant) {
      case TextFormFieldVariant.UnderLineGray400:
        return false;
      case TextFormFieldVariant.OutlineGray300:
        return true;
      case TextFormFieldVariant.OutlineBlack90019:
        return true;
      case TextFormFieldVariant.UnderLineGray300:
        return false;
      case TextFormFieldVariant.logoSecondColor:
        return true;
      case TextFormFieldVariant.UnderLineBlack90001:
        return false;
      case TextFormFieldVariant.OutlineGray400:
        return true;
      case TextFormFieldVariant.None:
        return false;
      default:
        return false;
    }
  }

  _setPadding() {
    switch (padding) {
      case TextFormFieldPadding.PaddingT8:
        return getPadding(
          top: 8,
          right: 8,
          bottom: 8,
        );
      case TextFormFieldPadding.PaddingT11_1:
        return getPadding(
          left: 10,
          top: 11,
          bottom: 11,
        );
      case TextFormFieldPadding.PaddingT4:
        return getPadding(
          left: 18,
          top: 18,
          bottom: 18,
        );
        case TextFormFieldPadding.addressPadding:
        return getPadding(
          left: 5,
          top: 18,
          bottom: 18,
        );
      default:
        return getPadding(
          left: 10,
          top: 11,
          right: 10,
          bottom: 11,
        );
    }
  }
}

enum TextFormFieldPadding {
  PaddingT8,
  PaddingT11,
  PaddingT11_1,
  PaddingT4,
  addressPadding,
}

enum TextFormFieldShape {
  RoundedBorder10,
}

enum TextFormFieldVariant {
  None,
  UnderLineGray400,
  OutlineGray300,
  OutlineGray200,
  OutlineBlack90019,
  UnderLineGray300,
  UnderLineBlack90001,
  OutlineGray400,
  logoSecondColor,
}

enum TextFormFieldFontStyle {
  PoppinsMedium13,
  PoppinsMedium16,
  InterSemiBold18,
  PoppinsSemiBold16,
  PoppinsMedium10,
  PoppinsMedium20,
  PoppinsMedium12,
}
