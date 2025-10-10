import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/routes/app_routes.dart';
import 'package:iq_mall/screens/Cart_List_screen/controller/Cart_List_controller.dart';
import 'package:iq_mall/screens/Wishlist_screen/controller/Wishlist_controller.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/utils/ShConstant.dart';
import 'package:iq_mall/widgets/CommonWidget.dart';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'package:iq_mall/main.dart';
import 'package:iq_mall/models/functions.dart';
import 'package:iq_mall/utils/ShImages.dart';

import '../../../models/HomeData.dart';
import '../../../widgets/image_widget.dart';
import '../../Home_screen_fragment/controller/Home_screen_fragment_controller.dart';
import '../../ProductDetails_screen/ProductDetails_screen.dart';

// ignore_for_file: must_be_immutable
class favoritelistView extends StatelessWidget {
  RxList<Product>? favorites = RxList<Product>.generate(favoritelist!.length, (index) => favoritelist![index]);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<AnimatedListState> key = GlobalKey();
    return Obx(
      () {
        return Padding(
            key: UniqueKey(),
            padding: getPadding(top: 5),
            child: MyAnimatedListView(
              favorites: favorites!,
            ));
      },
    );
  }
}

class MyAnimatedListView extends StatefulWidget {
  final List<Product> favorites;

  MyAnimatedListView({Key? key, required this.favorites}) : super(key: key);

  @override
  State<MyAnimatedListView> createState() => _MyAnimatedListViewState();
}

class _MyAnimatedListViewState extends State<MyAnimatedListView> {
  Set<int> _removingItems = {};

  final GlobalKey<AnimatedListState> key = GlobalKey();

  void _removeItem(int index, BuildContext context, GlobalKey<AnimatedListState> key) {
    Future.delayed(Duration(milliseconds: 100)).then((value) {
      if(mounted){
        setState(() {
          _removingItems.add(index); // Mark the item as being removed
        });
      }
    });

    Future.delayed(Duration(milliseconds: 400)).then((value) {
      favoritelist![index].removing = '0';
      // controller.removing_items.value = false;
      try {
        for (int i = 0; i < globalController.homeDataList.value.products!.length; i++) {
          if (globalController.homeDataList.value.products![i].product_id == favoritelist?[index].product_id) {
            globalController.updateFavoriteProduct(globalController.homeDataList.value.products![i].product_id,globalController.isLiked.value?1:0);

          }
        }
      } catch (e) {}
      favoritelist!.removeAt(index);

    });
    try{
      function.setFavorite(favoritelist![index], false, false).then(
            (value) {},
      );
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: favoritelist!.length,
      padding: getPadding( bottom: getBottomPadding() + getSize(50),top: getTopPadding()+ getSize(50)),
      physics: AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
      itemBuilder: (context, index) {
        bool isRemoving = _removingItems.contains(index);

        return TweenAnimationBuilder(
          tween: Tween<double>(begin: 1, end: isRemoving ? 0 : 1),
          duration: const Duration(milliseconds: 300),
          builder: (context, double opacity, child) {
            return Opacity(
              opacity: opacity,
              child: Transform.scale(
                scale: opacity,
                child: child,
              ),
            );
          },
          child: _buildItem(context, index), // Your method to build the list item
        );
      },
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    final Product product = widget.favorites[index];

    // Build your list item widget using the product data
    // Example:
    return InkWell(
      onTap: () {
        globalController.isLiked.value = true;

        Get.toNamed(AppRoutes.Productdetails_screen, arguments: {
          'product': favoritelist![index],
          'fromCart': false,
          'productSlug': null,
          'tag': "${UniqueKey()}${ favoritelist![index].product_id}"

        }, parameters: {
          'tag': "${ favoritelist![index].product_id}"
        })?.then((value) {
          globalController.updateCurrentRout(AppRoutes.tabsRoute);
          globalController.cartCount=0;

          if (!globalController.isLiked.value) {
            _removeItem(index, context, key);
          } else {
            WishlistController _controller = Get.find();
            _controller.GetFavorite();
          }
        });
      },
      child: Padding(
        padding: getPadding(
          right: 16.0,
          left: 16.0,
          bottom: 10,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1), // Shadow color with opacity
                spreadRadius: 2, // Spread radius
                blurRadius: 3, // Blur radius
                offset: const Offset(0, 2), // Position of the shadow
              ),
            ],
          ),
          height: getVerticalSize(80),
          width: MediaQuery.of(context).size.width,
          child: Obx(
            () {
              return Stack(
                alignment: Alignment.topLeft,
                children: [
                  Row(
                    children: <Widget>[
                      mediaWidget(
                        favoritelist![index].main_image ?? '',
                        AssetPaths.placeholder,
                        width: getSize(70.0),
                        height: getVerticalSize(80.0),
                        topRightBorder: 0,
                        bottomRightBorder: 0,
                        bottomLeftBorder: 5,
                        isProduct: true,
                        fit: BoxFit.cover,
                      ),

                      // CachedNetworkImage(
                      //   imageUrl: favoritelist![index].main_image!,
                      //   placeholder: (context, url) => SizedBox(
                      //     width: 120.0,
                      //     height: 150.0,
                      //     child: Image.asset(
                      //       AssetPaths.placeholder,
                      //       width: width * 0.25,
                      //       height: width * 0.20,
                      //     ),
                      //   ),
                      //   errorWidget: (context, url, error) => Image.asset(
                      //     AssetPaths.placeholder,
                      //   ),
                      //   width: width * 0.25,
                      //   height: width * 0.22,
                      // ),
                      favoritelist![index].boolean_percent_discount == 1 ? percent(favoritelist![index]) : const SizedBox(),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: getPadding(left: 8.0, right: 8, top: 8),
                              child: Text(
                                favoritelist![index].product_name.toString(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                textAlign: TextAlign.left,
                                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ),
                            Padding(
                              padding: getPadding(left: 8.0, right: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  favoritelist![index].sales_discount != null
                                      ? Text(
                                          "$sign ${favoritelist![index].price_after_discount}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: price_color,
                                            fontSize: getFontSize(18),
                                            decoration: TextDecoration.none,
                                          ),
                                        )
                                      : const SizedBox(),
                                  Padding(
                                    padding: getPadding(left: favoritelist![index].sales_discount != null ? 10.0 : 0),
                                    child: Text(
                                      "$sign ${favoritelist![index].product_price}",
                                      style: TextStyle(
                                        fontWeight: favoritelist![index].sales_discount == null ? FontWeight.bold : FontWeight.normal,
                                        color: favoritelist![index].sales_discount != null ? discount_price_color : price_color,
                                        fontSize: getFontSize(favoritelist![index].sales_discount != null ? 16 : 18),
                                        decoration: favoritelist![index].sales_discount != null ? TextDecoration.lineThrough : TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          padding: getPadding(bottom: 0),
                          color: ColorConstant.logoSecondColor,
                          onPressed: () {
                            _removeItem(index, context, key);
                            // Home_screen_fragmentController _controller = Get.find();
                            // _controller.refreshFunctions();
                          },
                          icon: Icon(
                            favoritelist![index].removing == '1' ? Icons.favorite_border_rounded : Icons.favorite_rounded,
                            color: ColorConstant.logoSecondColor,
                            size: getSize(30),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
