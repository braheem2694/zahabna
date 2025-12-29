import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/routes/app_routes.dart';
import 'package:iq_mall/screens/Cart_List_screen/controller/Cart_List_controller.dart';
import 'package:iq_mall/screens/Wishlist_screen/controller/Wishlist_controller.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/main.dart';
import 'package:iq_mall/models/functions.dart';
import 'package:iq_mall/utils/ShImages.dart';

import '../../../models/HomeData.dart';
import '../../../widgets/image_widget.dart';

// ═══════════════════════════════════════════════════════════════════════════
// 🎨 WISHLIST ITEM THEME
// ═══════════════════════════════════════════════════════════════════════════

class _ItemTheme {
  static Color get accent => ColorConstant.logoSecondColor;
  static Color get priceColor => ColorConstant.logoSecondColor;
  static Color get discountColor => ColorConstant.gray500;
  static Color get cardBg => Colors.white;
  static Color get textPrimary => const Color(0xFF1A1A2E);
  
  static const double spacingXS = 4.0;
  static const double spacingSM = 8.0;
  static const double spacingMD = 12.0;
  static const double spacingLG = 16.0;
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
  
  static List<BoxShadow> get accentGlow => [
    BoxShadow(
      color: accent.withOpacity(0.25),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
}

// ignore_for_file: must_be_immutable
class favoritelistView extends StatelessWidget {
  final RxList<Product> favorites = RxList<Product>.generate(
    favoritelist!.length,
    (index) => favoritelist![index],
  );

  favoritelistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => MyAnimatedListView(
      key: ValueKey(favorites.length),
      favorites: favorites,
    ));
  }
}

class MyAnimatedListView extends StatefulWidget {
  final List<Product> favorites;

  const MyAnimatedListView({super.key, required this.favorites});

  @override
  State<MyAnimatedListView> createState() => _MyAnimatedListViewState();
}

class _MyAnimatedListViewState extends State<MyAnimatedListView> {
  final Set<int> _removingItems = {};
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  void _removeItem(int index, BuildContext context) {
    Future.delayed(const Duration(milliseconds: 100)).then((value) {
      if (mounted) {
        setState(() {
          _removingItems.add(index);
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 400)).then((value) {
      favoritelist![index].removing = '0';
      try {
        for (int i = 0; i < globalController.homeDataList.value.products!.length; i++) {
          if (globalController.homeDataList.value.products![i].product_id == favoritelist?[index].product_id) {
            globalController.updateFavoriteProduct(
              globalController.homeDataList.value.products![i].product_id,
              globalController.isLiked.value ? 1 : 0,
            );
          }
        }
      } catch (e) {
        debugPrint('Error updating favorite: $e');
      }
      favoritelist!.removeAt(index);
    });
    
    try {
      function.setFavorite(favoritelist![index], false, false).then((_) {});
    } catch (e) {
      debugPrint('Error setting favorite: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: _listKey,
      itemCount: favoritelist!.length,
      padding: EdgeInsets.only(
        bottom: getBottomPadding() + getSize(50),
        top: getTopPadding() + getSize(50),
        left: _ItemTheme.spacingLG,
        right: _ItemTheme.spacingLG,
      ),
      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      itemBuilder: (context, index) {
        final isRemoving = _removingItems.contains(index);

        return TweenAnimationBuilder<double>(
          key: ValueKey('item_$index'),
          tween: Tween<double>(begin: isRemoving ? 1 : 0, end: isRemoving ? 0 : 1),
          duration: Duration(milliseconds: isRemoving ? 300 : 400),
          curve: isRemoving ? Curves.easeInBack : Curves.easeOutCubic,
          builder: (context, value, child) {
            return Opacity(
              opacity: value.clamp(0.0, 1.0),
              child: Transform.translate(
                offset: Offset(isRemoving ? 50 * (1 - value) : 30 * (1 - value), 0),
                child: Transform.scale(
                  scale: 0.95 + (0.05 * value),
                  child: child,
                ),
              ),
            );
          },
          child: _buildItem(context, index),
        );
      },
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: _ItemTheme.spacingMD),
      child: _AnimatedPressable(
        onTap: () => _navigateToDetails(context, index),
        child: Container(
          decoration: BoxDecoration(
            color: _ItemTheme.cardBg,
            borderRadius: BorderRadius.circular(_ItemTheme.radiusMD),
            boxShadow: _ItemTheme.cardShadow,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_ItemTheme.radiusMD),
            child: Obx(() => Row(
              children: [
                // Product Image with Discount Badge
                Stack(
                  children: [
                    mediaWidget(
                      favoritelist![index].main_image ?? '',
                      AssetPaths.placeholder,
                      width: getSize(85),
                      height: getVerticalSize(95),
                      topRightBorder: 0,
                      bottomRightBorder: 0,
                      bottomLeftBorder: _ItemTheme.radiusMD,
                      topLeftBorder: _ItemTheme.radiusMD,
                      isProduct: true,
                      fit: BoxFit.cover,
                    ),
                    
                    // Discount Badge
                    if (favoritelist![index].boolean_percent_discount == 1 && favoritelist![index].sales_discount != null)
                      Positioned(
                        top: _ItemTheme.spacingSM,
                        left: _ItemTheme.spacingSM,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: _ItemTheme.spacingSM,
                            vertical: _ItemTheme.spacingXS,
                          ),
                          decoration: BoxDecoration(
                            color: _ItemTheme.accent,
                            borderRadius: BorderRadius.circular(_ItemTheme.radiusSM),
                            boxShadow: _ItemTheme.accentGlow,
                          ),
                          child: Text(
                            '-${favoritelist![index].sales_discount}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                
                // Product Info
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(_ItemTheme.spacingMD),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Product Name
                        Text(
                          favoritelist![index].product_name ?? '',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            color: _ItemTheme.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: getFontSize(14),
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: _ItemTheme.spacingSM),
                        
                        // Price Row
                        _buildPriceRow(index),
                      ],
                    ),
                  ),
                ),
                
                // Favorite Button
                _AnimatedPressable(
                  onTap: () => _removeItem(index, context),
                  child: Container(
                    margin: const EdgeInsets.all(_ItemTheme.spacingMD),
                    padding: const EdgeInsets.all(_ItemTheme.spacingSM),
                    decoration: BoxDecoration(
                      color: _ItemTheme.accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(_ItemTheme.radiusSM),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: Icon(
                        favoritelist![index].removing == '1' 
                            ? Icons.favorite_border_rounded 
                            : Icons.favorite_rounded,
                        key: ValueKey(favoritelist![index].removing),
                        color: _ItemTheme.accent,
                        size: getSize(24),
                      ),
                    ),
                  ),
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }
  
  Widget _buildPriceRow(int index) {
    final hasDiscount = favoritelist![index].sales_discount != null;
    
    return Row(
      children: [
        // Discounted Price
        if (hasDiscount)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: _ItemTheme.spacingSM,
              vertical: _ItemTheme.spacingXS,
            ),
            decoration: BoxDecoration(
              color: _ItemTheme.priceColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(_ItemTheme.radiusSM),
            ),
            child: Text(
              "$sign ${favoritelist![index].price_after_discount}",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: _ItemTheme.priceColor,
                fontSize: getFontSize(15),
              ),
            ),
          ),
        
        if (hasDiscount) const SizedBox(width: _ItemTheme.spacingSM),
        
        // Original Price
        Text(
          "$sign ${favoritelist![index].product_price}",
          style: TextStyle(
            fontWeight: hasDiscount ? FontWeight.w500 : FontWeight.w700,
            color: hasDiscount ? _ItemTheme.discountColor : _ItemTheme.priceColor,
            fontSize: getFontSize(hasDiscount ? 13 : 15),
            decoration: hasDiscount ? TextDecoration.lineThrough : TextDecoration.none,
            decorationColor: _ItemTheme.discountColor,
          ),
        ),
      ],
    );
  }

  void _navigateToDetails(BuildContext context, int index) {
    globalController.isLiked.value = true;

    Get.toNamed(
      AppRoutes.Productdetails_screen,
      arguments: {
        'product': favoritelist![index],
        'fromCart': false,
        'productSlug': null,
        'tag': "${UniqueKey()}${favoritelist![index].product_id}"
      },
      parameters: {
        'tag': "${favoritelist![index].product_id}"
      },
    )?.then((value) {
      globalController.updateCurrentRout(AppRoutes.tabsRoute);
      globalController.cartCount = 0;

      if (!globalController.isLiked.value) {
        _removeItem(index, context);
      } else {
        WishlistController controller = Get.find();
        controller.GetFavorite();
      }
    });
  }
}

/// Animated pressable wrapper with tap feedback
class _AnimatedPressable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _AnimatedPressable({required this.child, this.onTap});

  @override
  State<_AnimatedPressable> createState() => _AnimatedPressableState();
}

class _AnimatedPressableState extends State<_AnimatedPressable> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOutCubic,
        child: AnimatedOpacity(
          opacity: _isPressed ? 0.85 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: widget.child,
        ),
      ),
    );
  }
}

