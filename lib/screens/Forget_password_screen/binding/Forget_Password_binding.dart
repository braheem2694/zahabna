import 'package:get/get.dart';
import 'package:iq_mall/screens/Forget_password_screen/controller/Forget_Password_controller.dart';

class Forget_Password_Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Forget_Password_Controller());
  }
}
