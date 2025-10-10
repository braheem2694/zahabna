import 'package:get/get.dart';
import 'package:iq_mall/screens/notifications_screen/controller/notification_controller.dart';
import 'package:iq_mall/screens/transactions/controllers/transactrions_controller.dart';

class TransActionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TransactionsController());
  }
}
