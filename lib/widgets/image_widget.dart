import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iq_mall/main.dart';
import 'package:iq_mall/widgets/ui.dart';
import 'package:photo_view/photo_view.dart';
import 'package:progressive_image/progressive_image.dart';

import '../Product_widget/Product_widget.dart';
import '../cores/math_utils.dart';
import '../theme/app_style.dart';

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

import '../utils/ShImages.dart';
import 'CommonWidget.dart';
import 'package:shimmer/shimmer.dart';

Widget mediaWidget(imageUrl, String asset,
    {double width = 0,
    double height = 0,
    double topLeftBorder = 5,
    double topRightBorder = 5,
    double bottomLeftBorder = 0,
    double bottomRightBorder = 0,
    bool isVideo = false,
    bool isAutoPlay = false,
    Color backgroundColor = Colors.white,
    bool isConverted = false,
    bool isProduct = false,
    bool isProductDetails = false,
    bool isCategory = false,
    bool isHomeBanner = false,
    bool isMuted = false,
    bool isTextOnImage = false,
    bool placeholderFit = false,
    BoxFit fit = BoxFit.cover,
    bool isForm = false,
    String imgTitle = "",
    String fromKey = "",
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
  RxBool isImageLoaded = false.obs;

  Future<Uint8List> _getBytesFromCachedImage(
      CachedNetworkImageProvider imageProvider) async {
    final imageStream = imageProvider.resolve(ImageConfiguration());
    final Completer<Uint8List> completer = Completer();
    ImageStreamListener? listener;

    listener = ImageStreamListener((ImageInfo image, bool synchronousCall) {
      if (!completer.isCompleted) {
        image.image.toByteData().then((ByteData? byteData) {
          if (byteData != null) {
            completer.complete(byteData.buffer.asUint8List());
          } else {
            completer.completeError(Exception("ByteData is null"));
          }
        });
        imageStream
            .removeListener(listener!); // Remove the listener after completion
      }
    }, onError: (Object exception, StackTrace? stackTrace) {
      if (!completer.isCompleted) {
        completer.completeError(exception, stackTrace);
        imageStream.removeListener(
            listener!); // Remove the listener in case of an error
      }
    });

    imageStream.addListener(listener);
    return completer.future;
  }

  return Align(
    alignment: Alignment.center,
    child: Container(
        width: width != 0 ? width : getHorizontalSize(390),
        height: height != 0 ? height : getVerticalSize(250),
        padding: getPadding(all: 0),
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: isCategory
                ? null
                : isProduct
                    ? BorderRadius.only(
                        topLeft: Radius.circular(topLeftBorder),
                        topRight: Radius.circular(topRightBorder),
                        bottomLeft: Radius.circular(bottomLeftBorder),
                        bottomRight: Radius.circular(bottomRightBorder))
                    : const BorderRadius.all(Radius.circular(5)),
            shape: isCategory ? BoxShape.circle : BoxShape.rectangle),
        child: () {
          bool isValidUrl = false;
          if (imageUrl != null &&
              imageUrl.toString().toLowerCase().startsWith("http")) {
            try {
              final uri = Uri.parse(imageUrl.toString());
              if (uri.hasAuthority && uri.host.isNotEmpty) {
                isValidUrl = true;
              }
            } catch (_) {}
          }

          if (!isValidUrl || (imageUrl?.isEmpty ?? true)) {
            return Image.asset(
              asset,
              height: height != 0 ? height : getVerticalSize(250),
              fit: fit,
            );
          }

          return ClipRRect(
              borderRadius: isProduct
                  ? BorderRadius.only(
                      topLeft: Radius.circular(topLeftBorder),
                      topRight: Radius.circular(topRightBorder),
                      bottomLeft: Radius.circular(bottomLeftBorder),
                      bottomRight: Radius.circular(bottomRightBorder))
                  : const BorderRadius.all(Radius.circular(5)),
              child: isHomeBanner
                  ? FadeInImage(
                      fadeInDuration: const Duration(milliseconds: 200),
                      placeholder: AssetImage(asset),
                      image: Ui.isValidUri(imageUrl)
                          ? CachedNetworkImageProvider(imageUrl)
                          : AssetImage(asset) as ImageProvider,
                      width: width,
                      height: height,
                      fit: fit,
                      imageErrorBuilder: (context, exception, stackTrace) {
                        return Image.asset(
                          asset,
                          height: height != 0 ? height : getVerticalSize(250),
                          fit: placeholderFit ? BoxFit.cover : fit,
                        );
                      },
                    )
                  : CachedNetworkImage(
                      height: height,
                      width: width,
                      fit: BoxFit.cover,
                      imageUrl:
                          convertToThumbnailUrl(imageUrl, isBlurred: false),
                      placeholder: (context, url) {
                        return CachedNetworkImage(
                            imageUrl: convertToThumbnailUrl(imageUrl,
                                isBlurred: true),
                            placeholderFadeInDuration:
                                const Duration(milliseconds: 100),
                            placeholder: (context, url) {
                              return Image.asset(
                                AssetPaths.placeholder,
                                width: Get.size.width,
                                height: Get.size.height,
                                fit: BoxFit.cover,
                              );
                            });
                      },
                      errorWidget: (context, s, a) {
                        return Center(
                          child: Image.asset(
                            AssetPaths.placeholder,
                            width: Get.size.width,
                            height: Get.size.height,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ));
        }()),
  );
}
