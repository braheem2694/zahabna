import 'package:iq_mall/screens/bill_screen/controller/bill_controller.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/screens/bill_screen/widgets/PaymentDetailsSection.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/main.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../tabs_screen/controller/tabs_controller.dart';

class Billsscreen extends GetView<BillController> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        TabsController _controller = Get.find();
        _controller.currentIndex.value = 0;
        Get.back();
        Get.back();
        return Future.value(true);
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text('Order Summary'.tr),
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10,bottom: 10 ),
            child: SingleChildScrollView(child: PaymentDetailsSection()),
          ),
        ),
      ),
    );
  }
}
