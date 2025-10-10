import 'package:get/get.dart';
import '../controller/Add_new_address_screen_controller.dart';

class Add_new_address_screenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Add_new_address_screenController());
  }


}
