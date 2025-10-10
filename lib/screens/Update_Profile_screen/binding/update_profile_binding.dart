import 'package:get/get.dart';
import 'package:iq_mall/screens/notifications_screen/controller/notification_controller.dart';

import '../controller/update_prodile_controller.dart';

class update_profile_screen_Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => update_profile_screen_Controller());
  }


}
