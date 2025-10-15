import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/ShColors.dart';
import '../../../widgets/Ui.dart';

class PaymentResultScreen extends StatefulWidget {
  final bool isPaymentSuccessful;
  final String requestId;
  final String wishPaymentKey;
  final bool transactionFailed;
  final String? subscriptionStartDate;
  final String? subscriptionEndDate;

  const PaymentResultScreen({
    super.key,
    required this.isPaymentSuccessful,
    required this.requestId,
    required this.wishPaymentKey,
    required this.transactionFailed,  this.subscriptionStartDate,  this.subscriptionEndDate,
  });

  @override
  State<PaymentResultScreen> createState() => _PaymentResultScreenState();
}

class _PaymentResultScreenState extends State<PaymentResultScreen> {
  @override
  Widget build(BuildContext context) {
    final bool isSuccess = widget.isPaymentSuccessful;
    final bool transactionFailed = widget.transactionFailed;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        toolbarHeight: 56,
        leadingWidth: 64,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Ui.backArrowIcon(
            iconColor: ColorConstant.logoFirstColor,
            onTap: () {
              Get.back();
              Get.back();
            },
          ),
        ),
        title: Text(
          "Payment Result".tr,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 18,
            letterSpacing: 0.2,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.black.withOpacity(0.08),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 420),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated Icon
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: isSuccess
                      ? Icon(Icons.check_circle_rounded,
                      key: const ValueKey('successIcon'),
                      color: Colors.green.shade600,
                      size: 100)
                      : Icon(Icons.error_rounded,
                      key: const ValueKey('errorIcon'),
                      color: Colors.red.shade600,
                      size: 100),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  isSuccess
                      ? "Payment Successful!".tr
                      : transactionFailed
                      ? "Payment Success but Server Error".tr
                      : "Payment Failed!".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color:
                    isSuccess ? Colors.green.shade700 : Colors.red.shade700,
                  ),
                ),
                const SizedBox(height: 12),

                // Subtitle
                Text(
                  isSuccess
                      ? "Your payment was processed successfully."
                      : transactionFailed
                      ? "Your payment succeeded, but an error occurred on the server. Please contact support."
                      : "There was an error processing your payment.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 30),

                // Request ID + Wish Key info
                // Container(
                //   padding:
                //   const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                //   decoration: BoxDecoration(
                //     color: Colors.grey.shade50,
                //     borderRadius: BorderRadius.circular(12),
                //     border: Border.all(color: Colors.grey.shade200),
                //   ),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       _infoRow("Request ID", widget.requestId),
                //       const SizedBox(height: 8),
                //       _infoRow("Wish Payment Key", widget.wishPaymentKey),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 32),

                // Back Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstant.logoFirstColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 2,
                    ),
                    onPressed: () {
                      Get.back(result: {
                        "key": "success",
                        "value": widget.isPaymentSuccessful,
                        "start_date":widget.subscriptionStartDate,
                        "end_date":widget.subscriptionEndDate
                      });
                    },
                    child: Text(
                      "Back to App".tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      children: [
        Text(
          "$label: ",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade900,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
