import 'package:get/get.dart';
import 'package:iq_mall/screens/notifications_screen/controller/notification_controller.dart';

import '../controller/Stores_screen_controller.dart';

class StoresBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StoreController());
  }


}
