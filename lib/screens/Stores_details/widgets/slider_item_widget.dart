import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iq_mall/utils/ShImages.dart';

import '../../../cores/math_utils.dart';
import '../../../models/Stores.dart';
import '../../../widgets/chewie_player.dart';
import '../../../widgets/custom_image_view.dart';
import '../../ProductDetails_screen/widgets/better_player.dart';
import '../controller/store_detail_controller.dart';
import '../models/MainSlider.dart';
// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable
class sliderItem extends StatelessWidget {
  sliderItem(this.slider, {Key? key})
      : super(
          key: key,
        );
  StoreSliderImage? slider;

  var controller = Get.find<StoreDetailController>();

  @override
  Widget build(BuildContext context) {

    return  Material(
      child: Align(
        alignment: Alignment.center,
        child: slider?.filePath != null
            ? ClipRRect(
              child: CustomImageView(
                image: slider?.filePath,
                height: getVerticalSize(180),
                placeHolder: AssetPaths.placeholder,
                width: getHorizontalSize(390),
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(10),
              ),
            )
            :
        ChewieVideoPlayer(
          initialQuality:  slider!.filePath!,
          isMuted: false,
          videoQualities :  {
            "360":  slider!.filePath!,
            "720":  slider!.filePath!,
          },
        )

      ),
    );
  }
}
