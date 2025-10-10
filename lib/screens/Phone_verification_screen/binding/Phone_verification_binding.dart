import 'package:get/get.dart';
import 'package:iq_mall/screens/notifications_screen/controller/notification_controller.dart';

import '../controller/Phone_verification_controller.dart';

class Phone_verificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Phone_verificationController());
  }


}
