import 'package:get/get.dart';
import 'package:iq_mall/screens/notifications_screen/controller/notification_controller.dart';

import '../controller/Orders_list_controller.dart';

class Orders_list_Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Orders_list_Controller());
  }


}
