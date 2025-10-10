
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/main.dart';
import 'package:iq_mall/models/CurrencyEx.dart';
import 'package:iq_mall/models/Address.dart';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'package:quickalert/models/quickalert_type.dart';
import '../../../cores/assets.dart';
import '../../../getxController.dart';
import '../../../models/HomeData.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/Alert.dart';
import '../../../widgets/ui.dart';
import '../../HomeScreenPage/ShHomeScreen.dart';
import '../Cart_List_screen.dart';
import '../widgets/AlertDaialogHandler.dart';

RxList<Product>? cartlist = RxList<Product>.empty();
RxList<Product>? favoritelist = RxList<Product>.empty();

class Cart_ListController extends GetxController {
  RxBool checking_data = false.obs;
  RxBool loading = true.obs;
  List addressesInfo = [];
  final myValue = ValueNotifier<bool>(false); // Initial value is false

  List currencyExInfo = [];
  List cartInfo = [];
  List mainproductInfo = [];
  RxBool LoadingTotal = false.obs;
  RxList<int> selectedProductIds = <int>[].obs;
  RxList<Product> Products_to_delete = <Product>[].obs;

  int offset = 0;
  int deletedIndex = 0;
  bool clearlist = false;
  bool ignoring = true;
  bool clearing = false;
  RxBool totalloading = true.obs;
  RxBool deleting_items = false.obs;
  bool loadmore = true;
  int offsetsug = 0;
  int limitsug = 8;
  ScrollController ScrollListenerCART = new ScrollController();
  RxBool awesomeOpened = false.obs;


  RxString errorResponse = "".obs;

  @override
  void onInit() {



    loading.value = true;
    checking_data.value = false;
    loading = true.obs;
    clearlist = false;
    ignoring = true;
    clearing = false;
    totalloading = true.obs;
    Future.delayed(const Duration(seconds: 4), () {
      selectedProductIds.clear();
      GetCart().then((value) => {
            loading.value = false,
            Future.delayed(const Duration(seconds: 5), () {
              Get.context?.read<Counter>().calculateTotal(0.0);
              loading.value = false;
            }),
          });
    });

    super.onInit();
  }

  void select(int productId) {
    if (selectedProductIds.contains(productId)) {
      selectedProductIds.remove(productId);
    } else {
      selectedProductIds.add(productId);
    }
  }

  String calculateTotalCost(double price, dynamic item) {
    int quantity = int.parse(item.quantity.toString());
    double shippingCost = item.shipping_cost != null && item.shipping_cost.toString().isNotEmpty ? double.parse(item.shipping_cost.toString()) : 0.0;

    double total = (price * quantity) + (item.multi_shipping.toString() == '1' ? (shippingCost * quantity) : 0);
    return formatter.format(total);
  }

  selectAll() {
    if (selectedProductIds.length == cartlist?.length) {
      selectedProductIds.clear();
    } else {
      selectedProductIds.clear();
      for (int i = 0; i < cartlist!.length; i++) {
        selectedProductIds.add(cartlist![i].product_id);
      }
    }
  }

  Future<void> handleRefresh() async {
    await refreshMethod();
    // The RefreshIndicator will remain active until this function completes
  }

  Future<void> refreshMethod() async {
    globalController.refreshHomeScreen(true);

    calculateTotalWithoutDelivery();
    computeAdditionalCostSum();

    // Await the asynchronous operation to complete
    await GetCart().then((value) {
      loading.value = false;
      globalController.refreshHomeScreen(false);
    });

    offset = 0;

    // If you want to delay something after GetCart, you should await it
  }

  Future<bool?> AddToCart(product, quantity, String fromKey) async {
    bool success = false;
    Cart_ListController controller = Get.find();
    controller.errorResponse.value = "";
    Map<String, dynamic> data = {
      'token': prefs!.getString("token") ?? "",
      'product_id': product.product_id.toString(),
      'qty': quantity.toString(),
      'variant_id': product.variant_id ?? '',
    };

    final sessionId = prefs!.getString("session_id");
    if (sessionId != null && sessionId.isNotEmpty) {
      data['session_id'] = sessionId;
    }
    Map<String, dynamic> response = await api.getData(data, "cart/add-to-cart");

    if (response.isNotEmpty) {
      String? sessionId = prefs!.getString("session_id");
      if (sessionId == null || sessionId.isEmpty) {
        String? session_id = response["session_id"];
        if (session_id != null) {
          await prefs!.setString("session_id", session_id);
        }
      }
      success = response["succeeded"];
      if (success) {
        if (int.parse(quantity.toString()) < 0) {
          product.quantity = (int.parse(product.quantity.toString()) - 1).toString();
        } else {
          product.quantity = (int.parse(product.quantity.toString()) + 1).toString();
        }

        calculateTotalWithoutDelivery();
        Get.context!.read<Counter>().calculateTotal(0.0);
        if (success) {
          loading.value = false;

          Ui.flutterToast(response["message"].toString().tr, Toast.LENGTH_LONG, MainColor, whiteA700);
          // toaster(Get.context!, response["message"].toString().tr);
        }

        return success;
      } else {
        if (fromKey != "alert") {
          CustomAlert.show(
            context: Get.context!,
            content: response["message"].toString().tr,
            type: QuickAlertType.error,
          );
        } else {
          controller.errorResponse.value = response["message"].toString().tr;
        }
      }
    } else {
      loading.value = false;
      if (fromKey != "alert") {
        CustomAlert.show(
          context: Get.context!,
          content: response["message"],
          type: QuickAlertType.error,
        );
      } else {
        controller.errorResponse.value = response["message"].toString().tr;

      }
    }
    loading.value = false;
  }

  Future<bool?> GetCart() async {
    List<int> item_ids = cartlist?.map((product) => product.product_id).toList() ?? [];

    bool success = false;

    Map<String, dynamic> data = {
      'ex_products': item_ids.toString(),
      'token': prefs!.getString("token") ?? "",
    };

    final sessionId = prefs!.getString("session_id");
    if (sessionId != null && sessionId.isNotEmpty) {
      data['session_id'] = sessionId;
    }
    Map<String, dynamic> response = await api.getData(data, "cart/get-cart");

    if (response.isNotEmpty) {
      String? sessionId = prefs!.getString("session_id");
      balance!.value = double.parse(response["balance"].toString());
      // Check if it's empty or null
      if (sessionId == null || sessionId.isEmpty) {
        // If empty, set the new value
        String? session_id = response["session_id"];
        if (session_id != null) {
          await prefs!.setString("session_id", session_id);
        }
      }
      success = response["succeeded"];
      if (success) {
        Updatecounter.value = true;
        List productsInfo = response["cart"];
        cartlist?.clear();
        mainproductInfo.clear();
        cartInfo.clear();
        cartlist!.addAll(productsInfo.map((productData) {
          var product = Product.fromJson(productData);
          calculateTotalWithoutDelivery();
          if (product.variations != null && product.variations!.isNotEmpty) {
            for (var variation in product.variations!) {
              // If variation's price_after_discount is not null, replace its price with price_after_discount
              if (variation.price_after_discount != null) {
                product.price_after_discount = variation.price_after_discount; // Updating product's price_after_discount to match variation's
              }

              // Now, update the product price with the variation's price (either original or after discount)
              if (variation.price != null) {
                product.product_price = variation.price!;
                break; // Assuming you want to use the first variation's price and then exit the loop
              }
            }
          }

          return product;
        }).toList());
        calculateTotalWithoutDelivery();
        computeAdditionalCostSum();
      }
      loading.value = false;
      ItemsCount.value = cartlist!.length.toString();
      Updatecounter.value = false;
      return success;
    } else {
      loading.value = false;
      CustomAlert.show(
        context: Get.context!,
        content: "Request Failed",
        type: QuickAlertType.error,
      );
    }
    loading.value = false;
  }

  Future<void> ContinueButtonMethod(context) async {
    int counter = 0;
    for (int i = 0; i < cartlist!.length; i++) {
      if (cartlist![i].variationfound.toString() == 'null' && cartlist![i].has_option == 1) counter++;
    }
    if (counter == 0) {
      checking_data.value = true;
      loading.value = false;
      await GetCart().then((value) {
        if (prefs?.getString('logged_in') == 'true') {
          if (addresseslist.isEmpty) {
            checking_data.value = false;
            loading.value = false;
            toaster(context, 'Add a new address to continue'.tr);
            Get.toNamed(AppRoutes.Add_new_address, arguments: {'edit': false, 'navigation': 'notnormal'})!.then((value) => {
                  checking_data.value = false,
                  loading.value = false,
                }).then((value) {
              // globalController.updateCurrentRout(AppRoutes.tabsRoute);

            });
          } else {
            Get.toNamed(AppRoutes.OrderSummary)!.then((value) => {
                  checking_data.value = false,
                  loading.value = false,
                  GetCart().then((value) {
                    loading.value = false;
                  }),
                }).then((value) {
              // globalController.updateCurrentRout(AppRoutes.tabsRoute);

            });
          }
        } else {
          checking_data.value = false;
          loading.value = false;
          AlertDialogHandler(Get.context!);
        }
      });
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(
        message: "Make sure that all product options available before continuing".tr,
        title: 'Alert',
      ));
    }
  }
}
