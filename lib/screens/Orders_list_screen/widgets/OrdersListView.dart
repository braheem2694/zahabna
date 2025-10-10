import 'package:iq_mall/screens/Orders_list_screen/controller/Orders_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/cores/assets.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/utils/ShConstant.dart';
import 'package:get/get.dart';
import 'package:iq_mall/models/orders.dart';
import '../../../routes/app_routes.dart';
import '../../Order_Details/widgets/orderStatus.dart';

class OrderListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Orders_list_Controller controller = Get.find();
    return ListView.builder(
      itemCount: orderslist.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        final order = orderslist[index];

        return Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5, bottom: 5, top: 5),
          child: Card(
            color: ColorConstant.gray100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: const BorderSide(
                color: Colors.grey,
                width: 2,
              ),
            ),
            child: InkWell(
              onTap: () {
                Get.toNamed(AppRoutes.OrderDetails, arguments: {'order': order});
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      height: 80, // Adjusted the height
                      width: Get.width * 0.9,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: order.statusMap.keys.where((key) => key != 11 && key != 15).length,
                        itemBuilder: (BuildContext context, int index) {
                          int key = order.statusMap.keys.where((key) => key != 11 && key != 15).elementAt(index);
                          int status = int.parse(order.status.toString());
                          bool shouldBeGreen = key <= status && key != 11 && key != 15;
                          double itemWidth = (Get.width * 0.9) / order.statusMap.keys.where((key) => key != 11 && key != 15).length;
                          String? label = order.statusMap[key];

                          return Container(
                            width: itemWidth,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Icon Row
                                Row(
                                  children: [
                                    shouldBeGreen
                                        ? Container(
                                            width: 30,
                                            height: 20,
                                            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.green),
                                            child: const Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 12, // Adjusted the size
                                            ),
                                          )
                                        : Container(
                                            width: 30,
                                            height: 20,
                                            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
                                            child: const Icon(
                                              Icons.cached,
                                              color: Colors.white,
                                              size: 12, // Adjusted the size
                                            ),
                                          ),
                                    // Exclude the divider for the last item or if status is 100
                                    status == 100 || index == order.statusMap.keys.where((key) => key != 11 && key != 15).length - 1
                                        ? SizedBox()
                                        : Expanded(
                                            child: Divider(
                                              color: shouldBeGreen ? Colors.green : Colors.grey,
                                              thickness: 1.5, // Adjusted the thickness
                                            ),
                                          ),
                                  ],
                                ),
                                // Label
                                label == null
                                    ? SizedBox()
                                    : Padding(
                                        padding: const EdgeInsets.only(top: 2.0), // Adjusted the padding
                                        child: Text(
                                          label,
                                          style: TextStyle(
                                            color: shouldBeGreen ? Colors.green : sh_textColorPrimary,
                                            fontSize: 10, // Adjusted the font size
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Card(
                      color: Color(0xffE0E0E0),
                      child: Container(
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(top: 2, left: 2, right: 2),
                                        child: Table(
                                          border: TableBorder.all(color: Colors.transparent, style: BorderStyle.solid, width: 1),
                                          children: [
                                            TableRow(children: [
                                              Padding(
                                                padding: const EdgeInsets.only(top: 8.0, left: 3, right: 3),
                                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                  Text(
                                                    'Order ID'.tr,
                                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                                  )
                                                ]),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 8.0, left: 3, right: 3),
                                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                  Text("#" + order.id.toString(),
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                      ))
                                                ]),
                                              ),
                                            ]),
                                            TableRow(children: [
                                              Padding(
                                                padding: const EdgeInsets.only(top: 8.0, left: 3, right: 3),
                                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                  Text('Order placed on'.tr, style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold))
                                                ]),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 8.0, left: 3, right: 3),
                                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                  Text(          getTime(order.created_at.toString()),
                                                      style: TextStyle(fontSize: 15.0))
                                                ]),
                                              ),
                                            ]),
                                            TableRow(children: [
                                              Padding(
                                                padding: const EdgeInsets.only(top: 8.0, left: 3, right: 3),
                                                child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [Text('Payment Type'.tr, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))]),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 8.0, left: 3, right: 3),
                                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                  Text(
                                                      order.payment_type_name,
                                                      style: const TextStyle(
                                                        fontSize: 15,
                                                      ))
                                                ]),
                                              ),
                                            ]),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: spacing_standard,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.all(5),
                      color: Color(0xffE0E0E0),
                      child: int.parse(order.status.toString()) != 100
                          ? SizedBox()
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "${'Rejection Reason'.tr}:",
                                      maxLines: 2,
                                      style: TextStyle(color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      order.rejectReason,
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 6, right: 6),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${'Total'.tr}:",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: MainColor),
                              ),
                              Text(
                                  "\$${formatter.format(
                                      ((double.parse(order.total) * (1 - (double.parse(order.discount ?? '0') / 100))) + order.shipping_amount)
                                  )}",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: MainColor)
                              )

                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
