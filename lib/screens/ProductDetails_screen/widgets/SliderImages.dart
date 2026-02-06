import 'dart:async';
import 'dart:typed_data';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_avif/flutter_avif.dart';
import 'package:get/get.dart';
import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/screens/ProductDetails_screen/controller/ProductDetails_screen_controller.dart';
import 'package:iq_mall/widgets/slider.dart';
import 'package:iq_mall/utils/ShImages.dart';
import 'package:iq_mall/widgets/ui.dart';
import 'package:photo_view/photo_view.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Product_widget/Product_widget.dart';
import '../../../models/HomeData.dart';
import '../../../utils/ShColors.dart';
import '../../../widgets/chewie_player.dart';
import '../../../widgets/image_widget.dart';
import 'better_player.dart';
//ignore: must_be_immutable

class SliderImages extends StatefulWidget {
  final RxList<MoreImage> newImages;
  final Product? product;
  final Map? args;

  const SliderImages(
      {super.key, this.product, this.args, required this.newImages});

  @override
  State<SliderImages> createState() => _SliderImagesState();
}

class _SliderImagesState extends State<SliderImages> {
  // RxList<String> imagesList = <String>[].obs;
  RxList<bool> loadingImageList = <bool>[].obs;
  RxBool loadingImage = true.obs;

  @override
  void initState() {
    // for (var imageUrl in widget.newImages) {
    //   imagesList.add(imageUrl.file_path);
    // }

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<Uint8List> _getBytesFromCachedImage(
      CachedNetworkImageProvider imageProvider, index) async {
    final imageStream = imageProvider.resolve(ImageConfiguration());
    final Completer<Uint8List> completer = Completer();
    ImageStreamListener? listener;

    try {
      listener = ImageStreamListener((ImageInfo image, bool synchronousCall) {
        if (!completer.isCompleted) {
          loadingImageList[index] = false;
          loadingImageList.refresh();
          image.image.toByteData().then((ByteData? byteData) {
            if (byteData != null) {
              completer.complete(byteData.buffer.asUint8List());
            } else {
              completer.completeError(Exception("ByteData is null"));
            }
          });
          imageStream.removeListener(
              listener!); // Remove the listener after completion
        }
      }, onError: (Object exception, StackTrace? stackTrace) {
        completer.completeError(exception, stackTrace);
        imageStream.removeListener(listener!);

        // Remove the listener in case of an error
      });
      imageStream.addListener(listener);
    } catch (e) {}
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    RxInt currentIndex = 1.obs;
    loadingImageList.value =
        List<bool>.generate(widget.newImages.length, (index) => true).obs;

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          color: Colors.white,
          width: Get.width,
          height: getVerticalSize(500),
          child: Swiper(
            // pagination: SwiperPagination(
            //
            //   alignment: Alignment.bottomCenter,
            //   margin: getMargin(bottom: 6),
            //
            //
            //   builder: DotSwiperPaginationBuilder(
            //     activeColor: MainColor,
            //     space: getSize(8)??8,
            //
            //     activeSize: getSize(10)!,
            //     size: getSize(10)!,
            //     // Color for the active dot
            //     color: Colors.white, // Color for the inactive dots
            //   ),
            // ),
            onIndexChanged: (value) {
              currentIndex.value = value + 1;
            },
            control: null,
            loop: false,
            itemHeight: getVerticalSize(200),
            itemBuilder: (BuildContext context, int index) {
              String? videoName =
                  widget.newImages[index].toString().split("/").last;
              List<String>? videoFinalUrlList =
                  widget.newImages[index].toString().split("/");
              String? finalVideoUrl = "";
              videoFinalUrlList.removeLast();
              for (var element in videoFinalUrlList) {
                if (finalVideoUrl == null || finalVideoUrl == "") {
                  finalVideoUrl = (finalVideoUrl ?? "") + element;
                } else {
                  finalVideoUrl += "/$element";
                }
              }
              bool isValid = Ui.isValidUri(widget.newImages[index].file_path);
              if (!widget.newImages[index].file_path!
                      .toString()
                      .toLowerCase()
                      .endsWith("avif") &&
                  isValid) {
                _getBytesFromCachedImage(
                    CachedNetworkImageProvider(
                        widget.newImages[index].file_path!),
                    index);
              } else {
                loadingImageList[index] = false;
              }
              return GestureDetector(
                  onTap: () {
                    print('------------------------------------');
                    if (widget.newImages[index].file_path!.isNotEmpty) {
                      Get.to(
                          () => slider(
                              list: widget.newImages,
                              product: widget.product,
                              index: index),
                          routeName: '/slider');
                    }
                  },
                  child: isVideo(widget.newImages[index].file_path.toString())
                      ? ChewieVideoPlayer(
                          initialQuality:
                              widget.newImages[index].file_path.toString(),
                          isMuted: false,
                          videoThumb: AssetPaths.placeholder,
                          videoQualities:
                              finalVideoUrl!.contains("cloudfront.net")
                                  ? {
                                      "360": widget.newImages[index].file_path
                                          .toString(),
                                      "720": widget.newImages[index].file_path
                                          .toString(),
                                    }
                                  : {
                                      "720": "$finalVideoUrl/$videoName",
                                    },
                          isGeneral: false,
                          looping: false,
                        )
                      :

                      // widget.loaded??false?

                      widget.newImages[index].file_path
                              .toString()
                              .toLowerCase()
                              .endsWith("avif")
                          ? Container(
                              height: getVerticalSize(500),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image:
                                          AssetImage(AssetPaths.placeholder))),
                              child: AvifImage.network(
                                widget.newImages[index].file_path!,
                                height: getVerticalSize(500),
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width,
                              ),
                            )
                          : !isValid
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    AssetPaths.placeholder,
                                    height: getVerticalSize(500),
                                    fit: BoxFit.cover,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                )
                              : ProgressiveImage(
                                  placeholder:
                                      const AssetImage(AssetPaths.placeholder),

                                  // size: 1.87KB
                                  thumbnail: CachedNetworkImageProvider(
                                    convertToThumbnailUrl(
                                        widget.newImages[index].file_path ?? '',
                                        isBlurred: true),
                                    errorListener: (p0) {},
                                  ),
                                  blur: 0,
                                  // size: 1.29MB
                                  image: CachedNetworkImageProvider(
                                    // convertToThumbnailUrl(imagesList[index] ?? '', isBlurred: false)
                                    loadingImageList[index]
                                        ? convertToThumbnailUrl(
                                            widget.newImages[index].file_path ??
                                                '',
                                            isBlurred: false)
                                        : widget.newImages[index].file_path!,
                                  ),
                                  height: getVerticalSize(500),
                                  fit: BoxFit.cover,

                                  width: MediaQuery.of(context).size.width,

                                  fadeDuration: Duration(milliseconds: 200),
                                ));
            },
            indicatorLayout: PageIndicatorLayout.COLOR,
            autoplay: false,

            autoplayDelay: 3000,
            itemCount: widget.newImages.length,
          ),
        ),
        Padding(
          padding: getPadding(bottom: 40.0, right: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 3.0, bottom: 3, right: 8, left: 8),
              child: Obx(() => Text(
                    '${currentIndex.value} / ${widget.newImages.length}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: getFontSize(12)),
                  )),
            ),
          ),
        )
      ],
    );
  }
}
