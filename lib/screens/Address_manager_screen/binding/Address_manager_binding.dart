import 'package:get/get.dart';
import 'package:iq_mall/screens/notifications_screen/controller/notification_controller.dart';

import '../controller/Address_manager_controller.dart';

class Address_managerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Address_managerController());
  }


}
