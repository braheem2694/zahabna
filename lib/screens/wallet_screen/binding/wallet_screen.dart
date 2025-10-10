import 'package:get/get.dart';
import '../controller/wallet_screen_controller.dart';
class wallet_screenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => wallet_screenController());
  }


}
