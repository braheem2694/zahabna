import 'package:get/get.dart';
import 'package:iq_mall/screens/notifications_screen/controller/notification_controller.dart';

import '../controller/OffersScreen_controller.dart';

class OffersScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OffersScreenController());
  }


}
