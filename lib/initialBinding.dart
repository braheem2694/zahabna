import 'package:get/get.dart';


import 'API.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(API());
   // Get.put(Splash_ScreenController());

  }
}