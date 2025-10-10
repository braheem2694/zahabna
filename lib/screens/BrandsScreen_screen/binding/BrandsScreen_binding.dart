import 'package:get/get.dart';

import '../controller/BrandsScreen_controller.dart';
class BrandsScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BrandsScreenController());
  }
}
