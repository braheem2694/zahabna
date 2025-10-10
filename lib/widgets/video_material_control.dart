import 'dart:async';

import 'package:chewie/src/center_play_button.dart';
import 'package:chewie/src/chewie_player.dart';
import 'package:chewie/src/chewie_progress_colors.dart';
import 'package:chewie/src/helpers/utils.dart';
import 'package:chewie/src/material/material_progress_bar.dart';
import 'package:chewie/src/material/widgets/options_dialog.dart';
import 'package:chewie/src/material/widgets/playback_speed_dialog.dart';
import 'package:chewie/src/models/option_item.dart';
import 'package:chewie/src/models/subtitle_model.dart';
import 'package:chewie/src/notifiers/index.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:iq_mall/widgets/ui.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../cores/math_utils.dart';
import '../main.dart';
import '../routes/app_routes.dart';
import '../utils/ShColors.dart';
import 'package:chewie/src/animated_play_pause.dart';

class MaterialControls extends StatefulWidget {
  final Map<String, String> videoQualities;
  final bool isGeneral;
  final bool fromTemp;
  final bool isMuted;

  const MaterialControls({
    this.showPlayButton = true,
    this.isGeneral = true,
    this.fromTemp = false,
    this.isMuted = false,
    Key? key,
    required this.videoQualities,
  }) : super(key: key);

  final bool showPlayButton;

  @override
  State<StatefulWidget> createState() {
    return _MaterialControlsState();
  }
}

class _MaterialControlsState extends State<MaterialControls> with SingleTickerProviderStateMixin {
  late PlayerNotifier notifier;
  late VideoPlayerValue _latestValue;
  late VideoPlayerValue _qualityValue;
  double? _latestVolume;
  Timer? _hideTimer;
  Timer? _initTimer;
  late var _subtitlesPosition = Duration.zero;
  bool _subtitleOn = false;
  Timer? _showAfterExpandCollapseTimer;
  bool _dragging = false;
  bool _displayTapped = false;
  Timer? _bufferingDisplayTimer;
  bool _displayBufferingIndicator = false;

  final barHeight = 30.0 * 1.5;
  final marginSize = 5.0;

  late Rx<VideoPlayerController> controller;
  ChewieController? _chewieController;

  // We know that _chewieController is set in didChangeDependencies
  ChewieController get chewieController => _chewieController!;

  RxString selectedQuality = "".obs;

  @override
  void initState() {
    super.initState();
    notifier = Provider.of<PlayerNotifier>(context, listen: false);
    if (widget.videoQualities.isNotEmpty) {
      String firstKey = widget.videoQualities.keys.toList()[0];
      String? firstValue = widget.videoQualities[firstKey];
      selectedQuality.value = firstKey; // set your string value equal to the first key of the map
    }
    if (widget.isMuted) {
      Future.delayed(const Duration(milliseconds: 5)).then((value) {
        if (widget.isGeneral) {
          _latestVolume = controller.value.value.volume;
          controller.value.setVolume(0.0);
        }
      });
    }
  }

  Widget buildProgressSlider() {
    final position = controller.value.value.position;
    final duration = controller.value.value.duration;

    return Slider(
      value: position.inMilliseconds.toDouble() <= duration.inMilliseconds.toDouble() ? position.inMilliseconds.toDouble() : 0.0,
      activeColor: ColorConstant.redA700,
      inactiveColor: ColorConstant.white,
      secondaryActiveColor: ColorConstant.redA700,
      thumbColor: ColorConstant.redA700,
      onChanged: (double newValue) {
        controller.value.seekTo(Duration(milliseconds: newValue.toInt()));
        try {
          globalController.currentPosition.value = Duration(milliseconds: newValue.toInt());
        } catch (e) {
          print(e);
        }
      },
      min: 0.0,
      max: duration.inMilliseconds.toDouble(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_latestValue.hasError) {
      return chewieController.errorBuilder?.call(
            context,
            chewieController.videoPlayerController.value.errorDescription!,
          ) ??
          const Center(
            child: Icon(
              Icons.error,
              color: Colors.white,
              size: 42,
            ),
          );
    }

    return MouseRegion(
      onHover: (_) {
        _cancelAndRestartTimer();
      },
      child: GestureDetector(
        onTap: () => _cancelAndRestartTimer(),
        child: AbsorbPointer(
          absorbing: notifier.hideStuff,
          child: Stack(
            children: [
              if (_displayBufferingIndicator)
                const Center(
                  child: CircularProgressIndicator(),
                )
              else
                _buildHitArea(),
              if (!widget.isGeneral) _buildActionBar(),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  if (_subtitleOn)
                    Transform.translate(
                      offset: Offset(
                        0.0,
                        notifier.hideStuff ? barHeight * 0.8 : 0.0,
                      ),
                      child: _buildSubtitles(context, chewieController.subtitle!),
                    ),
                  _buildBottomBar(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  void _dispose() {
    controller.value.removeListener(_updateState);
    _hideTimer?.cancel();
    _initTimer?.cancel();
    _showAfterExpandCollapseTimer?.cancel();
  }

  @override
  void didChangeDependencies() {
    final oldController = _chewieController;
    _chewieController = ChewieController.of(context);
    controller = chewieController.videoPlayerController.obs;

    if (oldController != chewieController) {
      _dispose();
      _initialize();
    }

    super.didChangeDependencies();
  }

  void _updateVideoQuality(String quality) {
    // save current position of video player
    Duration currentPosition = controller.value.value.position;

    // pause video player
    controller.value.pause();

    // update video player controller with new URL
    controller.value = VideoPlayerController.network(widget.videoQualities[quality] ?? "720");

    // seek to the saved position
    _chewieController?.seekTo(currentPosition);

    // update chewie controller with new video player controller
    _chewieController = ChewieController(
      videoPlayerController: controller.value,
      autoPlay: true,
      looping: true,
    );

    // update current quality
    selectedQuality.value = quality;
  }

  Widget _buildActionBar() {
    return Positioned(
      top: 0,
      right: 0,
      child: SafeArea(
        child: AnimatedOpacity(
          opacity: notifier.hideStuff ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 250),
          child: Row(
            children: [
              _buildSubtitleToggle(),
              if (chewieController.showOptions) _buildOptionsButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionsButton() {
    final options = <OptionItem>[
      // OptionItem(
      //   onTap: () async {
      //     // Navigator.pop(context);
      //     _onSpeedButtonTap();
      //   },
      //   iconData: Icons.speed,
      //   title: chewieController.optionsTranslation?.playbackSpeedButtonText ?? 'Playback speed'.tr,
      // ),
    ];

    if (chewieController.additionalOptions != null && chewieController.additionalOptions!(context).isNotEmpty) {
      options.addAll(chewieController.additionalOptions!(context));
    }

    return AnimatedOpacity(
      opacity: notifier.hideStuff ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 250),
      child: IconButton(
        onPressed: () async {
          _hideTimer?.cancel();

          if (chewieController.optionsBuilder != null) {
            await chewieController.optionsBuilder!(context, options);
          } else {}

          if (_latestValue.isPlaying) {
            _startHideTimer();
          }
        },
        icon: Container(
          decoration: const BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
          child: const Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSubtitles(BuildContext context, Subtitles subtitles) {
    if (!_subtitleOn) {
      return const SizedBox();
    }
    final currentSubtitle = subtitles.getByPosition(_subtitlesPosition);
    if (currentSubtitle.isEmpty) {
      return const SizedBox();
    }

    if (chewieController.subtitleBuilder != null) {
      return chewieController.subtitleBuilder!(
        context,
        currentSubtitle.first!.text,
      );
    }

    return Padding(
      padding: EdgeInsets.all(marginSize),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: const Color(0x96000000),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          currentSubtitle.first!.text.toString(),
          style: const TextStyle(
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  AnimatedOpacity _buildBottomBar(
    BuildContext context,
  ) {
    final iconColor = Theme.of(context).textTheme.labelLarge!.color;

    return AnimatedOpacity(
      opacity: notifier.hideStuff ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        height: barHeight + (chewieController.isFullScreen ? 10.0 : 0),
        color: Colors.black26,
        padding: EdgeInsets.only(
          left: 3,
          top: 3,

        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPosition(iconColor),
            if (chewieController.allowMuting) _buildMuteButton(controller.value),
            if (chewieController.allowFullScreen && !widget.isGeneral) _buildExpandButton(),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(right: 10),
                  child: _buildProgressBar(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  GestureDetector _buildMuteButton(
    VideoPlayerController controller,
  ) {
    return GestureDetector(
      onTap: () {
        _cancelAndRestartTimer();

        if (_latestValue.volume == 0) {
          controller.setVolume(_latestVolume ?? 0.5);
        } else {
          _latestVolume = controller.value.volume;
          controller.setVolume(0.0);
        }
      },
      child: AnimatedOpacity(
        opacity: notifier.hideStuff ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: ClipRect(
          child: Container(
            height: barHeight,
            padding: const EdgeInsets.only(
              left: 6.0,
            ),
            child: Icon(
              _latestValue.volume > 0 ? Icons.volume_up : Icons.volume_off,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector _buildExpandButton() {
    return GestureDetector(
      onTap: _onExpandCollapse,
      child: AnimatedOpacity(
        opacity: notifier.hideStuff ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          height: barHeight + (chewieController.isFullScreen ? 15.0 : 0),
          margin: const EdgeInsets.only(right: 12.0),
          padding: const EdgeInsets.only(
            left: 8.0,
            right: 2.0,
          ),
          child: Center(
            child: Icon(
              chewieController.isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHitArea() {
    final bool isFinished = _latestValue.position >= _latestValue.duration;
    final bool showPlayButton = widget.showPlayButton && !_dragging && !notifier.hideStuff;

    return GestureDetector(
      onTap: () {
        if (!globalController.updateVideoIndicator.value) {
          if (_latestValue.isPlaying) {
            if (_displayTapped) {
              setState(() {
                notifier.hideStuff = true;
              });
            } else {
              _cancelAndRestartTimer();
            }
          } else {
            _playPause();

            setState(() {
              notifier.hideStuff = true;
            });
          }
        }
      },
      child: Obx(
        () => globalController.updateVideoIndicator.value || widget.fromTemp
            ? Ui.circularIndicator(color: ColorConstant.logoFirstColor, width: getSize(32), height: getSize(32))
            : CenterPlayButton(
                backgroundColor: Colors.black54,
                iconColor: Colors.white,
                isFinished: isFinished,
                isPlaying: controller.value.value.isPlaying,
                show: showPlayButton,
                onPressed: _playPause,
              ),
      ),
    );
  }

  // Future<void> _onSpeedButtonTap() async {
  //   _hideTimer?.cancel();
  //
  //   final chosenSpeed = await showModalBottomSheet<double>(
  //     context: context,
  //     isScrollControlled: true,
  //     useRootNavigator: chewieController.useRootNavigator,
  //     builder: (context) => speed.PlaybackSpeedDialog(
  //       speeds: chewieController.playbackSpeeds,
  //       selected: _latestValue.playbackSpeed,
  //     ),
  //   );
  //
  //   if (chosenSpeed != null) {
  //     controller.value.setPlaybackSpeed(chosenSpeed);
  //   }
  //
  //   if (_latestValue.isPlaying) {
  //     _startHideTimer();
  //   }
  // }

  // Future<void> _onQualityButtonTap() async {
  //   _hideTimer?.cancel();
  //
  //   final chosenSpeed = await showModalBottomSheet<double>(
  //     context: context,
  //     isScrollControlled: true,
  //     useRootNavigator: chewieController.useRootNavigator,
  //     builder: (context) => speed.PlaybackSpeedDialog(
  //       speeds: widget.videoQualities.keys
  //           .map((key) => double.tryParse(key.replaceAll(RegExp(r'\D'), '')))
  //           .where((quality) => quality != null)
  //           .cast<double>()
  //           .toList(),
  //       selected: 360,
  //     ),
  //   );
  //
  //   if (chosenSpeed != null) {
  //     controller.value.setPlaybackSpeed(chosenSpeed);
  //   }
  //
  //   if (_latestValue.isPlaying) {
  //     _startHideTimer();
  //   }
  // }

  Widget _buildPosition(Color? iconColor) {
    final position = _latestValue.position;
    final duration = _latestValue.duration;

    return RichText(
      text: TextSpan(
        text: '${formatDuration(position)} ',
        children: <InlineSpan>[
          TextSpan(
            text: '/ ${formatDuration(duration)}',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.white.withOpacity(.75),
              fontWeight: FontWeight.normal,
            ),
          )
        ],
        style: const TextStyle(
          fontSize: 14.0,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSubtitleToggle() {
    //if don't have subtitle hiden button
    if (chewieController.subtitle?.isEmpty ?? true) {
      return const SizedBox();
    }
    return GestureDetector(
      onTap: _onSubtitleTap,
      child: Container(
        height: barHeight,
        color: Colors.transparent,
        padding: const EdgeInsets.only(
          left: 12.0,
          right: 12.0,
        ),
        child: Icon(
          _subtitleOn ? Icons.closed_caption : Icons.closed_caption_off_outlined,
          color: _subtitleOn ? Colors.white : Colors.grey[700],
        ),
      ),
    );
  }

  void _onSubtitleTap() {
    setState(() {
      _subtitleOn = !_subtitleOn;
    });
  }

  void _cancelAndRestartTimer() {
    _hideTimer?.cancel();
    _startHideTimer();

    setState(() {
      notifier.hideStuff = false;
      _displayTapped = true;
    });
  }

  Future<void> _initialize() async {
    _subtitleOn = chewieController.subtitle?.isNotEmpty ?? false;
    controller.value.addListener(_updateState);

    _updateState();

    if (controller.value.value.isPlaying || chewieController.autoPlay) {
      _startHideTimer();
    }

    if (chewieController.showControlsOnInitialize) {
      _initTimer = Timer(const Duration(milliseconds: 200), () {
        setState(() {
          notifier.hideStuff = false;
        });
      });
    }
  }

  void _onExpandCollapse() {
    setState(() {
      notifier.hideStuff = true;

      if (chewieController.isFullScreen) {
        // Get.until((route) => route.settings.name == AppRoutes.introductionVideoAllGradesScreen);
        // globalController.updateReturnFullScreen(true);
        // globalController.updateReturnFullScreen(false);
      } else {
        chewieController.toggleFullScreen();
        // globalController.updateReturnFullScreen(false);
      }

      _showAfterExpandCollapseTimer = Timer(const Duration(milliseconds: 300), () {
        setState(() {
          _cancelAndRestartTimer();
        });
      });
    });
  }

  void _playPause() {
    final isFinished = _latestValue.position >= _latestValue.duration;

    setState(() {
      if (controller.value.value.isPlaying) {
        notifier.hideStuff = false;
        _hideTimer?.cancel();
        controller.value.pause();
      } else {
        _cancelAndRestartTimer();

        if (!controller.value.value.isInitialized) {
          controller.value.initialize().then((_) {
            controller.value.play();
          });
        } else {
          if (isFinished) {
            controller.value.seekTo(Duration.zero);
          }
          controller.value.play();
        }
      }
    });
  }

  void _startHideTimer() {
    final hideControlsTimer = chewieController.hideControlsTimer.isNegative ? ChewieController.defaultHideControlsTimer : chewieController.hideControlsTimer;
    _hideTimer = Timer(hideControlsTimer, () {
      setState(() {
        notifier.hideStuff = true;
      });
    });
  }

  void _bufferingTimerTimeout() {
    _displayBufferingIndicator = true;
    if (mounted) {
      setState(() {});
    }
  }

  void _updateState() {
    if (!mounted) return;

    // display the progress bar indicator only after the buffering delay if it has been set
    if (chewieController.progressIndicatorDelay != null) {
      if (controller.value.value.isBuffering) {
        _bufferingDisplayTimer ??= Timer(
          chewieController.progressIndicatorDelay!,
          _bufferingTimerTimeout,
        );
      } else {
        _bufferingDisplayTimer?.cancel();
        _bufferingDisplayTimer = null;
        _displayBufferingIndicator = false;
      }
    } else {
      _displayBufferingIndicator = controller.value.value.isBuffering;
    }

    setState(() {
      _latestValue = controller.value.value;
      _subtitlesPosition = controller.value.value.position;
    });
  }

  Widget _buildProgressBar() {

    return
      buildProgressSlider();

    //   Row(
    //   children: [
    //     GestureDetector(
    //       onTap: _playPause,
    //       child: Container(
    //         height: barHeight,
    //         color: Colors.transparent,
    //         padding: const EdgeInsets.only(
    //           left: 6.0,
    //           right: 6.0,
    //         ),
    //         child: AnimatedPlayPause(
    //           color: Colors.white,
    //           size: getSize(25),
    //           playing: controller.value.value.isPlaying,
    //         ),
    //       ),
    //     ),
    //     buildProgressSlider(),
    //   ],
    // );
  }
}
