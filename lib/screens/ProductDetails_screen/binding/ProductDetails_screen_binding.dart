import 'package:get/get.dart';
import 'package:iq_mall/screens/notifications_screen/controller/notification_controller.dart';

import '../controller/ProductDetails_screen_controller.dart';

class ProductDetails_screen_Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProductDetails_screenController());
  }


}
