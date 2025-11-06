import 'dart:async';
import 'package:flutter/material.dart';
import 'package:iq_mall/cores/math_utils.dart';
import 'package:shimmer/shimmer.dart';

class MiniGoldPriceCard extends StatefulWidget {
  final Future<double> Function() fetchPrice;
  final Duration refreshEvery;
  final String title;

  const MiniGoldPriceCard({
    super.key,
    required this.fetchPrice,
    this.refreshEvery = const Duration(minutes: 2),
    this.title = 'Gold (XAU/USD)',
  });

  @override
  State<MiniGoldPriceCard> createState() => _MiniGoldPriceCardState();
}

class _MiniGoldPriceCardState extends State<MiniGoldPriceCard> with TickerProviderStateMixin {
  Timer? _timer;
  double? _price, _prevPrice;
  final List<double> _history = [];
  bool _loading = true;
  bool _error = false;
  late final AnimationController _refreshController = AnimationController(vsync: this, duration: const Duration(seconds: 1));

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
    super.dispose();
  }

  Future<void> _fetch() async {
    try {
      _refreshController.repeat();
      await _anim.reverse();
      await _anim.forward();
      final p = await widget.fetchPrice();
      setState(() {
        _prevPrice = _price;
        _price = p;
        _history.add(p);
        if (_history.length > 20) _history.removeAt(0);
        _loading = false;
        _error = false;
      });
      _refreshController.stop(); // ✅ stop rotation
    } catch (_) {
      setState(() => _error = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final up = _price != null && _prevPrice != null ? _price! >= _prevPrice! : null;
    final color = up == null
        ? Colors.grey
        : up
            ? Colors.green
            : Colors.red;
    final diff = (_price != null && _prevPrice != null) ? _price! - _prevPrice! : 0.0;
    final pct = (_price != null && _prevPrice != null && _prevPrice != 0) ? (diff / _prevPrice!) * 100 : 0.0;

    return ScaleTransition(
      scale: _anim,
      child: Container(
        height: getVerticalSize(72),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: _loading
            ? Center(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Row(
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
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title and Icon
                  Row(
                    children: [
                      const Icon(Icons.military_tech_rounded, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  // Price + Variation
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: Text(
                          _price?.toStringAsFixed(2) ?? '-',
                          key: ValueKey(_price),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        transitionBuilder: (child, anim) => FadeTransition(
                          opacity: anim,
                          child: SlideTransition(
                            position: Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(anim),
                            child: child,
                          ),
                        ),
                        child: (_prevPrice != null && _price != null)
                            ? Row(
                                key: ValueKey(up),
                                children: [
                                  Icon(
                                    up! ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                    color: color,
                                    size: 18,
                                  ),
                                  Text(
                                    '${diff >= 0 ? '+' : ''}${diff.toStringAsFixed(2)} (${pct >= 0 ? '+' : ''}${pct.toStringAsFixed(2)}%)',
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
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
