import 'dart:async';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:iq_mall/widgets/ui.dart';

import '../Product_widget/Product_widget.dart';
import '../cores/math_utils.dart';
import '../utils/ShColors.dart';
import 'chewie_player.dart';

Widget mediaVideoWidget(imageUrl, String asset,
    {double width = 0,
    double height = 0,
    bool isVideo = false,
    bool isAutoPlay = false,
    bool isConverted = false,
    bool isMuted = false,
    bool isTextOnImage = false,
    BoxFit fit = BoxFit.cover,
    bool isForm = false,
    String imgTitle = "",
    String imgBody = "",
    String formImage = "",
    String formName = "",
    String formUserName = "",
    String formFeedBack = '',
    String videoThumb = '',
    videoUrl =
        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
    imageVideoUrl =
        "https://www.google.com/url?sa=i&url=https%3A%2F%2Femqube.com%2Fblog%2Fvideo-marketing-a-new-normal%2F&psig=AOvVaw0YJ_jZSLY0B-7hQtY6kyap&ust=1670758396179000&source=images&cd=vfe&ved=0CBEQjRxqFwoTCMigvpf67vsCFQAAAAAdAAAAABAE",
    resolution = const {"": ""}}) {
  String videoName = videoUrl.split("/").last;
  List videoFinalUrlList = videoUrl.split("/");
  String finalVideoUrl = "";
  videoFinalUrlList.removeLast();
  for (var element in videoFinalUrlList) {
    if (finalVideoUrl == "") {
      finalVideoUrl += element;
    } else {
      finalVideoUrl += "/$element";
    }
  }
  Future<Uint8List> _getBytesFromCachedImage(
      CachedNetworkImageProvider imageProvider) async {
    final imageStream = imageProvider.resolve(ImageConfiguration());
    final Completer<Uint8List> completer = Completer();
    ImageStreamListener listener;

    listener = ImageStreamListener((ImageInfo image, bool synchronousCall) {
      if (!completer.isCompleted) {
        image.image.toByteData().then((ByteData? byteData) {
          if (byteData != null) {
            completer.complete(byteData.buffer.asUint8List());
          } else {
            completer.completeError(Exception("ByteData is null"));
          }
        });
      }
    }, onError: (Object exception, StackTrace? stackTrace) {
      if (!completer.isCompleted) {
        completer.completeError(exception, stackTrace);
      }
    });

    imageStream.addListener(listener);
    completer.future.then((_) => imageStream.removeListener(listener));
    return completer.future;
  }

  bool isValidUrl = Ui.isValidUri(imageUrl?.toString());

  CachedNetworkImageProvider? cachedThumbnailImage;
  CachedNetworkImageProvider? cachedBlurImage;
  CachedNetworkImageProvider? cachedMainImage;

  if (isValidUrl) {
    try {
      cachedThumbnailImage = CachedNetworkImageProvider(
          convertToThumbnailUrl(imageUrl.toString(), isBlurred: true),
          maxWidth: 250,
          maxHeight: 250);
      cachedBlurImage = CachedNetworkImageProvider(
          convertToThumbnailUrl(imageUrl.toString(), isBlurred: true),
          maxWidth: 250,
          maxHeight: 250);
      cachedMainImage = CachedNetworkImageProvider(imageUrl.toString(),
          maxWidth: 500, maxHeight: 500);
    } catch (_) {
      isValidUrl = false;
    }
  }

  return Align(
    alignment: Alignment.center,
    child: Container(
      width: width != 0 ? width : Get.width,
      height: height != 0 ? height : getVerticalSize(250),
      child: !isVideo && !isForm
          ? (!isValidUrl || (imageUrl?.isEmpty ?? true))
              ? Image.asset(
                  asset,
                  height: height != 0 ? height : getVerticalSize(250),
                  fit: fit,
                )
              : isTextOnImage
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        FutureBuilder(
                          future: Future.wait([
                            _getBytesFromCachedImage(cachedBlurImage!),
                            _getBytesFromCachedImage(cachedMainImage!),
                          ]),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Uint8List>> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return TweenAnimationBuilder(
                                tween: Tween<double>(begin: 0.0, end: 1.0),
                                duration: const Duration(milliseconds: 100),
                                builder: (BuildContext context, double value,
                                    Widget? child) {
                                  return Image.memory(
                                    value < 0.5
                                        ? snapshot.data![0]
                                        : snapshot.data![1],
                                    width: width,
                                    height: height,
                                    fit: fit,
                                    gaplessPlayback: true,
                                  );
                                },
                                onEnd: () {},
                              );
                            } else {
                              return Center(
                                // Wrap CircularProgressIndicator in a Center widget to center it on the screen
                                child:
                                    CircularProgressIndicator(), // Show a loading indicator while fetching image data
                              );
                            }
                          },
                        ),

                        // FadeInImage(
                        //   fadeInDuration: const Duration(milliseconds: 100),
                        //   placeholder: cachedBlurImage,
                        //   image: cachedMainImage,
                        //
                        //   width: width,
                        //   height: height,
                        //   fit: fit,
                        //
                        //   imageErrorBuilder: (context, exception, stackTrace) {
                        //     return Image.asset(
                        //       asset,
                        //       height: height != 0 ? height : getVerticalSize(250),
                        //       fit: fit,
                        //     );
                        //   },
                        //   placeholderErrorBuilder: (context, exception, stackTrace) {
                        //     return FadeInImage(
                        //       fadeInDuration: Duration(milliseconds: 200),
                        //       placeholder: cachedBlurImage,
                        //       image: cachedThumbnailImage,
                        //       width: width,
                        //       height: height,
                        //       fit: fit,
                        //       imageErrorBuilder: (context, exception, stackTrace) {
                        //         return Image.asset(
                        //           asset,
                        //           height: height != 0 ? height : getVerticalSize(250),
                        //           fit: fit,
                        //         );
                        //       },
                        //     );
                        //   },
                        // ),

                        Container(
                          width: width,
                          height: getVerticalSize(250),
                          decoration: BoxDecoration(
                            color: Colors.black45.withOpacity(0.3),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: getPadding(all: 10.0),
                              child: Text(imgTitle,
                                  style: TextStyle(
                                      height: 1.50,
                                      color: ColorConstant.white,
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.bold,
                                      fontSize: getFontSize(17))),
                            ),
                            Padding(
                              padding: getPadding(all: 10.0),
                              child: Text(
                                imgBody,
                                style: TextStyle(
                                    height: 1.50,
                                    overflow: TextOverflow.ellipsis,
                                    color: ColorConstant.white,
                                    fontSize: getFontSize(17)),
                              ),
                            )
                          ],
                        )
                      ],
                    )
                  :
                  // CustomCachedNetworkImage(imageUrl: imageUrl, width: width, height: height, fit: fit, asset: asset,)
                  FadeInImage(
                      fadeInDuration: Duration(milliseconds: 200),
                      placeholder: cachedThumbnailImage!,
                      image: cachedMainImage!,
                      width: width,
                      height: height,
                      fit: fit,
                      imageErrorBuilder: (context, exception, stackTrace) {
                        return Image.asset(
                          asset,
                          height: height != 0 ? height : getVerticalSize(250),
                          fit: fit,
                        );
                      },
                      placeholderErrorBuilder:
                          (context, exception, stackTrace) {
                        return FadeInImage(
                          fadeInDuration: Duration(milliseconds: 200),
                          placeholder: cachedBlurImage!,
                          image: cachedThumbnailImage!,
                          width: width,
                          height: height,
                          fit: fit,
                          imageErrorBuilder: (context, exception, stackTrace) {
                            return Image.asset(
                              asset,
                              height:
                                  height != 0 ? height : getVerticalSize(250),
                              fit: fit,
                            );
                          },
                        );
                      },
                    )
          : isForm
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: getPadding(all: 10.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: FadeInImage(
                              fadeInDuration: Duration(milliseconds: 200),
                              placeholder: cachedBlurImage!,
                              image: cachedMainImage!,
                              width: getHorizontalSize(70),
                              height: getHorizontalSize(70),
                              fit: fit,
                              imageErrorBuilder:
                                  (context, exception, stackTrace) {
                                return Image.asset(
                                  asset,
                                  height: height != 0
                                      ? height
                                      : getVerticalSize(250),
                                  fit: fit,
                                );
                              },
                              placeholderErrorBuilder:
                                  (context, exception, stackTrace) {
                                return FadeInImage(
                                  fadeInDuration: Duration(milliseconds: 200),
                                  placeholder: cachedBlurImage!,
                                  image: cachedThumbnailImage!,
                                  width: width,
                                  height: height,
                                  fit: fit,
                                  imageErrorBuilder:
                                      (context, exception, stackTrace) {
                                    return Image.asset(
                                      asset,
                                      height: height != 0
                                          ? height
                                          : getVerticalSize(250),
                                      fit: fit,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: getPadding(all: 10.0),
                          child: Text(
                            formUserName,
                            style: TextStyle(
                                height: 1.50,
                                overflow: TextOverflow.ellipsis,
                                fontSize: getFontSize(15)),
                          ),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: getPadding(left: 20.0),
                          child: Text(
                            formName,
                            style: TextStyle(
                                height: 1.50,
                                overflow: TextOverflow.ellipsis,
                                fontSize: getFontSize(15)),
                          ),
                        ),
                        Padding(
                          padding: getPadding(left: 20.0),
                          child: Text(
                            formFeedBack,
                            style: TextStyle(
                                color: ColorConstant.black900,
                                overflow: TextOverflow.visible,
                                fontSize: getFontSize(18)),
                          ),
                        ),
                      ],
                    )
                  ],
                )
              : SizedBox(
                  width: double.infinity,
                  child: ChewieVideoPlayer(
                    initialQuality: isConverted ? "360" : "720",
                    autoPlay: true,
                    looping: true,
                    isMuted: isMuted,
                    videoQualities: isConverted
                        ? {
                            "360": "$finalVideoUrl${"360/"}$videoName",
                            "720": "$finalVideoUrl/$videoName",
                          }
                        : {
                            "720": "$finalVideoUrl/$videoName",
                          },
                  ),
                ),

      // CustomVideoPlayer(
      //             videoUrl: videoUrl,
      //             isAutoPlay: isAutoPlay,
      //
      //             isMuted: isMuted,
      //             imageUrl: "https://schooltube.online/schooltube/web/img/default.png",
      //             resolutions: isConverted
      //                 ? {
      //                     "360": "$finalVideoUrl${"360/"}$videoName",
      //                     "720": "$finalVideoUrl/$videoName",
      //                   }
      //                 : {
      //                     "720": "$finalVideoUrl/$videoName",
      //                   },
      //           ),
    ),
  );
}
