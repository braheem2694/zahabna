import 'package:get/get.dart';
import 'package:iq_mall/screens/notifications_screen/controller/notification_controller.dart';

import '../controller/Home_screen_fragment_controller.dart';

class Home_screen_fragmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Home_screen_fragmentController());
  }


}
