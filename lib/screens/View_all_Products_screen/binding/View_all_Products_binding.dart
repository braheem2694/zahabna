import 'package:get/get.dart';
import 'package:iq_mall/screens/notifications_screen/controller/notification_controller.dart';

import '../controller/View_all_Products_controller.dart';

class View_all_ProductsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => View_all_ProductsController());
  }


}
