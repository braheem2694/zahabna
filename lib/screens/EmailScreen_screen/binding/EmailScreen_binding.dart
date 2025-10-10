import 'package:get/get.dart';
import 'package:iq_mall/screens/notifications_screen/controller/notification_controller.dart';

import '../controller/EmailScreen_controller.dart';

class EmailScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EmailScreenController());
  }


}
