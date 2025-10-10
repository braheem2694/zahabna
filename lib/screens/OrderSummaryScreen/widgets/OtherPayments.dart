import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller/OrderSummaryScreen_controller.dart';

class OtherPayments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    OrderSummaryScreenController controller = Get.find();

    return Padding(
      padding: const EdgeInsets.only(bottom: 28.0),
      child: Column(
        children: [
          controller.image.toString() == 'null'
              ? SizedBox()
              : Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 5),
                  child: Image.file(
                    controller.image,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.25,
                    fit: BoxFit.cover,
                  ),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(''),
              GestureDetector(
                onTap: () async {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext bc) {
                        return SafeArea(
                          child: Wrap(
                            children: <Widget>[
                              ListTile(
                                  leading:  Icon(Icons.photo_library),
                                  title:  Text('Gallery'.tr),
                                  onTap: () {
                                    //  _imgFromGallery();
                                    Get.back();
                                  }),
                               ListTile(
                                leading:  Icon(Icons.photo_camera),
                                title:  Text('Camera'.tr),
                                onTap: () {
                                  // controller.imgFromCamera();
                                  Get.back();
                                },
                              ),
                            ],
                          ),
                        );
                      });
                },
                child:  Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 18.0, right: 18, top: 10, bottom: 10),
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.blue, // replace with your primary color
                        size: 40,
                      ),
                    ),
                    Text(
                      'Add Payment bill here'.tr, // .tr is removed, add it if you use localization
                      style: const TextStyle(color: Colors.blue), // replace with your primary color
                    )
                  ],
                ),
              ),
              Text(''),
            ],
          ),
        ],
      ),
    );
  }
}
