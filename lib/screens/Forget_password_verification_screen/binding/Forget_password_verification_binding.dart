import 'package:get/get.dart';
import 'package:iq_mall/screens/notifications_screen/controller/notification_controller.dart';

import '../controller/Forget_password_verification_controller.dart';

class Forget_password_verificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Forget_password_verificationController());
  }


}
