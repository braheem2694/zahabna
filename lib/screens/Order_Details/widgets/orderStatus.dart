import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iq_mall/utils/ShColors.dart';
import '../../ProductDetails_screen/controller/ProductDetails_screen_controller.dart';
import '../controller/Order_Details_controller.dart';

class OrderStatusWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Order_DetailsController controller = Get.find();

    return Container(
      margin: EdgeInsets.all(16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0), // Optional
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // this is the shadow color
            spreadRadius: 5, // Spread the shadow
            blurRadius: 7, // Blur the shadow
            offset: Offset(0, 3), // Position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.access_time,
                color: MainColor,
                size: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Order Track'.tr,
                  style: TextStyle(color: MainColor, fontSize: 17),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  controller.order.statusMap[int.parse(controller.order.status)]
                  ,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blue[200],
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "${'Placed on'.tr}: ",
                  style: TextStyle(color: MainColor, fontSize: 17),
                ),
              ),
              Text(
                // Use it like this:
                getTime(controller.order.created_at.toString()).toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: MainColor,
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => controller.loading.value
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "Shipping Address:"+" "+controller.order.address +
                            "," +
                            controller.order.country +
                            "," +
                            controller.order.city +
                            "," +
                            controller.order.state +
                            "," +
                            controller.order.route_name +
                            "," +
                            controller.order.building_name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: MainColor,
                        ),
                      ),
                    )),
            ],
          ),
        ],
      ),
    );
  }
}

DateTime fromString(String dateTimeStr) {
  return DateTime.parse(dateTimeStr);
}


String getTime(String ss) {
  try {
    // Parse the string into a DateTime object
    var dateTime = DateFormat("yyyy-MM-dd H:m").parse(ss, true);

    // Convert to local time
    var dateLocal = dateTime.toLocal();

    // Format the date-time to a string without seconds
    var formatter = DateFormat('yyyy-MM-dd H:mm');
    return formatter.format(dateLocal);
  } catch (e) {
    return 'not Valid';
  }
}

