import 'package:flutter/material.dart';
import 'package:iq_mall/models/Address.dart';
import 'package:iq_mall/screens/OrderSummaryScreen/controller/OrderSummaryScreen_controller.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/utils/ShConstant.dart';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'package:iq_mall/main.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class ShippingAddressWidget extends StatefulWidget {
  @override
  _ShippingAddressWidgetState createState() => _ShippingAddressWidgetState();
}

class _ShippingAddressWidgetState extends State<ShippingAddressWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    OrderSummaryScreenController controller = Get.find();
    return Obx(() => Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: sh_item_background,

            borderRadius: BorderRadius.circular(10), // Match the border radius with the card
          ),
          padding: const EdgeInsets.all(spacing_standard_new),
          margin: const EdgeInsets.all(spacing_standard_new),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  controller.shipping_colaps = !controller.shipping_colaps;
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.local_shipping_rounded,
                          color: MainColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5),
                          child: Text(
                            'Shipping address'.tr,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: MainColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (!controller.shipping_colaps && addresseslist.isNotEmpty)
                Column(
                  children: [
                    text(
                      addresseslist[prefs!.getInt('selectedaddress') ?? 0].first_name +
                          " " +
                          addresseslist[prefs!.getInt('selectedaddress') ?? 0].last_name +
                          ',' +
                          addresseslist[prefs!.getInt('selectedaddress') ?? 0].phone_number,
                      textColor: sh_textColorPrimary,
                      fontSize: textSizeMedium,
                    ),
                    text(
                      addresseslist[prefs!.getInt('selectedaddress') ?? 0].address,
                      textColor: sh_textColorPrimary,
                      fontSize: textSizeMedium,
                    ),
                    text(
                      addresseslist[prefs!.getInt('selectedaddress') ?? 0].route_name +
                          addresseslist[prefs!.getInt('selectedaddress') ?? 0].building_name +
                          ',' +
                          addresseslist[prefs!.getInt('selectedaddress') ?? 0].city_name +
                          ',' +
                          addresseslist[prefs!.getInt('selectedaddress') ?? 0].country_name +
                          ",",
                      textColor: sh_textColorPrimary,
                      fontSize: textSizeMedium,
                    ),
                    text(
                      "Floor Number : " + addresseslist[prefs!.getInt('selectedaddress') ?? 0].floor_number,
                      textColor: sh_textColorPrimary,
                      fontSize: textSizeMedium,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: MaterialButton(
                        padding: const EdgeInsets.all(spacing_standard),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0), side: BorderSide(color: MainColor, width: 1)),
                        color: MainColor,
                        onPressed: () {
                          Get.toNamed(
                            AppRoutes.AddressesManager,
                          )!
                              .then((value) => {
                                    setState(() {
                                      prefs!.setInt('selectedaddress', prefs!.getInt('selectedaddress')!);
                                    }),
                                  });
                        },
                        child: text('Change Address'.tr, fontSize: textSizeMedium, textColor: sh_white),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ));
  }
}
