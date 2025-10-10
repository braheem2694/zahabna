import 'package:get/get.dart';
import 'package:iq_mall/screens/notifications_screen/controller/notification_controller.dart';

import '../controller/Stores_screen_controller.dart';
import '../controller/my_store_controller.dart';

class MyStoresBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyStoreController());
  }


}
