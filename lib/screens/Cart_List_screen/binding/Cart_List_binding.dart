import 'package:get/get.dart';
import 'package:iq_mall/screens/notifications_screen/controller/notification_controller.dart';

import '../controller/Cart_List_controller.dart';

class Cart_ListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Cart_ListController());
  }


}
