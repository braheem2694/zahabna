import 'package:get/get.dart';
import 'package:iq_mall/screens/bill_screen/controller/bill_controller.dart';

class BillBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BillController());
  // Get.put(BrandsController());
  }


}
