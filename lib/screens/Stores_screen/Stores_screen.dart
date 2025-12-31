import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:iq_mall/routes/app_routes.dart';
import 'package:iq_mall/widgets/custom_image_view.dart';
import 'package:shimmer/shimmer.dart';

import '../../cores/math_utils.dart';
import '../../main.dart';
import '../../models/Stores.dart';
import '../../utils/ShColors.dart';
import '../../utils/ShImages.dart';
import 'controller/Stores_screen_controller.dart';

// ═══════════════════════════════════════════════════════════════════════════
// 🎨 STORES THEME - Premium Gold Design
// ═══════════════════════════════════════════════════════════════════════════

class _StoresTheme {
  // Brand Colors
  static Color get primary => ColorConstant.logoFirstColor;
  static Color get accent => ColorConstant.logoSecondColor;
  static Color get background => const Color(0xFFF8F6F3);
  static Color get cardBg => Colors.white;
  static Color get textPrimary => const Color(0xFF1A1A2E);
  static Color get textSecondary => const Color(0xFF6B7280);
  
  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingSM = 8.0;
  static const double spacingMD = 12.0;
  static const double spacingLG = 16.0;
  static const double spacingXL = 24.0;
  
  // Radius
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  
  // Shadows
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> get accentGlow => [
    BoxShadow(
      color: accent.withOpacity(0.25),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
  
  // Gradients
  static LinearGradient get goldGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      accent.withOpacity(0.85),
      accent,
    ],
  );
  
  static LinearGradient get subtleGoldGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      accent.withOpacity(0.05),
      accent.withOpacity(0.1),
    ],
  );
}

class Storesscreen extends StatelessWidget {
  const Storesscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tag = Get.arguments?["tag"] ?? "main";

    if (!Get.isRegistered<StoreController>(tag: tag)) {
      Get.put(StoreController(), tag: tag);
    }

    final StoreController controller = Get.find<StoreController>(tag: tag);

    return Obx(() {
      if (controller.loading.isTrue) {
        return Scaffold(
          backgroundColor: _StoresTheme.background,
          body: _buildShimmerLoading(),
        );
      }

      return Scaffold(
        backgroundColor: _StoresTheme.background,
        appBar: globalController.storeRoute.value != AppRoutes.tabsRoute
            ? _buildAppBar()
            : null,
        body: Column(
          children: [
            // Header Section
            _buildHeader(controller),
            
            // City Filter Dropdown
            _buildCityFilter(context, controller),
            
            // Stores Grid
            Expanded(
              child: _buildStoresGrid(controller, tag),
            ),
          ],
        ),
      );
    });
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      toolbarHeight: getSize(50),
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        "All Stores".tr,
        style: TextStyle(
          color: _StoresTheme.primary,
          fontWeight: FontWeight.w700,
          fontSize: getFontSize(18),
        ),
      ),
      leading: _AnimatedPressable(
        onTap: () => Get.back(),
        child: Icon(
          Icons.arrow_back_ios_rounded,
          color: _StoresTheme.primary,
          size: 22,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: _StoresTheme.accent.withOpacity(0.1),
        ),
      ),
    );
  }

  Widget _buildHeader(StoreController controller) {
    return Obx(() {
      if (globalController.storeRoute.value != AppRoutes.tabsRoute) {
        return const SizedBox.shrink();
      }
      
      return Container(
        padding: EdgeInsets.only(
          top: getTopPadding() + _StoresTheme.spacingLG+ getSize(45),
          bottom: _StoresTheme.spacingSM,
        ),
        child: Column(
          children: [
            // Decorative accent line
            Container(
              width: 40,
              height: 3,
              decoration: BoxDecoration(
                color: _StoresTheme.accent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: _StoresTheme.spacingMD),
            Text(
              "All Stores".tr,
              style: TextStyle(
                color: _StoresTheme.textPrimary,
                fontSize: getFontSize(26),
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildCityFilter(BuildContext context, StoreController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _StoresTheme.spacingLG,
        vertical: _StoresTheme.spacingSM,
      ),
      child: Obx(() {
        final isFiltering = controller.isFiltering.value;
        
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: getSize(52),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(_StoresTheme.radiusMD),
            border: Border.all(
              color: isFiltering 
                  ? _StoresTheme.accent 
                  : _StoresTheme.accent.withOpacity(0.2),
              width: isFiltering ? 2 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isFiltering 
                    ? _StoresTheme.accent.withOpacity(0.15) 
                    : Colors.black.withOpacity(0.04),
                blurRadius: isFiltering ? 12 : 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: _StoresTheme.spacingMD),
          child: Row(
            children: [
              // Dropdown
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: controller.selectedCity.value,
                    items: List.generate(
                      controller.cities.length,
                      (index) => DropdownMenuItem(
                        value: controller.cities[index].values.last,
                        child: Row(
                          children: [
                            if (controller.cities[index].values.last != "Select City")
                              Container(
                                width: 8,
                                height: 8,
                                margin: const EdgeInsets.only(right: _StoresTheme.spacingSM),
                                decoration: BoxDecoration(
                                  color: _StoresTheme.accent,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            Text(
                              controller.cities[index].values.last.tr,
                              style: TextStyle(
                                color: _StoresTheme.textPrimary,
                                fontSize: getFontSize(14),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    onChanged: isFiltering ? null : (value) {
                      controller.filterByCity(value);
                    },
                    hint: Text(
                      'Select City'.tr,
                      style: TextStyle(
                        color: _StoresTheme.textSecondary,
                        fontSize: getFontSize(14),
                      ),
                    ),
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: isFiltering
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(_StoresTheme.accent),
                              ),
                            )
                          : Container(
                              padding: const EdgeInsets.all(_StoresTheme.spacingXS),
                              decoration: BoxDecoration(
                                color: _StoresTheme.accent.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(_StoresTheme.radiusSM),
                              ),
                              child: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: _StoresTheme.accent,
                                size: 20,
                              ),
                            ),
                    ),
                    isExpanded: true,
                    dropdownColor: Colors.white,
                    elevation: 8,
                    borderRadius: BorderRadius.circular(_StoresTheme.radiusMD),
                  ),
                ),
              ),
              
              // Clear filter button
              if (controller.selectedCity.value != null && !isFiltering)
                Padding(
                  padding: const EdgeInsets.only(left: _StoresTheme.spacingSM),
                  child: _AnimatedPressable(
                    onTap: () => controller.filterByCity("Select City"),
                    child: Container(
                      padding: const EdgeInsets.all(_StoresTheme.spacingXS),
                      decoration: BoxDecoration(
                        color: _StoresTheme.textSecondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(_StoresTheme.radiusSM),
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        color: _StoresTheme.textSecondary,
                        size: 18,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStoresGrid(StoreController controller, String tag) {
    return Obx(() {
      final isFiltering = controller.isFiltering.value;
      
      if (controller.stores.isEmpty && !isFiltering) {
        return _buildEmptyState();
      }

      final RxList<Rx<StoreClass>> stores = (Get.arguments == null || Get.arguments["tag"] != "side_menu"
          ? controller.stores
          : controller.stores
              .where((element) => element.value.ownerId.toString() == prefs?.getString("user_id"))
              .map((store) => store)
              .toList())
          .cast<Rx<StoreClass>>()
          .obs;

      return Stack(
        children: [
          RefreshIndicator(
            color: _StoresTheme.accent,
            backgroundColor: Colors.white,
            onRefresh: () => controller.fetchStores(false, true),
            child: GridView.builder(
              padding: EdgeInsets.only(
                bottom: getBottomPadding()+ getSize(55),
                right: _StoresTheme.spacingMD,
                left: _StoresTheme.spacingMD,
                top: _StoresTheme.spacingSM,
              ),
              physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
              controller: controller.scrollController,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: getVerticalSize(260),
                crossAxisCount: 2,
                mainAxisSpacing: _StoresTheme.spacingMD,
                crossAxisSpacing: _StoresTheme.spacingMD,
              ),
              itemCount: stores.isEmpty ? 0 : stores.length,
              itemBuilder: (context, index) {
                return AnimatedOpacity(
                  opacity: isFiltering ? 0.5 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: _StoreCard(
                    store: stores[index],
                    index: index,
                    controller: controller,
                    tag: tag,
                  ),
                );
              },
            ),
          ),
          
          // Filtering overlay with shimmer effect
          if (isFiltering)
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedOpacity(
                  opacity: isFiltering ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    color: _StoresTheme.background.withOpacity(0.3),
                    child: Center(
                      child: _buildFilteringIndicator(),
                    ),
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildFilteringIndicator() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: _StoresTheme.spacingXL,
          vertical: _StoresTheme.spacingLG,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(_StoresTheme.radiusLG),
          boxShadow: [
            BoxShadow(
              color: _StoresTheme.accent.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation(_StoresTheme.accent),
              ),
            ),
            const SizedBox(height: _StoresTheme.spacingMD),
            Text(
              'Filtering stores...'.tr,
              style: TextStyle(
                color: _StoresTheme.textPrimary,
                fontSize: getFontSize(14),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.8, end: 1.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(scale: value, child: child);
            },
            child: Container(
              padding: const EdgeInsets.all(_StoresTheme.spacingXL),
              decoration: BoxDecoration(
                color: _StoresTheme.accent.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.store_mall_directory_outlined,
                size: 60,
                color: _StoresTheme.accent,
              ),
            ),
          ),
          const SizedBox(height: _StoresTheme.spacingLG),
          Text(
            "No stores available".tr,
            style: TextStyle(
              color: _StoresTheme.textPrimary,
              fontSize: getFontSize(18),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: _StoresTheme.spacingSM),
          Text(
            "Check back later for new stores".tr,
            style: TextStyle(
              color: _StoresTheme.textSecondary,
              fontSize: getFontSize(14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Padding(
      padding: EdgeInsets.only(
        top: getTopPadding() + _StoresTheme.spacingXL * 3,
        left: _StoresTheme.spacingMD,
        right: _StoresTheme.spacingMD,
      ),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisExtent: getVerticalSize(260),
          crossAxisCount: 2,
          mainAxisSpacing: _StoresTheme.spacingMD,
          crossAxisSpacing: _StoresTheme.spacingMD,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(_StoresTheme.radiusLG),
              ),
              child: Column(
                children: [
                  // Header shimmer
                  Container(
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(_StoresTheme.radiusLG),
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Image shimmer
                  Container(
                    height: getVerticalSize(80),
                    width: getVerticalSize(100),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(_StoresTheme.radiusSM),
                    ),
                  ),
                  const Spacer(),
                  // Buttons shimmer
                  Container(
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(_StoresTheme.radiusLG),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// 🏪 STORE CARD - Premium Design
// ═══════════════════════════════════════════════════════════════════════════

class _StoreCard extends StatelessWidget {
  final Rx<StoreClass> store;
  final int index;
  final StoreController controller;
  final String tag;

  const _StoreCard({
    required this.store,
    required this.index,
    required this.controller,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    final unescape = HtmlUnescape();
    final storeName = unescape.convert(store.value.store_name ?? 'No Name');
    final mainImage = store.value.main_image ?? "";

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 50).clamp(0, 200)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: _AnimatedPressable(
        onTap: _onShopTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_StoresTheme.radiusLG),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_StoresTheme.radiusLG),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Full-size background image
                CustomImageView(
                  image: mainImage.isNotEmpty ? mainImage : AssetPaths.placeholder,
                  placeHolder: AssetPaths.placeholder,
                  fit: BoxFit.cover,
                ),
                
                // Gradient overlay for text readability
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.15),
                          Colors.black.withOpacity(0.05),
                          Colors.black.withOpacity(0.35),
                          Colors.black.withOpacity(0.85),
                        ],
                        stops: const [0.0, 0.25, 0.6, 1.0],
                      ),
                    ),
                  ),
                ),
                
                // Top accent border with glow
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      gradient: _StoresTheme.goldGradient,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(_StoresTheme.radiusLG),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _StoresTheme.accent.withOpacity(0.5),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Info badge - Top right corner
                Positioned(
                  top: _StoresTheme.spacingMD,
                  right: _StoresTheme.spacingSM,
                  child: _buildInfoBadge(),
                ),
                
                // Store name and Shop button - Bottom area
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(_StoresTheme.spacingMD),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.1),
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Store name with enhanced styling
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: _StoresTheme.spacingSM,
                            vertical: _StoresTheme.spacingXS,
                          ),
                          child: Text(
                            storeName,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: getFontSize(16),
                              letterSpacing: 0.4,
                              height: 1.2,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.7),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                                Shadow(
                                  color: Colors.black.withOpacity(0.4),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: _StoresTheme.spacingMD),
                        
                        // Shop button badge
                        _buildShopBadge(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Frosted-glass style Shop badge
  Widget _buildShopBadge() {
    return _AnimatedPressable(
      onTap: _onShopTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: _StoresTheme.spacingLG,
          vertical: _StoresTheme.spacingSM + 4,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _StoresTheme.accent,
              _StoresTheme.accent.withOpacity(0.9),
            ],
          ),
          borderRadius: BorderRadius.circular(_StoresTheme.radiusMD),
          border: Border.all(
            color: Colors.white.withOpacity(0.25),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _StoresTheme.accent.withOpacity(0.5),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.storefront_rounded,
              color: Colors.white,
              size: getFontSize(18),
            ),
            const SizedBox(width: _StoresTheme.spacingSM),
            Text(
              "Shop".tr,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: getFontSize(14),
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Modern solid-style Info badge with high visibility
  Widget _buildInfoBadge() {
    return _AnimatedPressable(
      onTap: _onInfoTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: _StoresTheme.spacingMD,
          vertical: _StoresTheme.spacingSM,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(_StoresTheme.radiusMD),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
            BoxShadow(
              color: _StoresTheme.accent.withOpacity(0.15),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: _StoresTheme.accent.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.info_rounded,
                color: _StoresTheme.accent,
                size: getFontSize(14),
              ),
            ),
            const SizedBox(width: _StoresTheme.spacingXS + 2),
            Text(
              "Info".tr,
              style: TextStyle(
                color: _StoresTheme.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: getFontSize(12),
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onShopTap() {
    controller.saveStoreView(store.value.id);
    globalController.updateStoreRoute(AppRoutes.tabsRoute);
    prefs?.setString("id", store.value.id.toString());
    Get.offAllNamed(AppRoutes.tabsRoute);
  }

  void _onInfoTap() {
    Get.toNamed(
      AppRoutes.soreDetails,
      arguments: {"store": store.value, "tag": tag},
    )?.then((value) {
      controller.refreshStores.value = true;
      store.value.main_image = globalController.storeImage.value;
      store.refresh();
      controller.stores[index].value.main_image = globalController.storeImage.value;
      controller.stores[index].refresh();
      Future.delayed(const Duration(milliseconds: 500)).then((value) {
        controller.refreshStores.value = false;
      });
      controller.fetchStores(false, false, fromInfo: true);
    });
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// 🎯 ANIMATED PRESSABLE - Tap Feedback Widget
// ═══════════════════════════════════════════════════════════════════════════

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
        scale: _isPressed ? 0.96 : 1.0,
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
