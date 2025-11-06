import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/screens/bill_screen/controller/bill_controller.dart';
import 'package:iq_mall/screens/bill_screen/widgets/d.dart';
// ignore: unused_import
import 'package:iq_mall/widgets/CommonFunctions.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/cores/assets.dart';

import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/main.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/ShConstant.dart';
import '../../Cart_List_screen/controller/Cart_List_controller.dart';
import '../../OrderSummaryScreen/controller/OrderSummaryScreen_controller.dart';

class ProductDetailsSection extends GetView<BillController> {
  OrderSummaryScreenController SummaryController = Get.find();

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => BillController());
    var controller = Get.find<BillController>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 5.0,
          ),
          child: DataTable(
            headingRowColor: MaterialStateColor.resolveWith((states) => MainColor),
            columns: <DataColumn>[
              DataColumn(label: mHeading('Product Name'.tr)),
              DataColumn(label: mHeading('Quantity'.tr)),
              DataColumn(label: mHeading('Price'.tr)),
            ],
            rows: cartlist!.value
                .map(
                  (data) => DataRow(
                    color: MaterialStateColor.resolveWith((states) {
                      return cartlist!.value.indexOf(data) % 2 == 0 ? Colors.white : Colors.grey;
                    }),
                    cells: [
                      DataCell(
                        SizedBox(
                          width: getHorizontalSize(340),
                          child: Text(data.product_name.toString(), maxLines: 2, style: TextStyle(fontSize: getFontSize(11))),
                        ),
                      ),
                      DataCell(Text(data.quantity!, style: secondaryTextStyle())),
                      DataCell(Text(
                        data.sales_discount.toString() == 'null'
                            ? "$sign ${formatter.format(double.parse((data.product_price).toString()) * int.parse(data.quantity!))}"
                            : sign + " " + (double.parse(data.sales_discount.toString()) * int.parse(data.quantity.toString())).toString(),
                        maxLines: 1,
                        style: secondaryTextStyle(),
                      )),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
        Divider(),
        prefs!.getString('has_shipping') == '1'
            ? controller.paying_method.toString() == 'pickup'
                ? const SizedBox()
                : controller.paying_method == 'Pick Up'
                    ? const SizedBox()
                    : Obx(() => globalController.sum.value != 0.0
                        ? Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Shipping amount'.tr, style: TextStyle(fontSize: getFontSize(20), color: Colors.black)),
                                Text("${sign.value}${formatter.format(globalController.sum.value)}", style: TextStyle(fontSize: getFontSize(20), color: Colors.black)),
                              ],
                            ),
                          )
                        : Container())
            : Container(),
        const SizedBox(height: spacing_standard),

        controller.paying_method == 'Pick Up'
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Delivery amount'.tr, style: TextStyle(fontSize: getFontSize(15), color: Colors.black)),
                    Text("${sign.value}${formatter.format(double.parse(prefs!.getString('delivery_cost')!))}", style: const TextStyle(fontSize: 20, color: Colors.black)),
                  ],
                ),
              ),
        const Divider(color: Colors.black, endIndent: 2, thickness: 0.6),

        // Add spacing
        Obx(() => Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Sub Total Amount '.tr, style: TextStyle(fontSize: getFontSize(15), color: Colors.black)),
                  Obx(() => Text("$sign${globalController.result.value - (double.parse(prefs!.getString('delivery_cost')!) + globalController.sum.value)}",
                      style: const TextStyle(fontSize: 20, color: Colors.black))),
                ],
              ),
            )),
        const SizedBox(height: spacing_standard),
        // Add spacing
        Obx(() => Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Total Amount + shipment'.tr, style: TextStyle(fontSize: getFontSize(15), color: Colors.black)),
                  Obx(() => Text("$sign ${(double.parse(Get.context!.read<Counter>().calculateTotal(0.0).toString()) + globalController.sum.value).toString()}",
                      style: const TextStyle(fontSize: 20, color: Colors.black))),
                ],
              ),
            )),
        const SizedBox(height: spacing_standard),
        // Add spacing
        Obx(
          () {
            return SummaryController.coupon_percentage.toString() == '0.0'
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Coupon code %'.tr, style: const TextStyle(fontSize: 20, color: Colors.black)),
                        Text("${SummaryController.coupon_percentage}${'%'}", style: const TextStyle(fontSize: 20, color: Colors.black)),
                      ],
                    ),
                  );
          },
        ),
        const SizedBox(height: spacing_standard),

        Obx(() => SummaryController.coupon_percentage.value != 0.0
            ? Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Discounted Total Amount'.tr, style: const TextStyle(fontSize: 20, color: Colors.black)),
                    Text("$sign${formatter.format(double.parse((Get.context!.read<Counter>().calculateTotal(SummaryController.coupon_percentage.value) + (globalController.sum.value)).toString()))}",
                        style: const TextStyle(fontSize: 20, color: Colors.black)),
                  ],
                ),
              )
            : Container()),
      ],
    );
  }
}
