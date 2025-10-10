import 'package:get/get.dart';
import 'package:iq_mall/screens/notifications_screen/controller/notification_controller.dart';

import '../controller/Order_Details_controller.dart';

class Order_DetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Order_DetailsController());
  }


}
