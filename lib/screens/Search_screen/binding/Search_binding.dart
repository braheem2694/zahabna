import 'package:get/get.dart';
import '../../Account_screen/controller/Account_controller.dart';
import '../controller/Search_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Searchcontroller());
  }


}
