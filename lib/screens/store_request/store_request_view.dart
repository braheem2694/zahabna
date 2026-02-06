import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/routes/app_routes.dart';
import 'package:iq_mall/screens/store_request/widgets/map_location.dart';
import 'package:iq_mall/screens/store_request/widgets/passport_widget.dart';
import 'package:iq_mall/widgets/html_widget.dart';
import '../../main.dart';
import '../../models/functions.dart';
import '../../utils/ShColors.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/image_viewer.dart';
import '../SignIn_screen/controller/SignIn_controller.dart';
import '../TermsAndConditions_screen/terms_widget.dart';
import 'store_request_controller.dart';
import 'package:flutter/services.dart';
import 'package:iq_mall/widgets/Ui.dart';

// ═══════════════════════════════════════════════════════════════════════════
// ✨ Simple & Cute Gold Theme
// ═══════════════════════════════════════════════════════════════════════════

class _Theme {
  // Soft Colors
  static Color get gold => ColorConstant.logoSecondColor;
  static Color get primary => ColorConstant.logoFirstColor;
  static Color get background => const Color(0xFFFFFBF5);
  static Color get card => Colors.white;
  static Color get text => const Color(0xFF2D2D2D);
  static Color get textLight => const Color(0xFF999999);
  static Color get error => const Color(0xFFFF6B6B);
  static Color get success => const Color(0xFF51CF66);
  static Color get border => const Color(0xFFE5E7EB);

  // Simple Card
  static BoxDecoration get cardDecoration => BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gold.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      );

  // Simple Input
  static InputDecoration inputStyle(String label,
      {IconData? icon, Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: textLight, fontSize: 14),
      floatingLabelStyle: TextStyle(color: gold, fontSize: 14),
      filled: true,
      fillColor: background,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      prefixIcon: icon != null ? Icon(icon, color: gold, size: 20) : null,
      suffixIcon: suffix,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: gold, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: error, width: 1.5),
      ),
      errorStyle: TextStyle(color: error, fontSize: 11),
    );
  }
}

enum _Action { edit, cancel, save, delete, enable, transactions }

class StoreRequestView extends GetView<StoreRequestController> {
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
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode subscriptionMonthsFocus = FocusNode();

  final GlobalKey documentsCardKey = GlobalKey();
  final RxBool showDocumentValidation = false.obs;

  StoreRequestView({super.key});

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
    emailFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isReadOnly =
          controller.args != null && !controller.editing.value;
      final bool isUploading = controller.isUploading.value;
      print("emailcontroller" + controller.emailController.text);

      return PopScope(
        canPop: !isUploading,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop && isUploading) {
            Get.snackbar(
              'Upload in Progress'.tr,
              'Please wait for images to finish uploading'.tr,
              backgroundColor: _Theme.gold,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
              margin: const EdgeInsets.all(16),
            );
          }
        },
        child: Stack(
          children: [
            AbsorbPointer(
              absorbing: isUploading,
              child: Scaffold(
                backgroundColor: _Theme.background,
                appBar: _buildAppBar(),
                body: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        // ═══════════════════════════════════════════════════════
                        // 👤 PERSONAL INFORMATION CARD
                        // ═══════════════════════════════════════════════════════
                        _buildCard(
                          icon: Icons.person_outline_rounded,
                          title: 'Personal Information',
                          subtitle: 'Your identity details',
                          color: _Theme.primary,
                          children: [
                            _buildField(
                              label: 'Full Name',
                              controller: controller.subscriberNameController,
                              focusNode: subscriberNameFocus,
                              icon: Icons.badge_outlined,
                              isReadOnly: isReadOnly,
                              validator: (v) =>
                                  v?.isEmpty ?? true ? 'Required'.tr : null,
                            ),
                            _buildField(
                              label: 'Mother\'s Name',
                              controller: controller.motherNameController,
                              focusNode: motherNameFocus,
                              icon: Icons.family_restroom_outlined,
                              isReadOnly: isReadOnly,
                              validator: (v) =>
                                  v?.isEmpty ?? true ? 'Required'.tr : null,
                            ),
                            _buildDateField(
                              label: 'Date of Birth',
                              controller: controller.birthDay,
                              focusNode: birthDayFocus,
                              isReadOnly: isReadOnly,
                              context: context,
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // ═══════════════════════════════════════════════════════
                        // 🏪 STORE INFORMATION CARD
                        // ═══════════════════════════════════════════════════════
                        _buildCard(
                          icon: Icons.store_mall_directory_outlined,
                          title: 'Store Information',
                          subtitle: 'Your business details',
                          color: _Theme.gold,
                          children: [
                            _buildField(
                              label: 'Store Name',
                              controller: controller.storeNameController,
                              focusNode: storeNameFocus,
                              icon: Icons.storefront_outlined,
                              isReadOnly: isReadOnly,
                              validator: (v) =>
                                  v?.isEmpty ?? true ? 'Required'.tr : null,
                            ),
                            _buildPhoneField(context, isReadOnly),
                            _buildField(
                              label: 'Email Address',
                              controller: controller.emailController,
                              focusNode: emailFocusNode,
                              icon: Icons.email_outlined,
                              isReadOnly: isReadOnly,
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) {
                                if (v == null || v.isEmpty)
                                  return 'Required'.tr;
                                if (!GetUtils.isEmail(v))
                                  return 'Invalid email'.tr;
                                return null;
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // ═══════════════════════════════════════════════════════
                        // 📍 LOCATION CARD
                        // ═══════════════════════════════════════════════════════
                        _buildCard(
                          icon: Icons.location_on_outlined,
                          title: 'Location',
                          subtitle: 'Where is your store?',
                          color: const Color(0xFF8B5CF6),
                          children: [
                            Obx(() => _buildField(
                                  label: 'Country',
                                  controller: TextEditingController(
                                      text: globalController.countryName.value),
                                  focusNode: countryFocus,
                                  icon: Icons.public_outlined,
                                  isReadOnly: isReadOnly,
                                  validator: (v) =>
                                      v?.isEmpty ?? true ? 'Required'.tr : null,
                                )),
                            _buildField(
                              label: 'Region / City',
                              controller: controller.regionController,
                              focusNode: regionFocus,
                              icon: Icons.map_outlined,
                              isReadOnly: isReadOnly,
                              validator: (v) =>
                                  v?.isEmpty ?? true ? 'Required'.tr : null,
                            ),
                            _buildField(
                              label: 'Street Address',
                              controller: controller.addressController,
                              focusNode: addressFocus,
                              icon: Icons.home_outlined,
                              isReadOnly: isReadOnly,
                              validator: (v) =>
                                  v?.isEmpty ?? true ? 'Required'.tr : null,
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // ═══════════════════════════════════════════════════════
                        // 📄 DOCUMENTS CARD
                        // ═══════════════════════════════════════════════════════
                        _buildDocumentsCard(isReadOnly),

                        const SizedBox(height: 16),

                        // ═══════════════════════════════════════════════════════
                        // 🗺️ MAP CARD
                        // ═══════════════════════════════════════════════════════
                        _buildMapCard(isReadOnly),

                        const SizedBox(height: 16),

                        // ═══════════════════════════════════════════════════════
                        // ✅ TERMS & SUMMARY
                        // ═══════════════════════════════════════════════════════
                        _buildTermsCard(isReadOnly),

                        const SizedBox(height: 16),

                        _buildPricingCard(),

                        const SizedBox(height: 24),

                        // Submit Button
                        if (controller.args == null) _buildSubmitButton(),

                        // Update Button (for editing)
                        if (controller.editing.value) _buildUpdateButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Upload Loading Overlay
            if (isUploading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 24,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: _Theme.gold.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: _Theme.gold.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation(_Theme.gold),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Uploading Images...'.tr,
                            style: TextStyle(
                              color: _Theme.text,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Please wait, do not close this screen'.tr,
                            style: TextStyle(
                              color: _Theme.textLight,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Obx(() => Text(
                                '${controller.uploadProgress.value}%',
                                style: TextStyle(
                                  color: _Theme.gold,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      leading: _Pressable(
        onTap: () {
          if (controller.isUploading.value) {
            Get.snackbar(
              'Upload in Progress'.tr,
              'Please wait for images to finish uploading'.tr,
              backgroundColor: _Theme.gold,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
              margin: const EdgeInsets.all(16),
            );
            return;
          }
          Get.back();
        },
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _Theme.gold.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.arrow_back_ios_new_rounded,
              color: _Theme.primary, size: 18),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Store Request'.tr,
            style: TextStyle(
                color: _Theme.primary,
                fontSize: 18,
                fontWeight: FontWeight.w700),
          ),
          Text(
            'Complete your application'.tr,
            style: TextStyle(
                color: _Theme.textLight,
                fontSize: 12,
                fontWeight: FontWeight.w400),
          ),
        ],
      ),
      actions: [AppBarActionsDropdown(controller: controller)],
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required List<Widget> children,
  }) {
    return Container(
      decoration: _Theme.cardDecoration,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Simple Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.tr,
                      style: TextStyle(
                        color: _Theme.text,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle.tr,
                      style: TextStyle(color: _Theme.textLight, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Fields
          ...children
              .map((child) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: child,
                  ))
              .toList(),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 📝 FORM FIELDS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
    required IconData icon,
    required bool isReadOnly,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return IgnorePointer(
      ignoring: isReadOnly,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        style: TextStyle(
            color: _Theme.text, fontSize: 15, fontWeight: FontWeight.w500),
        decoration: _Theme.inputStyle(label.tr, icon: icon),
        validator: validator,
        textDirection: prefs?.getString("locale") == "en"
            ? TextDirection.ltr
            : TextDirection.rtl,
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
    required bool isReadOnly,
    required BuildContext context,
  }) {
    return IgnorePointer(
      ignoring: isReadOnly,
      child: GestureDetector(
        onTap: () => _pickDate(context),
        child: AbsorbPointer(
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            readOnly: true,
            style: TextStyle(
                color: _Theme.text, fontSize: 15, fontWeight: FontWeight.w500),
            decoration: _Theme.inputStyle(
              label.tr,
              icon: Icons.cake_outlined,
              suffix: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _Theme.gold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.calendar_today_rounded,
                    color: _Theme.gold, size: 18),
              ),
            ),
            validator: (v) => v?.isEmpty ?? true ? 'Required'.tr : null,
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.light(
            primary: _Theme.gold,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: _Theme.text,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      controller.birthDay.text = intl.DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Widget _buildPhoneField(BuildContext context, bool isReadOnly) {
    return IgnorePointer(
      ignoring: isReadOnly,
      child: Container(
        decoration: BoxDecoration(
          color: _Theme.background,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Country Code Picker
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: _Theme.gold.withOpacity(0.1),
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(16),
                ),
              ),
              child: CodePicker(context, countryCode: country_code),
            ),
            // Phone Number Field
            Expanded(
              child: TextFormField(
                controller: controller.phoneNumberController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: TextStyle(
                  color: _Theme.text,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'Phone number'.tr,
                  hintStyle: TextStyle(color: _Theme.textLight, fontSize: 14),
                  filled: true,
                  fillColor: Colors.transparent,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(16),
                    ),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(16),
                    ),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(16),
                    ),
                    borderSide: BorderSide(color: _Theme.gold, width: 1.5),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(16),
                    ),
                    borderSide: BorderSide(color: _Theme.error, width: 1.5),
                  ),
                  errorStyle: TextStyle(color: _Theme.error, fontSize: 11),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Required'.tr;
                  if (v.length < 8) return 'Phone number too short'.tr;
                  if (v.length > 15) return 'Phone number too long'.tr;
                  return null;
                },
                textDirection: prefs?.getString("locale") == "en"
                    ? TextDirection.ltr
                    : TextDirection.rtl,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 📄 DOCUMENTS CARD
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildDocumentsCard(bool isReadOnly) {
    return Container(
      key: documentsCardKey,
      decoration: _Theme.cardDecoration,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Simple Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.folder_outlined,
                    color: Color(0xFFF59E0B), size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Required Documents'.tr,
                      style: TextStyle(
                        color: _Theme.text,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Upload your verification files'.tr,
                      style: TextStyle(color: _Theme.textLight, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Documents Grid
          Row(
            children: [
              _buildDocumentItem('ID Card'.tr, Icons.credit_card_outlined,
                  controller.idImage, 0, isReadOnly),
              _buildDocumentItem('Selfie'.tr, Icons.face_outlined,
                  controller.selfieImage, 1, isReadOnly),
              _buildDocumentItem('Store'.tr, Icons.store_outlined,
                  controller.storeImage, 2, isReadOnly),
              _buildDocumentItem('Logo'.tr, Icons.image_outlined,
                  controller.logoImage, 3, isReadOnly),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentItem(String label, IconData icon,
      Rxn<String> imageController, int index, bool isReadOnly) {
    return Expanded(
      child: Obx(() {
        final hasImage = imageController.value?.isNotEmpty ?? false;
        final bool readOnly =
            controller.args != null && !controller.editing.value;

        // Check if this is an ID card with 2 images (National ID)
        final bool isNationalIdWithTwoImages = index == 0 &&
            (controller.idImage.value?.isNotEmpty ?? false) &&
            (controller.id2Image.value?.isNotEmpty ?? false);

        return _Pressable(
          onTap: () {
            unfocusAll();
            if (readOnly) {
              if (isNationalIdWithTwoImages) {
                // Open gallery viewer for both images
                _openNationalIdGallery();
                return;
              }
              if (hasImage) {
                Get.to(() =>
                    FullScreenImageViewer(imageUrl: imageController.value!));
              }
              return;
            }
            if (index == 0) {
              showDocumentPickerBottomSheet(imageController, isPassport: true);
            } else {
              _showImagePicker(imageController);
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 90,
                  width: getHorizontalSize(120),
                  decoration: BoxDecoration(
                    color: hasImage
                        ? _Theme.gold.withOpacity(0.1)
                        : _Theme.background,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: hasImage
                          ? _Theme.gold
                          : (showDocumentValidation.value && !hasImage
                              ? _Theme.error
                              : (!readOnly && !hasImage
                                  ? _Theme.error.withOpacity(0.5)
                                  : _Theme.textLight.withOpacity(0.2))),
                      width: hasImage ||
                              (showDocumentValidation.value && !hasImage)
                          ? 2
                          : 1,
                    ),
                  ),
                  child: hasImage
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CustomImageView(
                                  image: imageController.value,
                                  fit: BoxFit.cover),
                              // Badge for 2 images (National ID)
                              if (isNationalIdWithTwoImages)
                                Positioned(
                                  top: 6,
                                  right: 6,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          _Theme.primary,
                                          _Theme.primary.withOpacity(0.85),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              _Theme.primary.withOpacity(0.4),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.25),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.photo_library_rounded,
                                            color: Colors.white,
                                            size: 10,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Text(
                                          '2',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              Positioned(
                                bottom: 4,
                                right: 4,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: _Theme.success,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.check,
                                      color: Colors.white, size: 10),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              icon,
                              color: !readOnly && !hasImage
                                  ? _Theme.error.withOpacity(0.6)
                                  : _Theme.textLight,
                              size: 32,
                            ),
                            const SizedBox(height: 4),
                            Icon(
                              Icons.add_circle_outline,
                              color: !readOnly && !hasImage
                                  ? _Theme.error.withOpacity(0.6)
                                  : _Theme.gold,
                              size: 18,
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: !readOnly && !hasImage ? _Theme.error : _Theme.text,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  /// Opens a gallery view for National ID with front and back images
  void _openNationalIdGallery() {
    final images = <String>[];
    if (controller.idImage.value != null) images.add(controller.idImage.value!);
    if (controller.id2Image.value != null)
      images.add(controller.id2Image.value!);

    Get.to(() => _NationalIdGalleryViewer(
          images: images,
          titles: ['ID Front'.tr, 'ID Back'.tr],
        ));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 🗺️ MAP CARD
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildMapCard(bool isReadOnly) {
    return Container(
      decoration: _Theme.cardDecoration,
      child: Column(
        children: [
          // Simple Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.pin_drop_outlined,
                      color: Color(0xFF3B82F6), size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pin Store Location'.tr,
                        style: TextStyle(
                          color: _Theme.text,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Drag the marker to set location'.tr,
                        style: TextStyle(color: _Theme.textLight, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Map
          IgnorePointer(
            ignoring: isReadOnly,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(20)),
              child: SizedBox(
                height: Get.height * 0.4,
                child: StoreLocationPicker(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ✅ TERMS CARD
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildTermsCard(bool isReadOnly) {
    return Obx(() => _Pressable(
          onTap: isReadOnly
              ? null
              : () {
                  if (controller.agreedToTerms.value) {
                    controller.agreedToTerms.value = false;
                  } else {
                    showTermsDialog(false, controller.termsConditions.value);
                  }
                },
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _Theme.card,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: controller.agreedToTerms.value
                    ? _Theme.success
                    : _Theme.textLight.withOpacity(0.2),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: controller.agreedToTerms.value
                      ? _Theme.success.withOpacity(0.1)
                      : _Theme.gold.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: controller.agreedToTerms.value
                        ? _Theme.success
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: controller.agreedToTerms.value
                          ? _Theme.success
                          : _Theme.gold,
                      width: 2,
                    ),
                  ),
                  child: controller.agreedToTerms.value
                      ? const Icon(Icons.check_rounded,
                          color: Colors.white, size: 16)
                      : null,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Terms & Conditions'.tr,
                        style: TextStyle(
                          color: _Theme.text,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        controller.agreedToTerms.value
                            ? 'Accepted ✓'.tr
                            : 'Tap to read and accept'.tr,
                        style: TextStyle(
                          color: controller.agreedToTerms.value
                              ? _Theme.success
                              : _Theme.textLight,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _Theme.gold.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.article_outlined,
                      color: _Theme.gold, size: 20),
                ),
              ],
            ),
          ),
        ));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 💰 PRICING CARD
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildPricingCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _Theme.gold,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _Theme.gold.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.diamond_outlined,
                color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Subscription Fee'.tr,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Obx(() => Text(
                      '${globalController.homeDataList.value.requestPrice ?? 0}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    )),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Total'.tr,
              style: TextStyle(
                color: _Theme.gold,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 🚀 SUBMIT BUTTON
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildSubmitButton() {
    return Obx(() {
      final isLoading =
          controller.sendingRequest.value || controller.isUploading.value;

      return _Pressable(
        onTap: isLoading
            ? null
            : () {
                // Check Documents
                if (controller.idImage.value == null ||
                    controller.idImage.value!.isEmpty ||
                    controller.selfieImage.value == null ||
                    controller.selfieImage.value!.isEmpty ||
                    controller.storeImage.value == null ||
                    controller.storeImage.value!.isEmpty ||
                    controller.logoImage.value == null ||
                    controller.logoImage.value!.isEmpty) {
                  showDocumentValidation.value = true;
                  Scrollable.ensureVisible(documentsCardKey.currentContext!,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                  Get.snackbar(
                    'Documents Required'.tr,
                    'Please upload all required documents'.tr,
                    backgroundColor: _Theme.error,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                    margin: const EdgeInsets.all(16),
                  );
                  return;
                }

                if (!controller.agreedToTerms.value) {
                  Get.snackbar(
                    'Terms Required'.tr,
                    'Please accept the terms and conditions'.tr,
                    backgroundColor: _Theme.error,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                    margin: const EdgeInsets.all(16),
                  );
                  return;
                }
                controller.submitRequest();
              },
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: _Theme.primary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _Theme.primary.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: isLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        controller.isUploading.value
                            ? 'Uploading (${controller.uploadProgress.value}/${controller.totalImages.value})'
                                .tr
                            : 'Submitting...'.tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.send_rounded,
                          color: Colors.white, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        'Submit Request'.tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      );
    });
  }

  Widget _buildUpdateButton() {
    return Obx(() => _Pressable(
          onTap: controller.sendingRequest.value
              ? null
              : () => controller.updateRequestForm(),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: _Theme.gold,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: _Theme.gold.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: controller.sendingRequest.value
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.save_rounded,
                            color: Colors.white, size: 20),
                        const SizedBox(width: 10),
                        Text(
                          'Update Request'.tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 📷 IMAGE PICKER
  // ═══════════════════════════════════════════════════════════════════════════

  void _showImagePicker(Rxn<String> image) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: _Theme.border,
                        borderRadius: BorderRadius.circular(2))),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: _Theme.gold.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12)),
                      child: Icon(Icons.add_photo_alternate_outlined,
                          color: _Theme.gold, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Text('Add Image'.tr,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: _Theme.text)),
                  ],
                ),
                const SizedBox(height: 20),
                _buildPickerOption(
                  icon: Icons.photo_library_outlined,
                  title: 'Gallery'.tr,
                  subtitle: 'Choose from photos'.tr,
                  onTap: () {
                    function.SingleImagePicker(ImageSource.gallery).then((v) {
                      if (v != null) image.value = v.path;
                      Get.back();
                    });
                  },
                ),
                const SizedBox(height: 12),
                _buildPickerOption(
                  icon: Icons.camera_alt_outlined,
                  title: 'Camera'.tr,
                  subtitle: 'Take a new photo'.tr,
                  onTap: () {
                    function.SingleImagePicker(ImageSource.camera).then((v) {
                      if (v != null) image.value = v.path;
                      Get.back();
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  Widget _buildPickerOption(
      {required IconData icon,
      required String title,
      required String subtitle,
      required VoidCallback onTap}) {
    return _Pressable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _Theme.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  _Theme.gold.withOpacity(0.1),
                  _Theme.gold.withOpacity(0.15)
                ]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: _Theme.gold, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          color: _Theme.text,
                          fontSize: 15,
                          fontWeight: FontWeight.w600)),
                  Text(subtitle,
                      style: TextStyle(color: _Theme.textLight, fontSize: 12)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: _Theme.gold, size: 24),
          ],
        ),
      ),
    );
  }

  void showDocumentPickerBottomSheet(Rxn<String> image,
      {bool isPassport = false}) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: _Theme.border,
                        borderRadius: BorderRadius.circular(2))),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: _Theme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12)),
                      child: Icon(Icons.badge_outlined,
                          color: _Theme.primary, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Text('Document Type'.tr,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: _Theme.text)),
                  ],
                ),
                const SizedBox(height: 20),
                _buildPickerOption(
                  icon: Icons.credit_card_outlined,
                  title: 'National ID'.tr,
                  subtitle: 'Front and back images'.tr,
                  onTap: () => openIDImagePickerScreen(),
                ),
                const SizedBox(height: 12),
                _buildPickerOption(
                  icon: Icons.flight_outlined,
                  title: 'Passport'.tr,
                  subtitle: 'Single page image'.tr,
                  onTap: () {
                    Get.back();
                    _showImagePicker(image);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  void openIDImagePickerScreen({String? idImage, String? id2Image}) async {
    final result = await Get.to(
        () => IDImagePickerScreen(idImage: idImage, id2Image: id2Image));
    if (result != null) {
      controller.idImage.value = result['id1'];
      controller.id2Image.value = result['id2'];
      Fluttertoast.showToast(msg: "Images captured successfully".tr);
    }
  }

  void handleImageCapture() async {
    final capturedImage = await function.SingleImagePicker(ImageSource.camera);
    if (capturedImage == null) return;
    if (controller.idImage.value == null) {
      controller.idImage.value = capturedImage.path;
    } else {
      controller.id2Image.value = capturedImage.path;
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// 🎯 PRESSABLE WIDGET
// ═══════════════════════════════════════════════════════════════════════════

class _Pressable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  const _Pressable({required this.child, this.onTap});

  @override
  State<_Pressable> createState() => _PressableState();
}

class _PressableState extends State<_Pressable> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 100),
        child: AnimatedOpacity(
            opacity: _pressed ? 0.8 : 1,
            duration: const Duration(milliseconds: 100),
            child: widget.child),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// 📋 APP BAR DROPDOWN & DIALOGS (Keeping existing logic)
// ═══════════════════════════════════════════════════════════════════════════

void showPickerBottomSheet(Rxn<String> image, {bool isPassport = false}) {
  Get.bottomSheet(
    Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: _Theme.border,
                      borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 20),
              _buildGlobalOption(Icons.photo_library_outlined, "Gallery".tr,
                  () {
                function.SingleImagePicker(ImageSource.gallery).then((v) {
                  if (v != null) image.value = v.path;
                  Get.back();
                  if (isPassport) Get.back();
                });
              }),
              const SizedBox(height: 12),
              _buildGlobalOption(Icons.camera_alt_outlined, "Camera".tr, () {
                function.SingleImagePicker(ImageSource.camera).then((v) {
                  if (v != null) image.value = v.path;
                  Get.back();
                  if (isPassport) Get.back();
                });
              }),
            ],
          ),
        ),
      ),
    ),
    backgroundColor: Colors.transparent,
  );
}

Widget _buildGlobalOption(IconData icon, String title, VoidCallback onTap) {
  return _Pressable(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Icon(icon, color: _Theme.gold, size: 24),
          const SizedBox(width: 12),
          Text(title,
              style: TextStyle(
                  color: _Theme.text,
                  fontSize: 15,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    ),
  );
}

Widget buildBottomSheetOption(
    {required String title,
    required IconData icon,
    required VoidCallback onTap}) {
  return _Pressable(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Icon(icon, size: 24, color: _Theme.gold),
          const SizedBox(width: 12),
          Text(title,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: _Theme.text)),
        ],
      ),
    ),
  );
}

void showTermsDialog(bool isPayment, String terms) {
  AwesomeDialog(
    width: Get.width < 1000 ? 360 : 600,
    context: Get.context!,
    dismissOnBackKeyPress: true,
    dismissOnTouchOutside: false,
    dialogType: DialogType.noHeader,
    body: ConstrainedBox(
      constraints: BoxConstraints(maxHeight: Get.height * 0.7),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                _Theme.gold.withOpacity(0.1),
                _Theme.gold.withOpacity(0.05)
              ]),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: _Theme.gold.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8)),
                  child:
                      Icon(Icons.gavel_rounded, color: _Theme.gold, size: 20),
                ),
                const SizedBox(width: 12),
                Text('Terms & Conditions'.tr,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: _Theme.text)),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: TermsWidget(terms: terms),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _Pressable(
                    onTap: () {
                      if (isPayment)
                        globalController.paymentAgreedToTerms.value = false;
                      else
                        Get.find<StoreRequestController>().agreedToTerms.value =
                            false;
                      Get.back();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: _Theme.error.withOpacity(0.3)),
                      ),
                      child: Center(
                          child: Text('Decline'.tr,
                              style: TextStyle(
                                  color: _Theme.error,
                                  fontWeight: FontWeight.w600))),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _Pressable(
                    onTap: () {
                      if (isPayment)
                        globalController.paymentAgreedToTerms.value = true;
                      else
                        Get.find<StoreRequestController>().agreedToTerms.value =
                            true;
                      Get.back();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                          color: _Theme.success,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Text('Accept'.tr,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600))),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  ).show();
}

class AppBarActionsDropdown extends StatefulWidget {
  final StoreRequestController controller;
  const AppBarActionsDropdown({super.key, required this.controller});

  @override
  State<AppBarActionsDropdown> createState() => _AppBarActionsDropdownState();
}

class _AppBarActionsDropdownState extends State<AppBarActionsDropdown> {
  bool _menuOpen = false;

  Future<void> _openMenu(
      BuildContext ctx, List<PopupMenuEntry<_Action>> items) async {
    final RenderBox button = ctx.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(ctx).context.findRenderObject() as RenderBox;
    final Offset topLeft = button.localToGlobal(Offset.zero, ancestor: overlay);
    final pos = RelativeRect.fromRect(
      Rect.fromLTWH(
          topLeft.dx, topLeft.dy + 50, button.size.width, button.size.height),
      Offset.zero & overlay.size,
    );

    setState(() => _menuOpen = true);
    final selected = await showMenu<_Action>(
        context: ctx,
        position: pos,
        elevation: 8,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        items: items);
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
        if (c.sendingRequest.value) return;
        if (c.formKey.currentState?.validate() != true) {
          Ui.flutterToast("Fill all fields".tr, Toast.LENGTH_SHORT,
              _Theme.error, Colors.white);
          return;
        }
        await c.updateRequestForm();
        break;
      case _Action.delete:
        final ok = await showDialog<bool>(
            context: context, builder: (_) => _DeleteDialog());
        if (ok == true) {
          await c.deleteStoreById(c.args!.id);
          if (context.mounted) Get.back();
        }
        break;
      case _Action.enable:
        final ok = await showDialog<bool>(
            context: context, builder: (_) => _EnableDialog());
        if (ok == true) {
          await c.enableStore(c.args!.id);
          if (context.mounted) Get.back();
        }
        break;
      case _Action.transactions:
        Get.toNamed(AppRoutes.transactionsScreen,
            arguments: {'storeRequestId': c.args?.id, 'isStoreRequest': true});
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    return Obx(() {
      final hasArgs = c.args != null;
      final isEditing = c.editing.value;
      final isSending = c.sendingRequest.value;
      final isDeleted = c.args?.status.toLowerCase() == 'deleted';

      final items = <PopupMenuEntry<_Action>>[];
      items.add(PopupMenuItem(
          value: _Action.transactions,
          child: Row(children: [
            Icon(Icons.receipt_long_outlined, color: _Theme.gold),
            const SizedBox(width: 12),
            Text('Transactions'.tr)
          ])));

      if (hasArgs && isDeleted)
        items.add(PopupMenuItem(
            value: _Action.enable,
            child: Row(children: [
              Icon(Icons.check_circle_outline, color: _Theme.success),
              const SizedBox(width: 12),
              Text('Enable'.tr)
            ])));
      if (hasArgs && isEditing && !isDeleted) {
        items.add(PopupMenuItem(
            value: _Action.cancel,
            child: Row(children: [
              Icon(Icons.close, color: _Theme.error),
              const SizedBox(width: 12),
              Text('Cancel'.tr)
            ])));
        items.add(PopupMenuItem(
            enabled: !isSending,
            value: _Action.save,
            child: Row(children: [
              isSending
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(_Theme.gold)))
                  : Icon(Icons.check, color: _Theme.success),
              const SizedBox(width: 12),
              Text(isSending ? 'Saving...'.tr : 'Save'.tr)
            ])));
      }
      if (hasArgs && !isEditing && !isDeleted)
        items.add(PopupMenuItem(
            value: _Action.edit,
            child: Row(children: [
              Icon(Icons.edit_outlined, color: _Theme.gold),
              const SizedBox(width: 12),
              Text('Edit'.tr)
            ])));
      if (hasArgs && !isDeleted)
        items.add(PopupMenuItem(
            value: _Action.delete,
            child: Row(children: [
              Icon(Icons.delete_outline, color: _Theme.error),
              const SizedBox(width: 12),
              Text('Delete'.tr, style: TextStyle(color: _Theme.error))
            ])));

      if (items.isEmpty) return const SizedBox.shrink();

      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: _Pressable(
          onTap: () => _openMenu(context, items),
          child: AnimatedRotation(
            turns: _menuOpen ? 0.25 : 0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color:
                      (isEditing ? _Theme.error : _Theme.gold).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(Icons.more_horiz_rounded,
                  color: isEditing ? _Theme.error : _Theme.primary),
            ),
          ),
        ),
      );
    });
  }
}

class _DeleteDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = Get.find<StoreRequestController>();
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: _Theme.error.withOpacity(0.1),
                    shape: BoxShape.circle),
                child:
                    Icon(Icons.warning_rounded, color: _Theme.error, size: 32)),
            const SizedBox(height: 16),
            Text('Delete Request?'.tr,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _Theme.text)),
            const SizedBox(height: 12),
            SizedBox(
                height: Get.height * 0.3,
                child: SingleChildScrollView(
                    child: HtmlWidget(
                        data: globalController
                                .homeDataList.value.deleteTermsConditions ??
                            ''))),
            const SizedBox(height: 12),
            Obx(() => _Pressable(
                  onTap: () => c.deleteAgreedToTerms.value =
                      !c.deleteAgreedToTerms.value,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: c.deleteAgreedToTerms.value
                            ? _Theme.error.withOpacity(0.05)
                            : const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: c.deleteAgreedToTerms.value
                                ? _Theme.error
                                : _Theme.border)),
                    child: Row(
                      children: [
                        AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                                color: c.deleteAgreedToTerms.value
                                    ? _Theme.error
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    color: c.deleteAgreedToTerms.value
                                        ? _Theme.error
                                        : _Theme.textLight,
                                    width: 2)),
                            child: c.deleteAgreedToTerms.value
                                ? const Icon(Icons.check,
                                    color: Colors.white, size: 14)
                                : null),
                        const SizedBox(width: 12),
                        Text('I agree to the terms'.tr,
                            style: TextStyle(
                                color: _Theme.text,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                    child: _Pressable(
                        onTap: () => Navigator.pop(context, false),
                        child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                                color: const Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: Text('Cancel'.tr,
                                    style: TextStyle(
                                        color: _Theme.textLight,
                                        fontWeight: FontWeight.w600)))))),
                const SizedBox(width: 12),
                Expanded(
                    child: Obx(() => _Pressable(
                        onTap: () {
                          if (!c.deleteAgreedToTerms.value) return;
                          c.deleteStoreById(c.args!.id);
                        },
                        child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                                color: c.deleteAgreedToTerms.value
                                    ? _Theme.error
                                    : _Theme.textLight.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: c.deletingRequest.value
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation(
                                                Colors.white)))
                                    : Text('Delete'.tr,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600))))))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EnableDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = Get.find<StoreRequestController>();
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: _Theme.success.withOpacity(0.1),
                    shape: BoxShape.circle),
                child: Icon(Icons.check_circle_outline,
                    color: _Theme.success, size: 32)),
            const SizedBox(height: 16),
            Text('Enable Request?'.tr,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _Theme.text)),
            const SizedBox(height: 12),
            SizedBox(
                height: Get.height * 0.3,
                child: SingleChildScrollView(
                    child: HtmlWidget(
                        data:
                            globalController.homeDataList.value.requestTerms ??
                                ''))),
            const SizedBox(height: 12),
            Obx(() => _Pressable(
                  onTap: () => c.deleteAgreedToTerms.value =
                      !c.deleteAgreedToTerms.value,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: c.deleteAgreedToTerms.value
                            ? _Theme.success.withOpacity(0.05)
                            : const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: c.deleteAgreedToTerms.value
                                ? _Theme.success
                                : _Theme.border)),
                    child: Row(
                      children: [
                        AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                                color: c.deleteAgreedToTerms.value
                                    ? _Theme.success
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    color: c.deleteAgreedToTerms.value
                                        ? _Theme.success
                                        : _Theme.textLight,
                                    width: 2)),
                            child: c.deleteAgreedToTerms.value
                                ? const Icon(Icons.check,
                                    color: Colors.white, size: 14)
                                : null),
                        const SizedBox(width: 12),
                        Text('I agree to the terms'.tr,
                            style: TextStyle(
                                color: _Theme.text,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                    child: _Pressable(
                        onTap: () => Navigator.pop(context, false),
                        child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                                color: const Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: Text('Cancel'.tr,
                                    style: TextStyle(
                                        color: _Theme.textLight,
                                        fontWeight: FontWeight.w600)))))),
                const SizedBox(width: 12),
                Expanded(
                    child: Obx(() => _Pressable(
                        onTap: () {
                          if (!c.deleteAgreedToTerms.value) return;
                          c.enableStore(c.args!.id);
                        },
                        child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                                color: c.deleteAgreedToTerms.value
                                    ? _Theme.success
                                    : _Theme.textLight.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: c.deletingRequest.value
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation(
                                                Colors.white)))
                                    : Text('Enable'.tr,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600))))))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// 🖼️ NATIONAL ID GALLERY VIEWER
// ═══════════════════════════════════════════════════════════════════════════

class _NationalIdGalleryViewer extends StatefulWidget {
  final List<String> images;
  final List<String> titles;

  const _NationalIdGalleryViewer({
    required this.images,
    required this.titles,
  });

  @override
  State<_NationalIdGalleryViewer> createState() =>
      _NationalIdGalleryViewerState();
}

class _NationalIdGalleryViewerState extends State<_NationalIdGalleryViewer> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: _Pressable(
          onTap: () => Get.back(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.close, color: Colors.white, size: 20),
          ),
        ),
        title: Text(
          widget.titles[_currentIndex],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _Theme.gold.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_currentIndex + 1} / ${widget.images.length}',
              style: TextStyle(
                color: _Theme.gold,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              itemBuilder: (context, index) {
                return InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Center(
                    child: CustomImageView(
                      image: widget.images[index],
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              },
            ),
          ),
          // Thumbnail indicators
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.images.length, (index) {
                final isSelected = index == _currentIndex;
                return GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? _Theme.gold : Colors.white24,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CustomImageView(
                            image: widget.images[index],
                            fit: BoxFit.cover,
                          ),
                          if (!isSelected)
                            Container(color: Colors.black.withOpacity(0.4)),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          // Labels
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.images.length, (index) {
                final isSelected = index == _currentIndex;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  width: 60,
                  child: Text(
                    widget.titles[index],
                    style: TextStyle(
                      color: isSelected ? _Theme.gold : Colors.white54,
                      fontSize: 10,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
