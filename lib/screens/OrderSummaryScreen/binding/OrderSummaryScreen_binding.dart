import 'package:get/get.dart';
import 'package:iq_mall/screens/notifications_screen/controller/notification_controller.dart';

import '../controller/OrderSummaryScreen_controller.dart';

class OrderSummaryScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OrderSummaryScreenController());
  }


}
