import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/utils/ShConstant.dart';
import 'package:iq_mall/widgets/CommonWidget.dart';
import '../../../main.dart';
import '../../../models/Stores.dart';
import '../../../utils/ShColors.dart';
import '../../../utils/ShImages.dart';
import '../../../widgets/image_widget.dart';
import '../../Stores_screen/controller/Stores_screen_controller.dart';

class TopStores extends StatefulWidget {
  @override
  _TopStoresState createState() => _TopStoresState();
}

class _TopStoresState extends State<TopStores> {
  StoreController storeController = Get.put(StoreController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return prefs!.getBool('multi_store') == true
        ?  ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Top Stores'.tr,
                    style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: Container(
            height: getVerticalSize(160),
            margin: const EdgeInsets.only(top: spacing_standard_new),
            child: Obx(
                  () {
                return storeController.loading.value
                    ? Container()
                    : Stack(
                  children: [
                    ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: storeList.length,
                        padding: const EdgeInsets.only(right: spacing_standard_new),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: getPadding(left: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                                border: Border.all(color: Colors.grey[200]!),
                                color: Colors.white,
                              ),
                              width: getHorizontalSize(160),
                              child: InkWell(
                                onTap: () {},
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    mediaWidget(
                                      storeList[index].main_image!,
                                      AssetPaths.placeholder,
                                      height: getSize(120)!,
                                      width: Get.size.width, // Adjust width if necessary
                                      fromKey: "",
                                      isProduct: false,
                                      fit: BoxFit.contain,
                                    ),
                                    // ClipRRect(
                                    //   borderRadius: BorderRadius.circular(8.0), // Set the desired radius for corners
                                    //   child: CachedNetworkImage(
                                    //     width: Get.size.width, // Adjust width if necessary
                                    //     fit: BoxFit.cover,
                                    //     imageUrl: storeList[index].main_image!,
                                    //     errorWidget: (context, url, error) => Container(
                                    //       color: Colors.grey,
                                    //       child: Center(
                                    //         child: Icon(Icons.error), // Optional: Add an error icon or any other widget
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: secondaryColor,
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(7),
                                          bottomRight: Radius.circular(7),
                                        ),
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 3.0, bottom: 3),
                                          child: Text(
                                            storeList[index].store_name!,
                                            style: const TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    )
        : Container();
  }
}
