import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iq_mall/screens/Search_screen/widgets/searchList.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/utils/ShConstant.dart';
import 'package:iq_mall/utils/ShImages.dart';
import 'package:iq_mall/widgets/CommonWidget.dart';
import 'package:iq_mall/widgets/ui.dart';
import '../../Product_widget/Product_widget.dart';
import '../../cores/math_utils.dart';
import '../../widgets/custom_image_view.dart';
import 'controller/Search_controller.dart';

class Searchscreen extends GetView<Searchcontroller> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf5f5f5),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        backgroundColor: sh_white,
        iconTheme: IconThemeData(color: sh_textColorPrimary),
        actionsIconTheme: IconThemeData(color: sh_textColorPrimary),
        title: TextFormField(
          focusNode: controller.focusNode,
          onChanged: (value) {
            controller.searchbarcode = false;
            controller.page.value = 1;
            // controller.Search();
            controller.performSearch(value, false);
          },
          controller: controller.searchController,
          style: const TextStyle(fontSize: 16, color: sh_textColorPrimary),
          decoration: InputDecoration(border: InputBorder.none, hintText: "Search".tr),
          textAlign: TextAlign.start,
        ),
        actions: <Widget>[
          controller.searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: sh_textColorPrimary,
                  ),
                  onPressed: () {
                    controller.searchController.clear();
                  },
                )
              : const SizedBox(),
        ],
      ),
      body: Obx(
        () => !controller.loading.value
            ? ListView(
                key: UniqueKey(),
                controller: controller.ScrollListener,
                children: [
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Obx(() {
                          return controller.loading.value
                              ? Ui.circularIndicator()
                              : !controller.loading.value && controller.SearchList!.isEmpty && controller.searchController.text.isEmpty
                                  ? Column(
                                      children: [
                                        Icon(
                                          Icons.search,
                                          size: 100,
                                          color: MainColor,
                                        ),
                                        Text(
                                          "Lets start".tr,
                                          style: TextStyle(color: MainColor, fontSize: textSizeLarge, fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "What are you looking for ?".tr,
                                          style: TextStyle(color: MainColor, fontSize: textSizeNormal),
                                        ),
                                      ],
                                    )
                                  : !controller.loading.value && controller.SearchList!.isNotEmpty
                                      ? Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 16.0, bottom: 16),
                                              child: Obx(() {
                                                return Center(
                                                    child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  key: Key(controller.SearchList!.toString()),
                                                  children: List.generate(
                                                    (controller.SearchList!.length / 2).ceil(),
                                                    (rowIndex) {
                                                      final startIndex = rowIndex * 2;
                                                      final endIndex = startIndex + 2;
                                                      return Row(
                                                        children: List.generate(
                                                          endIndex <= controller.SearchList!.length ? 2 : 1,
                                                          (columnIndex) {
                                                            final index = startIndex + columnIndex;
                                                            final product = controller.SearchList!.where((product) => product.cart_id != null).elementAt(index);
                                                            return product.cart_id != null
                                                                ? Expanded(
                                                                    child: Padding(
                                                                      padding: getPadding(all: 4.0),
                                                                      child: ProductWidget(product: product),
                                                                    ),
                                                                  )
                                                                : SizedBox();
                                                          },
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                )

                                                    // Wrap(
                                                    //   spacing: 10.0,
                                                    //   runSpacing: 10.0,
                                                    //   children:
                                                    //   products!
                                                    //       .map((product) => product.cart_id != null
                                                    //           ? ProductWidget(product: product)
                                                    //           : SizedBox())
                                                    //       .toList(),
                                                    // ),
                                                    );
                                                //   GridView.builder(
                                                //   key: Key(controller.SearchList!.toString()),
                                                //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                //     crossAxisCount: 2,
                                                //     childAspectRatio: getHorizontalSize(180) / getVerticalSize(310),
                                                //     mainAxisSpacing: 5.0, // vertical spacing
                                                //     crossAxisSpacing: 5.0, // horizontal spacing
                                                //   ),
                                                //   itemCount: controller.SearchList?.length,
                                                //   physics: const NeverScrollableScrollPhysics(),
                                                //   shrinkWrap: true,
                                                //   itemBuilder: (context, index) {
                                                //     return ProductWidget(
                                                //       product: controller.SearchList![index],
                                                //     );
                                                //   },
                                                // );
                                              }),
                                            ),
                                            Obx(() => controller.loadMore.value ? Progressor_indecator() : const SizedBox())
                                          ],
                                        )
                                      : Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: Get.width * 0.4,
                                                child:

                                                CustomImageView(
                                                    svgPath:AssetPaths.empty_search_image,
                                                    // svgUrl: prefs!.getString('Profile_image') ?? null,
                                                    height: Get.width * 0.4,
                                                    width: Get.width * 0.4,
                                                    notOpen: false,

                                                    fit: BoxFit.contain,
                                                    radius: BorderRadius.circular(getSize(20)))

                                              ),
                                              const Text(
                                                'No results found',
                                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        );
                        }),
                      ],
                    ),
                  ),
                ],
              )
            : Progressor_indecator(),
      ),
    );
  }
}
