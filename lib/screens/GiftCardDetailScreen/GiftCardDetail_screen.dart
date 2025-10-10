import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:get/get.dart';
import 'package:iq_mall/main.dart';
import 'package:iq_mall/screens/GiftCardDetailScreen/widgets/Form.dart';
import 'package:iq_mall/widgets/CommonWidget.dart';
import 'package:flutter/material.dart';
import '../../Product_widget/Product_widget.dart';
import '../../utils/ShColors.dart';
import '../../utils/ShImages.dart';
import '../../widgets/chewie_player.dart';
import '../OrderSummaryScreen/widgets/PaymentMethodsWidets/PaymentMethodsWidget.dart';
import '../ProductDetails_screen/controller/ProductDetails_screen_controller.dart';
import '../ProductDetails_screen/widgets/better_player.dart';
import 'controller/GiftCardDetailScreen_controller.dart';

class GiftCardDetailScreen extends GetView<GiftCardDetailScreenController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar(controller.GiftCard.name ?? ""),
        body: Obx(
          () => controller.loading.value
              ? Center(child: Progressor_indecator())
              : ListView(
                  children: [
                    Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Swiper(
                        pagination: const SwiperPagination(),
                        control: null,
                        itemHeight: 200.0,
                        itemBuilder: (BuildContext context, int index) {
                          String? videoName = controller.allImages[index].toString().split("/").last;
                          List videoFinalUrlList = controller.allImages[index].toString().split("/");
                          String? finalVideoUrl = "";
                          videoFinalUrlList.removeLast();
                          for (var element in videoFinalUrlList) {
                            if (finalVideoUrl == null || finalVideoUrl == "") {
                              finalVideoUrl = (finalVideoUrl ?? "") + element;
                            } else {
                              finalVideoUrl += "/$element";
                            }
                          }
                          return GestureDetector(
                            onTap: () {
                              // TODO: Navigate to your desired screen.
                            },
                            child: isVideo(controller.allImages[index].toString())
                                ?
                            ChewieVideoPlayer(
                              initialQuality: controller.allImages[index].toString(),
                              isMuted: false,
                              videoQualities :  {
                                "360": controller.allImages[index].toString(),
                                "720": controller.allImages[index].toString(),
                              },
                            )
                                : CachedNetworkImage(
                                    width: MediaQuery.of(context).size.width,
                                    height: 200.0,
                                    imageUrl: controller.allImages[index].toString(),
                                    placeholder: (context, url) => Container(
                                      width: MediaQuery.of(context).size.height * 0.3,
                                      height: MediaQuery.of(context).size.height * 0.22,
                                      child: Image.network(
                                        convertToThumbnailUrl(controller.allImages[index].toString(), isBlurred: true),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Image.asset(AssetPaths.placeholder),
                                  ),
                          );
                        },
                        indicatorLayout: PageIndicatorLayout.COLOR,
                        autoplay: false,
                        autoplayDelay: 3000,
                        itemCount: controller.allImages.length,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 5),
                      child: Text(
                        controller.GiftCard.title,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0), // Padding for the content inside the container
                            decoration: BoxDecoration(
                              color: Button_color, // Assuming you have a color defined by name `MainColor`
                              borderRadius: BorderRadius.circular(5.0), // Making the container rounded
                            ),
                            child: Center(
                              child: Text(
                                controller.GiftCard.name.toString(), // Displaying the category
                                style: const TextStyle(
                                  color: Colors.white, // Text color
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, bottom: 5),
                      child: Text(
                        'Enter Your Gift Card Details'.tr,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            const Text(
                              "Amounts: ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Obx(() => Row(
                                  children: [
                                    ...controller.GiftCard.Amounts.map<Widget>((amount) {
                                      // <-- Notice the <Widget>
                                      bool isCurrentSelected = amount.purchase_amount == controller.selectedAmount.value;

                                      return GestureDetector(
                                        onTap: () => controller.setSelectedAmount(amount.purchase_amount),
                                        child: Container(
                                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                                          padding: EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            color: isCurrentSelected ? Button_color : Colors.white,
                                            border: Border.all(color: Colors.grey),
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          child: Center(
                                            child: Text(sign + amount.purchase_amount.toString()),
                                          ),
                                        ),
                                      );
                                    }).toList(), // <-- Make sure to call toList() here
                                    const SizedBox(width: 10), // For spacing
                                    Container(
                                      width: 70,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: Center(
                                        child: TextFormField(
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                            hintText: sign + 'XX',
                                            border: InputBorder.none,
                                          ),
                                          keyboardType: TextInputType.number,
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text("Delivery:".tr, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        Obx(() => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: _DeliveryButton(
                                isSelected: controller.deliveryMethod.value == 'Email',
                                label: "Email".tr,
                                onPressed: () => controller.setDeliveryMethod('Email'),
                              ),
                            )),
                        Obx(() => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: _DeliveryButton(
                                isSelected: controller.deliveryMethod.value == 'Text Message',
                                label: "Text Message",
                                onPressed: () => controller.setDeliveryMethod('Text Message'),
                              ),
                            )),
                      ],
                    ),
                    MyForm(),
                    ListView.builder(
                      shrinkWrap: true, // Makes the ListView wrap content
                      physics: NeverScrollableScrollPhysics(), // Makes it non-scrollable
                      itemCount: GiftCards_payment_methods.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          height: 70,
                          child: GestureDetector(
                            onTap: () {
                              controller.paying_method!.value = payment_methods[index]['name'];
                              controller.val = index;
                              controller.PaymentMethod = payment_methods[index]['id'];
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                                  color: controller.val == index ? MainColor : Colors.grey,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        payment_methods[index]['name'],
                                        style: const TextStyle(
                                          color: sh_white,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                   // Obx(() => controller.paying_method!.value == 'Pick Up' ? pickup_Location(context) :controller.paying_method!.value=='Bank Transfer'?BankMoneyTransfer(context):controller.paying_method!.value=='Stripe'?CardInputWidget():Container()),
                  ],
                ),
        ));
  }
}

// Extracted delivery button
class _DeliveryButton extends StatelessWidget {
  final bool isSelected;
  final String label;
  final VoidCallback onPressed;

  _DeliveryButton({
    required this.isSelected,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed) || isSelected) return Button_color;
            return Colors.white; // Unselected background color
          },
        ),
        foregroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed) || isSelected) return Colors.white;
            return Colors.black; // Unselected text color
          },
        ),
        side: MaterialStateProperty.resolveWith<BorderSide>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed) || isSelected) return BorderSide.none;
            return BorderSide(color: Colors.black, width: 1); // Border for unselected state
          },
        ),
      ),
      onPressed: onPressed,
      child: Text(label.tr),
    );
  }
}
