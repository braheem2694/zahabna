import 'dart:async';
import 'package:flutter/material.dart';
import 'package:iq_mall/cores/math_utils.dart';
import 'package:shimmer/shimmer.dart';

class GoldPriceData {
  final double price;
  final double change;
  final double silverPrice;
  final double silverChange;

  GoldPriceData({
    required this.price,
    required this.change,
    required this.silverPrice,
    required this.silverChange,
  });
}

class MiniGoldPriceCard extends StatefulWidget {
  final Future<GoldPriceData> Function() fetchPrice;
  final Duration refreshEvery;
  final String title;
  final String silverTitle;

  const MiniGoldPriceCard({
    super.key,
    required this.fetchPrice,
    this.refreshEvery = const Duration(minutes: 2),
    this.title = 'Gold (XAU/USD)',
    this.silverTitle = 'Silver (XAG/USD)',
  });

  @override
  State<MiniGoldPriceCard> createState() => _MiniGoldPriceCardState();
}

class _MiniGoldPriceCardState extends State<MiniGoldPriceCard>
    with TickerProviderStateMixin {
  Timer? _timer;
  double? _price;
  double _change = 0.0;
  double? _silverPrice;
  double _silverChange = 0.0;
  final List<double> _history = [];
  bool _loading = true;
  bool _error = false;
  late final AnimationController _refreshController =
      AnimationController(vsync: this, duration: const Duration(seconds: 1));

  late final AnimationController _anim = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 120),
    lowerBound: 0.97,
    upperBound: 1.0,
    value: 1.0,
  );

  @override
  void initState() {
    super.initState();
    _fetch();
    _timer = Timer.periodic(widget.refreshEvery, (_) => _fetch());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _anim.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _fetch() async {
    try {
      if (!_loading) {
        _refreshController.repeat();
      }
      final data = await widget.fetchPrice();
      if (mounted) {
        setState(() {
          _price = data.price;
          _change = data.change;
          _silverPrice = data.silverPrice;
          _silverChange = data.silverChange;
          _history.add(data.price);
          if (_history.length > 20) _history.removeAt(0);
          _loading = false;
          _error = false;
        });
      }
      _refreshController.stop();
      _refreshController.reset();
    } catch (_) {
      if (mounted) setState(() => _error = true);
      _refreshController.stop();
      _refreshController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _anim,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: _loading
            ? Center(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildShimmerRow(),
                      const SizedBox(height: 8),
                      _buildShimmerRow(),
                    ],
                  ),
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTickerRow(
                    title: widget.title,
                    price: _price,
                    change: _change,
                    icon: Icons.military_tech_rounded,
                    iconColor: Colors.amber,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Divider(height: 1, thickness: 1),
                  ),
                  _buildTickerRow(
                    title: widget.silverTitle,
                    price: _silverPrice,
                    change: _silverChange,
                    icon: Icons.military_tech_rounded,
                    iconColor: Colors.blueGrey,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildShimmerRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: 100,
          height: 16,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Container(
          width: 70,
          height: 16,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Container(
          width: 30,
          height: 16,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }

  Widget _buildTickerRow({
    required String title,
    required double? price,
    required double change,
    required IconData icon,
    required Color iconColor,
  }) {
    final up = change >= 0;
    final color = change == 0
        ? Colors.grey
        : up
            ? Colors.green
            : Colors.red;

    final prevPrice = (price != null) ? price - change : 0.0;
    final pct = (prevPrice != 0) ? (change / prevPrice) * 100 : 0.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Title and Icon
        Expanded(
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        // Price + Variation
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Text(
                price?.toStringAsFixed(2) ?? '-',
                key: ValueKey(price),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(width: 8),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: SlideTransition(
                  position: Tween<Offset>(
                          begin: const Offset(0, 0.3), end: Offset.zero)
                      .animate(anim),
                  child: child,
                ),
              ),
              child: (price != null)
                  ? Row(
                      key: ValueKey(up),
                      children: [
                        Icon(
                          up ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                          color: color,
                          size: 18,
                        ),
                        Text(
                          '${change >= 0 ? '+' : ''}${change.toStringAsFixed(2)} (${pct >= 0 ? '+' : ''}${pct.toStringAsFixed(2)}%)',
                          style: TextStyle(
                            fontSize: 11,
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(width: 4),
            RotationTransition(
              turns: _refreshController,
              child: IconButton(
                onPressed: _loading ? null : _fetch,
                icon: Icon(
                  Icons.refresh_rounded,
                  size: getSize(20),
                  color: _loading ? Colors.grey : Colors.black87,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                visualDensity: VisualDensity.compact,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
