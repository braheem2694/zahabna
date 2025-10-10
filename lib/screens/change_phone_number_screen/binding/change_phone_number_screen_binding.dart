import 'package:get/get.dart';
import 'package:iq_mall/screens/change_phone_number_screen/controller/change_phone_number_screen_controller.dart';

class change_phone_number_screenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => change_phone_number_Controller());
  }


}
