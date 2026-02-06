import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:iq_mall/routes/app_routes.dart';
import 'package:shimmer/shimmer.dart';

import '../../cores/math_utils.dart';
import '../../main.dart';
import '../../models/Stores.dart';
import '../../utils/ShColors.dart';
import '../../utils/ShImages.dart';
import '../../widgets/ui.dart';
import 'controller/Stores_screen_controller.dart';

// Cached HtmlUnescape instance - avoid recreating on each build
final _htmlUnescape = HtmlUnescape();

// ═══════════════════════════════════════════════════════════════════════════
// 🎨 STORES THEME - Premium Gold Design (Cached for Performance)
// ═══════════════════════════════════════════════════════════════════════════

class _StoresTheme {
  // Cached colors - avoid repeated getter calls
  static final Color primary = ColorConstant.logoFirstColor;
  static final Color accent = ColorConstant.logoSecondColor;
  static const Color background = Color(0xFFF8F6F3);
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);

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

  static final LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      accent.withOpacity(0.85),
      accent,
    ],
  );

  // Cached text styles
  static final TextStyle storeNameStyle = TextStyle(
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
          body: _ShimmerLoading(),
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
            _HeaderWidget(controller: controller),

            // City Filter Dropdown
            _CityFilterWidget(controller: controller),

            // Stores Grid
            Expanded(
              child: _StoresGridWidget(controller: controller, tag: tag),
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
      leading: GestureDetector(
        onTap: () => Get.back(),
        behavior: HitTestBehavior.opaque,
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
}

// ═══════════════════════════════════════════════════════════════════════════
// 📍 HEADER WIDGET - Separated for targeted rebuilds
// ═══════════════════════════════════════════════════════════════════════════

class _HeaderWidget extends StatelessWidget {
  final StoreController controller;

  const _HeaderWidget({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (globalController.storeRoute.value != AppRoutes.tabsRoute) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: EdgeInsets.only(
          top: getTopPadding() + _StoresTheme.spacingLG + getSize(45),
          bottom: _StoresTheme.spacingSM,
        ),
        child: Column(
          children: [
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
}

// ═══════════════════════════════════════════════════════════════════════════
// 🔍 CITY FILTER WIDGET - Isolated rebuilds
// ═══════════════════════════════════════════════════════════════════════════

class _CityFilterWidget extends StatelessWidget {
  final StoreController controller;

  const _CityFilterWidget({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _StoresTheme.spacingLG,
        vertical: _StoresTheme.spacingSM,
      ),
      child: Obx(() {
        final isFiltering = controller.isFiltering.value;
        final selectedCity = controller.selectedCity.value;

        return Container(
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
          padding:
              const EdgeInsets.symmetric(horizontal: _StoresTheme.spacingMD),
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedCity,
                    items: _buildDropdownItems(),
                    onChanged: isFiltering
                        ? null
                        : (value) {
                            controller.filterByCity(value);
                          },
                    hint: Text(
                      'Select City'.tr,
                      style: TextStyle(
                        color: _StoresTheme.textSecondary,
                        fontSize: getFontSize(14),
                      ),
                    ),
                    icon: isFiltering
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation(_StoresTheme.accent),
                            ),
                          )
                        : Container(
                            padding:
                                const EdgeInsets.all(_StoresTheme.spacingXS),
                            decoration: BoxDecoration(
                              color: _StoresTheme.accent.withOpacity(0.1),
                              borderRadius:
                                  BorderRadius.circular(_StoresTheme.radiusSM),
                            ),
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: _StoresTheme.accent,
                              size: 20,
                            ),
                          ),
                    isExpanded: true,
                    dropdownColor: Colors.white,
                    elevation: 8,
                    borderRadius: BorderRadius.circular(_StoresTheme.radiusMD),
                  ),
                ),
              ),
              if (selectedCity != null && !isFiltering)
                Padding(
                  padding: const EdgeInsets.only(left: _StoresTheme.spacingSM),
                  child: GestureDetector(
                    onTap: () => controller.filterByCity("Select City"),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: const EdgeInsets.all(_StoresTheme.spacingXS),
                      decoration: BoxDecoration(
                        color: _StoresTheme.textSecondary.withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(_StoresTheme.radiusSM),
                      ),
                      child: const Icon(
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

  List<DropdownMenuItem<String>> _buildDropdownItems() {
    return List.generate(
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
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// 📦 STORES GRID WIDGET - Optimized with RepaintBoundary
// ═══════════════════════════════════════════════════════════════════════════

class _StoresGridWidget extends StatelessWidget {
  final StoreController controller;
  final String tag;

  const _StoresGridWidget({required this.controller, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isFiltering = controller.isFiltering.value;
      final storesList = controller.stores;

      if (storesList.isEmpty && !isFiltering) {
        return const _EmptyState();
      }

      // Compute filtered stores list once
      final List<Rx<StoreClass>> stores;
      if (Get.arguments == null || Get.arguments["tag"] != "side_menu") {
        stores = storesList;
      } else {
        final userId = prefs?.getString("user_id");
        stores = storesList
            .where((element) => element.value.ownerId.toString() == userId)
            .toList();
      }

      // Calculate item count for paired rows
      final int itemCount = (stores.length / 2).ceil();

      return Stack(
        children: [
          RefreshIndicator(
            color: _StoresTheme.accent,
            backgroundColor: Colors.white,
            onRefresh: () => controller.fetchStores(false, true),
            // Use ListView.builder with rows for better performance than GridView
            child: ListView.builder(
              padding: EdgeInsets.only(
                bottom: getBottomPadding() + getSize(55),
                right: _StoresTheme.spacingMD,
                left: _StoresTheme.spacingMD,
                top: _StoresTheme.spacingSM,
              ),
              physics: const AlwaysScrollableScrollPhysics(
                  parent: ClampingScrollPhysics()),
              controller: controller.scrollController,
              cacheExtent: 800, // Increased cache extent
              itemCount: itemCount,
              itemBuilder: (context, rowIndex) {
                final firstIndex = rowIndex * 2;
                final secondIndex = firstIndex + 1;
                final hasSecond = secondIndex < stores.length;

                return Padding(
                  padding:
                      const EdgeInsets.only(bottom: _StoresTheme.spacingMD),
                  child: SizedBox(
                    height: getVerticalSize(260),
                    child: Row(
                      children: [
                        Expanded(
                          child: RepaintBoundary(
                            child: _OptimizedStoreCard(
                              key: ValueKey(stores[firstIndex].value.id),
                              store: stores[firstIndex],
                              index: firstIndex,
                              controller: controller,
                              tag: tag,
                            ),
                          ),
                        ),
                        const SizedBox(width: _StoresTheme.spacingMD),
                        Expanded(
                          child: hasSecond
                              ? RepaintBoundary(
                                  child: _OptimizedStoreCard(
                                    key: ValueKey(stores[secondIndex].value.id),
                                    store: stores[secondIndex],
                                    index: secondIndex,
                                    controller: controller,
                                    tag: tag,
                                  ),
                                )
                              : const SizedBox(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Filtering overlay
          if (isFiltering)
            const Positioned.fill(
              child: IgnorePointer(
                child: _FilteringOverlay(),
              ),
            ),
        ],
      );
    });
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// ⏳ FILTERING OVERLAY - Lightweight indicator
// ═══════════════════════════════════════════════════════════════════════════

class _FilteringOverlay extends StatelessWidget {
  const _FilteringOverlay();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: _StoresTheme.background.withOpacity(0.3),
      child: Center(
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
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// 🚫 EMPTY STATE
// ═══════════════════════════════════════════════════════════════════════════

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
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
}

// ═══════════════════════════════════════════════════════════════════════════
// ✨ SHIMMER LOADING - Lightweight version
// ═══════════════════════════════════════════════════════════════════════════

class _ShimmerLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: getTopPadding() + _StoresTheme.spacingXL * 3,
        left: _StoresTheme.spacingMD,
        right: _StoresTheme.spacingMD,
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
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
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(_StoresTheme.radiusLG),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// 🏪 OPTIMIZED STORE CARD - Performance focused with cached decorations
// ═══════════════════════════════════════════════════════════════════════════

class _OptimizedStoreCard extends StatelessWidget {
  final Rx<StoreClass> store;
  final int index;
  final StoreController controller;
  final String tag;

  // Static cached decorations to avoid recreation
  static final _cardBorderRadius = BorderRadius.circular(_StoresTheme.radiusLG);

  static final _topAccentDecoration = BoxDecoration(
    gradient: _StoresTheme.goldGradient,
    borderRadius: const BorderRadius.vertical(
      top: Radius.circular(_StoresTheme.radiusLG),
    ),
  );

  static final _shopBadgeDecoration = BoxDecoration(
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
  );

  static final _infoBadgeDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(_StoresTheme.radiusMD),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 6,
        offset: const Offset(0, 2),
      ),
    ],
  );

  const _OptimizedStoreCard({
    super.key,
    required this.store,
    required this.index,
    required this.controller,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    // Use cached unescape instance
    final storeName =
        _htmlUnescape.convert(store.value.store_name ?? 'No Name');
    final mainImage = store.value.main_image ?? "";

    return Material(
      color: Colors.transparent,
      borderRadius: _cardBorderRadius,
      elevation: 6,
      shadowColor: Colors.black26,
      child: InkWell(
        onTap: _onShopTap,
        borderRadius: _cardBorderRadius,
        child: ClipRRect(
          borderRadius: _cardBorderRadius,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Optimized background image with memory caching
              _OptimizedNetworkImage(
                imageUrl: mainImage,
                placeholder: AssetPaths.placeholder,
              ),

              // Gradient overlay - simple decoration
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x26000000),
                      Color(0x0D000000),
                      Color(0x59000000),
                      Color(0xD9000000),
                    ],
                    stops: [0.0, 0.25, 0.6, 1.0],
                  ),
                ),
                child: SizedBox.expand(),
              ),

              // Top accent border
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 4,
                child: DecoratedBox(
                  decoration: _topAccentDecoration,
                  child: const SizedBox.expand(),
                ),
              ),

              // Info badge - Top right corner
              Positioned(
                top: _StoresTheme.spacingMD,
                right: _StoresTheme.spacingSM,
                child: _OptimizedInfoBadge(onTap: _onInfoTap),
              ),

              // Store name and Shop button - Bottom area
              Positioned(
                left: _StoresTheme.spacingMD,
                right: _StoresTheme.spacingMD,
                bottom: _StoresTheme.spacingMD,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Store name - simplified text
                    Text(
                      storeName,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: _StoresTheme.storeNameStyle,
                    ),
                    const SizedBox(height: _StoresTheme.spacingMD),
                    // Shop button badge
                    _OptimizedShopBadge(onTap: _onShopTap),
                  ],
                ),
              ),
            ],
          ),
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
      controller.stores[index].value.main_image =
          globalController.storeImage.value;
      controller.stores[index].refresh();
      Future.delayed(const Duration(milliseconds: 500)).then((value) {
        controller.refreshStores.value = false;
      });
      controller.fetchStores(false, false, fromInfo: true);
    });
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// 🖼️ OPTIMIZED NETWORK IMAGE - Lightweight with memory caching
// ═══════════════════════════════════════════════════════════════════════════

class _OptimizedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final String placeholder;

  const _OptimizedNetworkImage({
    required this.imageUrl,
    required this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty || !Ui.isValidUri(imageUrl)) {
      return Image.asset(
        placeholder,
        fit: BoxFit.cover,
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      // Use memory cache limits for better performance
      memCacheWidth: 400,
      memCacheHeight: 500,
      fadeInDuration: const Duration(milliseconds: 150),
      fadeOutDuration: const Duration(milliseconds: 100),
      placeholder: (context, url) => Image.asset(
        placeholder,
        fit: BoxFit.cover,
      ),
      errorWidget: (context, url, error) => Image.asset(
        placeholder,
        fit: BoxFit.cover,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// 🛒 OPTIMIZED SHOP BADGE - Const where possible
// ═══════════════════════════════════════════════════════════════════════════

class _OptimizedShopBadge extends StatelessWidget {
  final VoidCallback onTap;

  const _OptimizedShopBadge({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: DecoratedBox(
        decoration: _OptimizedStoreCard._shopBadgeDecoration,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: _StoresTheme.spacingLG,
            vertical: _StoresTheme.spacingSM + 4,
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
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// ℹ️ OPTIMIZED INFO BADGE - Simplified
// ═══════════════════════════════════════════════════════════════════════════

class _OptimizedInfoBadge extends StatelessWidget {
  final VoidCallback onTap;

  const _OptimizedInfoBadge({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: DecoratedBox(
        decoration: _OptimizedStoreCard._infoBadgeDecoration,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: _StoresTheme.spacingMD,
            vertical: _StoresTheme.spacingSM,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.info_rounded,
                color: _StoresTheme.accent,
                size: getFontSize(14),
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
      ),
    );
  }
}

// Note: Legacy _StoreCard, _ShopBadge, and _InfoBadge classes have been replaced
// with optimized versions above: _OptimizedStoreCard, _OptimizedShopBadge, _OptimizedInfoBadge
