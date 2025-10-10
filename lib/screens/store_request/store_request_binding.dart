import 'package:get/get.dart';
import 'store_request_controller.dart';

class StoreRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StoreRequestController>(() => StoreRequestController());
  }
} 