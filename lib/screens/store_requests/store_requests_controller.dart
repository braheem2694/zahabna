import 'package:get/get.dart';
import 'package:iq_mall/widgets/Ui.dart';
import '../../cores/math_utils.dart';
import '../../main.dart';
import '../../models/store_request.dart';
import '../../utils/ShColors.dart';

import 'package:flutter/material.dart';

class StoreRequestsController extends GetxController {
  final RxList<StoreRequest> requests = <StoreRequest>[].obs;
  RxBool isLoading = true.obs;
  RxList<bool> cancelRequests = <bool>[].obs;

  @override
  void onInit() {
    fetchStoreRequests();

    super.onInit();

  }

  Future<List<StoreRequest>> fetchStoreRequests() async {
    isLoading.value = true;
    final String token = prefs!.getString("token") ?? "";

    // Make the POST request using your getData function
    Map<String, dynamic> response = await api.getData(
      {
        'token': token,
      },
      "stores/get-store-requests", // Replace with your actual endpoint
    );

    try {
      if (response['success'] == true && response['requests'] != null) {
        final List<dynamic> dataList = response['requests'];
        requests.clear();

        for (var item in dataList) {
          try {
            requests.add(StoreRequest.fromMap(item));
            cancelRequests.value = List.generate(requests.length, (index) => false);
          } catch (e) {
          }
        }
      } else {
      }
    } catch (e) {
    } finally {
      // requests.clear();
      // requests.add(StoreRequest(
      //   id: "1",
      //   subscriberName: "Test Subscriber",
      //   motherName: "Test Mother",
      //   storeName: "Test Store",
      //   phoneNumber: "1234567890",
      //   country: "Test Country",
      //   region: "Test Region",
      //   branchCount: 1,
      //   status: "Waiting Payment",
      //   subscriptionMonths: 1,
      //   agreedToTerms: true,
      //   createdAt: DateTime.now(),
      //   images: [],
      // ));
      isLoading.value = false;
    }
    return requests;
  }

  Future<List<StoreRequest>> cancelRequest(id, int index) async {
    cancelRequests[index] = true;
    final String token = prefs!.getString("token") ?? "";

    // Make the POST request using your getData function
    Map<String, dynamic> response = await api.getData(
      {
        'token': token,
        'id': id,
      },
      "stores/cancel-request", // Replace with your actual endpoint
    );

    cancelRequests[index] = false;
    try {
      if (response['success'] == true) {
        requests.removeAt(index);
        Get.snackbar(
          "Alert".tr,
          response['message'].toString().tr,
          snackPosition: SnackPosition.BOTTOM,
          colorText: ColorConstant.white,
          backgroundColor: ColorConstant.logoSecondColor,
          margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
        );
      } else {
        Get.snackbar("Alert".tr, response['message'].toString().tr, snackPosition: SnackPosition.BOTTOM, colorText: ColorConstant.white, backgroundColor: redDark);

      }
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
    return requests;
  }
}
