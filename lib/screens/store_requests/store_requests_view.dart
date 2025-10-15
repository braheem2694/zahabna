import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iq_mall/screens/transactions/controllers/transactrions_controller.dart';
import 'package:shimmer/shimmer.dart';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'package:iq_mall/widgets/ui.dart';
import '../../main.dart';
import '../../utils/ShColors.dart';
import '../../cores/math_utils.dart';
import '../../models/store_request.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button.dart';
import '../store_request/widgets/payment_widget.dart';
import 'store_requests_controller.dart';

class StoreRequestsView extends GetView<StoreRequestsController> {
  const StoreRequestsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Text(
          'Store Requests'.tr,
          style: TextStyle(
            color: ColorConstant.logoFirstColor,
            fontSize: getFontSize(20),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Ui.backArrowIcon(
          iconColor: ColorConstant.logoFirstColor,
          onTap: () => Get.back(),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey[200],
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 3, // Show 3 shimmer items while loading
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Card(
                  elevation: 2,
                  color: ColorConstant.logoFirstColor.withOpacity(0.1),
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 140,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: 100,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 120,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 80,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: 60,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }

        if (controller.requests.isEmpty) {
          return Center(
            child: Text(
              'No requests found'.tr,
              style: const TextStyle(fontSize: 16),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.fetchStoreRequests();
          },
          color: ColorConstant.logoSecondColorConstant,
          child: ListView.builder(
            padding:
                const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 60),
            itemCount: controller.requests.length,
            itemBuilder: (context, index) {
              var request = controller.requests[index];
              bool canCancel = request.endDate == null
                  ? false
                  : request.endDate!.isAfter(DateTime.now());
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: ColorConstant.gray100,
                child: ListTile(
                  contentPadding: const EdgeInsets.only(left: 16, right: 16),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  request.storeName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Subscriber: ${request.subscriberName}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Obx(
                                () => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(
                                        controller.requests[index].status),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    controller.requests[index].status,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                          Icons.phone, 'Phone: ${request.phoneNumber}'),
                      const SizedBox(height: 8),
                      _buildInfoRow(Icons.location_on,
                          'Location: ${request.country}, ${request.region}'),
                      // const SizedBox(height: 8),
                      // _buildInfoRow(Icons.store, 'Branches: ${request.branchCount}'),
                      const SizedBox(height: 8),
                      // _buildInfoRow(Icons.attach_money, 'Total Amount: ${request.totalAmount}'),
                      _buildInfoRow(Icons.calendar_today,
                          'Duration: ${request.subscriptionMonths} months'),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: getVerticalSize(147),
                        child: Column(
                          children: [
                            request.registerDate == null
                                ? const SizedBox()
                                : _buildInfoRow(Icons.calendar_today,
                                    '${'registration Date'.tr}:  ${request.registerDate != null ? Ui.formatDate(request.registerDate!) : "N/A"}'),
                            const SizedBox(height: 8),
                            _buildInfoRow(Icons.calendar_today,
                                '${'Start Date'.tr}:  ${request.startDate != null ? Ui.formatDate(request.startDate!) : "N/A"}'),
                            const SizedBox(height: 8),
                            _buildInfoRow(Icons.calendar_today,
                                '${'End Date'.tr}:  ${request.endDate != null ? Ui.formatDate(request.endDate!) : "N/A"}',
                                color: canCancel ? Colors.red : null),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: request.status.toLowerCase() ==
                                              "deleted" ||
                                          request.status.toLowerCase() ==
                                              "cancelled" ||
                                          request.status == 'Pending'
                                      ? const SizedBox()
                                      : Obx(() {
                                          return MyCustomButton(
                                            text:
                                                request.status.toLowerCase() ==
                                                        "waiting payment"
                                                    ? "Pay".tr
                                                    : "Renew".tr,
                                            fontSize: 14,
                                            height: 40,
                                            width: getHorizontalSize(135),
                                            borderRadius: 10,
                                            padding: ButtonPadding.PaddingNone,
                                            buttonColor:
                                                ColorConstant.logoSecondColor,
                                            borderColor: Colors.transparent,
                                            isExpanded: controller
                                                .cancelRequests[index],
                                            onTap: () {
                                              Get.to(
                                                      () =>
                                                          PaymentImagePickerScreen(
                                                            request: request,
                                                            isReneu: true,
                                                          ),
                                                      transition: Transition
                                                          .rightToLeft,
                                                      duration: const Duration(
                                                          milliseconds: 200))
                                                  ?.then(
                                                (value) {
                                                  controller.requests[index] =
                                                      value;
                                                  request = value;
                                                  controller.requests.refresh();
                                                },
                                              );

                                              // controller.cancelRequest(request.id);
                                            },
                                          );
                                        }),
                                ),
                                Obx(() {
                                  return MyCustomButton(
                                    text: "View Request".tr,
                                    fontSize: 14,
                                    height: 40,
                                    width: request.status.toLowerCase() ==
                                                "deleted" ||
                                            request.status.toLowerCase() ==
                                                "cancelled" ||
                                            request.status == 'Pending'
                                        ? getHorizontalSize(290)
                                        : getHorizontalSize(135),
                                    borderRadius: 10,
                                    padding: ButtonPadding.PaddingNone,
                                    buttonColor: Colors.grey[600],
                                    borderColor: Colors.transparent,
                                    isExpanded:
                                        controller.cancelRequests[index],
                                    onTap: () {
                                      Get.toNamed(AppRoutes.storeRequest,
                                              arguments: request)
                                          ?.then(
                                        (value) {
                                          if (value != null) {
                                            controller.requests[index] =
                                                value as StoreRequest;
                                            controller.requests.refresh();
                                          }
                                        },
                                      );
                                      // controller.cancelRequest(request.id);
                                    },
                                  );
                                })
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  // onTap: () async {
                  //   if (request.status == 'Waiting Payment') {
                  //     Get.to(() => PaymentImagePickerScreen(
                  //           request: request,
                  //         ));
                  //   } else {
                  //     toaster(
                  //         context,
                  //         request.status == 'Pending'
                  //             ? "PLease wait for approval"
                  //             : request.status == 'Accepted'
                  //                 ? "This request is already approved"
                  //                 : request.status == 'Cancelled'
                  //                     ? "This request is already canceled"
                  //                     : request.status == 'Deleted'
                  //                         ? "This request is already deleted"
                  //                         : "Please wait for approval");
                  //   }
                  // },
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: Obx(() {
        bool isFound = false;
        controller.requests.forEach(
          (element) {
            if (element.status.toLowerCase() != "deleted" &&
                element.status.toLowerCase() != "cancelled") {
              isFound = true;
            }
          },
        );
        return !isFound
            ? SizedBox()
            : FloatingActionButton.extended(
                onPressed: () {
                  Get.toNamed(AppRoutes.storeRequest);
                },
                icon: Icon(Icons.add, color: Colors.white),
                label: Text(
                  "New Request".tr,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                backgroundColor: ColorConstant.logoSecondColor,
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              );
      }),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Accepted':
        return Colors.green;
      case 'Cancelled':
        return gray400;
      case 'Deleted':
        return redDark;
      case 'Waiting Payment':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  Widget _buildInfoRow(IconData icon, String text, {Color? color}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color ?? Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: color != null ? 16 : 14,
            color: color ?? Colors.grey[800],
          ),
        ),
      ],
    );
  }

  showStoreAlert(context, StoreRequest request, int index) {
    AlertDialog alert = AlertDialog(
      contentPadding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.white,
      content: Container(
        padding: getPadding(left: 5, right: 5, top: 10, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.white),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Adjust the height to fit content
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Directionality(
              textDirection: prefs?.getString("locale") == "en"
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              child: Text(
                'Alert'.tr,
                style: TextStyle(
                  color: ColorConstant.logoSecondColor,
                  fontSize: getFontSize(20),
                ),
              ),
            ),
            Directionality(
              textDirection: prefs?.getString("locale") != "ar"
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              child: Text(
                "Do you want to cancel the request?".tr,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: ColorConstant.black900,
                  fontSize: getFontSize(16),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            Get.back();
            controller.cancelRequest(request.id, index);
          },
          behavior: HitTestBehavior.translucent,
          child: Padding(
            padding: getPadding(left: 8, top: 5, right: 8, bottom: 5),
            child: Container(
              width: getHorizontalSize(90),
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ColorConstant.logoSecondColor,
              ),
              alignment: Alignment.center,
              child: Text(
                "Yes".tr,
                style: TextStyle(
                    fontSize: getFontSize(16), color: ColorConstant.whiteA700),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Get.back();
          },
          behavior: HitTestBehavior.translucent,
          child: Padding(
            padding: getPadding(left: 8, top: 5, right: 8, bottom: 5),
            child: Container(
              width: getHorizontalSize(90),
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ColorConstant.whiteA700,
                border:
                    Border.all(color: ColorConstant.logoSecondColor, width: 1),
              ),
              alignment: Alignment.center,
              child: Text(
                "No".tr,
                style: TextStyle(
                    fontSize: getFontSize(16),
                    color: ColorConstant.logoSecondColor),
              ),
            ),
          ),
        )
      ],
      actionsAlignment: MainAxisAlignment.spaceAround,
    );

    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
