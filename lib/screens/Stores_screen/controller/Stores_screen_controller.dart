import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import '../../../main.dart';
import '../../../models/Stores.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/ShColors.dart';
import '../../Cart_List_screen/controller/Cart_List_controller.dart';
import '../../Home_screen_fragment/controller/Home_screen_fragment_controller.dart';
import '../../OrderSummaryScreen/widgets/PaymentMethodsWidets/PaymentMethodsWidget.dart';
import '../../Wishlist_screen/controller/Wishlist_controller.dart';
import '../../categories_screen/controller/categories_controller.dart';

List? branches_countries;

class StoreController extends GetxController {
  RxBool loading = true.obs;
  RxBool loadingMore = false.obs;
  RxBool refreshStores = false.obs;
  Rx<String?> selectedCity = Rxn();
  Rx<String?> selectedCityId = Rxn();

  RxList<Rx<StoreClass>> stores = <Rx<StoreClass>>[].obs;
  RxInt offset = 2.obs;
  ScrollController scrollController = ScrollController();
  RxList<Map<String, String>> cities = <Map<String, String>>[].obs;

  @override
  void onInit() {
    storeList.clear();
    fetchStores(false, true);

    scrollController.addListener(() {
      if (scrollController.position.pixels > (scrollController.position.maxScrollExtent - 450) && !loadingMore.value) {
        fetchStores(true, false);
      }
    });

    super.onInit();
  }

  ChangeStroredStore(store, newsLetterChoosen) async {
    try {
      Get.delete<Home_screen_fragmentController>();
      Get.delete<CategoriesController>();
      Get.delete<WishlistController>();
      Get.delete<Cart_ListController>();
      prefs!.setString('id', store.id);
      try {
        if (newsLetterChoosen != null) {
          List<newsLetter> newsLetters = List<newsLetter>.from(newsLetterChoosen.map((x) => newsLetter.fromJson(x)));
          // news = newsLetters.firstWhere(
          //   (n) => n.r_store_id.toString() == prefs!.getString('id'),
          // );
        }
      } catch (ex) {}
      prefs!.setString('show_add_to_cart', store.show_add_to_cart.toString());
      prefs!.setString('store_name', store.store_name);
      prefs!.setString('delivery_cost', store.delivery_amount);
      prefs!.setString('store_type', store.store_type);
      prefs!.setString('phone_number', store.phone_number);
      prefs!.setString('whatsapp_number', store.whatsapp_number);
      prefs!.setString('email', store.email);
      prefs!.setString('address', store.address);
      prefs!.setString('privacy_policy', store.privacy_policy);
      prefs!.setString('terms_conditions', store.terms_conditions);
      prefs!.setString('slug', store.slug);
      prefs!.setString('description', store.description);
      prefs!.setString('longitude', store.longitude);
      prefs!.setString('latitude', store.latitude);
      prefs!.setString('main_image', store.main_image);
      prefs!.setString('country_name', store.country_name);
      prefs!.setString('button_background_color', store.button_background_color);
      prefs!.setString('button_color', store.button_color);
      prefs!.setString('price_color', store.price_color);
      prefs!.setString('discount_price_color', store.dicount_price_color);
      prefs!.setString('grid_type', store.grid_type);
      prefs!.setString('main_color', store.main_color);
      prefs!.setString('icon_color', store.icon_color);
      prefs!.setString('slider_type', store.slider_type);
      prefs!.setString('setting_image', store.setting_image);

      Get.offAllNamed(
        AppRoutes.tabsRoute,
      );
      // Navigator.pushReplacement(
      //   Get.context!,
      //   MaterialPageRoute(builder: (context) => ShHomeScreen()),
      // );
      changeColorsAndDisplay(store.button_color, store.main_color, store.dicount_price_color);
    } on Exception catch (_) {}
  }

  Future<bool> fetchStores(bool isScroll, bool init, {bool fromInfo = false}) async {
    bool success = false;
    if (isScroll) {
      loadingMore.value = true;
    } else if (init) {
      offset.value = 1;
      loading.value = true;
    } else {
      offset.value = 1;
    }

    Map<String, dynamic> response = await api.getData({
      'token': prefs?.getString("token") ?? "",
      'page': offset.value.toString(),
      'city': selectedCityId.value,
    }, "stores/get-stores");

    if (response.isNotEmpty) {
      offset.value++;

      if (!isScroll) {
        stores.clear();
      }

      List storesInfo = response["stores"] ?? [];

      success = response["succeeded"];
      prefs!.setString('stp_key', response["stp_key"].toString());

      if (response["multi_store"].toString() == '1') {
        branches_countries = response["branches_countries"];
        prefs!.setString('Stores_page_background', response['section'][0]['main_image']);
        prefs!.setString('welcome_text', response['section'][0]['welcome_text']);
        prefs!.setString('brief_text', response['section'][0]['brief_text']);
        if (response['section'] != null && response['section'].length > 0 && response['section'][0]['gif_image'] != null) {
          prefs!.setString('gif_image', response['section'][0]['gif_image'] ?? 'default_value');
        }
        payment_methods = response["payment_types"];
        for (int i = 0; i < storesInfo.length; i++) {
          stores.add(StoreClass.userFromJson(storesInfo[i]).obs);
        }
        if (isScroll) {
          offset.value++;
        }
        if (init) {
          cities.clear();
          for (int i = 0; i < storesInfo.length; i++) {
            String cityId = stores[i].value.cityId.toString();
            String cityName = stores[i].value.cityName.toString();

// Check if the cityId is already present in the list
            bool cityExists = cities.any((city) => city.keys.first == cityId);

            if (!cityExists && cityId != "null" && cityName != "null") {
              cities.add({cityId: cityName});
            }
          }
          cities.insert(0, {"0": "Select City"});
        }
        if (isScroll) {
          loadingMore.value = false;
        } else {
          loading.value = false;
        }

        prefs!.setBool('multi_store', true);
      } else {
        branches_countries = response["branches_countries"];
        prefs!.setString('Stores_page_background', response['section'][0]['main_image']);
        prefs!.setString('welcome_text', response['section'][0]['welcome_text']);
        prefs!.setString('brief_text', response['section'][0]['brief_text']);
        if (response['section'] != null && response['section'].length > 0 && response['section'][0]['gif_image'] != null) {
          prefs!.setString('gif_image', response['section'][0]['gif_image'] ?? 'default_value');
        }

        payment_methods = response["payment_types"] ?? [];

        for (int i = 0; i < storesInfo.length; i++) {
          stores.add(StoreClass.fromJson(storesInfo[i]).obs);
        }

        if (!fromInfo && !isScroll) {
          if (stores.isNotEmpty) {
            ChangeStroredStore(stores[0].value, response["newsLetters"]);
          }
        }
      }

      loading.value = false;
      if (isScroll) {
        loadingMore.value = false;
      }
    }

    return success;
  }

  saveStoreView(storeId) async {
    globalController.currentStoreId = storeId.toString();
    await api.getData({
      'token': prefs!.getString("token") != "" ? prefs!.getString("token") : null,
      'store_id': storeId,
    }, "stores/save-store-view").then((value) {
      print(value);
    });
  }
}
