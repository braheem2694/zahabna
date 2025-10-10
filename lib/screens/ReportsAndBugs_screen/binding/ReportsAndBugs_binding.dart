import 'package:get/get.dart';
import 'package:iq_mall/screens/notifications_screen/controller/notification_controller.dart';

import '../controller/TermsAndConditions_controller.dart';

class ReportsAndBugsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReportsAndBugsController());
  }


}
