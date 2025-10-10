import 'dart:async';
import 'package:flutter/material.dart';

class ShCarouselSlider extends StatefulWidget {
  ShCarouselSlider({
    this.items,
    this.height,
    this.aspectRatio = 16 / 9,
    this.viewportFraction = 0.8,
    this.initialPage = 0,
    int realPage = 10000,
    this.enableInfiniteScroll = true,
    this.reverse = false,
    this.autoPlay = false,
    this.autoPlayInterval = const Duration(seconds: 4),
    this.autoPlayAnimationDuration = const Duration(milliseconds: 800),
    this.autoPlayCurve = Curves.fastOutSlowIn,
    this.pauseAutoPlayOnTouch,
    this.enlargeCenterPage = false,
    this.onPageChanged,
    this.scrollPhysics,
    this.scrollDirection = Axis.horizontal,
  })  : this.realPage =
  enableInfiniteScroll ? realPage + initialPage : initialPage,
        this.itemCount = items!.length,
        this.itemBuilder = null,
        this.pageController = PageController(
          viewportFraction: viewportFraction.toDouble(),
          initialPage: enableInfiniteScroll ? realPage.toInt() + initialPage.toInt() : initialPage.toInt(),
        );

  ShCarouselSlider.builder({
    required this.itemCount,
    required this.itemBuilder,
    this.height,
    this.aspectRatio = 16 / 9,
    this.viewportFraction = 0.8,
    this.initialPage = 0,
    int realPage = 10000,
    this.enableInfiniteScroll = true,
    this.reverse = false,
    this.autoPlay = false,
    this.autoPlayInterval = const Duration(seconds: 4),
    this.autoPlayAnimationDuration = const Duration(milliseconds: 800),
    this.autoPlayCurve = Curves.fastOutSlowIn,
    required this.pauseAutoPlayOnTouch,
    required this.enlargeCenterPage,
    required this.onPageChanged,
    required this.scrollPhysics,
    this.scrollDirection = Axis.horizontal,
  })  : this.realPage =
  enableInfiniteScroll ? realPage + initialPage : initialPage,
        this.items = null,
        this.pageController = PageController(
          viewportFraction: viewportFraction.toDouble(),
          initialPage: enableInfiniteScroll ? realPage.toInt() + initialPage.toInt() : initialPage.toInt(),
        );

  final List<Widget?>? items;
  final IndexedWidgetBuilder? itemBuilder;

  final int itemCount;
  final double? height;
  final double aspectRatio;
  final num viewportFraction;
  final num initialPage;
  final num realPage;
  final bool enableInfiniteScroll;
  final bool reverse;
  final bool autoPlay;
  final Duration autoPlayInterval;
  final Duration autoPlayAnimationDuration;
  final Curve autoPlayCurve;
  final Duration? pauseAutoPlayOnTouch;
  final bool enlargeCenterPage;
  final Axis scrollDirection;
  final void Function(int index)? onPageChanged;
  final ScrollPhysics? scrollPhysics;
  final PageController pageController;

  nextPage({Duration? duration, Curve? curve}) {
    return pageController.nextPage(duration: duration!, curve: curve!);
  }

  previousPage({Duration? duration, Curve? curve}) {
    return pageController.previousPage(duration: duration!, curve: curve!);
  }

  void jumpToPage(int page) {
    final index = _getRealIndex(
        pageController.page!.toInt(), realPage.toInt() - initialPage.toInt(), itemCount);
    return pageController.jumpToPage(pageController.page!.toInt() + page - index);
  }

  animateToPage(int page, {Duration? duration, Curve? curve}) {
    final index = _getRealIndex(
        pageController.page!.toInt(), realPage.toInt() - initialPage.toInt(), itemCount);
    return pageController.animateToPage(
      pageController.page!.toInt() + page - index,
      duration: duration!,
      curve: curve!,
    );
  }

  @override
  _ShCarouselSliderState createState() => _ShCarouselSliderState();
}

class _ShCarouselSliderState extends State<ShCarouselSlider> with TickerProviderStateMixin {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = getTimer();
  }

  Timer getTimer() {
    return widget.autoPlay
        ? Timer.periodic(widget.autoPlayInterval, (_) {
      widget.pageController.nextPage(
        duration: widget.autoPlayAnimationDuration,
        curve: widget.autoPlayCurve,
      );
    })
        : Timer(Duration.zero, () {});
  }

  void pauseOnTouch() {
    timer?.cancel();
    timer = Timer(widget.pauseAutoPlayOnTouch!, () {
      timer = getTimer();
    });
  }

  Widget getWrapper(Widget child) {
    if (widget.height != null) {
      final wrapper = Container(height: widget.height, child: child);
      return widget.autoPlay && widget.pauseAutoPlayOnTouch != null
          ? addGestureDetection(wrapper)
          : wrapper;
    } else {
      final wrapper = AspectRatio(aspectRatio: widget.aspectRatio!, child: child);
      return widget.autoPlay && widget.pauseAutoPlayOnTouch != null
          ? addGestureDetection(wrapper)
          : wrapper;
    }
  }

  Widget addGestureDetection(Widget child) =>
      GestureDetector(onPanDown: (_) => pauseOnTouch(), child: child);

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return getWrapper(PageView.builder(
      physics: widget.scrollPhysics,
      scrollDirection: widget.scrollDirection,
      controller: widget.pageController,
      reverse: widget.reverse,
      itemCount: widget.enableInfiniteScroll ? null : widget.itemCount,
      onPageChanged: (int index) {
        int currentPage = _getRealIndex(
          index + widget.initialPage.toInt(),
          widget.realPage.toInt(),
          widget.itemCount,
        );
        if (widget.onPageChanged != null) {
          widget.onPageChanged!(currentPage);
        }
      },
      itemBuilder: (BuildContext context, int i) {
        final int index = _getRealIndex(
          i + widget.initialPage.toInt(),
          widget.realPage.toInt(),
          widget.itemCount,
        );

        return AnimatedBuilder(
          animation: widget.pageController,
          child: (widget.items != null)
              ? widget.items![index]
              : widget.itemBuilder!(context, index),
          builder: (BuildContext context, child) {
            if (widget.scrollDirection == Axis.horizontal) {
              return Center(
                child: SizedBox(
                  height: 2.0 * MediaQuery.of(context).size.width * (1 / widget.aspectRatio!),
                  child: child,
                ),
              );
            } else {
              return Center(
                child: SizedBox(
                  width: 2.0 * MediaQuery.of(context).size.width,
                  child: child,
                ),
              );
            }
          },
        );
      },
    ));
  }
}

int _getRealIndex(int position, int base, int length) {
  final offset = position - base;
  return _remainder(offset, length);
}

int _remainder(int input, int source) {
  if (source == 0) return 0;
  final result = input % source;
  return result < 0 ? source + result : result;
}
