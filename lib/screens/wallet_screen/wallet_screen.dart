import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/widgets/CommonWidget.dart';
import 'package:flutter/material.dart';
import '../../Product_widget/Product_widget.dart';
import '../../main.dart';
import '../../routes/app_routes.dart';
import '../../utils/ShImages.dart';
import 'controller/wallet_screen_controller.dart';

class wallet_screen extends GetView<wallet_screenController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar('Wallet'.tr),
      body: ListView(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Text(
                'My Wallet'.tr,
                style: TextStyle(color: MainColor, fontSize: 25),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 20, top: 15, bottom: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Balance'.tr,
                  style: TextStyle(color: MainColor, fontSize: 20),
                ),
                Text(
                  sign + balance!.value.toString(),
                  style: TextStyle(color: price_color, fontSize: 20),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextFormField(
              controller: controller.GiftCardSerialNumber,
              decoration: InputDecoration(
                hintText: 'Enter the code'.tr, // Hint text
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0), // Rounded corners
                  borderSide: const BorderSide(
                    color: Colors.grey, // Grey border color
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0), // Rounded corners
                  borderSide: const BorderSide(
                    color: Colors.grey, // Grey border color for enabled state
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0), // Rounded corners
                  borderSide: const BorderSide(
                    color: Colors.grey, // Grey border color for focused state
                  ),
                ),
              ),
            ),
          ),
          Obx(
            () => controller.Redeeming.value
                ? Center(
                    child: SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          color: MainColor,
                        )))
                : GestureDetector(
                    onTap: () {
                      controller.RedeemGiftCard(context, controller.GiftCardSerialNumber);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        padding: EdgeInsets.all(10.0), // Add padding if needed
                        decoration: BoxDecoration(
                          color: Button_color,
                          borderRadius: BorderRadius.circular(5.0), // Rounded corners
                        ),
                        child: Center(
                          child: Text(
                            'Redeem'.tr,
                            style: const TextStyle(
                              color: Colors.white, // Setting text color to white for better contrast with MainColor
                              fontSize: 16.0, // Adjust font size as needed
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Categories".tr,
              style: TextStyle(color: MainColor, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Obx(() => controller.loading.value
              ? Center(
                  child: CircularProgressIndicator(
                    color: MainColor,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 15.0,
                    runSpacing: 12.0,
                    children: List.generate(controller.categories!.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          controller.selectedCategoryId.value = controller.categories![index].id; // Assuming each category has an ID property
                        },
                        child: Row(
                          children: [
                            Icon(
                              controller.selectedCategoryId.value == controller.categories![index].id
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              size: 28,
                              color: MainColor.withOpacity(0.7),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(controller.categories![index].name.toString()),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                )),
          Obx(() => controller.loading.value
              ? Container()
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      spacing: 15.0,
                      runSpacing: 12.0,
                      children: List.generate(controller.GifCards!.length, (index) {
                        if (controller.selectedCategoryId.value != null &&
                            controller.GifCards![index].r_category_id != controller.selectedCategoryId.value) {
                          // Do not show the gift card if the category is selected and does not match the gift card's r_category_id
                          return Container();
                        }
                        return GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.GiftCard, arguments: {'GiftCard': controller.GifCards![index]});
                          },
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.45,
                            height: 240,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0), // rounded corners
                              ),
                              elevation: 5, // shadow
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Pushes the content to the edges of the column
                                children: [
                                  Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)), // rounded corners for the top image
                                        child: CachedNetworkImage(
                                          height: 160,
                                          width: MediaQuery.of(context).size.width * 0.4,
                                          fit: BoxFit.cover,
                                          imageUrl: convertToThumbnailUrl(controller.GifCards![index].main_image!, isBlurred: false),
                                          placeholder: (context, url) {
                                            return CachedNetworkImage(
                                              imageUrl: convertToThumbnailUrl(controller.GifCards![index].main_image!, isBlurred: true),
                                              placeholderFadeInDuration: const Duration(milliseconds: 100),
                                            );
                                          },
                                          errorWidget: (context, s, a) {
                                            return CachedNetworkImage(
                                              height: 160,
                                              width: MediaQuery.of(context).size.width * 0.4,
                                              fit: BoxFit.cover,
                                              imageUrl: controller.GifCards![index].main_image!,
                                              errorWidget: (context, s, a) {
                                                return Center(
                                                  child: Image.asset(
                                                    AssetPaths.placeholder,
                                                    width: Get.size.width * 0.4,
                                                    height: Get.size.height * 0.4,
                                                    fit: BoxFit.cover,
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 8.0), // Add some spacing for better UI
                                      Padding(
                                        padding: const EdgeInsets.only(left: 3.0, right: 3),
                                        child: Text(
                                          controller.GifCards![index].title!.length > 50
                                              ? controller.GifCards![index].title!.substring(0, 47) + '...'
                                              : controller.GifCards![index].title.toString(),
                                          maxLines: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Spacer will push the bottom content to the bottom
                                  Spacer(),
                                  Text("${controller.GifCards![index].min_amount.toString()} - ${controller.GifCards![index].max_amount.toString()}"),
                                  SizedBox(height: 8.0), // Add some spacing for better UI at the bottom
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ))
        ],
      ),
    );
  }
}
