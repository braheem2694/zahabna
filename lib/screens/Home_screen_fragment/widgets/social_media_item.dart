import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/utils/ShImages.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../cores/math_utils.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/custom_image_view.dart';
import '../../../widgets/ui.dart';
import '../../Stores_details/controller/store_detail_controller.dart';
import '../../tabs_screen/models/SocialMedia.dart';
import '../controller/Home_screen_fragment_controller.dart';
import 'package:flutter_html/flutter_html.dart' as html;

// ignore_for_file: must_be_immutable
class SocialMediaScreen extends StatelessWidget {
  SocialMediaScreen({Key? key, required this.sideMenu,required this.padding,required this.isStore})
      : super(
          key: key,
        );
  var controller;

  final bool sideMenu;
  final bool isStore;
  final EdgeInsetsGeometry padding;
  @override
  Widget build(BuildContext context) {
    if(!isStore){
      try{
        controller = Get.find<Home_screen_fragmentController>();

      }catch(e){
        print(e);
        controller = Get.put(Home_screen_fragmentController());

      }
    }
    else{
      controller = Get.find<StoreDetailController>();
    }

    return SizedBox(
      height: !sideMenu?getSize(45):null,
      child: Padding(
        padding: padding,
        child: Obx(
          () => controller.loading.value
              ? Ui.circularIndicator(width: 40, height: 40, color: ColorConstant.logoFirstColor)
              :
          sideMenu?
          GridView.builder(
                  shrinkWrap: true,

                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: getSize(35),
                    crossAxisCount: 3,
                    mainAxisSpacing: getVerticalSize(10),
                    crossAxisSpacing: getVerticalSize(10),
                  ),
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  padding: getPadding(top: 0, bottom: 10),
                  itemCount: controller.socialMedia.length,
                  itemBuilder: (context, index) {
                    SocialMedia model = controller.socialMedia[index];

                    return GestureDetector(
                      onTap: () async {
                        String url = model.link ?? "";
                        final Uri uri = Uri.parse(url);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      behavior: HitTestBehavior.translucent,
                      child: CustomImageView(
                        image: model.mainImage,
                        placeHolder: AssetPaths.placeholder,
                        width: getSize(35),
                        height: getSize(35),
                        fit: BoxFit.contain,
                      ),
                    );
                  },
                ):
          Center(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: getPadding(all: 0),
              scrollDirection: Axis.horizontal,
              itemCount: controller.socialMedia.length,
              itemBuilder: (context, index) {
                SocialMedia model = controller.socialMedia[index];

                return Center(
                  child: Padding(
                    padding: getPadding(right: 8.0,left: 8),
                    child: GestureDetector(
                      onTap: () async {
                        String url = model.link??"";
                        final Uri uri = Uri.parse(url);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      behavior: HitTestBehavior.translucent,
                      child: CustomImageView(
                        image: model.mainImage,
                        placeHolder: AssetPaths.placeholder,
                        width: getSize(35),
                        height: getSize(35),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                );
              },
            ),
          )
          ,
        ),
      ),
    );
  }


}
