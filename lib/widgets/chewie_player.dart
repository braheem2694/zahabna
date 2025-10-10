import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/widgets/custom_image_view.dart';
import 'package:iq_mall/widgets/ui.dart';
import 'package:iq_mall/widgets/video_material_control.dart' as materialVideo;
import 'package:video_player/video_player.dart';

import '../main.dart';
import '../utils/ShColors.dart';


import 'video_cupertino_control.dart' as cupertinoVideo;

class ChewieVideoPlayer extends StatefulWidget {
  final Map<String, String> videoQualities;
  final String initialQuality;
  final bool autoPlay;
  final bool looping;
  final bool showOptions;
  final bool isGeneral;
  final bool isMuted;
  final bool allowMute;
  final bool allowFullScreen;
  final String videoThumb;

  ChewieVideoPlayer({
    required this.videoQualities,
    required this.initialQuality,
    this.autoPlay = true,
    this.looping = true,
    this.isGeneral = true,
    this.showOptions = false,
    this.allowMute = true,
    this.allowFullScreen = true,
    this.videoThumb = "",
    Key? key,
    required this.isMuted, // Add a key parameter
  }) : super(key: key);

  @override
  _ChewieVideoPlayerState createState() => _ChewieVideoPlayerState();
}

class _ChewieVideoPlayerState extends State<ChewieVideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  RxBool loading = true.obs;
  RxDouble aspectRatio = 0.0.obs;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.initialQuality);
    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: widget.autoPlay,
        allowFullScreen: widget.allowFullScreen,

        looping: widget.looping,
        showOptions: widget.showOptions,
        allowMuting: true,
        customControls: Platform.isIOS
            ? cupertinoVideo.CupertinoControls(
                videoQualities: widget.videoQualities,
                isGeneral: widget.isGeneral,
                backgroundColor: const Color.fromRGBO(41, 41, 41, 0.7),
                iconColor: const Color.fromARGB(255, 200, 200, 200),
              )
            : materialVideo.MaterialControls(
                videoQualities: widget.videoQualities,
                isGeneral: widget.isGeneral,
                isMuted: widget.isMuted,
              ));
    _videoPlayerController.addListener(_videoStatusListener);

    loading.value = false;
  }

  void _videoStatusListener() {
    final status = _videoPlayerController.value;
    // Perform actions based on the video status, e.g., status.isPlaying, status.isBuffering, etc.
    if (status.isInitialized) {
      aspectRatio.value = _videoPlayerController.value.aspectRatio;
    }
    if (status.isPlaying && !globalController.playGeneralVideo.value) {
      _chewieController.pause();
    }
    if (status.isPlaying && globalController.playGeneralVideo.value) {
      _chewieController.play();
    }
  }

  List<dynamic> getControllers() {
    return [_videoPlayerController, _chewieController];
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    _videoPlayerController.removeListener(_videoStatusListener);
    super.dispose();
  }

  void _changeVideoQuality(String quality) {
    setState(() {
      _videoPlayerController = VideoPlayerController.network(widget.videoQualities[quality]!);
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: widget.autoPlay,
        looping: widget.looping,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => loading.value || aspectRatio.value == 0.0
        ? Stack(
      alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CustomImageView(
                  image: widget.videoThumb,
                  // svgPath:  ImageConstant.imgGroup190x237,
                  fit: BoxFit.cover,

                  height: Get.height,
                  width: Get.width,
                ),
            ),
            if(!widget.isGeneral)
            Ui.circularIndicator(color: ColorConstant.logoSecondColor)

          ],
        )
        : AspectRatio(
            aspectRatio: aspectRatio.value,
            child: Chewie(
              controller: _chewieController,
            )));
  }
}
