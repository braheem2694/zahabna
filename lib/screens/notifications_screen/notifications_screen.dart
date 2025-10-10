import 'package:flutter/material.dart';
import 'package:iq_mall/screens/notifications_screen/controller/notification_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iq_mall/screens/notifications_screen/widgets/notificationsList%20.dart';
import 'package:iq_mall/widgets/CommonWidget.dart';
import 'package:iq_mall/models/Notifications.dart';
import 'package:iq_mall/utils/ShImages.dart';
import 'package:flutter/src/services/system_chrome.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/widgets/ui.dart';

class notificationsscreen extends GetView<NotificationsController> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
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
              preferredSize: Size.fromHeight(1),
              child: Container(
                height: 1,
                color: Colors.grey[200],
              ),
            ),
          ),
          body: Obx(
            () => controller.loading.value
                ? Padding(
                    padding: const EdgeInsets.only(top: 100.0),
                    child: Progressor_indecator(),
                  )
                : notificationslist.isEmpty
                    ? Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: SvgPicture.asset(AssetPaths.No_notification),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () {
                          return controller.GetNotifications();
                        },
                        child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
                            child: Column(
                              children: [
                                Obx(
                                  () => controller.loading.value ? Container() : NotificationsList(),
                                ),
                              ],
                            )),
                      ),
          )),
    );
  }
}
