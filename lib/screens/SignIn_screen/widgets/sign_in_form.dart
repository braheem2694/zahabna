import 'dart:io';
import 'package:iq_mall/cores/language_model.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iq_mall/routes/app_routes.dart';
import 'package:iq_mall/screens/Home_screen_fragment/controller/Home_screen_fragment_controller.dart';
import 'package:iq_mall/screens/SignIn_screen/controller/SignIn_controller.dart';
import 'package:iq_mall/screens/Wishlist_screen/controller/Wishlist_controller.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/utils/ShConstant.dart';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'package:iq_mall/main.dart';
import 'package:iq_mall/screens/HomeScreenPage/ShHomeScreen.dart';
import 'package:iq_mall/utils/ShImages.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../cores/math_utils.dart';
import '../../../utils/validation_functions.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_image_view.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../TermsAndConditions_screen/terms_widget.dart';
import '../../tabs_screen/tabs_view_screen.dart';
import 'package:flutter/services.dart';

import '../SignIn_screen.dart';
import 'package:flutter/src/foundation/constants.dart';

class SignInForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;
  final TextEditingController passwordController;
  final bool obscureText;
  final VoidCallback onForgotPassword;
  final VoidCallback onSignIn;
  final VoidCallback onSignUp;
  final SignInController controller;
  final bool isIOS;
  final Function(BuildContext) onAppleSignIn;
  final Function(BuildContext) onGoogleSignIn;

  SignInForm({
    required this.formKey,
    required this.emailFocusNode,
    required this.passwordFocusNode,
    required this.emailController,
    required this.passwordController,
    required this.obscureText,
    required this.onForgotPassword,
    required this.onSignIn,
    required this.onSignUp,
    required this.isIOS,
    required this.onAppleSignIn,
    required this.onGoogleSignIn,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        height: Get.height,
        alignment: Alignment.bottomCenter,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: getPadding(top: 10.0),
                  child: Center(
                      child: CustomImageView(
                    // svgUrl: prefs!.getString('main_image')!,
                    svgPath: AssetPaths.signInIllustration,
                    width: getSize(250),
                    height: getSize(250),
                  )),
                ),
                SizedBox(
                  height: spacing_standard_new,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Select language".tr,
                        style: TextStyle(fontSize: getFontSize(14), color: ColorConstant.logoFirstColor, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(width: getHorizontalSize(10)),
                      typeDropDown(context),
                    ],
                  ),
                ),
                SizedBox(
                  height: getVerticalSize(10),
                ),
                CustomTextFormField(
                  controller: emailController,
                  textInputAction: TextInputAction.next,
                  focusNode: emailFocusNode,
                  textInputType: TextInputType.number,
                  width: 320,
                  autofocus: false,
                  hintText: 'Phone number',
                  prefix: CodePicker(context),
                  variant: TextFormFieldVariant.OutlineGray300,
                  shape: TextFormFieldShape.RoundedBorder10,
                  padding: TextFormFieldPadding.PaddingT4,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'fill phone number please'.tr;
                    }
                    if (value.length < 8) {
                      return 'Phone number must be of 8 digits'.tr;
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: spacing_standard_new,
                ),
                Obx(
                  () => CustomTextFormField(
                    controller: passwordController,
                    focusNode: passwordFocusNode,
                    textInputAction: TextInputAction.next,
                    textInputType: TextInputType.visiblePassword,
                    width: 320,
                    isObscureText: controller.obscureText.value,
                    autofocus: false,
                    hintText: 'Password',
                    prefix: const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(Icons.lock),
                    ),
                    suffix: IconButton(
                        onPressed: () {
                          controller.obscureText.value = !controller.obscureText.value;
                        },
                        icon: Icon(
                          !controller.obscureText.value ? Icons.remove_red_eye : Icons.visibility_off,
                          color: MainColor,
                          size: 18,
                        )),
                    variant: TextFormFieldVariant.OutlineGray300,
                    shape: TextFormFieldShape.RoundedBorder10,
                    padding: TextFormFieldPadding.PaddingT4,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Fill password please'.tr;
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: getPadding(top: 12.0),
                  child: InkWell(
                    onTap: onForgotPassword,
                    child: SizedBox(width: getHorizontalSize(250), height: getSize(50), child: Center(child: Text('Forget password?'.tr))),
                  ),
                ),
                Obx(() => MyCustomButton(
                      height: getVerticalSize(50),
                      text: "Sign In".tr,
                      fontSize: 20,
                      borderRadius: 10,
                      width: 320,
                      buttonColor: ColorConstant.logoSecondColor,
                      borderColor: Colors.transparent,
                      isExpanded: controller.loggin_in.value,
                      onTap: onSignIn,
                    )),
                Obx(() => IgnorePointer(
                      ignoring: controller.loggin_in.value,
                      child: MyCustomButton(
                        height: getVerticalSize(50),
                        text: "Sign Up".tr,
                        fontSize: 20,
                        borderRadius: 10,
                        textColor: Colors.white,
                        width: 320,
                        buttonColor: ColorConstant.logoSecondColor,
                        padding: ButtonPadding.PaddingNone,
                        borderColor: Colors.transparent,
                        variant: ButtonVariant.outLineBlackFillWhite,
                        isExpanded: false,
                        onTap: onSignUp,
                      ),
                    )),
                !isIOS
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(top: spacing_standard_new),
                        child: SignInWithAppleButton(
                          style: SignInWithAppleButtonStyle.black,
                          onPressed: () async {
                            final credential = await SignInWithApple.getAppleIDCredential(
                              scopes: [
                                AppleIDAuthorizationScopes.email,
                                AppleIDAuthorizationScopes.fullName,
                              ],
                            );
                            controller.emailFocusNode.unfocus();
                            controller.passwordFocusNode.unfocus();
                            onAppleSignIn(context);
                          },
                        ),
                      ),
                Padding(
                  padding: getPadding(top: 12.0),
                  child: SizedBox(
                    width: 320,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          onTap: () async {
                            controller.emailFocusNode.unfocus();
                            controller.passwordFocusNode.unfocus();
                            onGoogleSignIn(context);
                          },
                          child: CustomImageView(
                            svgPath: AssetPaths.GoogleImage,
                            width: getSize(
                              50,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Platform.isIOS
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SignInWithAppleButton(
                          style: SignInWithAppleButtonStyle.whiteOutlined,
                          onPressed: () async {
                            final credential = await SignInWithApple.getAppleIDCredential(
                              scopes: [
                                AppleIDAuthorizationScopes.email,
                                AppleIDAuthorizationScopes.fullName,
                              ],
                            );
                            final String? userIdentifier = credential.identityToken;
                            final String userIdentifier2 = credential.authorizationCode;
                            print(userIdentifier);
                            print(userIdentifier2);
                            print(credential);
                            controller.emailFocusNode.unfocus();
                            controller.passwordFocusNode.unfocus();
                            controller.socialmedialogin('apple', credential.userIdentifier, "");

                            // controller.applelogin(context, credential.email.toString(), credential.givenName.toString(), credential.familyName.toString(), '4', credential.userIdentifier.toString(),
                            //     credential.userIdentifier);
                          },
                        ),
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      if (prefs?.getString('terms_accepted') != 'true') {
                        _showTermsDialog(context);
                      } else {
                        prefs?.setString('logged_in', 'false');
                        LoadingDrawer.value = false;
                        if (Get.isRegistered<Home_screen_fragmentController>()) {
                          Get.back();
                        } else {
                          Get.offAllNamed(AppRoutes.tabsRoute);
                        }
                      }
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(''),
                          Row(
                            children: [
                              Padding(
                                padding:  EdgeInsets.only(bottom: getBottomPadding()),
                                child: Text(
                                  'Skip'.tr,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                size: 12,
                                color: MainColor,
                              )
                            ],
                          ),
                          const Text(''),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTermsDialog(BuildContext context) {
    AwesomeDialog(
        width: MediaQuery.of(context).size.width < 1000 ? 350 : 600,
        context: context,
        dismissOnBackKeyPress: true,
        dismissOnTouchOutside: false,
        dialogType: DialogType.info,
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: Get.height * 0.6,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: getFontSize(50)!),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(
                              'Warning'.tr,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TermsWidget()
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(''),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: MainColor,
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            prefs?.setString('terms_accepted', 'true');
                            Navigator.of(context).pop();
                          },
                          child: Text('Accept'.tr, style: const TextStyle(color: Colors.white)),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: MainColor,
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            exit(0);
                          },
                          child: Text(
                            'Decline'.tr,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Text(''),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        )).show();
  }

  Widget typeDropDown(BuildContext context) {
    return Obx(() {
      return Container(
        height: getSize(50),
        width: getHorizontalSize(110),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(color: Colors.white.withOpacity(0.5)),
          color: sh_light_grey,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 1,
              offset: const Offset(1, 2),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: getSize(12)),
        // Add padding for internal alignment
        child: DropdownButtonHideUnderline(
          child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: sh_light_grey, // Dropdown background color
              popupMenuTheme: PopupMenuThemeData(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
            child: DropdownButton<String>(
              isExpanded: true,
              value: controller.selectedLanguage.value.shortcut,
              items: controller.appLanguages.map((type) {
                return DropdownMenuItem<String>(
                  value: type.shortcut,
                  child: Text(
                    type.shortcut.toString().tr,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: getFontSize(13),
                    ),
                  ),
                );
              }).toList(),
              icon: Icon(
                Icons.arrow_drop_down,
              ),
              // Adjust icon size if needed
              onChanged: (newValue) {
                if (kDebugMode) {
                  print(newValue.toString());
                }
                controller.selectedLanguage.value = languages.firstWhere((element) => element.shortcut == newValue);
                Get.updateLocale(Locale(newValue!));
                // controller.locale = Locale(value);
                prefs?.setString('locale', newValue);
              },
              hint: Text(
                "Select type".tr,
                style: TextStyle(
                  fontSize: getFontSize(13),
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              style: TextStyle(color: Colors.black),
              // Selected item style
              dropdownColor: sh_light_grey,
              elevation: 16,
              // Shadow elevation
              borderRadius: BorderRadius.circular(15),
              // Border radius of dropdown
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            ),
          ),
        ),
      );
    });
  }
}
