
import 'package:get/get.dart';
import 'package:iq_mall/main.dart';
import 'dart:convert';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'package:iq_mall/models/orders.dart';
import 'package:quickalert/models/quickalert_type.dart';
import '../../../utils/device_data.dart';
import '../../../widgets/Alert.dart';

class Orders_list_Controller extends GetxController {
  List ordersInfo = [];
  RxBool loading = true.obs;

  @override
  void onInit() {
    getorders();
    super.onInit();
  }

  remove_unused_words(address) {
    address = address.replaceAll('Country Name : ', '');
    address = address.replaceAll('City Name : ', '');
    address = address.replaceAll('Branch Name : ', '');
    return address.toString();
  }

  Future<bool?> getorders() async {
    bool success = false;
    // Assuming loading is an observable, and api is your API class
    // I also assume that getDeviceInfo(), prefs and toaster are defined somewhere else in your code
    loading.value = true;

    var data = json.encode(await getDeviceInfo());

    Map<String, dynamic> response = await api.getData({
      'token': prefs!.getString("token") ?? "",
    }, "cart/get-orders");

    if (response.isNotEmpty) {
      success = response["succeeded"];
      if (success) {
        prefs?.setInt('selectedaddress', 0);

        // Populate statusMap from response['status']
        Map<int, String> statusMap = {};
        var statusInfo = response['status'];
        for (var data in statusInfo) {
          statusMap[data["id"]] = data["label"];
        }

        // Create orders and populate orderslist from response['orders']
        var ordersInfo = response['orders'];
        orderslist.clear(); // Clearing existing orders if any, this step is optional based on your requirement
        for (int i = 0; i < ordersInfo.length; i++) {
          ordersclass order = ordersclass.fromJson(ordersInfo[i]);
          order.statusMap = statusMap; // Set statusMap here
          orderslist.add(order);
        }

        prefs?.setString('logged_in', 'true');
        loading.value = false;
        return success;
      } else {
        loading.value = false;
        CustomAlert.show(
          context: Get.context!,
          content: response['Message'],
          type: QuickAlertType.error,
        );
 
        return false;
      }
    } else {
      loading.value = false;
      CustomAlert.show(
        context: Get.context!,
        content: 'Request Failed',
        type: QuickAlertType.error,
      );
      
      return false;
    }
  }
}
