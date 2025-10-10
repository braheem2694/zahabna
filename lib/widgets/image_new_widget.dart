import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../utils/ShImages.dart';

class CustomImageWidget extends StatefulWidget {
  final String blurImageUrl;
  final String thumbImageUrl;
  final String? originalImageUrl; // Nullable to allow for no original image
  final double width;
  final double height;
  final BoxFit fit;
  final bool cacheThumb; // Option to choose which image to cache

  const CustomImageWidget({
    Key? key,
    required this.blurImageUrl,
    required this.thumbImageUrl,
    this.originalImageUrl,
    this.width = double.infinity,
    this.height = double.infinity,
    this.fit = BoxFit.cover,
    this.cacheThumb = true, // Default to caching the thumb image
  }) : super(key: key);

  @override
  _CustomImageWidgetState createState() => _CustomImageWidgetState();
}

class _CustomImageWidgetState extends State<CustomImageWidget> {
  @override
  Widget build(BuildContext context) {
    String imageUrlToCache = widget.cacheThumb ? widget.thumbImageUrl : widget.originalImageUrl ?? widget.blurImageUrl;

    return CachedNetworkImage(
      imageUrl: imageUrlToCache,
      imageBuilder: (context, imageProvider) => widget.originalImageUrl != null
          ? Image.network(
              widget.originalImageUrl!,
              width: widget.width,
              height: widget.height,
              fit: widget.fit,
              errorBuilder: (context, error, stackTrace) {
                return Image.network(
                  widget.thumbImageUrl,
                  width: widget.width,
                  height: widget.height,
                  fit: widget.fit,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(widget.blurImageUrl,
                        width: widget.width,
                        height: widget.height,
                        fit: widget.fit, errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        AssetPaths.placeholder,
                        width: widget.width,
                        height: widget.height,
                        fit: widget.fit,
                      );
                    });
                  },
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Image.network(
                  widget.thumbImageUrl,
                  width: widget.width,
                  height: widget.height,
                  fit: widget.fit,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      widget.blurImageUrl,
                      width: widget.width,
                      height: widget.height,
                      fit: widget.fit,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          AssetPaths.placeholder,
                          width: widget.width,
                          height: widget.height,
                          fit: widget.fit,
                        );
                      },
                    );
                  },
                );
              },
            )
          : Image.network(
              widget.thumbImageUrl,
              width: widget.width,
              height: widget.height,
              fit: widget.fit,
              errorBuilder: (context, error, stackTrace) {
                return Image.network(widget.blurImageUrl, width: widget.width, height: widget.height, fit: widget.fit,
                    errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    AssetPaths.placeholder,
                    width: widget.width,
                    height: widget.height,
                    fit: widget.fit,
                  );
                });
              },
            ),
      placeholder: (context, url) => Image.network(
        widget.blurImageUrl,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
      ),
      errorWidget: (context, url, error) => Image.asset(
        AssetPaths.placeholder,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
      ),
    );
  }
}
