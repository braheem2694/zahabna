import 'package:get/get.dart';
import 'package:iq_mall/routes/app_routes.dart';

import 'package:iq_mall/main.dart';
import 'dart:convert';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'package:iq_mall/widgets/CommonFunctions.dart';
import 'package:http/http.dart' as http;
import 'package:iq_mall/cores/assets.dart';
import 'package:iq_mall/models/Notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/ShColors.dart';

class NotificationsController extends GetxController {
  bool? reload;
  RxBool loading = true.obs;

  @override
  void onInit() {
    GetNotifications();
    super.onInit();
  }

  @override
  void dispose() {
    notificationslist.clear();
    super.dispose();
  }

  int limit = 20;
  int offset = 0;


  Future<bool> GetNotifications() async {
    bool success = false;

    try {
      Map<String, dynamic> response = await api.getData({
        'token': prefs!.getString("token") ?? "",
        'page': offset.toString(),
      }, "notif/notifications");

      if (response.isNotEmpty) {
        success = response["succeeded"];
        loading.value = true;

        if (success) {
          notificationslist.clear();
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
