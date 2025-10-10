import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/main.dart';
import 'dart:convert';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'package:http/http.dart' as http;
import 'package:iq_mall/cores/assets.dart';
import 'dart:async';
import 'package:iq_mall/models/Address.dart';
import 'package:iq_mall/screens/bill_screen/bill_screen.dart';
import 'package:dio/dio.dart' as dio;
import 'package:quickalert/models/quickalert_type.dart';
import '../../../widgets/Alert.dart';
import '../../../widgets/ui.dart';
import '../../Cart_List_screen/controller/Cart_List_controller.dart';
import 'dart:io';
import 'package:path/path.dart';

class OrderSummaryScreenController extends GetxController with GetSingleTickerProviderStateMixin{
  int val = -1;
  var image;
  List payment_methods = [];
  RxBool payment_methods_loading = true.obs;
  int? PaymentMethod;

  final ImagePicker _picker = ImagePicker();
  bool countiresloading = true;
  bool citiesloading = false;
  bool branchesloading = false;

  List<String> countries = <String>[];
  List<String> cities = <String>[];
  List<String> branches = <String>[];
  var webimage;
  String? webimageString;
  String? usrImgBase64;
  Uint8List usrImagebytes = new Uint8List(0);
  RxBool agreement_accepted = false.obs;
  List cartInfo = [];
  String? countrychoosen;
  ScrollController summaryController =  ScrollController();

  RxString? paying_method = 'none'.obs;
  final TextEditingController couponCode = TextEditingController();

  List countriesInfo = [];
  List branchesInfo = [];
  bool country_selected = false;
  bool city_selected = false;
  bool branch_selected = false;
  List citiesInfo = [];
  String? countrychoosenID;
  String? citychoosen;
  String? citychoosenID;
  String? branchchoosen;
  String? branchchoosenID;
  DateTime? selecteddate;
  RxDouble coupon_percentage = RxDouble(0.0);
  late AnimationController policyAnimationController;
  RxBool ordering = false.obs;
  RxBool policyAlert = false.obs;
  RxBool policyAlertText = false.obs;
  RxBool applyingCouponCode = false.obs;
  bool checking_data = false;
  bool ignoring = false;
  bool giftcard_loading = true;
  RxBool loading = false.obs;
  TextEditingController cardnameOneController = TextEditingController();

  TextEditingController cardnumberOneController = TextEditingController();

  TextEditingController expirydateOneController = TextEditingController();

  TextEditingController cvvOneController = TextEditingController();

  bool shipping_colaps = false;
  RxBool loadingall = false.obs;
  String? unique_id;
  RxString total = ''.obs;

  @override
  void onInit() {

    Get.context!.read<Counter>().calculateTotal(0.0);
    super.onInit();
    calculateTotalWithoutDelivery();
    computeAdditionalCostSum();
    total.value = "$sign ${(double.parse(Get.context!.read<Counter>().calculateTotal(0.0).toString()) + globalController.sum.value).toString()}";
    globalController.updateCartPrice( double.parse(Get.context!.read<Counter>().calculateTotal(0.0).toString()) + globalController.sum.value);
    policyAnimationController = AnimationController(
      vsync: this, // Ensure to use SingleTickerProviderStateMixin
      duration: const Duration(milliseconds: 800), // Duration of the animation
    );

  }
  @override
  void onClose(){
    policyAnimationController.dispose(); // D
    super.onClose();
  }



  getcountries() async {
    countiresloading = true;
    var url = "${con!}product/get-countries";
    final http.Response response = await http.post(Uri.parse(url), body: {}).catchError((e) {});
    if (json.decode(response.body) == 0) {
    } else {
      countriesInfo = json.decode(response.body) as List;
      countries.clear();
      for (int i = 0; i < countriesInfo.length; i++) {
        countries.add(countriesInfo[i]['country_name'].toString());
      }
      countiresloading = false;
    }
  }

  getcities(id) async {
    citiesloading = true;
    citiesInfo.clear();
    var url = "${con!}product/get-cities";
    final http.Response response = await http.post(
      Uri.parse(url),
      body: {
        'country_id': id,
      },
    ).catchError((e) {});

    if (json.decode(response.body) == 0) {
    } else {
      citiesInfo = json.decode(response.body) as List;
      cities.clear();
      for (int i = 0; i < citiesInfo.length; i++) {
        cities.add(citiesInfo[i]['city_name'].toString());
      }
      citiesloading = false;
    }
  }

  Future<bool?> ApplyCouponCode(
    coupon_code,
  ) async {
    bool success = false;
    applyingCouponCode.value=true;
    Map<String, dynamic> response = await api.getData({
      'coupon_code': coupon_code,
      'token': prefs!.getString("token") ?? "",
    }, "cart/apply-coupon-code");
    applyingCouponCode.value=false;

    if (response.isNotEmpty) {
      success = response["succeeded"];
      if (success) {
        try {
          coupon_percentage.value = double.parse(response["discount"].toString());
          globalController.updateCartPrice(Get.context!.read<Counter>().calculateTotal(coupon_percentage.value) + (globalController.sum.value));

        } catch (e, s) {
          print(s);
        }
        CustomAlert.show(
          context: Get.context!,
          content: response["message"],
          type: QuickAlertType.success,
        );
      } else {
        CustomAlert.show(
          context: Get.context!,
          content: response["message"],
          type: QuickAlertType.error,
        );

      }
      return success;
    } else {
      loading.value = false;
    }
    loading.value = false;
  }

  getbranches(id) async {
    branchesloading = true;
    var url = "${con!}product/get-branches";
    final http.Response response = await http.post(
      Uri.parse(url),
      body: {
        'city_id': id,
      },
    ).catchError((e) {});
    if (json.decode(response.body) == 0) {
    } else {
      branchesInfo = json.decode(response.body) as List;
      branches.clear();
      for (int i = 0; i < branchesInfo.length; i++) {
        branches.add(branchesInfo[i]['branch_name'].toString());
      }
      branchesloading = false;
    }
  }

  // Future<bool> Checkout() async {
  // List productIds = cartlist!.map((product) => product.product_id).toList();
  //   var data = json.encode(await productIds);
  //   bool success = false;
  //   loading.value = true;
  //
  //   dio.FormData formData = dio.FormData.fromMap({
  //     'token': prefs!.getString("token") ?? "",
  //     'total':
  //         (double.parse(Get.context!.read<Counter>().calculateTotal(coupon_percentage.value).toString()) + computeAdditionalCostSum()!).toString().toString(),
  //     'address_id': addresseslist[prefs?.getInt('selectedaddress') ?? 0].id,
  //     'product_id': '',
  //     'ex_products': data,
  //     'payment_type': PaymentMethod.toString(),
  //   });
  //
  //   if (paying_method!.value == 'Bank Transfer' && image != null) {
  //     File imageFile = File(image.path);
  //     List<int> imgBytes = await imageFile.readAsBytes();
  //     String fileName = basename(imageFile.path);
  //     formData.files.add(MapEntry('bank_image', dio.MultipartFile.fromBytes(imgBytes, filename: fileName)));
  //   }
  //
  //   if (paying_method!.value == 'Pick Up') {
  //     formData.fields.add(MapEntry('branch_id', branchchoosenID!.toString()));
  //   }
  //   if (coupon_percentage.value != 0.0) {
  //     formData.fields.add(MapEntry('coupon_code', couponCode.text.toString()));
  //   }
  //
  //
  //
  //
  //   dio.Dio dioInstance = dio.Dio();
  //
  //   await dioInstance.post(
  //     "${con!}cart/check-out",
  //     data: formData,
  //     // options: dio.Options(
  //     //   headers: {
  //     //     'Accept': "application/json",
  //     //     'Authorization': 'Bearer ${prefs!.getString("token") ?? ""}',
  //     //   },
  //     // ),
  //   ).then((response) {
  //     if (response.statusCode == 200) {
  //       var responseMap = response.data;
  //       if (responseMap["succeeded"] == true) {
  //         if (paying_method!.value == 'Bank Transfer' && image != null) {
  //           File imageFile = File(image.path);
  //           String fileName = basename(imageFile.path);
  //
  //           UploadImage(responseMap["table_name"], responseMap["row_id"], fileName);
  //         }
  //         success = true;
  //         CustomAlert.show(
  //           context: Get.context!,
  //           content: responseMap["message"],
  //           type: CoolAlertType.success,
  //         );
  //
  //         Get.to(
  //               () => Billsscreen(),
  //           arguments: paying_method!.value,
  //           routeName: '/Bill',
  //         )!
  //             .then((value) => Get.back());
  //       } else {
  //         CustomAlert.show(
  //           context: Get.context!,
  //           content: responseMap["message"],
  //           type: CoolAlertType.error,
  //         );
  //
  //         loading.value = false;
  //       }
  //     } else {
  //       CustomAlert.show(
  //         context: Get.context!,
  //         content: 'Checkout Failed',
  //         type: CoolAlertType.error,
  //       );
  //
  //       loading.value = false;
  //     }
  //   }).catchError((e) {
  //     print(e);
  //   });
  //
  //
  //
  //   return success;
  // }

  Future<bool> Checkout() async {
    bool success = false;

    List productIds = cartlist!.map((product) => product.product_id).toList();
    var data = json.encode(await productIds);
    loading.value = true;


    Map<String, dynamic> param= <String, dynamic>{
      'token': prefs!.getString("token") ?? "",
      'total':
      (double.parse(Get.context!.read<Counter>().calculateTotal(coupon_percentage.value).toString()) + globalController.sum.value).toString().toString(),
      'address_id': addresseslist[prefs?.getInt('selectedaddress') ?? 0].id,
      'product_id': '',
      'ex_products': data,
      'payment_type': PaymentMethod.toString(),
    };
    print(param);

    if (paying_method!.value == 'Bank Transfer' && image != null) {
      File imageFile = File(image.path);
      List<int> imgBytes = await imageFile.readAsBytes();
      String fileName = basename(imageFile.path);
      param.addAll({'bank_image': dio.MultipartFile.fromBytes(imgBytes, filename: fileName)} );

    }

    if (paying_method!.value == 'Pick Up') {
      param.addAll({'branch_id': branchchoosenID!.toString()} );

    }
    if (coupon_percentage.value != 0.0) {
      dynamic s= couponCode.text;
      param.addAll({'coupon_code': couponCode.text} );
    }



    try {
      await api.getData(param, "cart/check-out",).then((responseMap) {
        success = responseMap["succeeded"];
        if (success) {
              if (paying_method!.value == 'Bank Transfer' && image != null) {
                File imageFile = File(image.path);
                String fileName = basename(imageFile.path);

                UploadImage(responseMap["table_name"], responseMap["row_id"], fileName);
              }
              success = true;
              CustomAlert.show(
                context: Get.context!,
                content: responseMap["message"],
                type: QuickAlertType.success,
              );

              Cart_ListController _controller = Get.find();
              _controller.selectedProductIds.clear();

              Get.to(
                    () => Billsscreen(),
                arguments: paying_method!.value,
                routeName: '/Bill',
              )!
                  .then((value) => Get.back());

              loading.value = false;


        }  else {
          CustomAlert.show(
            context: Get.context!,
            content: 'Checkout Failed',
            type: QuickAlertType.error,
          );

          loading.value = false;
        }
      });
    } catch (e) {
      loading.value = false;

    }
    update();
    refresh();
    return success;
  }



  UploadImage(table_name, row_id, file_name) async {
    dio.FormData data = dio.FormData.fromMap({
      "file": await dio.MultipartFile.fromFile(
        image.path.toString(),
        filename: file_name.toString(),
      ).catchError((e) {}),
      "file_name": file_name,
      "token": prefs!.getString('token') ?? "", // Sending token
      "table_name": table_name.toString(), // Using passed table name
      "row_id": row_id.toString() // Using passed row id
    });

    dio.Dio dio2 = dio.Dio();

    try {
      var response = await dio2.post(
        "${con!}side/upload-images",
        data: data,
        options: dio.Options(
          headers: {
            'Accept': "application/json",
            'Authorization': 'Bearer ${prefs!.getString("token") ?? ""}',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Handle 200 status code response
        var responseData = response.data;

        if (responseData['succeeded'] == true) {
          // Assuming there is a 'succeeded' key in the response to check for success.
          // You can adapt this based on the actual structure of your response.

          var results = responseData['results']; // Accessing results, adapt key as needed
          // Handle the results here as per your needs
        } else {
          var errorMessage = responseData['message']; // Assuming 'message' key contains error details
          print('Error: $errorMessage');
        }
      } else {
        print('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error while uploading: $e');
    }
  }

  List currencyExInfo = [];
}
