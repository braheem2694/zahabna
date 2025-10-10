import 'package:get/get.dart';

import '../controller/NoInternet_controller.dart';

class NoInternetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NoInternetController());
  }


}
