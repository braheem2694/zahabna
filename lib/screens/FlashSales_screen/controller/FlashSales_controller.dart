import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/main.dart';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:iq_mall/cores/assets.dart';


import 'package:iq_mall/screens/Cart_List_screen/Cart_List_screen.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/widgets/ShWidget.dart';

import '../../../models/HomeData.dart';
import '../../Cart_List_screen/controller/Cart_List_controller.dart';

class FlashSalesController extends GetxController {
  RxBool checking_data = false.obs;
  RxBool loading = true.obs;
  List addressesInfo = [];

  List currencyExInfo = [];
  List cartInfo = [];
  List mainproductInfo = [];
  List selected = [];
  List selectedID = [];
  int offset = 0;
  bool clearlist = false;
  bool ignoring = true;
  bool clearing = false;
  RxBool totalloading = true.obs;
  bool deleting_items = false;
  bool loadmore = true;
  int offsetsug = 0;
  int limitsug = 8;
  ScrollController ScrollListenerCART = new ScrollController();
  var cartFragment = Cart_Listscreen().obs;

  @override
  void onInit() {
    selected.clear();
    loading.value = true;
    checking_data.value = false;
    loading = true.obs;
    clearlist = false;
    ignoring = true;
    clearing = false;
    totalloading = true.obs;
    super.onInit();
  }
}
