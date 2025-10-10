import 'dart:io';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

CommonAppBar(text) {
  return AppBar(
    backgroundColor: Colors.white,
    title: Text(text),
    leading: GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Padding(
        padding: EdgeInsets.all(15.0), // You can adjust the padding value
        child: Icon(
         Icons.arrow_back_ios,
          color: Colors.black,
        ),
      ),
    )
    ,
  );
}

// sound() {
//   final player = AudioPlayer();
//   AudioCache audioCache = AudioCache();
//   // audioCache.play('fb_like_hit.mp3');
// }

SVG(path, width, height, color) {
  return SvgPicture.asset(
    path,
    width: double.parse(width.toString()),
    height: double.parse(height.toString()),
    color: color,
  );
}

Widget Progressor_indecator({Color? indicatorColor}) {
  return Center(
    child: SizedBox(
      width: 100,
      height: 100,
      child: LoadingAnimationWidget.inkDrop(color: indicatorColor??MainColor, size: 20),
    ),
  );
}
