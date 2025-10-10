import 'package:flutter/material.dart';
import 'package:iq_mall/screens/Cart_List_screen/controller/Cart_List_controller.dart';
import 'package:iq_mall/screens/Wishlist_screen/controller/Wishlist_controller.dart';
import 'package:iq_mall/screens/Wishlist_screen/widgets/favoriteListView.dart';
import 'package:iq_mall/screens/tabs_screen/controller/tabs_controller.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/widgets/CommonWidget.dart';
import 'package:iq_mall/main.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iq_mall/utils/ShImages.dart';

import '../../cores/math_utils.dart';
import '../../getxController.dart';
import '../../widgets/custom_image_view.dart';
import '../HomeScreenPage/ShHomeScreen.dart';
// ignore_for_file: must_be_immutable

class Wishlistscreen extends StatelessWidget {
  WishlistController controller = Get.put(WishlistController());

  Wishlistscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        TabsController _controller = Get.find();
        _controller.currentIndex.value = 0;
        return Future.value(false);
      },
      child: Scaffold(

        body: RefreshIndicator(
          color: MainColor,
          onRefresh: () async {
            globalController.refreshHomeScreen(true);
            await controller.GetFavorite();
            return Future(() => true);
          },
          child: GestureDetector(
            onTap: () {
                

            },
            child: Obx(() => controller.loading.value
                ? Progressor_indecator()
                : favoritelist!.isEmpty
                    ? Column(
                        children: [
                          SizedBox(
                            height: Get.height,
                            child: Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 38.0, right: 38),
                                child: CustomImageView(
                                  width: Get.width,
                                  height: Get.width,
                                  image: AssetPaths.emptyFavorite_image,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Padding(
                        padding: EdgeInsets.only(top: globalController.refreshingHomeScreen.value ? 8.0 : 0.0),
                        child: favoritelistView(),
                      )),
          ),
        ),
      ),
    );
  }
}
