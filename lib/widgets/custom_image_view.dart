// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_avif/flutter_avif.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iq_mall/utils/ShImages.dart';
import 'package:iq_mall/widgets/ui.dart';
import '../cores/math_utils.dart';
import '../utils/ShColors.dart';

class CustomImageView extends StatelessWidget {
  ///[url] is required parameter for fetching network image
  String? url;
  bool? notOpen;
  bool? isRounded;
  bool? isIllustration;

  ///[imagePath] is required parameter for showing png,jpg,etc image
  String? imagePath;

  ///[svgPath] is required parameter for showing svg image
  String? svgPath;
  String? svgUrl;
  String? image;

  ///[file] is required parameter for fetching image file
  File? file;

  double? height;
  double? width;
  Color? color;
  BorderRadius? borderRadius;
  BoxFit? fit;
  final String placeHolder;
  Alignment? alignment;
  VoidCallback? onTap;
  EdgeInsetsGeometry? margin;
  BorderRadius? radius;
  BoxBorder? border;
  BoxShape? shape;

  ///a [CustomImageView] it can be used for showing any type of images
  /// it will shows the placeholder image if image is not found on network image
  CustomImageView({
    this.url,
    this.svgUrl,
    this.imagePath,
    this.svgPath,
    this.file,
    this.height,
    this.width,
    this.color,
    this.fit,
    this.alignment,
    this.image,
    this.onTap,
    this.borderRadius,
    this.shape,
    this.isRounded,
    this.radius,
    this.margin,
    this.border,
    this.notOpen = true,
    this.placeHolder = AssetPaths.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    if (image == null) {
      image = svgPath != null
          ? svgPath
          : svgUrl != null
              ? svgUrl
              : imagePath != null
                  ? imagePath
                  : null;
    }

    return alignment != null
        ? Align(
            alignment: alignment!,
            child: _buildWidget(),
          )
        : _buildWidget();
  }

  Widget _buildWidget() {
    return IgnorePointer(
      ignoring: notOpen ?? false,
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: GestureDetector(
          onTap: onTap ??
              () => {
                    if (onTap != null)
                      {onTap}
                    else
                      {
                        if (!notOpen!)
                          {
                            if (svgUrl != null ||
                                url != null ||
                                svgPath != null ||
                                (imagePath != null &&
                                    !imagePath
                                        .toString()
                                        .toLowerCase()
                                        .startsWith("assets")))
                              {
                                // Get.context!.pushTransparentRoute(HeroImageView(
                                //   ImageUrl: svgUrl ?? url ?? svgPath ?? imagePath!,
                                //   from: "profile",
                                // ))
                              }
                            else
                              {
                                Ui.flutterToast(
                                    "No Image".tr,
                                    Toast.LENGTH_LONG,
                                    MainColor,
                                    ColorConstant.whiteA700)
                              }
                          }
                      }
                  },
          child: _buildCircleImage(),
        ),
      ),
    );
  }

  ///build the image with border radius
  _buildCircleImage() {
    if (radius != null) {
      return ClipRRect(
        borderRadius: radius!,
        child: _buildImageWithBorder(),
      );
    } else {
      return _buildImageWithBorder();
    }
  }

  ///build the image with border and border radius style
  _buildImageWithBorder() {
    if (border != null) {
      return Container(
        decoration: BoxDecoration(
            border: border,
            borderRadius: shape == null ? radius : null,
            shape: shape ?? BoxShape.circle),
        child: _buildImageView(),
      );
    } else {
      return _buildImageView();
    }
  }

  Widget _buildImageView() {
    if (image != null && image.toString().toLowerCase().endsWith(".svg")) {
      return Container(
        height: height,
        width: width,
        color: null,
        decoration: BoxDecoration(
            borderRadius: shape == null ? borderRadius : null,
            shape: shape ?? BoxShape.rectangle,
            border: border),
        child: image.toString().toLowerCase().startsWith("http")
            ? SvgPicture.network(
                image!,
                height: height,
                width: width,
                placeholderBuilder: (context) {
                  return placeHolder != null
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              placeHolder,
                              height: height,
                              width: width,
                              fit: fit ?? BoxFit.cover,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: ColorConstant.whiteA700,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: getPadding(all: 5),
                            ),
                          ],
                        )
                      : SizedBox();
                },
                fit: fit ?? BoxFit.cover,
                color: color,
              )
            : SvgPicture.asset(
                image!,
                height: height,
                width: width,
                placeholderBuilder: (context) {
                  return placeHolder != null
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              placeHolder,
                              height: height,
                              width: width,
                              fit: fit ?? BoxFit.cover,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: ColorConstant.whiteA700,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: getPadding(all: 5),
                            ),
                          ],
                        )
                      : SizedBox();
                },
                fit: fit ?? BoxFit.cover,
                color: color,
              ),
      );
    } else if (image != null) {
      bool isValidUrl = Ui.isValidUri(image);

      return isValidUrl
          ? image.toString().toLowerCase().endsWith("avif")
              ? AvifImage.network(
                  image!,
                  height: height,
                  width: width,
                  fit: BoxFit.cover,
                )
              : fadeImage()
          : image != null && image!.startsWith("assets")
              ? Image.asset(
                  image ?? AssetPaths.noresultsfound,
                  height: height,
                  width: width,
                  errorBuilder: (context, error, stackTrace) {
                    return placeHolder != null
                        ? Image.asset(
                            placeHolder,
                            height: height,
                            width: width,
                            fit: fit ?? BoxFit.cover,
                          )
                        : SizedBox();
                  },
                  fit: fit ?? BoxFit.cover,
                )
              : Image.file(
                  File(image!),
                  height: height,
                  width: width,
                  fit: fit ?? BoxFit.cover,
                );
    } else if (image == null && file != null && file!.path.isNotEmpty) {
      return Image.file(
        file!,
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
        color: color,
      );
    } else if (image == null && imagePath != null && imagePath!.isNotEmpty) {
      return Image.asset(
        imagePath!,
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
        color: color,
      );
    }
    return Image.asset(
      placeHolder,
      height: height,
      width: width,
      fit: fit ?? BoxFit.cover,
      color: color,
    );
  }

  Widget fadeImage() {
    if (!Ui.isValidUri(image)) {
      return Image.asset(
        placeHolder,
        height: height != 0 ? height : getVerticalSize(250),
        width: width,
        fit: fit,
      );
    }

    try {
      CachedNetworkImageProvider cachedThumbnailImage =
          CachedNetworkImageProvider(Ui.progImages(image!, "thumbnails"));
      CachedNetworkImageProvider cachedBlurImage =
          CachedNetworkImageProvider(Ui.progImages(image!, "blur"));
      CachedNetworkImageProvider cachedMainImage =
          CachedNetworkImageProvider(image!);

      return ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(10),
        child: FadeInImage(
          fadeInDuration: Duration(milliseconds: 200),
          placeholder: AssetImage(
            placeHolder,
          ), // Asset placeholder
          image: cachedMainImage,
          width: width,
          height: height,
          fit: fit,
          imageErrorBuilder: (context, exception, stackTrace) {
            return placeHolder != null
                ? Image.asset(
                    placeHolder,
                    height: height != 0 ? height : getVerticalSize(250),
                    width: width,
                    fit: fit,
                  )
                : SizedBox();
          },
          placeholderErrorBuilder: (context, exception, stackTrace) {
            return FadeInImage(
              fadeInDuration: Duration(milliseconds: 200),
              placeholder: cachedBlurImage,
              image: cachedThumbnailImage,
              width: width,
              height: height,
              fit: fit,
              imageErrorBuilder: (context, exception, stackTrace) {
                return placeHolder != null
                    ? Image.asset(
                        placeHolder,
                        height: height != 0 ? height : getVerticalSize(250),
                        width: width,
                        fit: fit,
                      )
                    : SizedBox();
              },
            );
          },
        ),
      );
    } catch (e) {
      return Image.asset(
        placeHolder,
        height: height != 0 ? height : getVerticalSize(250),
        width: width,
        fit: fit,
      );
    }
  }
}
