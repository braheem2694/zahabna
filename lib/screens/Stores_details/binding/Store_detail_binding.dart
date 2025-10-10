import 'package:get/get.dart';
import 'package:iq_mall/screens/notifications_screen/controller/notification_controller.dart';

import '../controller/store_detail_controller.dart';


class StoreDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StoreDetailController());
  }


}
