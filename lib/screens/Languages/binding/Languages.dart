import 'package:get/get.dart';
import 'package:iq_mall/screens/notifications_screen/controller/notification_controller.dart';

import '../controller/Languages_controller.dart';

class LanguagesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LanguagesController());
  }
}
