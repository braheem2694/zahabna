import 'package:get/get_rx/src/rx_types/rx_types.dart';

import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/src/widgets/container.dart';

import 'package:flutter/src/widgets/gesture_detector.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

import 'package:iq_mall/cores/math_utils.dart';

import 'package:iq_mall/utils/ShColors.dart';

import '../../../utils/ShImages.dart';

import '../../../widgets/custom_image_view.dart';

import 'package:percent_indicator/percent_indicator.dart';


class VideoGridItem extends StatelessWidget {
  final String videoPath;
  final RxDouble? uploadProgress;
  final VoidCallback onDelete;
  final VoidCallback onPreview;
  final bool isAdding;

  const VideoGridItem({
    Key? key,
    required this.videoPath,
    this.uploadProgress,
    required this.onDelete,
    required this.onPreview,
    required this.isAdding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPreview,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey[200],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: getPadding(all: 10.0),
              child: CustomImageView(
                image: AssetPaths.videoThumb,
                fit: BoxFit.cover,
                height: 80,
                width: 80,
              ),
            ),
            // Progress Indicator, but it will only build when needed
            if (uploadProgress != null)
              Obx(() {
                final progress = uploadProgress!.value;
                return
                  isAdding?
                  CircularPercentIndicator(
                  radius: 25.0,
                  lineWidth: 3.0,
                  percent: progress,
                  center: Text(
                    "${(progress * 100).toInt()}%",
                    style: TextStyle(
                      fontSize: getFontSize(13),
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  progressColor: Colors.grey,
                ):SizedBox();
              }),
            Positioned(
              top: -1,
              right: -1,
              child: GestureDetector(
                onTap: onDelete,
                child: Icon(
                  Icons.remove_circle,
                  color: ColorConstant.logoSecondColor,
                  size: getSize(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
