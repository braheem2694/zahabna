import 'package:flutter/material.dart';
import 'package:iq_mall/screens/ProductDetails_screen/controller/ProductDetails_screen_controller.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/utils/ShConstant.dart';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'package:iq_mall/main.dart';
import 'package:get/get.dart';
import 'package:iq_mall/models/functions.dart';
import 'flutter_rating_bar.dart';
import 'package:iq_mall/cores/math_utils.dart';
import '../../Wishlist_screen/controller/Wishlist_controller.dart';

class ProductInfo extends StatefulWidget {
  final ProductDetails_screenController controller;

  const ProductInfo({super.key, required this.controller});

  @override
  _ProductInfoState createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  onLikeButtonTapped() async {
    widget.controller.liked.value = !widget.controller.liked.value;
    widget.controller.product.value?.is_liked =
        widget.controller.liked.value ? 1 : 0;
    globalController.isLiked.value = widget.controller.liked.value;

    function
        .setFavorite(widget.controller.product.value!, true,
            widget.controller.liked.value)
        .then(
      (value) {
        if (Get.isRegistered<WishlistController>()) {
          WishlistController _controller = Get.find();
          _controller.GetFavorite();
        }
      },
    );
  }

  @override
  void initState() {
    widget.controller.liked.value =
        widget.controller.product.value?.is_liked == 0 ? false : true;
    globalController.isLiked.value = widget.controller.liked.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Header Row: Name & Like
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Obx(
                  () => Text(
                    widget.controller.product.value?.product_name ?? '',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                      fontSize: getFontSize(20),
                      height: 1.3,
                      letterSpacing: 0.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Obx(
                () => widget.controller.updatingProductInfo.value
                    ? const SizedBox()
                    : (prefs?.getString("token") == null ||
                            prefs?.getString("token") == 'null')
                        ? const SizedBox()
                        : Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(50),
                              onTap: onLikeButtonTapped,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[100],
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    )
                                  ],
                                ),
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  transitionBuilder: (Widget child,
                                      Animation<double> animation) {
                                    return ScaleTransition(
                                        scale: animation, child: child);
                                  },
                                  child: Icon(
                                    widget.controller.liked.value
                                        ? Icons.favorite_rounded
                                        : Icons.favorite_border_rounded,
                                    key: ValueKey<bool>(
                                        widget.controller.liked.value),
                                    color: widget.controller.liked.value
                                        ? Colors.redAccent
                                        : Colors.grey[400],
                                    size: getSize(22),
                                  ),
                                ),
                              ),
                            ),
                          ),
              )
            ],
          ),

          const SizedBox(height: 16),

          // Price Section
          Obx(() {
            if (widget.controller.updatingProductInfo.value) {
              return const SizedBox();
            }
            final product = widget.controller.product.value;
            if (product == null) return const SizedBox();

            bool hasDiscount = product.price_after_discount != null &&
                product.price_after_discount != product.product_price;

            // Contact for price case
            if (product.product_price == 0) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: ColorConstant.logoFirstColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Contact us for price'.tr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ColorConstant.logoFirstColor,
                    fontSize: getFontSize(16),
                  ),
                ),
              );
            }

            return Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 4,
              children: [
                Text(
                  hasDiscount
                      ? '${sign.value}${product.price_after_discount ?? 0}'
                      : '${sign.value}${product.product_price ?? 0}',
                  style: TextStyle(
                    color: ColorConstant.logoFirstColor,
                    fontWeight: FontWeight.w800,
                    fontSize: getFontSize(24),
                    letterSpacing: -0.5,
                  ),
                ),
                if (hasDiscount)
                  Text(
                    '${sign.value}${product.product_price}',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.lineThrough,
                      fontSize: getFontSize(16),
                    ),
                  ),
                if (hasDiscount)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "Sale",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: getFontSize(10),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            );
          }),

          // Disclaimer (subtle)
          Obx(() => widget.controller.product.value?.product_price != 0
              ? Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text(
                    'The displayed price is not final'.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[500],
                      fontSize: getFontSize(11),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                )
              : const SizedBox()),

          const SizedBox(height: 20),

          // Stats / Info Chips
          Obx(
            () {
              if (widget.controller.updatingProductInfo.value) {
                return const SizedBox();
              }
              final product = widget.controller.product.value;
              if (product == null) return const SizedBox();

              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  // Rating Pill
                  if (product.is_ordered_before == 1)
                    InkWell(
                      onTap: () => _showReviewDialog(context),
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star_rounded,
                                color: Colors.amber, size: getSize(18)),
                            const SizedBox(width: 4),
                            Text(
                              "${product.rate}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: getFontSize(13),
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Sold Count
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Text(
                      "${product.orders_count} ${"sold".tr}",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: getFontSize(13),
                        color: Colors.black54,
                      ),
                    ),
                  ),

                  // Remaining Stock
                  if ((product.product_qty_left ?? 0) > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: (product.product_qty_left ?? 0) < 5
                            ? Colors.red.withOpacity(0.05)
                            : Colors.green.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                            color: (product.product_qty_left ?? 0) < 5
                                ? Colors.red.withOpacity(0.2)
                                : Colors.green.withOpacity(0.2)),
                      ),
                      child: Text(
                        "${product.product_qty_left} ${"remaining".tr}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: getFontSize(13),
                          color: (product.product_qty_left ?? 0) < 5
                              ? Colors.red
                              : Colors.green[700],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  void _showReviewDialog(BuildContext context) {
    showDialog<ConfirmAction>(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text("Review and Rate".tr,
                        style: TextStyle(
                            fontSize: getFontSize(22),
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                    const SizedBox(height: 16),
                    Obx(() => RatingBar(
                          initialRating:
                              widget.controller.rating.value.toDouble(),
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 36,
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            widget.controller.rateNumber = rating;
                          },
                        )),
                    const SizedBox(height: 20),
                    Form(
                      key: widget.controller.formKey,
                      child: TextFormField(
                        controller: widget.controller.Reviewcontroller,
                        keyboardType: TextInputType.multiline,
                        maxLines: 4,
                        validator: (value) => value == null || value.isEmpty
                            ? "Review Filed Required!".tr
                            : null,
                        decoration: InputDecoration(
                          hintText: 'Describe your experience'.tr,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: ColorConstant.logoFirstColor),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextButton(
                            onPressed: () =>
                                Navigator.of(context).pop(ConfirmAction.CANCEL),
                            child: Text('Cancel'.tr,
                                style: const TextStyle(color: Colors.black54)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorConstant.logoFirstColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () {
                              if (widget.controller.Reviewcontroller.text
                                  .trim()
                                  .isEmpty) {
                                toaster(context, 'Review it first please'.tr);
                              } else {
                                widget.controller.Review_Rate();
                                Navigator.of(context).pop(ConfirmAction.CANCEL);
                              }
                            },
                            child: Text('Submit'.tr,
                                style: const TextStyle(color: Colors.white)),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
