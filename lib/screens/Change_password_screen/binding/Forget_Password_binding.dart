import 'package:get/get.dart';
import 'package:iq_mall/screens/notifications_screen/controller/notification_controller.dart';

import '../controller/change_password_controller.dart';

class Change_password_screen_Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Change_password_screen_Controller());
  }


}
