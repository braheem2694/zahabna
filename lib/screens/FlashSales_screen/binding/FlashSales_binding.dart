import 'package:get/get.dart';
import 'package:iq_mall/screens/notifications_screen/controller/notification_controller.dart';

import '../controller/FlashSales_controller.dart';

class FlashSalesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FlashSalesController());
  }


}
