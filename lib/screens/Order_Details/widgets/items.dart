import 'package:flutter/material.dart';
import 'package:iq_mall/main.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iq_mall/cores/assets.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/utils/ShConstant.dart';
import 'package:iq_mall/utils/ShImages.dart';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'package:iq_mall/models/orderdetails.dart';
import '../controller/Order_Details_controller.dart';

class ItemWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Order_DetailsController controller = Get.find();
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: orderdetaillist.length,
      padding: const EdgeInsets.only(bottom: spacing_standard_new),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // controller.getsingleproduct(orderdetaillist[index].r_product_id.toString())
            //     .then((value) {
            //   if (searchlist.isEmpty) {
            //   } else {
            //     Get.toNamed(AppRoutes.Productdetails_screen, arguments: {
            //       'product': searchlist[0],
            //       'from_cart': false
            //     });
            //   }
            // });
          },
          child: Container(
            margin: const EdgeInsets.only(
              left: spacing_standard_new,
              right: spacing_standard_new,
              top: spacing_standard_new,
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: orderdetaillist[index].main_image!,
                    placeholder: (context, url) => SizedBox(
                      width: 120.0,
                      height: 200.0,
                      child: Container(
                        color: Colors.grey,
                      ),
                    ),
                    errorWidget: (context, url, error) => Image.asset(AssetPaths.placeholder),
                    width: controller.width * 0.25,
                    height: controller.width * 0.20,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(
                                  height: spacing_standard,
                                ),
                                Expanded(
                                  child: Text(
                                    orderdetaillist[index].product_name!,
                                    style: const TextStyle(
                                      color: sh_textColorPrimary,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                // text(
                                //   " \$${formatter.format(
                                //       ((double.parse(controller.order.total) * (1 - (double.parse(controller.order.discount ?? '0') / 100))) + controller.order.shipping_amount)
                                //   )}",
                                //   textColor: sh_textColorPrimary,
                                //   fontSize: 15,
                                // ),
                                text(
                                  "${'Product price'.tr}:${sign.value}${formatter.format(
                                    double.parse(orderdetaillist[index].product_price!),
                                  )}",
                                  textColor: sh_textColorPrimary,
                                  fontSize: 15,
                                ),
                                text(
                                  "${'Discount'.tr}:${sign.value}${formatter.format(
                                    double.parse(orderdetaillist[index].discount!),
                                  )}",
                                  textColor: sh_textColorPrimary,
                                  fontSize: 15,
                                ),
                                text(
                                  "${'Quantity'.tr}: ${orderdetaillist[index].quantity!}${' PCE'.tr}",
                                  textColor: sh_textColorPrimary,
                                  fontSize: 15,
                                ),
                                text(
                                  "${"Total".tr}: ${sign.value}${formatter.format(
                                    (double.parse(orderdetaillist[index].product_price!) - double.parse(orderdetaillist[index].discount!)) *
                                        double.parse(orderdetaillist[index].quantity!),
                                  )}",
                                  textColor: sh_textColorPrimary.withOpacity(0.7),
                                  fontSize: 15,
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            height: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
