import 'package:get/get.dart';

import 'package:iq_mall/main.dart';
import 'package:iq_mall/models/Notifications.dart';

import 'package:flutter/src/widgets/scroll_controller.dart';

class NotificationsController extends GetxController {
  bool? reload;
  RxBool loading = true.obs;

  ScrollController mainController = ScrollController();

  @override
  void onInit() {
    mainController.addListener(() {
      if (mainController.position.pixels == mainController.position.maxScrollExtent) {
        GetNotifications(true);
      }
    });
    GetNotifications(false);
    super.onInit();
  }

  @override
  void dispose() {
    notificationslist.clear();
    super.dispose();
  }

  int limit = 20;
  int offset = 1;

  Future<bool> GetNotifications(bool isScroll) async {
    bool success = false;

    try {
      Map<String, dynamic> response = await api.getData({
        'token': prefs!.getString("token") ?? "",
        'page': offset.toString(),
      }, "notif/notifications");

      if (response.isNotEmpty) {
        success = response["succeeded"];
        loading.value = true;
        offset++;

        if (success) {
          if (!isScroll) {
            notificationslist.clear();
          }
          List notificationsInfo = response["notifications"];
          for (int i = 0; i < notificationsInfo.length; i++) {
            notificationsclass.fromJson(notificationsInfo[i]);
          }
        }

        loading.value = false;
      }
    } catch (e) {
      loading.value = false;
    }
    return success;
  }
}
