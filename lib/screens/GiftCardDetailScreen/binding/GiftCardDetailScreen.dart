import 'package:get/get.dart';

import '../controller/GiftCardDetailScreen_controller.dart';

class GiftCardDetailScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GiftCardDetailScreenController());
  }


}
