import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:iq_mall/screens/notifications_screen/controller/notification_controller.dart';
import 'package:iq_mall/screens/notifications_screen/widgets/notificationsList%20.dart';
import 'package:iq_mall/widgets/CommonWidget.dart';
import 'package:iq_mall/widgets/ui.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/utils/ShImages.dart';
import 'package:iq_mall/cores/math_utils.dart';

import '../../models/Notifications.dart';

class notificationsscreen extends GetView<NotificationsController> {
  const notificationsscreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Notifications".tr,
          style: TextStyle(
            color: ColorConstant.logoFirstColor,
            fontSize: getFontSize(20),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Ui.backArrowIcon(
          iconColor: ColorConstant.logoFirstColor,
          onTap: () => Get.back(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey[200],
          ),
        ),
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return  Center(
            child: Padding(
              padding: EdgeInsets.only(top: 100),
              child: Progressor_indecator(),
            ),
          );
        }

        if (notificationslist.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AssetPaths.No_notification,
                    height: size.height * 0.3,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "No notifications yet".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: getFontSize(16),
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () {
            controller.offset = 1;
            return controller.GetNotifications(false);
          },
          color: ColorConstant.logoFirstColor,
          child: SingleChildScrollView(
            controller: controller.mainController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: AnimatedOpacity(
                opacity: controller.loading.value ? 0.5 : 1.0,
                duration: const Duration(milliseconds: 300),
                child: NotificationsList(),
              ),
            ),
          ),
        );
      }),
    );
  }
}
