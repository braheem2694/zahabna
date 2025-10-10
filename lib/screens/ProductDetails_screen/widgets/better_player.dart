//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:iq_mall/cores/math_utils.dart';
//
// class CustomVideoPlayer extends StatefulWidget {
//   final Color? backGroundColor;
//   final double? videoAspectRatio;
//   final String? videoUrl;
//   final String? imageUrl;
//   final bool isAutoPlay;
//   final bool isMuted;
//   final bool viewMute;
//   final Map<String, String> resolutions;
//
//   const CustomVideoPlayer({
//      Key? key ,
//     this.videoUrl =
//         "https://d2lb7gsppnsll7.cloudfront.net/schooltube/videos/o_1cvaj9lke34s16efdb534tqgllm1b1qutm16k31ktgc1c1pm898p19hdoe719ec19o71cr81f831egc5fs11mc1938gk619imb.mp4",
//     this.backGroundColor = Colors.white,
//     this.videoAspectRatio = 1,
//     this.isAutoPlay = false,
//     this.isMuted = false,
//     this.viewMute = false,
//     this.resolutions = const {"": ""},
//     this.imageUrl = "https://schooltube.online/schooltube/web/img/default.png",
//   }) : super(key: key);
//
//   callMethod() => createState().disposeBetterPlay();
//
//   @override
//   _CustomVideoPlayerState createState() => _CustomVideoPlayerState();
// }
//
// class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
//    late BetterPlayerController _betterPlayerController;
//
//   RxBool isPlaying = false.obs;
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     _betterPlayerController.dispose();
//     super.dispose();
//   }
//
//   disposeBetterPlay() {
//     _betterPlayerController.dispose();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//
//     BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
//         BetterPlayerDataSourceType.network, widget.videoUrl!,
//         notificationConfiguration: BetterPlayerNotificationConfiguration(
//           title: "School Tube",
//           showNotification: false,
//           imageUrl: widget.imageUrl,
//           activityName: "School Tube",
//           notificationChannelName: "school_tube",
//         ),
//         resolutions: widget.resolutions,
//         cacheConfiguration: const BetterPlayerCacheConfiguration(
//           useCache: false,
//           // preCacheSize: 10 * 1024 * 1024,
//           // maxCacheSize: 10 * 1024 * 1024,
//           // maxCacheFileSize: 10 * 1024 * 1024,
//         ));
//
//     _betterPlayerController = BetterPlayerController(
//         BetterPlayerConfiguration(
//             aspectRatio: widget.videoAspectRatio,
//             controlsConfiguration: BetterPlayerControlsConfiguration(
//                 enableRetry: true,
//                 enablePlayPause: true,
//                 enablePlaybackSpeed: false,
//                 enableSkips: false,
//                 enableFullscreen: false,
//                 enableSubtitles: false,
//                 enableProgressBar: true,
//                 enableMute: widget.viewMute,
//                 enableProgressText: false,
//                 enableOverflowMenu: false,
//                 playerTheme: BetterPlayerTheme.cupertino,
//                 customControlsBuilder: (
//                   BetterPlayerController controller,
//                   dynamic Function(bool) showControls,
//                 ) {
//                   return Obx(()=>
//                       AnimatedSwitcher(
//                         duration: const Duration(milliseconds: 300),
//                         child: isPlaying.value
//                             ? IconButton(
//                           iconSize: getSize(20),
//                           key: const ValueKey("pause"),
//                           icon: const Icon(Icons.pause,color: Colors.white,),
//                           onPressed: controller.pause,
//                         )
//                             : IconButton(
//                           iconSize: getSize(25),
//
//                           key: const ValueKey("play"),
//                           icon: const Icon(Icons.play_arrow,color:Colors.white),
//                           onPressed: controller.play,
//                         ),
//                       )
//                   );
//                 },
//                 enableQualities: false                                                             ,
//                 enableAudioTracks: false)),
//         betterPlayerDataSource: betterPlayerDataSource);
//
//     _betterPlayerController.preCache(betterPlayerDataSource);
//     _betterPlayerController.setupDataSource(betterPlayerDataSource);
//
//   if(widget.isAutoPlay){
//     _betterPlayerController.play();
//   }
//
//     if(widget.isMuted){
//       _betterPlayerController.setVolume(0);
//     }
//
//     _betterPlayerController.addEventsListener((event) {
//
//       if (event.betterPlayerEventType ==
//           BetterPlayerEventType.play) {
//         isPlaying.value=true;
//       }
//       if (event.betterPlayerEventType ==
//           BetterPlayerEventType.pause) {
//         isPlaying.value=false;
//       }
//
//       if (event.betterPlayerEventType ==
//           BetterPlayerEventType.changedResolution) {
//         _betterPlayerController.play();
//       } else if (event.betterPlayerEventType ==
//           BetterPlayerEventType.changedResolution) {
//         _betterPlayerController.play();
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//
//       color: widget.backGroundColor,
//       child: AspectRatio(
//           aspectRatio: widget.videoAspectRatio!,
//           child: BetterPlayer(
//
//             controller: _betterPlayerController,
//
//           )),
//     );
//   }
// }
