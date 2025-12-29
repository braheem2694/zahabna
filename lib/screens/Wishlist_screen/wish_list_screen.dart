import 'package:flutter/material.dart';
import 'package:iq_mall/screens/Cart_List_screen/controller/Cart_List_controller.dart';
import 'package:iq_mall/screens/Wishlist_screen/controller/Wishlist_controller.dart';
import 'package:iq_mall/screens/Wishlist_screen/widgets/favoriteListView.dart';
import 'package:iq_mall/screens/tabs_screen/controller/tabs_controller.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/main.dart';
import 'package:get/get.dart';
import 'package:iq_mall/utils/ShImages.dart';
import 'package:shimmer/shimmer.dart';

import '../../cores/math_utils.dart';
import '../../widgets/custom_image_view.dart';

// ═══════════════════════════════════════════════════════════════════════════
// 🎨 WISHLIST THEME - Using App Brand Colors
// ═══════════════════════════════════════════════════════════════════════════

class _WishlistTheme {
  static Color get accent => ColorConstant.logoSecondColor;
  static Color get background => ColorConstant.gray50;
  static Color get textPrimary => ColorConstant.logoFirstColor;
  static Color get textSecondary => ColorConstant.gray500;
  
  static const double spacingSM = 8.0;
  static const double spacingMD = 12.0;
  static const double spacingLG = 16.0;
  static const double radiusMD = 12.0;
}

class Wishlistscreen extends StatelessWidget {
  final WishlistController controller = Get.put(WishlistController());

  Wishlistscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        TabsController tabController = Get.find();
        tabController.currentIndex.value = 0;
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: _WishlistTheme.background,
        body: RefreshIndicator(
          color: _WishlistTheme.accent,
          backgroundColor: Colors.white,
          onRefresh: () async {
            globalController.refreshHomeScreen(true);
            await controller.GetFavorite();
            return Future(() => true);
          },
          child: Obx(() {
            if (controller.loading.value) {
              return _buildShimmerLoading();
            }
            
            if (favoritelist == null || favoritelist!.isEmpty) {
              return _buildEmptyState();
            }
            
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Padding(
                padding: EdgeInsets.only(
                  top: globalController.refreshingHomeScreen.value ? _WishlistTheme.spacingSM : 0,
                ),
                child: favoritelistView(),
              ),
            );
          }),
        ),
      ),
    );
  }

  /// Shimmer loading skeleton
  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: EdgeInsets.only(
        top: getTopPadding() + getSize(50),
        bottom: getBottomPadding() + getSize(50),
        left: _WishlistTheme.spacingLG,
        right: _WishlistTheme.spacingLG,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: _WishlistTheme.spacingMD),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: getVerticalSize(85),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(_WishlistTheme.radiusMD),
              ),
              child: Row(
                children: [
                  // Image placeholder
                  Container(
                    width: getSize(75),
                    height: getVerticalSize(85),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(_WishlistTheme.radiusMD),
                      ),
                    ),
                  ),
                  const SizedBox(width: _WishlistTheme.spacingMD),
                  // Content placeholders
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: _WishlistTheme.spacingMD),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 14,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          Container(
                            width: 100,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          Container(
                            width: 80,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Icon placeholder
                  Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.all(_WishlistTheme.spacingMD),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
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

  /// Empty state with animation
  Widget _buildEmptyState() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: Get.height * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated icon container
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.8, end: 1.0),
              duration: const Duration(milliseconds: 600),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: child,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: _WishlistTheme.accent.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: CustomImageView(
                  width: Get.width * 0.35,
                  height: Get.width * 0.35,
                  image: AssetPaths.emptyFavorite_image,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            
            const SizedBox(height: _WishlistTheme.spacingLG * 1.5),
            
            // Title
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: Text(
                'Your Wishlist is Empty'.tr,
                style: TextStyle(
                  color: _WishlistTheme.textPrimary,
                  fontSize: getFontSize(20),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            
            const SizedBox(height: _WishlistTheme.spacingSM),
            
            // Subtitle
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: child,
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Save your favorite items here to buy them later'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _WishlistTheme.textSecondary,
                    fontSize: getFontSize(14),
                    height: 1.4,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: _WishlistTheme.spacingLG * 2),
            
            // Browse button
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.scale(
                    scale: 0.8 + (0.2 * value),
                    child: child,
                  ),
                );
              },
              child: _AnimatedButton(
                onTap: () {
                  TabsController tabController = Get.find();
                  tabController.currentIndex.value = 0;
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: _WishlistTheme.accent,
                    borderRadius: BorderRadius.circular(_WishlistTheme.radiusMD),
                    boxShadow: [
                      BoxShadow(
                        color: _WishlistTheme.accent.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: _WishlistTheme.spacingSM),
                      Text(
                        'Browse Products'.tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Animated button with tap feedback
class _AnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  
  const _AnimatedButton({required this.child, this.onTap});
  
  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton> {
  bool _isPressed = false;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOutCubic,
        child: AnimatedOpacity(
          opacity: _isPressed ? 0.8 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: widget.child,
        ),
      ),
    );
  }
}
