import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:iq_mall/routes/app_routes.dart';
import 'package:iq_mall/screens/SignIn_screen/controller/SignIn_controller.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/screens/SignIn_screen/widgets/background_widget.dart';
import 'package:iq_mall/screens/SignIn_screen/widgets/sign_in_form.dart';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../cores/language_model.dart';
import '../../cores/math_utils.dart';
import '../../main.dart';
import '../../utils/ShColors.dart';
import '../../utils/ShImages.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/image_widget.dart';
import '../HomeScreenPage/ShHomeScreen.dart';
import '../Wishlist_screen/controller/Wishlist_controller.dart';

class SignInScreen extends GetView<SignInController> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          prefs?.setString('logged_in', 'false');
          LoadingDrawer.value = false;
        });
        return Future.value(true);
      },
      child: Obx(
        () => AbsorbPointer(
          absorbing: controller.signing.value,
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: IgnorePointer(
              ignoring: controller.signing.value,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Image.asset(AssetPaths.iqMallBackground,
                  //   width: Get.width,
                  //   height: Get.height,
                  //   fit: BoxFit.cover,
                  // ),
                  // CustomImageView(
                  //   imagePath: AssetPaths.iqMallBackgroundPng,
                  //   height: Get.height,
                  //   width: Get.width,
                  //   fit: BoxFit.cover,
                  // ),

                  // mediaWidget(
                  //   prefs!.getString('Stores_page_background') ?? "",
                  //   AssetPaths.placeholder,
                  //   width: Get.width,
                  //   height: Get.height,
                  //   isProduct: false,
                  //   fromKey: "filter",
                  //   fit: BoxFit.cover,
                  // ),
                  SignInForm(
                    controller: controller,
                    emailFocusNode: controller.emailFocusNode,
                    passwordFocusNode: controller.passwordFocusNode,
                    formKey: controller.formKey,
                    emailController: controller.emailcontroller,
                    passwordController: controller.passwordcontroller,
                    obscureText: controller.obscureText.value,
                    onForgotPassword: () {
                      // Get.toNamed(AppRoutes.ForgetPasswordscreen, arguments: {'phone_number': "76600252", 'code': country_code});

                      Get.toNamed(AppRoutes.Forgetpasswordverificationscreen);
                    },
                    onSignIn: () async {
                      if (!controller.loggin_in.value) {
                        if (prefs?.getString('terms_accepted') != 'true') {
                          _showTermsDialog(context);
                        } else {
                          if (controller.emailcontroller.text.isNotEmpty &&
                              controller.passwordcontroller.text.isNotEmpty) {
                            controller.emailFocusNode.unfocus();
                            controller.passwordFocusNode.unfocus();
                            controller.Login();
                          } else {
                            toaster(
                                context, 'Fill both username and password'.tr);
                          }
                        }
                      }
                    },
                    onSignUp: () {
                      Get.toNamed(AppRoutes.SignUp);
                    },
                    isIOS: controller.isIOS,
                    onAppleSignIn: (context) async {
                      if (prefs?.getString('terms_accepted') != 'true') {
                        _showTermsDialog(context);
                      } else {
                        final credential =
                            await SignInWithApple.getAppleIDCredential(
                          scopes: [
                            AppleIDAuthorizationScopes.email,
                            AppleIDAuthorizationScopes.fullName,
                          ],
                        );
                        controller.applelogin(
                            context,
                            credential.email.toString(),
                            credential.givenName.toString(),
                            credential.familyName.toString(),
                            '4',
                            credential.userIdentifier.toString(),
                            credential.userIdentifier);
                      }
                    },
                    onGoogleSignIn: (context) {
                      if (prefs?.getString('terms_accepted') != 'true') {
                        _showTermsDialog(context);
                      } else {
                        controller.onGoogleSignIn(context);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showTermsDialog(BuildContext context) {
    AwesomeDialog(
      width: Get.width < 1000 ? 350 : 600,
      context: Get.context!,
      dismissOnBackKeyPress: true,
      dismissOnTouchOutside: false,
      dialogType: DialogType.info,
      body: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight:
              Get.height * 0.7, // Increased max height to prevent cut-off
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          'Warning'.tr,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      Html(
                        data: languages
                            .firstWhere(
                              (element) =>
                                  element.shortcut?.toLowerCase() ==
                                  (prefs
                                          ?.getString("locale")
                                          .toString()
                                          .toLowerCase() ??
                                      "en"),
                            )
                            .termsAndConditions,
                        shrinkWrap: true,
                        style: {
                          "body": Style(
                            padding:
                                HtmlPaddings.zero, // Remove unnecessary padding
                            margin: Margins.zero, // Remove unnecessary margins
                          ),
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: MainColor,
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      prefs?.setString('terms_accepted', 'true');
                      Get.back();
                    },
                    child: Text('Accept'.tr,
                        style: const TextStyle(color: Colors.white)),
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
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    ).show();
  }

  Future<void> updateLocaleAndShowDialog() async {
    String? locale =
        (prefs?.getString("locale") != null && prefs?.getString("locale") != "")
            ? prefs?.getString("locale")!
            : "EN";

    Get.updateLocale(Locale(locale ?? 'EN')); // ✅ Update Locale
  }
}
