import 'package:iq_mall/routes/app_routes.dart';
import 'package:iq_mall/screens/Address_manager_screen/widgets/AddressListView.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/utils/ShConstant.dart';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'package:get/get.dart';
import '../../models/Address.dart';
import '../../utils/ShImages.dart';
import 'controller/Address_manager_controller.dart';

class AddressManager extends GetView<Address_managerController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
                color: Colors.black,
                icon: Icon(Icons.add),
                onPressed: () async {
                  Get.toNamed(AppRoutes.Add_new_address, arguments: {'edit': false, 'navigation': 'normal'})!.then((value) => {
                        controller.loading.value = true,
                        controller.GetAddresses(),
                      });
                })
          ],
          iconTheme: const IconThemeData(color: sh_textColorPrimary),
          title: text(
            'Address Manager'.tr,
            textColor: sh_textColorPrimary,
            fontSize: textSizeNormal,
          ),
          backgroundColor: Colors.white,
        ),
        body: Obx(
          () => !controller.loading.value
              ? addresseslist.isEmpty?Align(
            alignment: Alignment.center,
                child: Container(
                height: 300,
                child: Center(child: Padding(
                  padding: const EdgeInsets.only(top: 48.0),
                  child: Image.asset(AssetPaths.noresultsfound),
                ))),
              ):Stack(
                  children: <Widget>[
                    AddressListView(),
                    addresseslist.isNotEmpty? Align(
                      alignment: Alignment.bottomLeft,
                      child: SizedBox(
                        width: double.infinity,
                        child: MaterialButton(
                          color: MainColor,
                          elevation: 0,
                          padding: const EdgeInsets.all(spacing_standard_new),
                          child: text("Save".tr, textColor: sh_white, fontSize: textSizeLargeMedium),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                      ),
                    ):Container(),
                  ],
                )
              : Center(child: const CircularProgressIndicator()),
        ));
  }
}
