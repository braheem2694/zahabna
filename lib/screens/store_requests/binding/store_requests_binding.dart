import 'package:get/get.dart';
import '../store_requests_controller.dart';

class StoreRequestsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StoreRequestsController>(
      () => StoreRequestsController(),
    );
  }
} 