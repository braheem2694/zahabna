import 'package:get/get.dart';
import 'package:iq_mall/models/GiftCards.dart';
import '../../../main.dart';
import 'package:flutter/material.dart';

class GiftCardDetailScreenController extends GetxController {
   RxBool loading = false.obs;
   TextEditingController EmailController = TextEditingController();
   TextEditingController phoneNumberController = TextEditingController();
   TextEditingController senderNameController = TextEditingController();
   TextEditingController messageController = TextEditingController();
  String? tag = '/brandsscreen';
  var GiftCard;
   RxString? paying_method = 'none'.obs;
   int? PaymentMethod;
  @override
  void onInit() {
    final arguments = Get.arguments;
    GiftCard = arguments['GiftCard'];
    GetGiftCardById();
    super.onInit();
  }
   RxInt selectedAmount = RxInt(0);  // initialize with some default value or null

   void setSelectedAmount(int value) {
     selectedAmount.value = value;
   }
   RxString deliveryMethod = 'Email'.obs;
   int val = -1;
   void setDeliveryMethod(String method) {
     deliveryMethod.value = method;
     update(); // Refresh the UI
   }
  List<dynamic> get allImages {
    List<dynamic> combinedImages = [];
    if (GiftCard.main_image != null) {
      combinedImages.add(GiftCard.main_image!);
    }
    combinedImages.addAll(GiftCard.moreImages);
    return combinedImages;
  }

  Future<bool> GetGiftCardById() async {
    bool success = false;
    loading.value = true;

    Map<String, dynamic> response = await api.getData({
      'slug': GiftCard.slug.toString(),
    }, "gift/get-gift-card-by-id");

    if (response.isNotEmpty) {
      success = response["succeeded"];

      if (success) {
        GiftCard = GiftCards.fromJson(response["gift_card"]);
        List<amounts> amountsListFromJson(List<dynamic> json) {
          return json.map((item) => amounts.fromJson(item)).toList();
        }

        List<amounts> AmountsList = amountsListFromJson(response["amounts"]);
        GiftCard.Amounts = AmountsList;
        loading.value=false;

      }
    }
    return success;
  }
}
