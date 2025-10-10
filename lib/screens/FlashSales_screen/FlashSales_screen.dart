import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/screens/FlashSales_screen/widgets/FlashSale.dart';
import 'package:iq_mall/screens/Home_screen_fragment/controller/Home_screen_fragment_controller.dart';
import 'package:get/get.dart';
import 'package:iq_mall/screens/timer.dart';
import '../../main.dart';
import '../../routes/app_routes.dart';
import '../../utils/ShColors.dart';
import '../../widgets/ViewAllButton.dart';
import 'controller/FlashSales_controller.dart';

class FlashSalesscreen extends GetView<FlashSalesController> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Obx(()=>
      globalController.homeDataList.value.flashSales!.isNotEmpty?
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,

              itemCount: globalController.homeDataList.value.flashSales!.length,
              itemBuilder: (BuildContext context, int index) {
                var flashSaleItem = globalController.homeDataList.value.flashSales![index];
                var filteredFlashProducts = globalController.homeDataList.value.flashProducts!.where((item) => item.r_flash_id == flashSaleItem.id).toList();

                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(int.parse(flashSaleItem.color1!.replaceFirst('#', '0xff'))),
                        Color(int.parse(flashSaleItem.color2!.replaceFirst('#', '0xff'))),
                        Color(int.parse(flashSaleItem.color3!.replaceFirst('#', '0xff')))
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      Padding(
                        padding: getPadding(left: 15.0, right: 15.0, bottom: 12, top: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,  // This line aligns children to the top
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(flashSaleItem.title,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: CustomButton(
                                    onTap: () {
                                      var f = {
                                        "flash_sales": [
                                          globalController.homeDataList.value.flashSales?[index].id.toString(),
                                        ],
                                      };
                                      String jsonString = jsonEncode(f);

                                      Get.toNamed(AppRoutes.View_All_Products, arguments: {
                                        'title': globalController.homeDataList.value.flashSales?[index].title.toString(),
                                        'id': globalController.homeDataList.value.flashSales?[index].id.toString(),
                                        'type': jsonString,
                                        'flashSale': globalController.homeDataList.value.flashSales?[index],
                                      });
                                    },
                                    label: 'View All'.tr,
                                    color: MainColor.withOpacity(0.9),
                                  ),
                                )
                              ],
                            ),

                            TimerScreen(initialDuration: flashSaleItem.endTime),
                          ],
                        ),
                      ),
                      FlashLists(filteredFlashProducts, flashSaleItem.sliderType, globalController.homeDataList.value.flashSales)
                    ],
                  )
                  ,
                );
              }):SizedBox()
      ),
    );
  }
}
