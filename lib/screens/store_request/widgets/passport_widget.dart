import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/widgets/custom_button.dart';
import 'package:iq_mall/widgets/custom_image_view.dart';

import '../../../utils/ShColors.dart';
import '../store_request_controller.dart';
import '../store_request_view.dart';

class IDImagePickerScreen extends StatefulWidget {
  final String? idImage;
  final String? id2Image;

  const IDImagePickerScreen({Key? key, this.idImage, this.id2Image})
      : super(key: key);

  @override
  _IDImagePickerScreenState createState() => _IDImagePickerScreenState();
}

class _IDImagePickerScreenState extends State<IDImagePickerScreen> {
  RxBool isLoading = false.obs;

  StoreRequestController controller = Get.find();

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.idImage != null) controller.idImage.value = widget.idImage;
    if (widget.id2Image != null) controller.id2Image.value = widget.id2Image;
  }

  Future<void> pickImage(int imageNumber) async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() {
        if (imageNumber == 1) {
          controller.idImage.value = picked.path;
        } else {
          controller.id2Image.value = picked.path;
        }
      });
    }
  }

  void onConfirm() {
    if (controller.idImage.value == null || controller.id2Image.value == null) {
      Fluttertoast.showToast(msg: "add both image to proceed".tr);
      return;
    }

    // Both images are selected
    // Handle the result (e.g., pass back, update controller)
    Navigator.pop(context, {
      'id1': controller.idImage.value,
      'id2': controller.id2Image.value,
    });
  }

  Widget imageBox(
      {required Rxn<String>? imagePath,
      required int imageNumber,
      required String label}) {
    return GestureDetector(
      onTap: () => showPickerBottomSheet(imagePath!),
      child: Container(
        height: 150,
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        child: imagePath == null
            ? Center(
                child: Text("Click to add $label".tr,
                    style: TextStyle(fontSize: 16)))
            : ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Obx(
                  () => imagePath.value != null
                      ? CustomImageView(
                          image: imagePath.value,
                          fit: BoxFit.contain,
                          width: double.infinity,
                        )
                      : SizedBox(
                          child: Center(
                              child: Text("Click to add $label".tr,
                                  style: TextStyle(fontSize: 16))),
                        ),
                )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add National ID Images".tr),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            imageBox(
                imagePath: controller.idImage,
                imageNumber: 1,
                label: "Face image".tr),
            imageBox(
                imagePath: controller.id2Image,
                imageNumber: 2,
                label: "Back image".tr),
            SizedBox(height: 20),
            Obx(() => MyCustomButton(
                  height: getVerticalSize(50),
                  text: "Confirm".tr,
                  fontSize: 20,
                  variant: ButtonVariant.FillDeeporange300,
                  circularIndicatorColor: Colors.white,
                  margin: getMargin(bottom: 20),
                  width: 280,
                  isExpanded: isLoading.value,
                  onTap: onConfirm,
                )),
          ],
        ),
      ),
    );
  }
}
