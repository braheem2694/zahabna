import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iq_mall/models/HomeData.dart';

import '../../../cores/math_utils.dart';
import '../../../main.dart';
import '../../../utils/ShColors.dart';
import '../controller/ProductDetails_screen_controller.dart';

// ═══════════════════════════════════════════════════════════════════════════
// 🎨 DESIGN TOKENS
// ═══════════════════════════════════════════════════════════════════════════

class _DesignTokens {
  // Colors
  static Color get gold => ColorConstant.logoSecondColor;
  static Color get primary => ColorConstant.logoFirstColor;
  static const Color whatsappGreen = Color(0xFF25D366);
  static const Color whatsappDark = Color(0xFF128C7E);
  static const Color success = Color(0xFF10B981);
  static const Color surface = Colors.white;

  // Dimensions
  static const double barHeight = 72.0;
  static const double borderRadius = 28.0;
  static const double buttonRadius = 25.0;
  static const double iconSize = 25.0;
  static const double buttonIconSize = 20.0;

  // Durations
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration entrance = Duration(milliseconds: 600);

  // Shadows
  static List<BoxShadow> get barShadow => [
        BoxShadow(
          color: gold.withOpacity(0.35),
          blurRadius: 24,
          offset: const Offset(0, -10),
          spreadRadius: -6,
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.12),
          blurRadius: 16,
          offset: const Offset(0, -6),
        ),
      ];

  static List<BoxShadow> buttonShadow(bool pressed) => [
        BoxShadow(
          color: primary.withOpacity(pressed ? 0.08 : 0.18),
          blurRadius: pressed ? 4 : 16,
          offset: Offset(0, pressed ? 1 : 6),
        ),
      ];
}

// ═══════════════════════════════════════════════════════════════════════════
// 🚀 MAIN WIDGET
// ═══════════════════════════════════════════════════════════════════════════

class AddToCartButtons extends StatefulWidget {
  final VoidCallback onTap;
  final bool? isText;
  final String? text;
  final Product? product;
  final bool addingToCard;
  final bool animatingAddToCardTick;
  final ProductDetails_screenController productDetailsController;

  const AddToCartButtons({
    super.key,
    required this.onTap,
    this.isText = true,
    this.text = "Continue",
    this.product,
    this.addingToCard = false,
    required this.animatingAddToCardTick,
    required this.productDetailsController,
  });

  @override
  State<AddToCartButtons> createState() => _AddToCartButtonsState();
}

class _AddToCartButtonsState extends State<AddToCartButtons>
    with TickerProviderStateMixin {
  // ─────────────────────────────────────────────────────────────────────────
  // Animation Controllers
  // ─────────────────────────────────────────────────────────────────────────

  late final AnimationController _entranceController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  late final AnimationController _glowController;
  late final Animation<double> _glowAnimation;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    // Entrance: Slide + Fade
    _entranceController = AnimationController(
      vsync: this,
      duration: _DesignTokens.entrance,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
    ));

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _entranceController.forward();

    // Icon pulse
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Button glow
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.6).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _pulseController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Interaction Handlers
  // ─────────────────────────────────────────────────────────────────────────

  void _handleTapDown(TapDownDetails _) {
    HapticFeedback.lightImpact();
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails _) {
    setState(() => _isPressed = false);
    widget.onTap();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: _buildBar(),
        ),
      ),
    );
  }

  Widget _buildBar() {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          key: widget.productDetailsController.startPointKey,
          height: getSize(_DesignTokens.barHeight) + getBottomPadding(),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                _DesignTokens.gold,
                Color.lerp(_DesignTokens.gold, _DesignTokens.primary, 0.08)!,
              ],
            ),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(_DesignTokens.borderRadius),
            ),
            boxShadow: [
              BoxShadow(
                color: _DesignTokens.gold.withOpacity(_glowAnimation.value),
                blurRadius: 28,
                offset: const Offset(0, -12),
                spreadRadius: -8,
              ),
              ..._DesignTokens.barShadow,
            ],
          ),
          child: child,
        );
      },
      child: Stack(
        children: [
          // Background pattern
          _buildBackgroundPattern(),

          // Content
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildBackgroundPattern() {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(_DesignTokens.borderRadius),
        ),
        child: Stack(
          children: [
            // Top-right decorative circle
            Positioned(
              top: -30,
              right: -30,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withOpacity(0.12),
                      Colors.white.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom-left decorative circle
            Positioned(
              bottom: -40,
              left: 20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.06),
                ),
              ),
            ),

            // Subtle line accent
            Positioned(
              top: 0,
              left: 40,
              right: 40,
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0),
                      Colors.white.withOpacity(0.3),
                      Colors.white.withOpacity(0),
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

  Widget _buildContent() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          14,
          16,
          getBottomPadding() > 0 ? 4 : 14,
        ),
        child: Row(
          children: [
            // Store info section
            if (widget.isText ?? true) ...[
              Expanded(
                  child: _StoreInfoSection(
                      controller: widget.productDetailsController)),
              const SizedBox(width: 16),
            ],

            // Action button
            _buildActionButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _isPressed ? 0.94 : 1.0,
        duration: _DesignTokens.fast,
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: _DesignTokens.fast,
          padding: EdgeInsets.symmetric(
            horizontal: getHorizontalSize(5),
            vertical: getVerticalSize(5),
          ),
          // decoration: BoxDecoration(
          //   color: _isPressed
          //       ? _DesignTokens.surface.withOpacity(0.95)
          //       : _DesignTokens.surface,
          //   borderRadius: BorderRadius.circular(_DesignTokens.buttonRadius),
          //   border: Border.all(
          //     color: _DesignTokens.primary.withOpacity(0.06),
          //     width: 1.5,
          //   ),
          //   boxShadow: _DesignTokens.buttonShadow(_isPressed),
          // ),
          child: _buildDynamicIcon(),
        ),
      ),
    );
  }

  Widget _buildDynamicIcon() {
    // Loading state
    if (widget.addingToCard) {
      return _LoadingIcon(gold: _DesignTokens.gold);
    }

    // Success state
    if (widget.animatingAddToCardTick) {
      return const _SuccessIcon();
    }

    // Default WhatsApp icon
    return _WhatsAppIcon(animation: _pulseAnimation);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// 🏪 STORE INFO SECTION
// ═══════════════════════════════════════════════════════════════════════════

class _StoreInfoSection extends StatelessWidget {
  final ProductDetails_screenController controller;

  const _StoreInfoSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    final storeName = controller.product.value?.store.name ??
        prefs?.getString('store_name') ??
        '';

    return Row(
      children: [
        // Store avatar
        _buildStoreAvatar(),

        const SizedBox(width: 14),

        // Store details
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Label
              Text(
                "Store".tr,
                style: TextStyle(
                  fontSize: getFontSize(11),
                  color: Colors.white.withOpacity(0.65),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.8,
                ),
              ),

              const SizedBox(height: 3),

              // Store name
              Text(
                storeName,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: getFontSize(15),
                  color: Colors.white,
                  letterSpacing: 0.1,
                  height: 1.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStoreAvatar() {
    return Container(
      width: getSize(44),
      height: getSize(44),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withOpacity(0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.store_rounded,
          color: Colors.white,
          size: getSize(_DesignTokens.iconSize),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// ⏳ LOADING ICON
// ═══════════════════════════════════════════════════════════════════════════

class _LoadingIcon extends StatelessWidget {
  final Color gold;

  const _LoadingIcon({required this.gold});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getSize(24),
      height: getSize(24),
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        strokeCap: StrokeCap.round,
        valueColor: AlwaysStoppedAnimation(gold),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// ✅ SUCCESS ICON
// ═══════════════════════════════════════════════════════════════════════════

class _SuccessIcon extends StatefulWidget {
  const _SuccessIcon();

  @override
  State<_SuccessIcon> createState() => _SuccessIconState();
}

class _SuccessIconState extends State<_SuccessIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _checkAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();
    HapticFeedback.mediumImpact();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: getSize(26),
            height: getSize(26),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _DesignTokens.success,
                  _DesignTokens.success.withGreen(200),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _DesignTokens.success.withOpacity(0.5),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: CustomPaint(
                size: Size(getSize(14), getSize(14)),
                painter: _CheckmarkPainter(progress: _checkAnimation.value),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CheckmarkPainter extends CustomPainter {
  final double progress;

  _CheckmarkPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(size.width * 0.2, size.height * 0.55);
    path.lineTo(size.width * 0.4, size.height * 0.75);
    path.lineTo(size.width * 0.8, size.height * 0.3);

    final pathMetric = path.computeMetrics().first;
    final extractPath = pathMetric.extractPath(
      0,
      pathMetric.length * progress,
    );

    canvas.drawPath(extractPath, paint);
  }

  @override
  bool shouldRepaint(covariant _CheckmarkPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// 💬 WHATSAPP ICON
// ═══════════════════════════════════════════════════════════════════════════

class _WhatsAppIcon extends StatelessWidget {
  final Animation<double> animation;

  const _WhatsAppIcon({required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final scale = 1.0 + (animation.value * 0.06);
        final glowOpacity = 0.2 + (animation.value * 0.3);

        return Transform.scale(
          scale: scale,
          child: Container(
            width: getSize(45),
            height: getSize(45),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _DesignTokens.whatsappGreen,
                  _DesignTokens.whatsappDark,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: _DesignTokens.whatsappGreen.withOpacity(glowOpacity),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                FontAwesomeIcons.whatsapp,
                color: Colors.white,
                size: getSize(_DesignTokens.buttonIconSize),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// 🎨 TICK PAINTER (LEGACY SUPPORT)
// ═══════════════════════════════════════════════════════════════════════════

class TickPainter extends CustomPainter {
  final double progress;

  TickPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(size.width * 0.25, size.height * 0.6);
    path.lineTo(size.width * 0.45, size.height * 0.8);
    path.lineTo(size.width * 0.75, size.height * 0.4);

    PathMetric pathMetric = path.computeMetrics().first;
    Path extractPath = pathMetric.extractPath(0, pathMetric.length * progress);

    canvas.drawPath(extractPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
