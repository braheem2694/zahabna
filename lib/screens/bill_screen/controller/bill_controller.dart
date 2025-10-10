import 'package:get/get.dart';

import '../../../main.dart';
import '../../Cart_List_screen/controller/Cart_List_controller.dart';


class BillController extends GetxController {
  var paying_method;
  @override
  void onInit() {
     paying_method = Get.arguments.toString();
    super.onInit();
  }

}

