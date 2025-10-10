import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/main.dart';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'package:iq_mall/models/orderdetails.dart';
import 'package:iq_mall/models/orders.dart';

class Order_DetailsController extends GetxController {
  var order;

  List orderdetailsInfo = [];
  List statusdetailsInfo = [];
  RxBool loading = true.obs;

  @override
  void onInit() {
    final arguments = Get.arguments;
    order = arguments['order'];
    orderdetailslist();

    super.onInit();
  }

  var width = MediaQuery.of(Get.context!).size.width;

  TextStyle secondaryTextStyle({
    int? size,
    Color? color,
    FontWeight weight = FontWeight.normal,
    String? fontFamily,
    double? letterSpacing,
    FontStyle? fontStyle,
    double? wordSpacing,
    TextDecoration? decoration,
    TextDecorationStyle? textDecorationStyle,
    TextBaseline? textBaseline,
    Color? decorationColor,
  }) {
    return TextStyle(
      fontSize: size != null ? size.toDouble() : 14,
      color: Colors.black,
      fontWeight: weight,
      letterSpacing: letterSpacing,
      fontStyle: fontStyle,
      decoration: decoration,
      decorationStyle: textDecorationStyle,
      decorationColor: decorationColor,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline,
    );
  }

  Widget mHeading(var value) {
    return Expanded(
        child: Text(
      value,
      style: TextStyle(fontSize: 12, color: Colors.white),
    ));
  }

  Future<bool?> orderdetailslist() async {
    bool success = false;
    loading.value = true;

    Map<String, dynamic> response = await api.getData({
      'token': prefs!.getString("token") ?? "",
      'order_id': order.id,
    }, "cart/get-order-details");

    if (response.isNotEmpty) {
      success = response["succeeded"];

      if (success) {
        prefs?.setInt('selectedaddress', 0);

        var orderdetailsInfo = response['order_products'];
        var orderDetailed = response['order'];
        orderdetaillist.clear();

        Map<int, String> statusMap = {};
        var statusInfo = response['status'];
        for (var data in statusInfo) {
          statusMap[data["id"]] = data["label"];
        }

        for (int i = 0; i < orderdetailsInfo.length; i++) {
          orderdetailsclass.fromJson(orderdetailsInfo[i]);
          order.statusMap = statusMap; // Set statusMap here
        }
        var Temp = ordersclass.fromJson(orderDetailed);
        Temp.statusMap = statusMap;
        order = Temp;

        prefs?.setString('logged_in', 'true');
        loading.value = false;
        return success;
      } else {
        loading.value = false;
        toaster(Get.context!, response["message"]);

        return false;
      }
    } else {
      loading.value = false;
      toaster(Get.context!, 'Request Failed');

      return false;
    }
  }
}
