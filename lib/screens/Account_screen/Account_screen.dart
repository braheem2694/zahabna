import 'dart:convert';
import 'package:iq_mall/routes/app_routes.dart';
import 'package:iq_mall/screens/Account_screen/controller/Account_controller.dart';
import 'package:iq_mall/screens/Account_screen/widgets/getRowItem.dart';
import 'package:iq_mall/screens/SignIn_screen/controller/SignIn_controller.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/cores/assets.dart';
import 'package:iq_mall/screens/tabs_screen/controller/tabs_controller.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/utils/ShConstant.dart';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'package:iq_mall/widgets/CommonFunctions.dart';
import 'package:iq_mall/widgets/CommonWidget.dart';
import 'package:http/http.dart' as http;
import 'package:iq_mall/main.dart';
import 'package:get/get.dart';

import '../../getxController.dart';
import '../HomeScreenPage/ShHomeScreen.dart';

class Accountsscreen extends GetView<AccountController> {
  const Accountsscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar('Account'.tr),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                left: spacing_standard_new,
                bottom: spacing_standard_new,
                right: spacing_standard_new,
                top: 50,
              ),
              child: Column(
                children: <Widget>[
                  RowItem(
                    icon: Icon(
                      Icons.person_outline,
                      color: Button_color,
                    ),
                    title: 'My Profile'.tr,
                    callback: () {
                      Get.toNamed(
                        AppRoutes.MyProfile,
                      )!
                          .then((value) {
                        prefs?.setInt('visitaddresses', prefs?.getInt('1') ?? 1);
                      });
                    },
                  ),
                  // const SizedBox(
                  //   height: spacing_standard_new,
                  // ),
                  // RowItem(
                  //   icon: Icon(
                  //     Icons.person_outline,
                  //     color: Button_color,
                  //   ),
                  //   title: 'Address Manager'.tr,
                  //   callback: () {
                  //     Get.toNamed(
                  //       AppRoutes.AddressesManager,
                  //     )!
                  //         .then((value) {
                  //       prefs?.setInt('visitaddresses', prefs?.getInt('1') ?? 1);
                  //     });
                  //   },
                  // ),
                  // const SizedBox(
                  //   height: spacing_standard_new,
                  // ),
                  // RowItem(
                  //   icon: Icon(
                  //     Icons.reorder_outlined,
                  //     color: Button_color,
                  //   ),
                  //   title: 'My Order'.tr,
                  //   callback: () {
                  //     Get.toNamed(AppRoutes.Orderslistscreen);
                  //   },
                  // ),
                  // const SizedBox(height: spacing_standard_new),
                  // RowItem(
                  //   icon: Icon(
                  //     Icons.local_offer_outlined,
                  //     color: Button_color,
                  //   ),
                  //   title: 'My Offers'.tr,
                  //   callback: () {
                  //     Get.toNamed(AppRoutes.offersScreen, arguments: {
                  //       'offer': '1',
                  //       'store_id': 'null',
                  //     });
                  //   },
                  // ),
                  const SizedBox(height: spacing_standard_new),
                  RowItem(
                    icon: Icon(
                      Icons.favorite_border,
                      color: Button_color,
                    ),
                    title: 'Wish list'.tr,
                    callback: () {
                      TabsController _controller = Get.find();
                      if (globalController.stores.isNotEmpty) {
                        _controller.currentIndex.value = 3;
                      } else {
                        _controller.currentIndex.value = 2;
                      }

                      Get.back();
                      Get.back();
                    },
                  ),
                  if (prefs?.getString("login_type") != "google" && prefs?.getString("login_type") != "facebook" && prefs?.getString("login_type") != "apple")
                    Column(
                      children: [
                        const SizedBox(height: spacing_standard_new),
                        RowItem(
                          icon: Icon(
                            Icons.password,
                            color: Button_color,
                          ),
                          title: 'Change Password'.tr,
                          callback: () {
                            Get.toNamed(
                              AppRoutes.Changepasswordscreen,
                            );
                          },
                        ),
                      ],
                    ),
                  if (prefs?.getString('login_method') == '3')
                    Column(
                      children: [
                        const SizedBox(height: spacing_standard_new),
                        RowItem(
                          icon: Icon(
                            Icons.phone,
                            color: Button_color,
                          ),
                          title: 'Change Phone Number'.tr,
                          callback: () {
                            Get.to(AppRoutes.Phoneverificationscreen, arguments: {'change_password': 'changephonenumber'});
                          },
                        ),
                      ],
                    )
                  else
                    Container(),
                  const SizedBox(height: spacing_standard_new),
                  // RowItem(
                  //   icon: Icon(
                  //     Icons.delete_outline_outlined,
                  //     color: Button_color,
                  //   ),
                  //   title: 'Delete Account'.tr,
                  //   callback: () {
                  //     showDialog(
                  //       context: context,
                  //       builder: (context) => AlertDialog(
                  //         title:  Text('Account Deletion'.tr),
                  //         content:  Text('Are you sure you want to delete your account?'.tr),
                  //         actions: [
                  //           TextButton(
                  //             child:  Text('Cancel'.tr),
                  //             onPressed: () {
                  //               Get.back();
                  //             },
                  //           ),
                  //           ElevatedButton(
                  //             style: ElevatedButton.styleFrom(
                  //               backgroundColor: Button_color,
                  //             ),
                  //             child: Obx(() => controller.Deleting.value
                  //                 ? Container(
                  //                 height: 30,
                  //                 width: 30,child: const CircularProgressIndicator())
                  //                 :  Text(
                  //                     'Yes'.tr,
                  //                     style: TextStyle(color: Colors.white),
                  //                   )),
                  //             onPressed: () async {
                  //               controller.Deleting.value = true;
                  //               bool success = false;
                  //               Map<String, dynamic> response = await api.getData({
                  //                 'token': prefs!.getString("token") ?? "",
                  //               }, "users/disable-user");
                  //
                  //               if (response.isNotEmpty) {
                  //                 success = response["succeeded"];
                  //                 if (success) {
                  //                   controller.Deleting.value = false;
                  //                   Get.back();
                  //                   state?.closeSideMenu();
                  //                   prefs?.setString('logged_in', 'false');
                  //                   prefs!.remove("first_name");
                  //                   prefs!.remove("last_name");
                  //                   prefs!.remove("user_name");
                  //                   prefs!.remove("country_code");
                  //                   prefs!.remove("user_id");
                  //                   prefs!.remove("user_role");
                  //                   prefs!.remove("phone_number");
                  //                   prefs!.remove("login_method");
                  //                   prefs!.remove("token");
                  //                   firebaseMessaging.deleteToken();
                  //                   prefs?.setString('seen', 'true');
                  //                   Get.toNamed(AppRoutes.SignIn);
                  //                 }
                  //               }
                  //             },
                  //           ),
                  //         ],
                  //       ),
                  //     );
                  //   },
                  // ),
                  // const SizedBox(
                  //   height: spacing_standard_new,
                  // ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: MaterialButton(
                      color: Button_color,
                      padding: const EdgeInsets.all(spacing_standard),
                      textColor: Button_color,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0), side: const BorderSide(color: Colors.transparent, width: 1)),
                      onPressed: () async => {
                        // globalController.sideMenuController.closeMenu(),
                        prefs?.setString('logged_in', 'false'),
                        prefs!.remove("first_name"),
                        prefs!.remove("last_name"),
                        prefs!.remove("user_name"),
                        prefs!.remove("country_code"),
                        prefs!.remove("user_id"),
                        prefs!.remove("user_role"),
                        prefs!.remove("phone_number"),
                        prefs!.remove("login_method"),
                        prefs!.remove("token"),
                        prefs!.remove("Profile_image"),
                        firebaseMessaging.deleteToken(),
                        prefs?.setString('seen', 'true'),
                        Get.offAllNamed(AppRoutes.SignIn)
                      },
                      child: text('Sign Out'.tr, fontSize: textSizeNormal, textColor: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
