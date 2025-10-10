import 'package:get/get.dart';
import 'package:iq_mall/screens/notifications_screen/controller/notification_controller.dart';

import '../controller/ContactUs_controller.dart';

class ContactUsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ContactUsController());
  }


}
