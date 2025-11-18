// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../main.dart';
import '../../../utils/ShColors.dart';
import '../../../widgets/Ui.dart';
import 'payment_result.dart'; // Your PaymentResultScreen widget

class WhshPaymentView extends StatefulWidget {
  final String url;
  final String requestId;

  const WhshPaymentView({super.key, required this.url, required this.requestId});

  @override
  State<WhshPaymentView> createState() => _WhshPaymentViewState();
}

class _WhshPaymentViewState extends State<WhshPaymentView> {
  late WebViewController _controller;
  bool _isLoading = true; // Flag to track if the page is loading
  bool updatingTransaction = false; // Flag to track if the page is loading

  Future<void> updateTransAction(BuildContext context, String transactionId) async {
    try {
      updatingTransaction = true;
      final Map<String, dynamic> response = await api.getData(
        {
          "external_id": transactionId,
          "token": prefs?.getString("token"),
        },
        "stores/update-transaction",
      );

      if (response["success"] == true) {
        updatingTransaction = false;

        await Get.to(() => PaymentResultScreen(
              isPaymentSuccessful: true,
              requestId: widget.requestId,
              wishPaymentKey: transactionId,
              transactionFailed: false,
              subscriptionStartDate: response["subscription_start_date"].toString(),
              subscriptionEndDate: response["subscription_end_date"].toString(),
            ))?.then(
          (value) {
            Get.back(result: value);
          },
        );
      } else {
        updatingTransaction = false;

        await Get.to(() => PaymentResultScreen(
              isPaymentSuccessful: false,
              requestId: widget.requestId,
              wishPaymentKey: transactionId,
              transactionFailed: true,
            ))?.then(
          (value) {
            Get.back(result: value);
          },
        );
        // Handle error
      }
    } catch (e) {
      updatingTransaction = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // If the progress is less than 100, the page is still loading
            setState(() {
              _isLoading = progress < 100;
            });
          },
          onPageStarted: (String url) {
            // When a new page starts, we show the loading indicator
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            // When the page finishes loading, we hide the loading indicator
            setState(() {
              _isLoading = false;
            });
          },
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) async {
            // Check if the URL contains "success" or "fail"
            if (request.url.contains("success")) {
              await updateTransAction(context, request.url.split("/").last);
              // Navigate to the success page

              return NavigationDecision.prevent; // Prevent WebView from navigating
            } else if (request.url.contains("fail")) {
              // Navigate to the failure page
              await Get.to(
                () => PaymentResultScreen(
                  isPaymentSuccessful: true,
                  requestId: widget.requestId,
                  wishPaymentKey: request.url.split("/").last,
                  transactionFailed: false,
                ),
              )?.then(
                (value) {
                  Get.back(result: value);
                },
              );

              return NavigationDecision.prevent; // Prevent WebView from navigating
            }
            return NavigationDecision.navigate; // Allow other URLs to load
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstant.white,
        elevation: 0,
        centerTitle: false,
        title: Text(
          "Whish Payment".tr,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 18,
            letterSpacing: 0.2,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Ui.backArrowIcon(
            iconColor: ColorConstant.logoFirstColor,
            onTap: () => Get.back(),
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
      body: Column(
        children: [
          // Show shimmer effect while loading
          _isLoading
              ? Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Logo
                        Center(
                          child: Container(
                            width: 120,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Payment to title
                        Container(
                          width: 150,
                          height: 20,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 20),

                        // Payment Details (INV-15 and amount)
                        Container(
                          width: double.infinity,
                          height: 18,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          height: 18,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          height: 18,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          height: 18,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 24),

                        // Phone input field placeholder
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Button
                        Center(
                          child: Container(
                            width: double.infinity,
                            height: 55,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Expanded(
                  child: WebViewWidget(controller: _controller),
                ),
        ],
      ),
    );
  }
}
