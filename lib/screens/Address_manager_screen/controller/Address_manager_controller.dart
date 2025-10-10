import 'package:get/get.dart';
import 'package:iq_mall/main.dart';
import '../../../models/Address.dart';

class Address_managerController extends GetxController {
  var addressinfo = <addressesclass>[];
  var primaryColor;

  RxBool loading = true.obs;

  @override
  void onInit() {
    final arguments = Get.arguments;
    //  type = arguments['type'];

    addresseslist.value.clear();
    addressesInfo.clear();
    GetAddresses();
    super.onInit();
  }

  Future<bool?> DeleteAddress(index) async {
    loading.value = true;
    bool success = false;
    loading.value = true;
    Map<String, dynamic> response = await api.getData({
      'token': prefs!.getString("token") ?? "",
      'address_id': addresseslist[index].id,
    }, "addresses/remove-address");

    if (response.isNotEmpty) {
      success = response["succeeded"];
      if (success) {}
      loading.value = false;
      return success;
    } else {
      loading.value = false;
      
    }
    loading.value = false;
    return null;
  }

  Future<bool?> GetAddresses() async {
    loading.value = true;
    addresseslist.clear();
    addressesInfo.clear();

    bool success = false;
    loading.value = true;
    Map<String, dynamic> response = await api.getData({
      'token': prefs!.getString("token") ?? "",
    }, "addresses/get-addresses");

    if (response.isNotEmpty) {
      success = response["succeeded"];
      if (success) {
        List productsInfo = response["addresses"];
        addresseslist.clear();
        for (int i = 0; i < productsInfo.length; i++) {
          addressesclass.fromJson(productsInfo[i]);
        }
      }
      loading.value = false;
      return success;
    } else {
      loading.value = false;
      
    }
    loading.value = false;
    return null;
  }
}
