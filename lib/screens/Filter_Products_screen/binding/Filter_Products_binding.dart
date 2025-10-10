import 'package:get/get.dart';
import 'package:iq_mall/screens/notifications_screen/controller/notification_controller.dart';

import '../controller/Filter_Products_controller.dart';

class Filter_ProductsBinding extends Bindings {
  @override
  void dependencies() {
    final tag = Get.parameters['tag'];
    if (tag != null) {
      Get.lazyPut(() => Filter_ProductsController(), tag: tag);
    }
  }
}
