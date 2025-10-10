import 'package:flutter/material.dart';

import 'package:iq_mall/screens/ProductDetails_screen/controller/ProductDetails_screen_controller.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/utils/ShConstant.dart';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:iq_mall/main.dart';
import 'package:get/get.dart';

import '../../../cores/math_utils.dart';
import '../../Wishlist_screen/controller/Wishlist_controller.dart';
import 'flutter_rating_bar.dart';
import 'package:iq_mall/models/functions.dart';

class ProductInfo extends StatefulWidget {
  final ProductDetails_screenController controller;

  const ProductInfo({super.key, required this.controller});

  @override
  _ProductInfoState createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  onLikeButtonTapped() async {
    widget.controller.liked.value = !widget.controller.liked.value;
    widget.controller.product.value?.is_liked = widget.controller.liked.value ? 1 : 0;
    globalController.isLiked.value = widget.controller.liked.value;

    print("1 : ${widget.controller.liked.value}");
    print("2 : ${widget.controller.product.value?.is_liked}");

    function.setFavorite(widget.controller.product.value!, true, widget.controller.liked.value).then(
      (value) {
        WishlistController _controller = Get.find();
        _controller.GetFavorite();
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    widget.controller.liked.value = widget.controller.product.value?.is_liked == 0 ? false : true;
    globalController.isLiked.value = widget.controller.liked.value;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, left: 12),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(
                () => widget.controller.product.value?.product_price == 0
                    ? Text(
                        'Contact us for price'.tr,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: price_color,
                          fontSize: getFontSize(15),
                          decoration: TextDecoration.none,
                        ),
                      )
                    : widget.controller.product.value?.price_after_discount != null && widget.controller.product.value?.price_after_discount != widget.controller.product.value?.product_price
                        ? Padding(
                            padding: getPadding(right: 4.0),
                            child: Text(
                              widget.controller.updatingProductInfo.value
                                  ? ""
                                  : (widget.controller.product.value?.price_after_discount != null && widget.controller.product.value?.price_after_discount != widget.controller.product.value?.product_price)
                                      ? '${sign.value}${widget.controller.product.value?.price_after_discount ?? 0}' // Show discounted price if available
                                      : '${sign.value}${widget.controller.product.value?.product_price ?? 0}',
                              textAlign: TextAlign.center, // Else, show the product price

                              // Else, show the product price
                              style: TextStyle(
                                color: price_color,
                                fontWeight: FontWeight.w700,
                                fontSize: getFontSize(25),
                                decoration: TextDecoration.none, // Else, show plain text
                              ),
                            ),
                          )
                        : SizedBox(),
              ),
              Obx(() {
                return Text(
                  '${sign.value}${widget.controller.product.value?.product_price} ',
                  textAlign: TextAlign.center, // Else, show the product price
                  style: TextStyle(
                    color: (widget.controller.product.value?.price_after_discount != null && widget.controller.product.value?.price_after_discount != widget.controller.product.value?.product_price) ? discount_price_color : price_color,
                    fontWeight: FontWeight.w700,

                    fontSize: (widget.controller.product.value?.price_after_discount != null && widget.controller.product.value?.price_after_discount != widget.controller.product.value?.product_price) ? getFontSize(15) : getFontSize(23),
                    decoration: (widget.controller.product.value?.price_after_discount != null && widget.controller.product.value?.price_after_discount != widget.controller.product.value?.product_price)
                        ? TextDecoration.lineThrough // If there's a discount, strikethrough the original price
                        : TextDecoration.none, // Else, show plain text
                  ),
                );
              }),
              Expanded(child: SizedBox()),
              Obx(
                () => widget.controller.updatingProductInfo.value
                    ? Container()
                    : prefs!.getString("token").toString() == 'null'
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.only(top: 0.0, right: 15),
                            child: GestureDetector(
                              onTap: () => onLikeButtonTapped(),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder: (Widget child, Animation<double> animation) {
                                  return ScaleTransition(scale: animation, child: child);
                                },
                                child: Icon(
                                  widget.controller.liked.value ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                  key: ValueKey<bool>(widget.controller.liked.value),
                                  color: ColorConstant.logoSecondColor,
                                  size: getSize(27),
                                ),
                              ),
                            )
                            // IconButton(
                            //   icon: Obx(() => Icon(
                            //         widget.controller.liked.value ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            //         size: getSize(30),
                            //       )),
                            //   color: ColorConstant.logoSecondColor,
                            //   onPressed: () => onLikeButtonTapped(),
                            // )
                            // LikeButton(
                            //   size: 30,
                            //   onTap: onLikeButtonTapped,
                            //   isLiked: widget.controller.product.value?.isLiked.toString() == '0' ? false : true,
                            //   likeCountAnimationType:
                            //       199 < 1000 ? LikeCountAnimationType.all : LikeCountAnimationType.part,
                            //   product: widget.controller.product.value,
                            // ),
                            ),
              )
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              // parse(widget.controller.product.value?.product_name).body!.text,
              widget.controller.product.value?.product_name ?? '',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: getFontSize(18),
              ),
              textAlign: TextAlign.start,
              maxLines: 1,
            ),
          ),

          widget.controller.product.value?.product_price != 0
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'The displayed price is not final'.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: price_color,
                      fontSize: getFontSize(15),
                      decoration: TextDecoration.none,
                    ),
                  ),
                )
              : const SizedBox(),
          Obx(
            () => widget.controller.updatingProductInfo.value
                ? Container()
                : widget.controller.product.value?.is_ordered_before == 1
                    ? Padding(
                        padding: const EdgeInsets.only(right: 8.0, bottom: 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                showDialog<ConfirmAction>(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (context) {
                                      return Scaffold(
                                        backgroundColor: Colors.transparent,
                                        body: Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(16),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  color: Colors.white,
                                                  alignment: Alignment.center,
                                                  width: MediaQuery.of(context).size.width - 40,
                                                  child: Column(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: const EdgeInsets.all(10.0),
                                                        child: text("Review and Rate".tr, fontSize: 24, fontFamily: fontBold, textColor: Colors.black),
                                                      ),
                                                      const Divider(
                                                        thickness: 0.5,
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(spacing_large),
                                                        child: Row(
                                                          children: [
                                                            Obx(() => RatingBar(
                                                                  initialRating: widget.controller.rating.value.toDouble(),
                                                                  direction: Axis.horizontal,
                                                                  allowHalfRating: true,
                                                                  tapOnlyMode: true,
                                                                  itemCount: 5,
                                                                  itemSize: 30,
                                                                  itemBuilder: (context, _) => const Icon(
                                                                    Icons.star,
                                                                    color: Colors.amber,
                                                                    size: 25,
                                                                  ),
                                                                  onRatingUpdate: (rating) {
                                                                    widget.controller.rateNumber = rating;
                                                                  },
                                                                )),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  widget.controller.product.value!.rate.toString(),
                                                                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                                                                ),
                                                                const Icon(
                                                                  Icons.star,
                                                                  color: Colors.green,
                                                                  size: 14,
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: spacing_large, right: spacing_large),
                                                        child: Form(
                                                          key: widget.controller.formKey,
                                                          child: TextFormField(
                                                            controller: widget.controller.Reviewcontroller,
                                                            keyboardType: TextInputType.multiline,
                                                            maxLines: 5,
                                                            validator: (value) {
                                                              return "Review Filed Required!".tr;
                                                            },
                                                            style: const TextStyle(fontFamily: fontRegular, fontSize: textSizeNormal, color: sh_textColorPrimary),
                                                            decoration: InputDecoration(
                                                              hintText: 'Describe your experience'.tr,
                                                              border: InputBorder.none,
                                                              enabledBorder: const OutlineInputBorder(
                                                                borderSide: BorderSide(color: Colors.grey, width: 1),
                                                              ),
                                                              focusedBorder: const OutlineInputBorder(
                                                                borderSide: BorderSide(color: Colors.grey, width: 1),
                                                              ),
                                                              filled: false,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(spacing_large),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          children: <Widget>[
                                                            Expanded(
                                                              child: MaterialButton(
                                                                textColor: MainColor,
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(5.0),
                                                                  side: BorderSide(color: MainColor),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.of(context).pop(ConfirmAction.CANCEL);
                                                                },
                                                                child: text('Cancel'.tr, fontSize: textSizeNormal, textColor: MainColor),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: spacing_standard_new,
                                                            ),
                                                            Expanded(
                                                              child: MaterialButton(
                                                                color: MainColor,
                                                                textColor: Colors.white,
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(5.0),
                                                                ),
                                                                onPressed: () async {
                                                                  if (widget.controller.Reviewcontroller.text.toString() == '') {
                                                                    toaster(context, 'Review it first please'.tr);
                                                                  } else {
                                                                    widget.controller.Review_Rate();
                                                                    Navigator.of(context).pop(ConfirmAction.CANCEL);
                                                                  }
                                                                },
                                                                child: text('Submit'.tr, fontSize: textSizeNormal, textColor: sh_white),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              },
                              child: AbsorbPointer(
                                child: Obx(() => RatingBar(
                                      initialRating: widget.controller.rating.value.toDouble(),
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      tapOnlyMode: true,
                                      itemCount: 5,
                                      itemSize: getSize(20),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        size: getSize(30),
                                        color: Colors.amber,
                                      ),
                                    )),
                              ),
                            ),
                            Padding(
                              padding: getPadding(
                                left: 12.0,
                              ),
                              child: Obx(() => Text(
                                    widget.controller.updatingProductInfo.value ? "" : "${widget.controller.product.value!.orders_count}${" sold".tr}",
                                    style: TextStyle(
                                      color: ColorConstant.logoFirstColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: getFontSize(15),
                                    ),
                                  )),
                            ),
                            Padding(
                              padding: getPadding(left: 6.0, right: 6),
                              child: Text(
                                "/",
                                style: TextStyle(
                                  color: ColorConstant.logoFirstColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: getFontSize(15),
                                ),
                              ),
                            ),

                            // Padding(
                            //   padding: const EdgeInsets.only(left: 4.0,right: 4),
                            //   child: Container(color: ColorConstant.logoFirstColor,width: 2,height: 15,
                            //   alignment: Alignment.topCenter,),
                            // ),
                            Obx(() => Text(
                                  widget.controller.product.value!.product_qty_left.toString() + " remaining".tr,
                                  style: TextStyle(
                                    color: ColorConstant.logoFirstColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: getFontSize(15),
                                  ),
                                ))
                          ],
                        ),
                      )
                    : Container(),
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: [
          //     Padding(
          //       padding: getPadding(right: 8.0),
          //       child: Container(
          //         width: getHorizontalSize(110),
          //         alignment: Alignment.center,
          //         child: buildInfoItem(
          //           icon: Icons.monetization_on,
          //           title: "Price ".tr // If there's a discount, show original price
          //           , // Else, just show the product price
          //           content: Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Obx(
          //                 () => widget.controller.product.value?.price_after_discount != null
          //                     ? Padding(
          //                         padding: getPadding(right: 4.0),
          //                         child: Text(
          //                           widget.controller.updatingProductInfo.value
          //                               ? ""
          //                               : widget.controller.product.value?.price_after_discount != null
          //                                   ? '${sign.value}${widget.controller.product.value?.price_after_discount ?? 0}' // Show discounted price if available
          //                                   : '${sign.value}${widget.controller.product.value?.product_price ?? 0}',
          //                           textAlign: TextAlign.center, // Else, show the product price
          //
          //                           // Else, show the product price
          //                           style: TextStyle(
          //                             color: price_color,
          //                             fontWeight: FontWeight.w700,
          //                             fontSize: getFontSize(15),
          //                             decoration: TextDecoration.none, // Else, show plain text
          //                           ),
          //                         ),
          //                       )
          //                     : SizedBox(),
          //               ),
          //               Obx(() {
          //                 return Text(
          //                   '${sign.value}${widget.controller.product.value?.product_price} ',
          //                   textAlign: TextAlign.center, // Else, show the product price
          //                   style: TextStyle(
          //                     color: widget.controller.product.value?.price_after_discount != null ? discount_price_color : price_color,
          //                     fontWeight: FontWeight.w700,
          //
          //                     fontSize: getFontSize(15),
          //                     decoration: widget.controller.product.value?.price_after_discount != null
          //                         ? TextDecoration.lineThrough // If there's a discount, strikethrough the original price
          //                         : TextDecoration.none, // Else, show plain text
          //                   ),
          //                 );
          //               }),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //     Padding(
          //       padding: getPadding(right: 8.0),
          //       child: Obx(() => widget.controller.product.value?.orders_count != null && (widget.controller.product.value?.orders_count ?? 0) > 0
          //           ? SizedBox(
          //               width: getHorizontalSize(110),
          //               child: Padding(
          //                 padding: const EdgeInsets.all(5.0),
          //                 child: buildInfoItem(
          //                   icon: Icons.library_books,
          //                   title: "No. of Order".tr,
          //                   content: Obx(() => Text(
          //                         widget.controller.updatingProductInfo.value ? "" : widget.controller.product.value!.orders_count.toString(),
          //                         style: TextStyle(
          //                           color: Colors.red[800],
          //                           fontWeight: FontWeight.w700,
          //                           fontSize: getFontSize(15),
          //                         ),
          //                       )),
          //                 ),
          //               ),
          //             )
          //           : SizedBox()),
          //     ),
          //     Padding(
          //       padding: getPadding(right: 8.0),
          //       child: SizedBox(
          //         width: getHorizontalSize(110),
          //         child: buildInfoItem(
          //           icon: Icons.layers,
          //           title: "Available Stocks".tr,
          //           content: Obx(() => Text(
          //                 widget.controller.product.value!.product_qty_left.toString(),
          //                 style: TextStyle(
          //                   color: Colors.red[800],
          //                   fontWeight: FontWeight.w700,
          //                   fontSize: getFontSize(15),
          //                 ),
          //               )),
          //         ),
          //       ),
          //     )
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget buildInfoItem({
    required IconData icon,
    required String title,
    Widget? subtitle,
    required Widget content,
  }) {
    return DottedBorder(
      radius: const Radius.circular(55),
      color: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Obx(() => widget.controller.updatingProductInfo.value
            ? Container()
            : SizedBox(
                width: getHorizontalSize(110),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          icon,
                          color: Colors.black,
                          size: 18,
                        ),
                        if (subtitle != null) subtitle,
                        Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.black, fontSize: getFontSize(10), fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: content,
                    ),
                  ],
                ),
              )),
      ),
    );
  }
}
