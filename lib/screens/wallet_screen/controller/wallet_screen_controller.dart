import 'package:get/get.dart';
import 'package:iq_mall/models/GiftCards.dart';
import 'package:iq_mall/widgets/ShWidget.dart';
import '../../../main.dart';
import '../../../models/CardsCategories.dart';
import 'package:flutter/material.dart';

class wallet_screenController extends GetxController {
  final RxBool loading = false.obs;

  String? tag = '/brandsscreen';
  var GiftCardSerialNumber = TextEditingController();

  @override
  void onInit() {
    GetCardsCategories().then((value) {
      GetGiftCards();
    });
    super.onInit();
  }

  var selectedCategoryId = Rxn<int>();

  List<CardCategory>? categories;
  List<GiftCards>? GifCards;

  RxBool Redeeming = false.obs;

  Future<bool> RedeemGiftCard(context, serial) async {
    bool success = false;
    Redeeming.value = true;

    Map<String, dynamic> response = await api.getData({
      'token': prefs!.getString("token") ?? "",
      'card_serial': serial.toString(),
    }, "gift/redeem-gift-card");

    if (response.isNotEmpty) {
      Redeeming.value = false;
      success = response["succeeded"];
      balance!.value = double.parse(response["balance"].toString());
      if (success) {
        toaster(context, response["message"]);
      } else {
        toaster(context, response["message"]);
      }
    }
    return success;
  }

  Future<bool> GetCardsCategories() async {
    bool success = false;
    loading.value = true;

    Map<String, dynamic> response = await api.getData({
      'token': prefs!.getString("token") ?? "",
      'storeId': prefs!.getString("id") ?? "",
    }, "gift/get-gift-card-categories");

    if (response.isNotEmpty) {
      success = response["succeeded"];

      if (success) {
        print(response["categories"]);
        categories = (response["categories"] as List).map((category) => CardCategory.fromJson(category as Map<String, dynamic>)).toList();
      }
    }
    return success;
  }

  Future<bool> GetGiftCards() async {
    bool success = false;

    Map<String, dynamic> response = await api.getData({
      'token': prefs!.getString("token") ?? "",
      'storeId': prefs!.getString("id") ?? "",
    }, "gift/get-gift-cards");

    if (response.isNotEmpty) {
      success = response["succeeded"];

      if (success) {
        print(response["gift_cards"]);
        GifCards = (response["gift_cards"] as List).map<GiftCards>((giftCardMap) => GiftCards.fromJson(giftCardMap as Map<String, dynamic>)).toList();
      }

      loading.value = false;
    }
    loading.value = false;
    return success;
  }
}
