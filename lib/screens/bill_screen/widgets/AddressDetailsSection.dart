import 'package:iq_mall/main.dart';
import 'package:iq_mall/screens/OrderSummaryScreen/widgets/PaymentMethodsWidets/PaymentMethodsWidget.dart';
import 'package:iq_mall/screens/bill_screen/controller/bill_controller.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/models/Address.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'package:get/get.dart';

class AddressDetailsSection extends GetView<BillController> {
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => BillController());
    var controller = Get.find<BillController>();
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text('Recipient full name: '.tr),
            ),
            Expanded(
              child: Text(
                '${addresseslist[prefs?.getInt('selectedaddress') ?? 0].first_name} ${addresseslist[prefs?.getInt('selectedaddress') ?? 0]!.last_name}',
              ),
            ),
          ],
        ),
        Divider(color: MainColor, thickness: 1.5),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text("${'Phone number'.tr}: "),
            ),
            Text(addresseslist[(prefs?.getInt('selectedaddress') ?? 0).toInt()].phone_number),
          ],
        ),
        Divider(color: MainColor, thickness: 1.5),
        controller.paying_method == 'Pick Up'
            ? Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text('Address: '.tr),
                  ),
                  Expanded(
                    child: text(
                      "${PaymentMethodsWidgetState.countrychoosen},${PaymentMethodsWidgetState.citychoosen},${PaymentMethodsWidgetState.branchchoosen},",
                      textColor: sh_textColorPrimary,
                    ),
                  ),
                ],
              )
            : Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      // This will allow the text to take up available space
                      child: Text(
                        '${"Shipping address".tr}: ${addresseslist[prefs?.getInt('selectedaddress') ?? 0].first_name} ${addresseslist[prefs?.getInt('selectedaddress') ?? 0].last_name}, ${addresseslist[prefs?.getInt('selectedaddress') ?? 0].phone_number}, ${addresseslist[prefs?.getInt('selectedaddress') ?? 0].address}, ${addresseslist[prefs?.getInt('selectedaddress') ?? 0].state}',
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
              ),
        Divider(color: MainColor, thickness: 1.5),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text("${'Payment Type'.tr} "),
            ),
            Text(controller.paying_method),
          ],
        ),
      ],
    );
  }
}
