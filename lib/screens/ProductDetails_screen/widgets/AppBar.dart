import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iq_mall/main.dart';
import 'package:iq_mall/routes/app_routes.dart';
import 'package:iq_mall/screens/ProductDetails_screen/controller/ProductDetails_screen_controller.dart';
import 'package:share_plus/share_plus.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProductDetails_screenController>();
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: const Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
      ),
      title:  Text(
        'Product Details'.tr,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.share,
            color: Colors.black,
          ),
          onPressed: () async {
            final box = context.findRenderObject() as RenderBox?;
            Share.shareUri(
              Uri.parse('https://play.google.com/store/apps/details?id=com.brainkets.jewelry',),
              sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
            );

          },
        ),
      ],
    );
  }
}
