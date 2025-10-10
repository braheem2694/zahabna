import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/screens/store_request/widgets/map_location.dart';
import 'package:iq_mall/screens/store_request/widgets/passport_widget.dart';
import 'package:iq_mall/widgets/custom_button.dart';
import '../../main.dart';
import '../../models/functions.dart';
import '../../utils/ShColors.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/image_viewer.dart';
import '../SignIn_screen/controller/SignIn_controller.dart';
import '../TermsAndConditions_screen/terms_widget.dart';
import 'store_request_controller.dart';
import 'package:flutter/services.dart';
import 'package:iq_mall/widgets/Ui.dart';

enum _Action { edit, cancel, save, delete }

class StoreRequestView extends GetView<StoreRequestController> {
  // Add FocusNodes for each TextField
  final FocusNode subscriberNameFocus = FocusNode();
  final FocusNode motherNameFocus = FocusNode();
  final FocusNode storeNameFocus = FocusNode();
  final FocusNode phoneNumberFocus = FocusNode();
  final FocusNode countryFocus = FocusNode();
  final FocusNode regionFocus = FocusNode();
  final FocusNode addressFocus = FocusNode();
  final FocusNode recordFocus = FocusNode();
  final FocusNode birthDayFocus = FocusNode();
  final FocusNode branchCountFocus = FocusNode();
  final FocusNode subscriptionMonthsFocus = FocusNode();

  // Method to unfocus all text fields
  void unfocusAll() {
    subscriberNameFocus.unfocus();
    motherNameFocus.unfocus();
    storeNameFocus.unfocus();
    phoneNumberFocus.unfocus();
    countryFocus.unfocus();
    regionFocus.unfocus();
    addressFocus.unfocus();
    branchCountFocus.unfocus();
    subscriptionMonthsFocus.unfocus();
    FocusNode().unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Read-only if we are viewing an existing request and not in edit mode
      final bool isReadOnly = controller.args != null && !controller.editing.value;
      return Scaffold(
        bottomNavigationBar: Obx(() => controller.editing.value
            ? MyCustomButton(
                height: getVerticalSize(50),
                text: "Update Request".tr,
                fontSize: 20,
                borderRadius: 10,
                variant: ButtonVariant.FillDeeporange300,
                circularIndicatorColor: Colors.white,
                margin: getMargin(bottom: 0),
                width: 250,
                isExpanded: controller.sendingRequest.value,
                onTap: () {
                  controller.updateRequestForm();
                },
              )
            : const SizedBox()),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: false,
          title: Text(
            'Subscription Request'.tr,
            style: TextStyle(
              color: ColorConstant.logoFirstColor,
              fontSize: getFontSize(20),
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: Ui.backArrowIcon(
            iconColor: ColorConstant.logoFirstColor,
            onTap: () => Get.back(),
          ),
          actions: [
            controller.args?.status.toLowerCase() != 'deleted' ? AppBarActionsDropdown(controller: controller) : const SizedBox(),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(height: 1, color: Colors.grey[200]),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                IgnorePointer(ignoring: isReadOnly, child: _buildTextField('Subscriber Name'.tr, controller.subscriberNameController, focusNode: subscriberNameFocus)),
                const SizedBox(height: 12),
                IgnorePointer(ignoring: isReadOnly, child: _buildTextField('Mother\'s Name'.tr, controller.motherNameController, focusNode: motherNameFocus)),
                const SizedBox(height: 12),
                IgnorePointer(ignoring: isReadOnly, child: _buildTextField('Store Name'.tr, controller.storeNameController, focusNode: storeNameFocus)),
                const SizedBox(height: 12),
                IgnorePointer(
                  ignoring: isReadOnly,
                  child: CustomTextFormField(
                    controller: controller.phoneNumberController,
                    textInputAction: TextInputAction.next,
                    textInputType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    width: MediaQuery.of(context).size.width,
                    autofocus: false,
                    hintText: 'Phone number',
                    prefix: CodePicker(context, countryCode: country_code),
                    variant: TextFormFieldVariant.logoSecondColor,
                    shape: TextFormFieldShape.RoundedBorder10,
                    padding: TextFormFieldPadding.PaddingT4,
                    validator: (v) => (v == null || v.isEmpty) ? 'required'.tr : null,
                  ),
                ),
                const SizedBox(height: 12),
                IgnorePointer(ignoring: isReadOnly, child: _buildBirthDateField('Birthday'.tr, controller.birthDay, focusNode: birthDayFocus, context: context)),
                const SizedBox(height: 12),

                Obx(() => IgnorePointer(
                      ignoring: isReadOnly,
                      child: _buildCountryField('Country'.tr, globalController.countryName, focusNode: countryFocus),
                    )),
                const SizedBox(height: 12),
                IgnorePointer(ignoring: isReadOnly, child: _buildTextField('Region'.tr, controller.regionController, focusNode: regionFocus)),
                const SizedBox(height: 12),
                IgnorePointer(ignoring: isReadOnly, child: _buildTextField('Address'.tr, controller.addressController, focusNode: addressFocus)),
                const SizedBox(height: 12),
                IgnorePointer(ignoring: isReadOnly, child: _buildTextField('Record Number'.tr.tr, controller.recordNumber, focusNode: recordFocus)),
                const SizedBox(height: 12),
                // IgnorePointer(ignoring: isReadOnly, child: _buildNumberField('Subscription Duration (Months)'.tr, controller.subscriptionMonthsController, focusNode: subscriptionMonthsFocus)),
                IgnorePointer(ignoring: isReadOnly, child: const SizedBox(height: 16)),

                // Pickers (they already check args; IgnorePointer will block taps in view-mode)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildFilePicker('ID/Passport Image'.tr, controller.idImage, 0),
                    _buildFilePicker('Selfie Image'.tr, controller.selfieImage, 1),
                    _buildFilePicker('Store Image'.tr, controller.storeImage, 2),
                    _buildFilePicker('Logo'.tr, controller.logoImage, 3),
                  ],
                ),
                const SizedBox(height: 16),

                Text('Store Location'.tr, style: TextStyle(fontWeight: FontWeight.bold, color: ColorConstant.black900, fontSize: getFontSize(18))),
                const SizedBox(height: 16),
                IgnorePointer(ignoring: isReadOnly, child: SizedBox(width: Get.width, height: Get.height * 0.5, child: StoreLocationPicker())),
                const SizedBox(height: 16),

                Obx(() => IgnorePointer(
                      ignoring: isReadOnly,
                      child: CheckboxListTile(
                        value: controller.agreedToTerms.value,
                        onChanged: (v) {
                          if (v == true) {
                            // showTermsDialog(false, controller.args?.userTermsANdConditions ?? '');

                            showTermsDialog(false, controller.termsConditions.value);
                          } else {
                            controller.agreedToTerms.value = false;
                          }
                        },
                        contentPadding: getPadding(all: 0),
                        checkColor: ColorConstant.white,
                        activeColor: ColorConstant.logoFirstColor,
                        title: Text('Agree to Terms'.tr),
                        subtitle: Text('Required to proceed'.tr, style: const TextStyle(color: Colors.red)),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    )),
                const SizedBox(height: 16),

                IgnorePointer(ignoring: isReadOnly, child: _buildSummary()),
                const SizedBox(height: 16),

                // Submit button: only for NEW requests (args == null)
                if (controller.args == null)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstant.logoFirstColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      if (controller.isUploading.value) return;
                      if (!controller.agreedToTerms.value) {
                        Get.snackbar('Terms Required'.tr, 'Please accept the terms and conditions to proceed'.tr,
                            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white, margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10), duration: const Duration(seconds: 3));
                        return;
                      }
                      controller.submitRequest(); // create new
                    },
                    child: Obx(() {
                      if (controller.sendingRequest.value) {
                        return const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                        );
                      }
                      if (controller.isUploading.value) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                            ),
                            const SizedBox(width: 12),
                            Obx(() => Text(
                                  'Uploading images (${controller.uploadProgress.value}/${controller.totalImages.value})'.tr,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                )),
                          ],
                        );
                      }
                      return Text('Submit Subscription Request'.tr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white));
                    }),
                  ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text, required FocusNode focusNode}) {
    return TextFormField(
      focusNode: focusNode,
      textDirection: prefs?.getString("locale") == "en" ? TextDirection.ltr : TextDirection.rtl,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: ColorConstant.logoSecondColor)),
        filled: true,
        fillColor: Colors.grey[100],
        errorStyle: const TextStyle(color: Colors.red),
      ),
      keyboardType: keyboardType,
      controller: controller,
      validator: (v) => v == null || v.isEmpty ? 'This field is required'.tr : null,
    );
  }

  Widget _buildCountryField(String label, RxString controller, {TextInputType keyboardType = TextInputType.text, required FocusNode focusNode}) {
    TextEditingController textController = TextEditingController(text: controller.value);
    return TextFormField(
      focusNode: focusNode,
      controller: textController,
      textDirection: prefs?.getString("locale") == "en" ? TextDirection.ltr : TextDirection.rtl,
      readOnly: false,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: ColorConstant.logoSecondColor)),
        filled: true,
        fillColor: Colors.grey[100],
        errorStyle: const TextStyle(color: Colors.red),
      ),
      keyboardType: keyboardType,
      validator: (v) => v == null || v.isEmpty ? 'This field is required'.tr : null,
      onChanged: (v) => textController.text = v,
    );
  }

  Widget _buildBirthDateField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    required FocusNode focusNode,
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) {
    final isEn = (prefs?.getString("locale") == "en");
    final dir = isEn ? TextDirection.ltr : TextDirection.rtl;
    final _dateFmt = intl.DateFormat('yyyy-MM-dd');

    // Wrap the field so taps are guaranteed to be caught
    return GestureDetector(
      behavior: HitTestBehavior.translucent, // let child paint but we still get taps
      onTap: () => _pickBirthday(context), // anywhere on the field opens picker
      child: AbsorbPointer(
        // prevent inner field from consuming taps
        absorbing: true, // we handle taps at the wrapper
        child: TextFormField(
          focusNode: focusNode,
          readOnly: true,
          textDirection: dir,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: ColorConstant.logoSecondColor),
            ),
            filled: true,
            fillColor: Colors.grey[100],
            errorStyle: const TextStyle(color: Colors.red),
            suffixIcon: IconButton(
              tooltip: 'Pick date'.tr,
              icon: const Icon(Icons.calendar_today_rounded, size: 16),
              onPressed: () => _pickBirthday(context), // anywhere on the field opens picker
              splashRadius: 18,
            ),
          ),
          keyboardType: keyboardType,
          controller: controller,
          validator: (v) => v == null || v.isEmpty ? 'This field is required'.tr : null,
        ),
      ),
    );
  }

  Future<void> _pickBirthday(BuildContext context) async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18, now.month, now.day), // default: 18 years old
      firstDate: DateTime(1900, 1, 1),
      lastDate: now,
      helpText: 'Select birthday',
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: Theme.of(ctx).colorScheme.copyWith(
                primary: Theme.of(ctx).colorScheme.primary,
              ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      controller.birthDay.text = intl.DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Widget _buildNumberField(String label, TextEditingController controller, {required FocusNode focusNode}) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            focusNode: focusNode,
            controller: controller,
            textDirection: TextDirection.rtl,
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: ColorConstant.logoSecondColor)),
              filled: true,
              fillColor: Colors.grey[100],
              errorStyle: const TextStyle(color: Colors.red),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (v) => v == null || v.isEmpty ? 'This field is required'.tr : null,
            onChanged: (v) {
              final value = int.tryParse(v) ?? 1;
              if (controller.text != value.toString()) {
                controller.text = value.toString();
                controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
              }
            },
          ),
        ),
        IconButton(
          icon: Icon(Icons.add_circle, color: ColorConstant.logoSecondColor),
          onPressed: () {
            int value = int.tryParse(controller.text) ?? 1;
            value++;
            controller.text = value.toString();
            controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
          },
        ),
        IconButton(
          icon: Icon(Icons.remove_circle, color: ColorConstant.logoSecondColor),
          onPressed: () {
            int value = int.tryParse(controller.text) ?? 1;
            if (value > 1) value--;
            controller.text = value.toString();
            controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
          },
        ),
      ],
    );
  }

  Widget _buildSummary() {
    return Obx(() {
      double total = (globalController.homeDataList.value.requestPrice ?? 0.0);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text('Subscription Months: $months'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text('Total Amount: $total'.tr, style: TextStyle(fontWeight: FontWeight.bold, color: ColorConstant.logoSecondColor)),
        ],
      );
    });
  }

  Widget _buildFilePicker(String label, Rxn<String> fileController, int index) {
    return Obx(() {
      final bool readOnly = controller.args != null && !controller.editing.value;
      final bool hasImage = (fileController.value != null && fileController.value!.trim().isNotEmpty);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          InkWell(
            onTap: () {
              unfocusAll();

              // VIEW MODE (existing request, not editing) → open viewer if available
              if (readOnly) {
                if (hasImage) {
                  Get.to(() => FullScreenImageViewer(imageUrl: fileController.value!));
                } else {
                  // Optional: show a hint that you must tap Edit to add images
                  Get.snackbar(
                    'Read-only'.tr,
                    'Tap Edit to add/replace this image.'.tr,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
                return;
              }

              // EDIT / NEW MODE → open appropriate picker
              if (index == 0) {
                showDocumentPickerBottomSheet(fileController, isPassport: true);
              } else {
                showPickerBottomSheet(fileController);
              }
            },
            child: Container(
              height: getSize(70),
              width: getSize(70),
              decoration: BoxDecoration(
                border: Border.all(
                  color: (!readOnly && !hasImage) ? Colors.red : ColorConstant.logoSecondColor,
                ),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[100],
              ),
              child: Center(
                child: !hasImage
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            readOnly ? Icons.image_not_supported : Icons.upload,
                            size: 32,
                            color: (!readOnly && !hasImage) ? Colors.red : Colors.black38,
                          ),
                          Text(
                            readOnly ? 'No Image'.tr : 'Required'.tr,
                            style: TextStyle(
                              color: (!readOnly && !hasImage) ? Colors.red : Colors.black54,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      )
                    : CustomImageView(
                        image: fileController.value,
                        height: getSize(50),
                        width: getSize(50),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: getSize(80),
            height: getVerticalSize(32),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: (!readOnly && !hasImage) ? Colors.red : Colors.black,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    });
  }

  void showDocumentPickerBottomSheet(Rxn<String> image, {bool isPassport = false}) {
    unfocusAll(); // Use the new method to unfocus all fields

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 20),
            buildBottomSheetOption(
              title: "National ID".tr,
              icon: Icons.credit_card,
              onTap: () {
                showPickerBottomSheet(image, isPassport: true);
              },
            ),
            const SizedBox(height: 12),
            buildBottomSheetOption(
              title: "Passport".tr,
              icon: Icons.flight,
              onTap: () {
                openIDImagePickerScreen();
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  void openIDImagePickerScreen() async {
    final result = await Get.to(() => IDImagePickerScreen());

    if (result != null) {
      controller.idImage.value = result['id1'];
      controller.id2Image.value = result['id2'];
      Fluttertoast.showToast(msg: "Both images captured successfully".tr);
    }
  }

  void handleImageCapture() async {
    final capturedImage = await function.SingleImagePicker(ImageSource.camera);

    if (capturedImage == null) return;

    if (controller.idImage.value == null) {
      controller.idImage.value = capturedImage.path;
      Fluttertoast.showToast(msg: "Face image captured".tr);
    } else if (controller.id2Image.value == null) {
      controller.id2Image.value = capturedImage.path;
      Fluttertoast.showToast(msg: "Back image captured".tr);
    } else {
      controller.id2Image.value = capturedImage.path;
      Fluttertoast.showToast(msg: "Back image updated".tr);
    }
  }
}

void showPickerBottomSheet(Rxn<String> image, {bool isPassport = false}) {
  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 20),
          buildBottomSheetOption(
            title: "Chose from Gallery".tr,
            icon: Icons.photo_library,
            onTap: () {
              function.SingleImagePicker(ImageSource.gallery).then((value) {
                if (value != null) {
                  image.value = value.path;
                }
                Get.back();
                if (isPassport) {
                  Get.back();
                }
              });
            },
          ),
          const SizedBox(height: 12),
          buildBottomSheetOption(
            title: "Capture from Camera".tr,
            icon: Icons.photo_library,
            onTap: () {
              function.SingleImagePicker(ImageSource.camera).then((value) {
                if (value != null) {
                  image.value = value.path;
                }
                Get.back();
                if (isPassport) {
                  Get.back();
                }
              });
            },
          ),
        ],
      ),
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
  );
}

Widget buildBottomSheetOption({
  required String title,
  required IconData icon,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.black54),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    ),
  );
}

void showTermsDialog(bool isPayment, String terms) {
  AwesomeDialog(
    width: Get.width < 1000 ? 350 : 600,
    context: Get.context!,
    dismissOnBackKeyPress: true,
    dismissOnTouchOutside: false,
    dialogType: DialogType.info,
    body: ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: Get.height * 0.7,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        'Terms and Conditions'.tr,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    TermsWidget(terms: terms)
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            child: Row(
              children: [
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    label: Text('Accept'.tr, style: TextStyle(fontSize: getFontSize(13))),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MainColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(44),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5), // ← 5px radius
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      if (isPayment) {
                        globalController.paymentAgreedToTerms.value = true;
                      } else {
                        final controller = Get.find<StoreRequestController>();
                        controller.agreedToTerms.value = true;
                      }
                      Get.back();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    label: Text('Decline'.tr, style: TextStyle(fontSize: getFontSize(13))),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(44),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5), // ← 5px radius
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      if (isPayment) {
                        globalController.paymentAgreedToTerms.value = false;
                      } else {
                        final controller = Get.find<StoreRequestController>();
                        controller.agreedToTerms.value = false;
                      }
                      Get.back();
                    },
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          )
        ],
      ),
    ),
  ).show();
}

class AppBarActionsDropdown extends StatefulWidget {
  final dynamic controller; // your GetX controller type
  const AppBarActionsDropdown({Key? key, required this.controller}) : super(key: key);

  @override
  State<AppBarActionsDropdown> createState() => _AppBarActionsDropdownState();
}

class _AppBarActionsDropdownState extends State<AppBarActionsDropdown> {
  bool _menuOpen = false;

  // ⬇️ Change this value to push the menu further down
  static const double _menuYOffset = 60;

  Future<void> _openMenuAtButton(BuildContext ctx, List<PopupMenuEntry<_Action>> items) async {
    final RenderBox button = ctx.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(ctx).context.findRenderObject() as RenderBox;

    final Offset topLeft = button.localToGlobal(Offset.zero, ancestor: overlay);
    final Offset bottomRight = button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay);

    final pos = RelativeRect.fromRect(
      Rect.fromPoints(
        topLeft + const Offset(0, _menuYOffset),
        bottomRight + const Offset(0, _menuYOffset),
      ),
      Offset.zero & overlay.size,
    );

    setState(() => _menuOpen = true);
    final selected = await showMenu<_Action>(
      context: ctx,
      position: pos,
      elevation: 0,
      color: ColorConstant.whiteA700,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      items: items,
    );
    setState(() => _menuOpen = false);

    if (selected == null) return;

    final c = widget.controller;
    HapticFeedback.selectionClick();

    switch (selected) {
      case _Action.edit:
        c.editing.value = true;
        break;

      case _Action.cancel:
        c.fillFromStoreRequest(c.args!);
        c.editing.value = false;
        break;

      case _Action.save:
        if (c.sendingRequest.value == true) return;
        if (c.formKey.currentState?.validate() != true) {
          Ui.flutterToast("Please fill all required fields".tr, Toast.LENGTH_SHORT, Colors.red, Colors.white);
          return;
        }
        await c.updateRequestForm();
        break;

      case _Action.delete:
        final confirmed = await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (ctx) => _ConfirmDeleteDialog(),
        );
        if (confirmed == true) {
          try {
            await c.deleteRequest();
            if (context.mounted) Get.back();
          } catch (e) {
            Ui.flutterToast('Delete failed'.tr, Toast.LENGTH_SHORT, Colors.red, Colors.white);
          }
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;

    return Obx(() {
      final hasArgs = c.args != null;
      final isEditing = c.editing.value as bool;
      final isSending = c.sendingRequest.value as bool;

      // Build the dynamic menu items
      final items = <PopupMenuEntry<_Action>>[];

      if (hasArgs && isEditing) {
        items.addAll([
          const PopupMenuItem<_Action>(
            value: _Action.cancel,
            child: Row(
              children: [
                Icon(Icons.close, color: Colors.red),
                SizedBox(width: 12),
                Text('Cancel'),
              ],
            ),
          ),
          PopupMenuItem<_Action>(
            enabled: !isSending,
            value: _Action.save,
            child: Row(
              children: [
                if (isSending) const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) else const Icon(Icons.check, color: Colors.green),
                const SizedBox(width: 12),
                Text(isSending ? 'Saving…' : 'Save'),
              ],
            ),
          ),
          const PopupMenuDivider(),
        ]);
      }

      if (hasArgs && !isEditing) {
        items.add(
          const PopupMenuItem<_Action>(
            value: _Action.edit,
            child: Row(
              children: [
                Icon(Icons.edit, color: Colors.black87),
                SizedBox(width: 12),
                Text('Edit'),
              ],
            ),
          ),
        );
        items.add(const PopupMenuDivider());
      }

      if (hasArgs) {
        items.add(
          const PopupMenuItem<_Action>(
            value: _Action.delete,
            child: Row(
              children: [
                Icon(Icons.delete_forever, color: Colors.red),
                SizedBox(width: 12),
                Text('Delete request'),
              ],
            ),
          ),
        );
      }

      if (items.isEmpty) return const SizedBox.shrink();

      // Trigger (no splash/highlight/shadow)
      return Padding(
        padding: const EdgeInsets.only(right: 4.0),
        child: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
          ),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _openMenuAtButton(context, items), // 👈 manual open with offset
            child: AnimatedRotation(
              duration: const Duration(milliseconds: 200),
              turns: _menuOpen ? 0.25 : 0.0,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.more_horiz,
                  color: !isEditing ? Colors.black : Colors.red,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _ConfirmDeleteDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    StoreRequestController c = Get.find<StoreRequestController>();
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_rounded, size: 40, color: Colors.red),
            const SizedBox(height: 12),
            Text('Delete request?'.tr, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'This action cannot be undone.'.tr,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black54),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: Text('Cancel'.tr),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        StoreRequestController controller = Get.find<StoreRequestController>();
                        controller.deleteStoreById(controller.args!.id);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Obx(
                        () => c.deletingRequest.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                              )
                            : Text('Delete'.tr),
                      )),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
