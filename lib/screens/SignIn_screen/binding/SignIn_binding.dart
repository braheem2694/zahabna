import 'package:get/get.dart';

import '../controller/SignIn_controller.dart';

class SignInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignInController());
  }


}
