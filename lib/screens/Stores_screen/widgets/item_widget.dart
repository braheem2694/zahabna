import 'dart:convert';
import 'dart:ui';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/main.dart';
import 'package:iq_mall/screens/Stores_screen/widgets/style_bottomsheet.dart';
import 'package:iq_mall/screens/Stores_screen/widgets/video_item.dart';
import 'dart:io';
import 'package:lottie/src/lottie.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/widgets/ui.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/foundation.dart' as fn;

import '../../../cores/assets.dart';
import '../../../utils/ShImages.dart';
import '../../../models/HomeData.dart';
import '../../../models/Stores.dart';
import '../../../widgets/chewie_player.dart';
import '../../../widgets/custom_image_view.dart';
import 'description_widget.dart';
import 'package:iq_mall/models/functions.dart';
import 'package:dio/dio.dart' as dio;
import 'package:percent_indicator/percent_indicator.dart';

import 'item_bottomsheet_widget.dart';

// ═══════════════════════════════════════════════════════════════════════════
// 🎨 APP DESIGN SYSTEM - Using App Main Colors
// ═══════════════════════════════════════════════════════════════════════════

class GoldTheme {
  // Primary Colors (from app's ColorConstant)
  static Color get gold => ColorConstant.logoSecondColor; // #c8a443
  static Color get primary => ColorConstant.logoFirstColor; // #0f0649
  static Color get goldLight => ColorConstant.logoSecondColor.withOpacity(0.7);
  static Color get goldDark => ColorConstant.logoSecondColor;
  static Color get goldAccent => ColorConstant.logoSecondColor.withOpacity(0.2);
  
  // Neutral Palette
  static Color get charcoal => ColorConstant.logoFirstColor;
  static Color get warmGray => ColorConstant.gray500;
  static Color get softGray => ColorConstant.gray400;
  static Color get lightGray => ColorConstant.gray100;
  static Color get cream => ColorConstant.gray50;
  
  // Semantic Colors
  static Color get success => ColorConstant.green500;
  static Color get error => ColorConstant.redA700;
  static Color get info => ColorConstant.blue500;
  
  // Gradients
  static LinearGradient get goldGradient => LinearGradient(
    colors: [goldLight, gold, goldDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static LinearGradient get subtleGoldGradient => LinearGradient(
    colors: [goldAccent.withOpacity(0.3), goldAccent.withOpacity(0.1)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  // Typography
  static TextStyle get headingLarge => TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: charcoal,
    letterSpacing: 0.5,
  );
  
  static TextStyle get headingMedium => TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: charcoal,
    letterSpacing: 0.3,
  );
  
  static TextStyle get labelMedium => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: warmGray,
    letterSpacing: 0.2,
  );
  
  static TextStyle get bodyText => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: warmGray,
  );
  
  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingSM = 8.0;
  static const double spacingMD = 12.0;
  static const double spacingLG = 16.0;
  static const double spacingXL = 24.0;
  
  // Border Radius
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  
  // Shadows
  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
  
  static List<BoxShadow> get goldGlow => [
    BoxShadow(
      color: gold.withOpacity(0.2),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];
  
  // Decorations
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(radiusMD),
    boxShadow: softShadow,
  );
  
  static BoxDecoration get inputDecoration => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(radiusMD),
    border: Border.all(color: goldAccent, width: 1.5),
  );
  
  static BoxDecoration get focusedInputDecoration => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(radiusMD),
    border: Border.all(color: gold, width: 2),
    boxShadow: goldGlow,
  );
}

// ═══════════════════════════════════════════════════════════════════════════
// 🎬 ANIMATED COMPONENTS
// ═══════════════════════════════════════════════════════════════════════════

/// Animated wrapper for smooth scale and opacity transitions
class AnimatedPressable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Duration duration;
  
  const AnimatedPressable({
    Key? key,
    required this.child,
    this.onTap,
    this.duration = const Duration(milliseconds: 150),
  }) : super(key: key);
  
  @override
  State<AnimatedPressable> createState() => _AnimatedPressableState();
}

class _AnimatedPressableState extends State<AnimatedPressable> {
  bool _isPressed = false;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: widget.duration,
        curve: Curves.easeOutCubic,
        child: AnimatedOpacity(
          opacity: _isPressed ? 0.8 : 1.0,
          duration: widget.duration,
          child: widget.child,
        ),
      ),
    );
  }
}

/// Premium Gold Dropdown with smooth animations
class GoldDropdown<T> extends StatefulWidget {
  final String hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final Widget? trailing;
  final bool hasError;
  
  const GoldDropdown({
    Key? key,
    required this.hint,
    this.value,
    required this.items,
    this.onChanged,
    this.trailing,
    this.hasError = false,
  }) : super(key: key);
  
  @override
  State<GoldDropdown<T>> createState() => _GoldDropdownState<T>();
}

class _GoldDropdownState<T> extends State<GoldDropdown<T>> with SingleTickerProviderStateMixin {
  bool _isFocused = false;
  
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      height: getSize(52),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(GoldTheme.radiusMD),
        border: Border.all(
          color: widget.hasError 
              ? GoldTheme.error 
              : _isFocused 
                  ? GoldTheme.gold 
                  : GoldTheme.goldAccent,
          width: _isFocused ? 2 : 1.5,
        ),
        boxShadow: _isFocused ? GoldTheme.goldGlow : null,
      ),
      child: Focus(
        onFocusChange: (focused) => setState(() => _isFocused = focused),
        child: DropdownButtonHideUnderline(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: GoldTheme.spacingMD),
            child: DropdownButton2<T>(
              isExpanded: true,
              hint: Text(
                widget.hint,
                style: GoldTheme.labelMedium.copyWith(color: GoldTheme.softGray),
              ),
              items: widget.items,
              value: widget.value,
              onChanged: widget.onChanged,
              buttonStyleData: const ButtonStyleData(
                height: 50,
                width: double.infinity,
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: Get.height * 0.4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(GoldTheme.radiusMD),
                  boxShadow: GoldTheme.softShadow,
                  border: Border.all(color: GoldTheme.goldAccent, width: 1),
                ),
                offset: const Offset(0, -4),
              ),
              menuItemStyleData: MenuItemStyleData(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: GoldTheme.spacingLG),
              ),
              iconStyleData: IconStyleData(
                icon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.trailing != null) widget.trailing!,
                    AnimatedRotation(
                      turns: 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: GoldTheme.gold,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                openMenuIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.trailing != null) widget.trailing!,
                    Icon(
                      Icons.keyboard_arrow_up_rounded,
                      color: GoldTheme.gold,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Premium Image Card with animations
class GoldImageCard extends StatefulWidget {
  final String? imagePath;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;
  final bool isUploading;
  final double? uploadProgress;
  final double size;
  
  const GoldImageCard({
    Key? key,
    this.imagePath,
    this.onTap,
    this.onRemove,
    this.isUploading = false,
    this.uploadProgress,
    this.size = 100,
  }) : super(key: key);
  
  @override
  State<GoldImageCard> createState() => _GoldImageCardState();
}

class _GoldImageCardState extends State<GoldImageCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  
  @override
  Widget build(BuildContext context) {
    final hasImage = widget.imagePath != null && widget.imagePath!.isNotEmpty;
    
    return AnimatedPressable(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: hasImage ? Colors.transparent : GoldTheme.cream,
            borderRadius: BorderRadius.circular(GoldTheme.radiusMD),
            border: Border.all(
              color: _isHovered ? GoldTheme.gold : GoldTheme.goldAccent,
              width: _isHovered ? 2 : 1.5,
              strokeAlign: BorderSide.strokeAlignInside,
            ),
            boxShadow: _isHovered ? GoldTheme.goldGlow : GoldTheme.softShadow,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(GoldTheme.radiusMD - 1),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (hasImage)
                  CustomImageView(
                    image: widget.imagePath,
                    fit: BoxFit.cover,
                  )
                else
                  Center(
                    child: AnimatedScale(
                      scale: _isHovered ? 1.1 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.add_photo_alternate_outlined,
                        color: GoldTheme.gold,
                        size: 32,
                      ),
                    ),
                  ),
                
                // Upload Progress Overlay
                if (widget.isUploading)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: CircularPercentIndicator(
                        radius: 24,
                        lineWidth: 3,
                        percent: widget.uploadProgress ?? 0,
                        center: Text(
                          '${((widget.uploadProgress ?? 0) * 100).toInt()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        progressColor: GoldTheme.gold,
                        backgroundColor: Colors.white24,
                      ),
                    ),
                  ),
                
                // Remove Button
                if (hasImage && widget.onRemove != null && !widget.isUploading)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: AnimatedOpacity(
                      opacity: _isHovered ? 1.0 : 0.7,
                      duration: const Duration(milliseconds: 150),
                      child: GestureDetector(
                        onTap: widget.onRemove,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: GoldTheme.error,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Section Header with gold accent
class GoldSectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  
  const GoldSectionHeader({
    Key? key,
    required this.title,
    this.trailing,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: GoldTheme.spacingSM),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 18,
            decoration: BoxDecoration(
              gradient: GoldTheme.goldGradient,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: GoldTheme.spacingSM),
          Text(
            title,
            style: GoldTheme.headingMedium.copyWith(
              fontSize: 15,
              color: GoldTheme.charcoal,
            ),
          ),
          if (trailing != null) ...[
            const Spacer(),
            trailing!,
          ],
        ],
      ),
    );
  }
}

class AddNewItemScreen extends StatefulWidget {
  final String? fromKey;
  final Product? product;

  const AddNewItemScreen({super.key, this.fromKey, this.product});

  @override
  _AddNewItemScreenState createState() => _AddNewItemScreenState();
}

class _AddNewItemScreenState extends State<AddNewItemScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // Define controllers for text fields
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productPriceController = TextEditingController();
  final TextEditingController priceAfterDiscountController = TextEditingController();
  final TextEditingController productCodeController = TextEditingController();

  // final TextEditingController productWeightController = TextEditingController();
  final TextEditingController productkeratController = TextEditingController();
  final TextEditingController salesDiscountController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController optionsController = TextEditingController();
  final TextEditingController variationFoundController = TextEditingController();
  final TextEditingController variantIdController = TextEditingController();
  late HtmlEditorController descriptionController;
  ScrollController scrollController = ScrollController();
  bool isLoading = false;
  RxBool refreshDropDown = false.obs;
  late final AnimationController _animationController;

  String? mainImage;

  List<int> gemstoneStylesIds = <int>[];
  List<String> moreImages = [];
  List<String> moreVideos = [];
  RxBool addingItem = false.obs;
  RxBool deletingItem = false.obs;
  RxList<RxDouble> imageUploadPercent = <RxDouble>[].obs;
  RxList<String> images = <String>[].obs;
  bool flatDiscount = true;
  bool loadingStores = true;
  String? dynamicFieldsJson;
  Map<String, String> dynamicFields = <String, String>{};
  String? selectedMetalType;
  String? selectedGemstoneType;
  bool isStyleEmpty = false;
  String? selectedGemstoneStyleFirst;
  RxString? selectedCut;
  RxString? selectedClarity;
  RxString selectedCatId = "".obs;
  RxString? selectedColor;
  RxList? diamondColors = [].obs;

  RxInt remainingFiles = 0.obs;

  RxList<Category> selectedCategoriesList = <Category>[].obs;
  RxMap<int, List<Category>> selectedCategoriesMap = RxMap<int, List<Category>>();
  Rx<ProductType>? selectedTypeObject = ProductType(items: []).obs;
  List dynamicTextControllers = [];
  RxMap<int, List<Category>> selectedCatObjectList = RxMap<int, List<Category>>();
  Rxn<StoreClass>? selectedStoreObject = Rxn();
  RxList<List<Category>> subCategoriesList = RxList<List<Category>>();
  Rx<String> productTypeName = ''.obs;
  Rx<int> productTypeId = 0.obs;
  Rxn<Category>? selectedCatObject = Rxn();
  Rx<Product>? product;
  RxBool policyAlert = false.obs;
  RxBool categoryAlert = false.obs;
  RxBool categoryAlertText = false.obs;
  RxBool policyAlertText = false.obs;
  RxBool loadingProduct = true.obs;
  RxBool loadingCategory = true.obs;
  RxBool loadingCategoriesDropDown = false.obs;
  RxList<Widget> categoriesDropDown = <Widget>[].obs;
  RxList<Widget> gemstonStylesDropDowns = <Widget>[].obs;

  List<String> cut = ['Excellent', 'Very Good', 'Good', 'Fair', 'Poor'];
  List<String> clarity = [
    'FL (Flawless)',
    'IF (Internally Flawless)',
    'VVS1/VVS2 (Very Very Slightly Included)',
    'VS1/VS2 (Very Slightly Included)',
    'SI1/SI2 (Slightly Included)',
    'I1/I2/I3 (Included)',
  ];

  final List<Map<String, dynamic>> items = [
    {'type': 'textfield', 'label': 'Name'},
    {
      'type': 'dropdown',
      'label': 'Hobbies',
      'options': ['Reading', 'Gaming', 'Traveling', 'Cooking']
    },
  ];

  RxList<Category> itemCategories = <Category>[].obs;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickMainImage() async {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(GoldTheme.radiusLG)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(GoldTheme.spacingLG),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag Handle
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: GoldTheme.spacingLG),
                  decoration: BoxDecoration(
                    color: GoldTheme.softGray.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                
                // Title
                Padding(
                  padding: const EdgeInsets.only(bottom: GoldTheme.spacingLG),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(GoldTheme.spacingSM),
                        decoration: BoxDecoration(
                          color: GoldTheme.gold.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(GoldTheme.radiusSM),
                        ),
                        child: Icon(
                          Icons.add_photo_alternate_rounded,
                          color: GoldTheme.gold,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: GoldTheme.spacingMD),
                      Text(
                        "Add Image".tr,
                        style: GoldTheme.headingMedium.copyWith(fontSize: 17),
                      ),
                    ],
                  ),
                ),
                
                // Options
                _buildImagePickerOption(
                  icon: Icons.photo_library_rounded,
                  title: "Select from Gallery".tr,
                  subtitle: "Choose from your photos".tr,
                  onTap: () {
                    function.SingleImagePicker(ImageSource.gallery).then((value) {
                      if (value != null) {
                        setState(() {
                          mainImage = value.path;
                        });
                      }
                      Get.back();
                    });
                  },
                ),
                
                const SizedBox(height: GoldTheme.spacingSM),
                
                _buildImagePickerOption(
                  icon: Icons.camera_alt_rounded,
                  title: "Take Photo".tr,
                  subtitle: "Use your camera".tr,
                  onTap: () {
                    function.SingleImagePicker(ImageSource.camera).then((value) {
                      if (value != null) {
                        setState(() {
                          mainImage = value.path;
                        });
                      }
                      Get.back();
                    });
                  },
                ),
                
                const SizedBox(height: GoldTheme.spacingMD),
                
                // Cancel Button
                AnimatedPressable(
                  onTap: () => Get.back(),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: GoldTheme.spacingMD),
                    decoration: BoxDecoration(
                      color: GoldTheme.lightGray,
                      borderRadius: BorderRadius.circular(GoldTheme.radiusMD),
                    ),
                    child: Center(
                      child: Text(
                        "Cancel".tr,
                        style: GoldTheme.labelMedium.copyWith(
                          color: GoldTheme.warmGray,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
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
  
  Widget _buildImagePickerOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return AnimatedPressable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(GoldTheme.spacingMD),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(GoldTheme.radiusMD),
          border: Border.all(color: GoldTheme.goldAccent, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(GoldTheme.spacingMD),
              decoration: BoxDecoration(
                gradient: GoldTheme.subtleGoldGradient,
                borderRadius: BorderRadius.circular(GoldTheme.radiusSM),
              ),
              child: Icon(
                icon,
                color: GoldTheme.gold,
                size: 24,
              ),
            ),
            const SizedBox(width: GoldTheme.spacingMD),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoldTheme.labelMedium.copyWith(
                      color: GoldTheme.charcoal,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoldTheme.bodyText.copyWith(
                      color: GoldTheme.softGray,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: GoldTheme.gold,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  void resetFields() {
    productNameController.clear();
    productPriceController.clear();
    priceAfterDiscountController.clear();
    productCodeController.clear();
    // productWeightController.clear();
    productkeratController.clear();
    salesDiscountController.clear();
    quantityController.clear();
    optionsController.clear();
    variationFoundController.clear();
    variantIdController.clear();
    selectedStoreObject?.value = null; // Reset selected store
    selectedCatId.value = ''; // Reset selected category
    flatDiscount = false; // Reset flatDiscount flag if it's a boolean
    dynamicFieldsJson = null; // Reset dynamic fields JSON if it's a Map
    selectedCategoriesMap.clear();
    selectedCatObjectList.clear();
    selectedStoreObject?.value = null;
    selectedMetalType = null;
    selectedGemstoneType = null;
    selectedCategoriesMap.clear();
    globalController.selectedGemstoneStyle.clear();
    globalController.selectedGemstoneStyle.add(null);
    globalController.itemGemstoneStyles.clear();
    globalController.gemstonesDropDownMap.clear();
    globalController.gemstonStylesDropList.removeRange(1, globalController.gemstonStylesDropList.length);
    globalController.resetMetalFields(globalController.metals, globalController.gemstones);
    globalController.resetGemstonStylesDropList();
    globalController.resetgemstonesDropDownMap();
    try {
      descriptionController.setText(""); // For HtmlEditorController
    } catch (e) {
      print(e);
    }
    // Reset dynamic fields JSON if it's a Map
  }

  resetStyle(int index){
    globalController.selectedGemstoneStyle.removeAt(index);
    if(index==0){
      globalController.selectedGemstoneStyle.add(null);

    }
    if(index>0){
      globalController.gemstonStylesDropList.removeAt(index);

    }
    try{
      globalController.itemGemstoneStyles.removeAt(index);

    }catch(e){

    }


    // globalController.resetGemstonStylesDropList();
    // globalController.resetgemstonesDropDownMap();
  }

  void fillDiamondColors() {
    // ASCII values of 'D' to 'z'
    for (int i = 'D'.codeUnitAt(0); i <= 'z'.codeUnitAt(0); i++) {
      diamondColors?.add(String.fromCharCode(i));
    }
  }

  Future<void> _changeMainImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        mainImage = pickedFile.path;
      });
    }
  }

  Future<void> _removeMainImage() async {
    setState(() {
      mainImage = null;
    });
  }

  Future<void> _pickMoreImages() async {
    // MediaPicker.pickImagesAndVideos().then((value) {
    //   try {
    //     if (value!.isNotEmpty) {
    //       setState(() {
    //         value.forEach(
    //               (element) {
    //             moreImages.add(element.path ?? "");
    //           },
    //         );
    //       });
    //     }
    //   } catch (e) {
    //     print(e);
    //   }
    // },);
    function.multiImagePicker().then((value) {
      try {
        if (value!.isNotEmpty) {
          setState(() {
            value.forEach(
                  (element) {
                moreImages.add(element.path ?? "");
              },
            );
          });
        }
      } catch (e) {
        print(e);
      }
    });
  }

  Future<void> _pickVideos() async {
    MediaPicker.pickVideos().then(
          (value) {
        try {
          if (value != null) {
            setState(() {
              moreVideos.add(value.path ?? "");
            });
          }
        } catch (e) {
          print(e);
        }
      },
    );
  }

  void _removeImage(int index) {
    setState(() {
      moreImages.removeAt(index);
    });
  }

  void _removeVideo(int index) {
    setState(() {
      moreVideos.removeAt(index);
    });
  }

  void organizeCategories(dynamic apiResponse) {
    try {
      // Clear old data
      selectedCategoriesList.clear();
      selectedCategoriesMap.clear();
      selectedCatObjectList.clear();
      categoriesDropDown.clear();

      // Ensure API response is valid
      if (apiResponse is! List) {
        throw Exception("API response is not a List");
      }

      // Convert API response into a list of Category objects
      List<Category> categories = apiResponse.map((e) => Category.fromJson(e)).toList();

      // Map categories by parent ID
      Map<int?, List<Category>> categoryMap = {};

      for (var category in categories) {
        categoryMap.putIfAbsent(category.parent, () => []).add(category);
      }

      // Organize categories into two levels
      List<Category> mainCategories = categoryMap[null] ?? []; // Parent categories
      List<Category> subCategories = [];

      for (var mainCategory in mainCategories) {
        if (categoryMap.containsKey(mainCategory.id)) {
          subCategories.addAll(categoryMap[mainCategory.id]!);
        }
      }

      // Add categories to selectedCatObjectList properly
      selectedCatObjectList[0] = mainCategories;
      selectedCatObjectList[1] = subCategories;

      // Add categories to selectedCategoriesMap
      if (mainCategories.isNotEmpty) {
        selectedCategoriesMap[0] = mainCategories;
      }
      if (subCategories.isNotEmpty) {
        selectedCategoriesMap[1] = subCategories;
      }

      // Ensure we have only two dropdowns
      categoriesDropDown.add(categoriesList(context, 0)); // Main categories dropdown
      if (subCategories.isNotEmpty) {
        categoriesDropDown.add(categoriesList(context, 1)); // Subcategories dropdown
      }
    } catch (e) {
      print("Error in organizeCategories: $e");
    }
  }

  void _changeImage(int index) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        moreImages[index] = pickedFile.path;
      });
    }
  }

  void addStoreCategoriesToSelectedCatObjectList() {
    try {
      selectedCategoriesList.clear();
      selectedCategoriesMap.forEach((key, value) {
        selectedCategoriesList.addAll(value);
      });

      // Ensure only 2 levels exist in categoriesDropDown
      if (categoriesDropDown.length > 2) {
        categoriesDropDown.removeRange(2, categoriesDropDown.length);
      }

      // Reset category selection structure
      selectedCatObjectList.clear();

      // Get all main categories (parent == null) and set them at index 0
      selectedCatObjectList[0] = globalController.homeDataList.value.categories!.where((element) => element.parent == null).toList();

      // Collect all subcategories and set them at index 1
      List<Category> subcategories = [];
      for (var category in selectedCategoriesList) {
        subcategories.addAll(globalController.homeDataList.value.categories!.where((element) => element.parent == category.id));
      }

      // Ensure subcategories are added only once at index 1
      if (subcategories.isNotEmpty) {
        selectedCatObjectList[1] = subcategories.toSet().toList(); // Remove duplicates
      }
    } catch (e) {
      print("Error updating category selection: $e");
    }
    print("Error updating category selection: ");
  }

  @override
  void initState() {
    fillDiamondColors();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 5000));

    globalController.descriptionController = HtmlEditorController();

    super.initState();

    if (widget.product != null) {
      editItemInitialize();
    } else {
      addItemInitialize();
    }
  }

  @override
  dispose() {
    // resetFields();
    super.dispose();
  }

  editItemInitialize() async {
    // Initialize basic product details
    WidgetsBinding.instance.addPostFrameCallback((_) {
      globalController.updateAddItemDropDownLists();
    });
    productTypeName.value = widget.product!.productTypeName ?? '';
    productTypeId.value = widget.product!.productTypeId ?? 0;
    product = widget.product!.obs;
    mainImage = widget.product!.main_image;

    // Process additional images
    widget.product?.more_images?.forEach((element) {
      if (element.file_path != mainImage.toString()) {
        moreImages.add(element.file_path!);
      }
    });

    // Initialize input fields with product values
    productNameController.text = widget.product!.product_name ?? '';
    productPriceController.text = widget.product!.product_price.toString() ?? '';
    priceAfterDiscountController.text = widget.product!.price_after_discount?.toString() ?? '';
    productCodeController.text = widget.product!.model ?? '';
    // productWeightController.text = widget.product!.product_weight?.toString() ?? '';
    productkeratController.text = widget.product!.product_kerat?.toString() ?? '';
    salesDiscountController.text = widget.product!.sales_discount?.toString() ?? '';
    quantityController.text = widget.product!.product_qty_left.toString() ?? '';

    // Set discount type
    flatDiscount = widget.product!.boolean_percent_discount == 0;

    setState(() {
      try {
        // Fetch related store and product type details
        selectedStoreObject?.value = globalController.stores.firstWhere((element) => element.store_name == widget.product?.store.name);

        selectedTypeObject?.value = globalController.homeDataList.value.productTypes!.firstWhere((element) => element.name == widget.product?.productTypeName);

        // Generate controllers for dynamic text fields
        dynamicTextControllers = List.generate(selectedTypeObject!.value.items!.length, (index) => TextEditingController());
      } catch (e) {
        print("Error in fetching store/type: $e");
      }
    });

    // Fetch product details after initializing
    loadingCategory.value = false;
    GetProductDetails(widget.product?.product_id);
  }

  addItemInitialize() async {
    productTypeId.value = widget.product?.productTypeId ?? 0;
    productTypeName.value = widget.product?.productTypeName ?? '';
    loadingCategory.value = false;
  }

// Function to parse response and populate RxLists
  void populateMetalsAndGemstones(Map<String, dynamic> response) {
    // Extract metals from response
    List<ProductType> extractedMetals = (response["metals"] != null) ? List<ProductType>.from(response["metals"].where((element) => element["type"] == "Metal").map((x) => ProductType.fromJson(x))) : [];

    List<ProductType> extractedGemstones = (response["metals"] != null) ? List<ProductType>.from(response["metals"].where((element) => element["type"] == "Gemstone").map((x) => ProductType.fromJson(x))) : [];

    List<ProductType> extractedGemstonesStyles = [];
    RxList<List<ProductType>> extractedGemstonStylesDropList = <List<ProductType>>[].obs;
    globalController.selectedGemstoneStyle.clear();

    if (response["gemstones_styles"] != null && response["gemstones_styles"]
        .toList()
        .length > 0) {
      List<ProductType> temp = [...globalController.gemstonStylesDropList[0]];

      globalController.gemstonStylesDropList.clear();
      for (int i = 0; i < response["gemstones_styles"]
          .toList()
          .length; i++) {
        var gemstoneStyle = response["gemstones_styles"][i]["style_name"];
        response["gemstones_styles"][i]["data"].forEach((element) {
          if (element["isEdited"] == true) {
            ProductType tempMetal = ProductType.fromJson(element);

            for (int i = 0; i < temp.length; i++) {
              if (temp[i].name == gemstoneStyle) {
                temp.forEach(
                      (element) => element.isEdited = false,
                );
                temp[i].metalName = tempMetal.metalName;
                temp[i].items?.clear();
                temp[i].isEdited = true;
                temp[i].items?.addAll(tempMetal.items!.toList());
                try {
                  gemstoneStylesIds[i] = int.parse(temp[i].id.toString());
                } catch (e) {
                  print(e);
                  gemstoneStylesIds.add(int.parse(temp[i].id.toString()));
                }
              }
            }
          }
        });
        globalController.gemstonStylesDropList.add(temp.map((product) => product.copyWith()).toList());

        globalController.selectedGemstoneStyle.add(gemstoneStyle);
      }

      for (var gemstoneStyle in response["gemstones_styles"]) {
        if (gemstoneStyle["data"] != null) {
          List<ProductType> gemstoneData = List<ProductType>.from(
            gemstoneStyle["data"].map((x) => ProductType.fromJson(x)),
          );
          extractedGemstonesStyles.addAll(gemstoneData);
          extractedGemstonStylesDropList.add(gemstoneData); // Add gemstone styles list
        }
      }
    }

// Assign the extracted list to the global controller

    // ✅ Update the RxLists and RxMap
    setState(() {
      globalController.selectedGemstonStylesDropList.clear(); // Clear before adding new values
      globalController.selectedGemstonStylesDropList.assignAll(extractedGemstonStylesDropList);

      // Clear existing data in gemstonStylesDropList

      // for (int i = 0; i < globalController.selectedGemstonStylesDropList.length; i++) {
      //   List<ProductType> selectedList = globalController.selectedGemstonStylesDropList[i];
      //   List<ProductType> updatedList = []; // Temporary list for modified items
      //
      //   for (int j = 0; j < selectedList.length; j++) {
      //     var selectedElement = selectedList[j];
      //
      //     // Create a copy of selectedElement to prevent modifying the original list
      //     ProductType updatedElement = ProductType(
      //       name: selectedElement.name,
      //       items: selectedElement.items != null ? List.from(selectedElement.items!) : [],
      //       isEdited: selectedElement.isEdited,
      //       type: selectedElement.type,
      //       id: selectedElement.id,
      //       metalName: selectedElement.metalName,
      //       metalId: selectedElement.metalId,
      //       unit: selectedElement.unit,
      //     );
      //
      //     updatedList.add(updatedElement);
      //     globalController.gemstonStylesDropList[i][j].items?.clear();
      //     globalController.gemstonStylesDropList[i][j].items?.addAll(updatedElement.items!.toList());
      //   }
      //
      //   // Update the selectedGemstonStylesDropList at index i
      //   // globalController.selectedGemstonStylesDropList[i] = updatedList;
      // }

// Now, populate gemstonesDropDownMap with gemstonStylesDropList
      globalController.gemstonesDropDownMap.clear(); // Clear the existing map

      for (int i = 0; i < globalController.gemstonStylesDropList.length; i++) {
        globalController.gemstonesDropDownMap[i] = globalController.gemstonStylesDropList[i];
      }

      // **Metals Processing**
      // globalController.selectedMetals.assignAll(extractedMetals);
      globalController.selectedMetals.assignAll(extractedMetals);

      if (globalController.selectedMetals.isNotEmpty) {
        globalController.itemMetal.value = globalController.selectedMetals[0];
      }

      // Sync items list for metals
      globalController.metals.forEach((metalElement) {
        for (var selectedElement in globalController.selectedMetals) {
          if (selectedElement.name == metalElement.name) {
            metalElement.items?.clear();
            metalElement.items?.addAll(selectedElement.items ?? []);
          }
          if (selectedElement.isEdited) {
            metalElement.isEdited = true;

            selectedMetalType = selectedElement.name;
          }
        }
      });

      // **Gemstones Processing**
      globalController.selectedGemstones.assignAll(extractedGemstones);

      // Sync items list for gemstones
      globalController.gemstones.forEach((gemElement) {
        for (var selectedElement in globalController.selectedGemstones) {
          if (selectedElement.name == gemElement.name) {
            gemElement.items?.clear();
            gemElement.items?.addAll(selectedElement.items ?? []);
          }
          if (selectedElement.isEdited) {
            gemElement.isEdited = true;
            selectedGemstoneType = selectedElement.name;
          }
        }
      });

      // ✅ Assign gemstones dropdown list (gemstone styles mapped by ID)
    });
    if (globalController.gemstonesDropDownMap.isEmpty) {
      isStyleEmpty = true;
      globalController.updateEditItemStyleList();
    }

    globalController.update();
    globalController.refresh();
  }

  Future<bool> GetProductDetails(id) async {
    bool success = false;

    Map<String, dynamic> response = await api.getData({
      'token': prefs!.getString("token") ?? "",
      'productId': id,
    }, "products/get-product-by-id");
    if (response.isNotEmpty) {
      try {
        print(response["product_categories"]);
        if (success = response["succeeded"]) {
          product?.value = Product.fromJson(response["product"]);
          globalController.description.value = product!.value.description ?? '';
          populateMetalsAndGemstones(response);

          organizeCategories(response["product_categories"]);
          if (widget.product != null) {
            addStoreCategoriesToSelectedCatObjectList();
          }
        }
      } catch (e) {
        print(e);
      }
    }
    if (success) {} else {
      loadingProduct.value = false;
    }
    mainImage = product!.value.main_image;
    moreImages.clear();
    moreVideos.clear();
    product!.value.more_images?.forEach((element) {
      if (element.file_path != mainImage.toString()) {
        if (element.file_path!.toString().isImageFileName) {
          moreImages.add(element.file_path.toString());
        } else {
          moreVideos.add(element.file_path.toString());
        }
      }
    });
    if (mounted) {
      setState(() {
        productNameController.text = product!.value.product_name ?? '';
        productPriceController.text = product!.value.product_price.toString() ?? '';
        priceAfterDiscountController.text = product!.value.price_after_discount?.toString() ?? '';
        productCodeController.text = product!.value.model ?? '';
        // productWeightController.text = product!.value.product_weight?.toString() ?? '';
        productkeratController.text = product!.value.product_kerat?.toString() ?? '';
        salesDiscountController.text = product!.value.sales_discount?.toString() ?? '';
        quantityController.text = product!.value.product_qty_left.toString() ?? '';
      });
    }
    print(product);
    return success;
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      backgroundColor: GoldTheme.cream,
      key: scaffoldKey,
      appBar: widget.product != null
          ? AppBar(
              toolbarHeight: getSize(56),
              title: Text(
                'Edit Item'.tr,
                style: GoldTheme.headingMedium.copyWith(color: GoldTheme.charcoal),
              ),
              elevation: 0,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              leading: AnimatedPressable(
                onTap: () => Get.back(),
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: GoldTheme.charcoal,
                  size: 22,
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        GoldTheme.goldAccent.withOpacity(0),
                        GoldTheme.gold.withOpacity(0.3),
                        GoldTheme.goldAccent.withOpacity(0),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: GoldTheme.spacingLG),
        child: Form(
          key: _formKey,
          child: GestureDetector(
            onTap: FocusScope.of(context).unfocus,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ListView(
                  key: const PageStorageKey('addProductScroll'),
                  controller: scrollController,
                  padding: getPadding(
                    top: getTopPadding() + (widget.product == null ? getSize(55) : GoldTheme.spacingMD),
                    bottom: (widget.product == null ? getSize(55) : 0) + getBottomPadding(),
                  ),
                  children: [
                    _buildMainImageSection(),
                    const SizedBox(height: GoldTheme.spacingLG),
                    
                    // Store Selection Dropdown
                    Obx(() {
                      return GoldDropdown<String>(
                        hint: 'Select Store'.tr,
                        hasError: policyAlert.value,
                        value: selectedStoreObject?.value?.store_name,
                        items: globalController.stores.map((store) {
                          return DropdownMenuItem<String>(
                            value: store.store_name,
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: GoldTheme.gold,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: GoldTheme.spacingSM),
                                Expanded(
                                  child: Text(
                                    store.store_name ?? '',
                                    style: GoldTheme.bodyText.copyWith(color: GoldTheme.charcoal),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            loadingCategory.value = true;
                            categoriesDropDown.clear();
                            selectedCatObjectList.clear();

                            selectedStoreObject?.value = globalController.stores.firstWhere(
                              (element) => element.store_name == newValue.toString(),
                            );

                            selectedCatObject?.value = selectedStoreObject?.value?.categories?.first;
                            selectedCatObjectList.addAll({
                              selectedCatObjectList.length: [selectedCatObject!.value!]
                            });

                            for (int i = 0; i < selectedStoreObject!.value!.categories!.length; i++) {
                              if (selectedCatObjectList.isEmpty) {
                                selectedCatObjectList.value = {
                                  0: [selectedStoreObject!.value!.categories![i]]
                                };
                              } else {
                                selectedCatObjectList[i]?.add(selectedStoreObject!.value!.categories![i]);
                              }
                            }
                          });

                          categoriesDropDown.add(categoriesList(context, 0));
                          loadingCategory.value = false;
                        },
                      );
                    }),
                    const SizedBox(height: GoldTheme.spacingLG),
                    typeDropDown(context, "Metal", globalController.metals),
                    SizedBox(height: 20),
                    // typeDropDown(context, "Gemstone", globalController.gemstones),

                    // SizedBox(height: 20),
                    // typeDropDown(context, "Gemstone Style".tr, globalController.gemstonStylesDropList[0], index: 1000),
                    Obx(() {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: getPadding(all: 0),
                        itemCount: globalController.gemstonStylesDropList.length,
                        itemBuilder: (context, index) {
                          final model = globalController.gemstonStylesDropList[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: typeDropDown(context, "Gemstone Style".tr, model, index: index),
                          );
                        },
                      );
                    }),

                    Obx(() {
                      return ListView.builder(
                        shrinkWrap: true,
                        padding: getPadding(all: 0),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: categoriesDropDown.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: getPadding(bottom: 20.0),
                            child: categoriesList(context, index),
                          );
                        },
                      );
                    }),
                    // Obx(() {
                    //   return selectedTypeObject?.value.name == "Diamond"
                    //       ? Column(
                    //           children: [
                    //             SizedBox(height: 20),
                    //             colorDropDown(context),
                    //           ],
                    //         )
                    //       : SizedBox();
                    // }),
                    // Obx(() {
                    //   return selectedTypeObject?.value.name == "Diamond"
                    //       ? Column(
                    //           children: [
                    //             SizedBox(height: 20),
                    //             cutDropDown(context),
                    //           ],
                    //         )
                    //       : SizedBox();
                    // }),
                    // Obx(() {
                    //   return selectedTypeObject?.value.name == "Diamond"
                    //       ? Column(
                    //           children: [
                    //             SizedBox(height: 20),
                    //             clarityDropDown(context),
                    //             SizedBox(height: 20),
                    //           ],
                    //         )
                    //       : SizedBox();
                    // }),

                    _buildTextField(
                      productNameController,
                      'Product Name'.tr,
                      'Enter product name'.tr,
                      required: true,
                    ),

                    // SizedBox(height: 20),
                    _buildTextField(
                      productPriceController,
                      'Product Price'.tr,
                      'Enter product price'.tr,
                      inputType: TextInputType.number,
                      required: true,
                    ),
                    // Obx(() {
                    //   return selectedTypeObject!.value.items.isNotEmpty
                    //       ? ListView.builder(
                    //           shrinkWrap: true,
                    //           padding: EdgeInsets.zero,
                    //           physics: const NeverScrollableScrollPhysics(),
                    //           itemCount: selectedTypeObject!.value.items.length,
                    //           itemBuilder: (context, index) {
                    //             ItemFormField item = selectedTypeObject!.value.items[index];
                    //             return
                    //               _buildTextField(
                    //               dynamicTextControllers[index],
                    //               selectedTypeObject!.value.items[index].field ?? '',
                    //               'Enter ${selectedTypeObject!.value.items[index].field}',
                    //               inputType: TextInputType.name,
                    //               required: selectedTypeObject!.value.items[index].isRequired ?? false,
                    //               isDynamicField: true,
                    //               item: selectedTypeObject!.value.items[index],
                    //             );
                    //           })
                    //       : SizedBox();
                    // }),
                    _buildTextField(
                      productCodeController,
                      'Product Model'.tr,
                      'Enter product model'.tr,
                      required: false,
                    ),
                    // _buildTextField(
                    //   productWeightController,
                    //   'Product Weight',
                    //   'Enter product weight',
                    //   inputType: TextInputType.number,
                    //   required: false,
                    // ),
                    // _buildTextField(
                    //   productkeratController,
                    //   'cerat',
                    //   'Enter product kerat',
                    //   inputType: TextInputType.number,
                    //   required: false,
                    // ),
                    _buildTextField(
                      salesDiscountController,
                      'Sales Discount'.tr,
                      'Enter sales discount'.tr,
                      inputType: TextInputType.number,
                      required: false,
                      isSwitch: true,
                    ),
                    _buildTextField(priceAfterDiscountController, 'Price After Discount', 'Enter price after discount', inputType: TextInputType.number, required: false, readOnly: true),

                    _buildTextField(
                      quantityController,
                      'Quantity'.tr,
                      'Enter quantity'.tr,
                      inputType: TextInputType.number,
                      required: false,
                    ),
                    SizedBox(height: 20),

                    const SizedBox(height: GoldTheme.spacingLG),
                    
                    // Description Button
                    AnimatedPressable(
                      onTap: () => descriptionBottomSheet(),
                      child: Container(
                        height: getVerticalSize(48),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(GoldTheme.radiusMD),
                          border: Border.all(color: GoldTheme.gold, width: 1.5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.description_outlined, color: GoldTheme.gold, size: 20),
                            const SizedBox(width: GoldTheme.spacingSM),
                            Text(
                              "Add description".tr,
                              style: GoldTheme.labelMedium.copyWith(
                                color: GoldTheme.gold,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: GoldTheme.spacingLG),

                    // Submit / Delete Buttons
                    widget.product == null
                        ? _buildPrimarySubmitButton()
                        : Row(
                            children: [
                              Expanded(child: _buildPrimarySubmitButton()),
                              const SizedBox(width: GoldTheme.spacingMD),
                              Expanded(child: _buildDeleteButton()),
                            ],
                          ),
                    const SizedBox(height: GoldTheme.spacingXL),
                  ],
                ),
                // Premium Loading Overlay
                Obx(() {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: addingItem.value
                        ? BackdropFilter(
                            key: const ValueKey('loading'),
                            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                            child: Container(
                              color: Colors.white.withOpacity(0.3),
                              child: Center(
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  padding: const EdgeInsets.all(GoldTheme.spacingXL),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(GoldTheme.radiusLG),
                                    boxShadow: GoldTheme.goldGlow,
                                    border: Border.all(color: GoldTheme.goldAccent, width: 2),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: getHorizontalSize(120),
                                        child: Lottie.asset(
                                          AssetPaths.addingItemLoader,
                                          repeat: true,
                                          animate: true,
                                        ),
                                      ),
                                      const SizedBox(height: GoldTheme.spacingMD),
                                      Text(
                                        'Please wait while adding product...'.tr,
                                        style: GoldTheme.headingMedium.copyWith(
                                          fontSize: 15,
                                          color: GoldTheme.charcoal,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: GoldTheme.spacingSM),
                                      Obx(() {
                                        return AnimatedOpacity(
                                          opacity: remainingFiles.value > 0 ? 1.0 : 0.0,
                                          duration: const Duration(milliseconds: 200),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: GoldTheme.spacingMD,
                                              vertical: GoldTheme.spacingSM,
                                            ),
                                            decoration: BoxDecoration(
                                              color: GoldTheme.goldAccent.withOpacity(0.5),
                                              borderRadius: BorderRadius.circular(GoldTheme.radiusSM),
                                            ),
                                            child: RichText(
                                              textAlign: TextAlign.center,
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: remainingFiles.value.toString(),
                                                    style: GoldTheme.labelMedium.copyWith(
                                                      color: GoldTheme.gold,
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: ' files remaining...'.tr,
                                                    style: GoldTheme.labelMedium.copyWith(
                                                      color: GoldTheme.warmGray,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(key: ValueKey('empty')),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateAllGemstonesDropDownMap() {
    // Loop through all indexes in gemstonStylesDropList
    for (int index = 0; index < globalController.gemstonStylesDropList.length; index++) {
      if (globalController.gemstonStylesDropList[index].isNotEmpty) {
        var deepCopiedList = globalController.gemstonStylesDropList[index]
            .map((productType) =>
            productType.copyWith(
              items: productType.items?.map((item) {
                return item.copyWith(
                  options: item.options?.map((option) => option.copyWith()).toList(),
                );
              }).toList(),
            ))
            .toList();

        // Update gemstonesDropDownMap at the current index
        globalController.gemstonesDropDownMap[index] = deepCopiedList;
      }
    }
  }



  Future<bool?> addNewItem(BuildContext context) async {
    if(globalController.itemMetal.value.id==null){
      Get.snackbar("Alert".tr, 'Please select a metal first'.tr, snackPosition: SnackPosition.BOTTOM, colorText: ColorConstant.white, backgroundColor: ColorConstant.logoSecondColor);

      return null;
    }
    bool success = false;
    addingItem.value = true;
    remainingFiles.value = moreImages.length + moreVideos.length;
    List<int> tempIds = selectedCategoriesList.map((e) => e.id).toList();

    selectedCatId.value = jsonEncode(tempIds);
    String itemMetalString = jsonEncode(globalController.itemMetal.value);
    updateAllGemstonesDropDownMap();
    String itemGemstoneStyleString = '';

    if (gemstoneStylesIds.isNotEmpty) {
      itemGemstoneStyleString = jsonEncode(
        globalController.gemstonesDropDownMap.map(
              (key, value) => MapEntry(
            key.toString(),
            {
              "id": gemstoneStylesIds[key],
              "data": value.map((product) => product.toJson()).toList(),
            },
          ),
        ),
      );
    }

    Map<String, dynamic> parameters = {
      'token': prefs!.getString("token") ?? "",
      'storeId': selectedStoreObject?.value!.id.toString(),
      'product_name': productNameController.text.toString(),
      'product_code': productCodeController.text.toString(),
      'description': globalController.description.value,
      'product_price': productPriceController.text.toString(),
      'product_metal': itemMetalString.toString(),
      'style': itemGemstoneStyleString.toString(),
      'quantity': quantityController.text.toString(),
      'fields': dynamicFieldsJson,
      'category': selectedCatId.value,
      'boolean_percent_discount': flatDiscount ? 0 : 1,
      'discount': salesDiscountController.text,
    };

    try {
      Map<String, dynamic> response = await api.getData(parameters, "products/add-provider-product");

      if (response.isNotEmpty) {
        success = response["succeeded"];
        if (success) {
          if (mainImage != null) {
            await uploadImageInBackground({
              "table_name": response["table_name"],
              "product_id": response["product_id"],
              "file_path": mainImage!,
              "file_name": mainImage!.split("/").last,
              "size": 1000,
              "type": 1,
              "token": prefs!.getString("token"),
            });
          }

          for (int i = 0; i < moreImages.length; i++) {
            imageUploadPercent.add(0.0.obs);
            if (!moreImages[i].startsWith("http")) {
              await uploadImageInBackground({
                "table_name": response["table_name"],
                "product_id": response["product_id"],
                "file_path": moreImages[i],
                "file_name": moreImages[i].split("/").last,
                "size": i,
                "type": 2,
                "token": prefs!.getString("token"),
              });
            }
            remainingFiles -= 1;
          }

          for (int i = 0; i < moreVideos.length; i++) {
            imageUploadPercent.add(0.0.obs);
            if (!moreVideos[i].toString().startsWith("http")) {
              await uploadImageInBackground({
                "table_name": response["table_name"],
                "product_id": response["product_id"],
                "file_path": moreVideos[i],
                "file_name": moreVideos[i].split("/").last,
                "size": i,
                "type": 4,
                "token": prefs!.getString("token"),
              });
            }
            remainingFiles -= 1;
          }
        }

        if (success) {

          setState(() {
            mainImage = null;
            globalController.description.value = "";
            imageUploadPercent.clear();
            moreImages.clear();
            moreVideos.clear();
            resetFields();

          });
        }

        Ui.flutterToast(
          response["message"].toString().tr,
          Toast.LENGTH_LONG,
          ColorConstant.logoFirstColor,
          whiteA700,
        );
        toggleAddingItem(false);
        return success;
      } else {
        toggleAddingItem(false);
      }
    } catch (e) {
      toggleAddingItem(false);
    }
    return null;
  }




  Future<void> uploadImageInBackground(Map<String, dynamic> args) async {
    String filePath = args["file_path"];
    if (filePath.isNotEmpty) {
      File file = File(filePath);
      if (!await file.exists()) {
        print("❌ File does not exist: $filePath");
        return;
      }

      try {
        fn.Uint8List fileBytes = await file.readAsBytes();

        dio. FormData data = dio.FormData.fromMap({
          "file": dio.MultipartFile.fromBytes(
            fileBytes,
            filename: args["file_name"],
          ),
          "file_name": args["file_name"],
          "token": args["token"],
          "table_name": args["table_name"].toString(),
          "row_id": args["product_id"].toString(),
          "type": args["type"].toString(),
        });

        dio.Dio dio2 = dio.Dio();

        var response = await dio2.post(
          "${con!}side/upload-images",
          data: data,
          options: dio.Options(
            headers: {
              'Accept': "application/json",
              'Authorization': 'Bearer ${args["token"]}',
            },
          ),
        );

        if (response.statusCode == 200) {
          var responseData = response.data;
          if (responseData['succeeded'] == true) {
            print("✅ Image uploaded successfully: ${args["file_name"]}");
          } else {
            print('❌ Error: ${responseData["message"]}');
          }
        } else {
          print('❌ Failed with status code: ${response.statusCode}');
        }
      } catch (e) {
        print('❌ Error while uploading: $e');
      }
    }
  }



  toggleAddingItem(bool value) {
    Future.delayed(Duration(milliseconds: 1500), () {
      addingItem.value = value;
    });
  }

  Future<bool?> deleteItem(context) async {
    bool success = false;

    setState(() {
      deletingItem.value = false;
    });

    Map<String, dynamic> parameters = {
      'token': prefs!.getString("token") ?? "",
      'id': product?.value.product_id,
    };
    print(parameters);

    try {
      Map<String, dynamic> response = await api.getData(parameters, "products/delete-product");

      if (response.isNotEmpty) {
        success = response["succeeded"];

        if (success) {
          resetFields();
        }
        if (success) {
          Get.back();
        }
        Ui.flutterToast(response["message"]
            .toString()
            .tr, Toast.LENGTH_LONG, ColorConstant.logoFirstColor, whiteA700);

        setState(() {
          deletingItem.value = false;
        });
        return success;
      } else {
        setState(() {
          deletingItem.value = false;
        });
      }
      setState(() {
        deletingItem.value = false;
      });
    } catch (e) {
      setState(() {
        deletingItem.value = false;
      });
    }
    return null;
  }


  Future<bool?> editItem(BuildContext context) async {
    bool success = false;
    addingItem.value = true;
    remainingFiles.value = moreImages.length + moreVideos.length;

    List tempIds = [];
    for (int i = 0; i < selectedCategoriesList.length; i++) {
      tempIds.add(selectedCategoriesList[i].id);
    }

    selectedCatId.value = jsonEncode(tempIds);
    String itemMetalString = jsonEncode(globalController.itemMetal.value);
    updateAllGemstonesDropDownMap();
    String itemGemstoneStyleString = '';

    if (gemstoneStylesIds.isNotEmpty) {
      itemGemstoneStyleString = jsonEncode(
        globalController.gemstonesDropDownMap.map(
              (key, value) => MapEntry(
            key.toString(),
            {
              "id": gemstoneStylesIds[key],
              "data": value.map((product) => product.toJson()).toList(),
            },
          ),
        ),
      );
    }

    moreImages.forEach((element) {
      images.add(element.split("/").last);
    });
    moreVideos.forEach((element) {
      images.add(element.split("/").last);
    });

    String imageString = jsonEncode(images);

    Map<String, dynamic> parameters = {
      'token': prefs!.getString("token") ?? "",
      'id': product?.value.product_id,
      'storeId': selectedStoreObject?.value!.id.toString(),
      'product_name': productNameController.text.toString(),
      'product_code': productCodeController.text.toString(),
      'description': globalController.description.value,
      'product_price': productPriceController.text.toString(),
      'product_metal': itemMetalString.toString(),
      'style': itemGemstoneStyleString.toString(),
      'quantity': quantityController.text.toString(),
      'fields': dynamicFieldsJson,
      'files_names': imageString,
      'category': selectedCatId.value,
      'boolean_percent_discount': flatDiscount ? 0 : 1,
      'discount': salesDiscountController.text,
    };

    try {
      Map<String, dynamic> response =
      await api.getData(parameters, "products/edit-provider-product");

      if (response.isNotEmpty) {
        success = response["succeeded"];

        if (success) {
          if (mainImage != null && !mainImage!.startsWith("http")) {
            await uploadImageInBackground({
              "table_name": response["table_name"],
              "product_id": product?.value.product_id,
              "file_path": mainImage!,
              "file_name": mainImage!.split("/").last,
              "size": 1000,
              "type": 1,
              "token": prefs!.getString("token"),
            });
          }

          for (int i = 0; i < moreImages.length; i++) {
            imageUploadPercent.add(0.0.obs);
            if (!moreImages[i].startsWith("http")) {
              await uploadImageInBackground({
                "table_name": response["table_name"],
                "product_id": product?.value.product_id,
                "file_path": moreImages[i],
                "file_name": moreImages[i].split("/").last,
                "size": i,
                "type": 2,
                "token": prefs!.getString("token"),
              });
            }

            remainingFiles -= 1;
          }
          for (int i = 0; i < moreVideos.length; i++) {
            imageUploadPercent.add(0.0.obs);
            if (!moreVideos[i].toString().startsWith("http")) {
              await uploadImageInBackground({
                "table_name": response["table_name"],
                "product_id": product?.value.product_id,
                "file_path": moreVideos[i],
                "file_name": moreVideos[i].split("/").last,
                "size": i,
                "type": 4,
                "token": prefs!.getString("token"),
              });
            }
            remainingFiles -= 1;
          }


        }

        toggleAddingItem(false);
        Ui.flutterToast(
          response["message"].toString().tr,
          Toast.LENGTH_LONG,
          ColorConstant.logoFirstColor,
          whiteA700,
        );
        return success;
      } else {
        toggleAddingItem(false);
      }
    } catch (e) {
      print(e);
      toggleAddingItem(false);
    }
    return null;
  }



  // Future<void> uploadImageInBackground(Map<String, dynamic> args) async {
  //   String? image = args["image"];
  //   if (image != null) {
  //     dio.FormData data = dio.FormData.fromMap({
  //       "file": await dio.MultipartFile.fromFile(
  //         image,
  //         filename: args["file_name"].toString(),
  //       ).catchError((e) {}),
  //       "file_name": args["file_name"],
  //       "token": args["token"],
  //       "table_name": args["table_name"].toString(),
  //       "row_id": args["row_id"].toString(),
  //       "type": args["type"].toString(),
  //     });
  //
  //     dio.Dio dio2 = dio.Dio();
  //
  //     try {
  //       var response = await dio2.post(
  //         "${args["con"]}side/upload-images",
  //         data: data,
  //         options: dio.Options(
  //           headers: {
  //             'Accept': "application/json",
  //             'Authorization': 'Bearer ${args["token"]}',
  //           },
  //         ),
  //       );
  //
  //       if (response.statusCode == 200) {
  //         var responseData = response.data;
  //         if (responseData['succeeded'] == true) {
  //           print("✅ Image uploaded successfully: ${args["file_name"]}");
  //         } else {
  //           print('❌ Error: ${responseData["message"]}');
  //         }
  //       } else {
  //         print('❌ Failed with status code: ${response.statusCode}');
  //       }
  //     } catch (e) {
  //       print('❌ Error while uploading: $e');
  //     }
  //   }
  // }

  clearForm() {
    productNameController.clear();
    productPriceController.clear();
    priceAfterDiscountController.clear();
    productCodeController.clear();
    // productWeightController.clear();
    productkeratController.clear();
    salesDiscountController.clear();
    quantityController.clear();
    optionsController.clear();
    variationFoundController.clear();
    variantIdController.clear();
    globalController.descriptionController.clear();
    setState(() {
      moreImages.clear();
      moreVideos.clear();
      imageUploadPercent.clear();
      mainImage = null;
    });
  }

  Widget _buildTextField(TextEditingController controller,
      String label,
      String hint, {
        TextInputType inputType = TextInputType.text,
        bool required = true,
        bool isSwitch = false,
        bool readOnly = false,
        bool isDynamicField = false,
        ItemFormField? item,
      }) {
    
    ValueChanged<String>? changeHandler;
    
    if (isSwitch) {
      changeHandler = (value) {
        if (flatDiscount) {
          setState(() {
            try {
              double discountedPrice = double.parse(productPriceController.text) - double.parse(salesDiscountController.text.isNotEmpty ? salesDiscountController.text : "0");
              priceAfterDiscountController.text = discountedPrice < 0 ? "0" : discountedPrice.toString();
            } catch (e) {
              print(e);
            }
          });
        } else {
          setState(() {
            try {
              double productPrice = double.parse(productPriceController.text.isNotEmpty ? productPriceController.text : "0");
              double discount = double.parse(salesDiscountController.text.isNotEmpty ? salesDiscountController.text : "0");
              double discountedPrice = productPrice - (productPrice * discount / 100);
              priceAfterDiscountController.text = discountedPrice < 0 ? "0" : discountedPrice.toString();
            } catch (e) {
              print(e);
            }
          });
        }
      };
    } else if (isDynamicField) {
      changeHandler = (value) {
        if (dynamicFields.containsKey(item?.id.toString())) {
          dynamicFields[item!.id!.toString()] = value;
        } else {
          dynamicFields.addAll({item!.id!.toString(): value});
        }
      };
    } else if (label == "Product Price".tr) {
      changeHandler = (value) {
        if (flatDiscount) {
          setState(() {
            try {
              priceAfterDiscountController.text = (double.parse(productPriceController.text) - double.parse(salesDiscountController.text != "" ? salesDiscountController.text : "0")).toString();
            } catch (e) {
              print(e);
            }
          });
        } else {
          setState(() {
            try {
              priceAfterDiscountController.text = (double.parse(productPriceController.text) - (double.parse(productPriceController.text != "" ? productPriceController.text : "0") * double.parse(salesDiscountController.text != "" ? salesDiscountController.text : "0") / 100)).toString();
            } catch (e) {
              print(e);
            }
          });
        }
        if (double.parse(priceAfterDiscountController.text) < 0) {
          priceAfterDiscountController.text = "0";
        }
      };
    }
    
    return Padding(
      padding: const EdgeInsets.only(bottom: GoldTheme.spacingLG),
      child: _GoldInputFieldWidget(
        controller: controller,
        label: label,
        hint: hint,
        inputType: inputType,
        required: required,
        isSwitch: isSwitch,
        readOnly: readOnly,
        flatDiscount: flatDiscount,
        onFlatDiscountChanged: (value) {
          try {
            setState(() {
              flatDiscount = value;
              double productPrice = double.tryParse(productPriceController.text) ?? 0;
              double discount = double.tryParse(salesDiscountController.text) ?? 0;
              double discountedPrice;

              if (flatDiscount) {
                discountedPrice = productPrice - discount;
                Ui.flutterToast("flat discount".tr, Toast.LENGTH_LONG, GoldTheme.gold, whiteA700);
              } else {
                discountedPrice = productPrice - (productPrice * discount / 100);
                Ui.flutterToast("percent discount".tr, Toast.LENGTH_LONG, GoldTheme.gold, whiteA700);
              }

              priceAfterDiscountController.text = discountedPrice < 0 ? "0" : discountedPrice.toString();
            });
          } catch (e) {
            Ui.flutterToast("please fill the price first".tr, Toast.LENGTH_LONG, GoldTheme.gold, whiteA700);
          }
        },
        onChanged: changeHandler,
      ),
    );
  }

  Widget _buildMainImageSection() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.all(GoldTheme.spacingLG),
      decoration: GoldTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main Image Section
          GoldSectionHeader(title: 'Main Image'.tr),
          const SizedBox(height: GoldTheme.spacingSM),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: mainImage == null
                ? _buildEmptyImagePicker(
                    key: const ValueKey('empty_main'),
                    onTap: _pickMainImage,
                    height: 180,
                    icon: Icons.add_photo_alternate_rounded,
                    label: 'Tap to add main image'.tr,
                  )
                : _buildMainImagePreview(),
          ),
          
          const SizedBox(height: GoldTheme.spacingXL),
          
          // Additional Images Section
          GoldSectionHeader(
            title: 'Gallery Images'.tr,
            trailing: Text(
              '${moreImages.length} ${'images'.tr}',
              style: GoldTheme.labelMedium.copyWith(color: GoldTheme.gold),
            ),
          ),
          const SizedBox(height: GoldTheme.spacingSM),
          _buildImageGrid(),
          
          const SizedBox(height: GoldTheme.spacingXL),
          
          // Videos Section
          GoldSectionHeader(
            title: 'Videos'.tr,
            trailing: Text(
              '${moreVideos.length} ${'videos'.tr}',
              style: GoldTheme.labelMedium.copyWith(color: GoldTheme.gold),
            ),
          ),
          const SizedBox(height: GoldTheme.spacingSM),
          _buildVideoGrid(),
        ],
      ),
    );
  }
  
  Widget _buildEmptyImagePicker({
    required Key key,
    required VoidCallback onTap,
    required double height,
    required IconData icon,
    required String label,
  }) {
    return AnimatedPressable(
      key: key,
      onTap: onTap,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: GoldTheme.subtleGoldGradient,
          borderRadius: BorderRadius.circular(GoldTheme.radiusMD),
          border: Border.all(
            color: GoldTheme.goldAccent,
            width: 2,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(GoldTheme.spacingMD),
              decoration: BoxDecoration(
                color: GoldTheme.gold.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: GoldTheme.gold,
                size: 36,
              ),
            ),
            const SizedBox(height: GoldTheme.spacingSM),
            Text(
              label,
              style: GoldTheme.labelMedium.copyWith(color: GoldTheme.softGray),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMainImagePreview() {
    return Column(
      key: const ValueKey('main_preview'),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(GoldTheme.radiusMD),
          child: Stack(
            children: [
              CustomImageView(
                image: mainImage,
                height: 180,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
              // Gold overlay gradient at bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.4),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: GoldTheme.spacingMD),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                onTap: _changeMainImage,
                icon: Icons.edit_rounded,
                label: 'Change'.tr,
                isPrimary: true,
              ),
            ),
            const SizedBox(width: GoldTheme.spacingMD),
            Expanded(
              child: _buildActionButton(
                onTap: _removeMainImage,
                icon: Icons.delete_outline_rounded,
                label: 'Remove'.tr,
                isPrimary: false,
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildActionButton({
    required VoidCallback onTap,
    required IconData icon,
    required String label,
    required bool isPrimary,
  }) {
    return AnimatedPressable(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          vertical: GoldTheme.spacingSM,
          horizontal: GoldTheme.spacingMD,
        ),
        decoration: BoxDecoration(
          color: isPrimary ? GoldTheme.gold : Colors.white,
          borderRadius: BorderRadius.circular(GoldTheme.radiusSM),
          border: Border.all(
            color: isPrimary ? GoldTheme.gold : GoldTheme.softGray.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: isPrimary ? GoldTheme.goldGlow : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isPrimary ? Colors.white : GoldTheme.warmGray,
            ),
            const SizedBox(width: GoldTheme.spacingXS),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isPrimary ? Colors.white : GoldTheme.warmGray,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildImageGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: GoldTheme.spacingSM,
        mainAxisSpacing: GoldTheme.spacingSM,
      ),
      padding: EdgeInsets.zero,
      itemCount: moreImages.length + 1,
      itemBuilder: (context, index) {
        if (index == moreImages.length) {
          return GoldImageCard(
            onTap: _pickMoreImages,
            size: double.infinity,
          );
        }
        
        // Wrap only the item that uses reactive variables
        return Obx(() {
          final isUploading = addingItem.value && imageUploadPercent.length > index;
          return GoldImageCard(
            key: ValueKey('img_$index'),
            imagePath: moreImages[index],
            onRemove: () => _removeImage(index),
            isUploading: isUploading,
            uploadProgress: isUploading ? imageUploadPercent[index].value : null,
            size: double.infinity,
          );
        });
      },
    );
  }
  
  Widget _buildVideoGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: GoldTheme.spacingSM,
        mainAxisSpacing: GoldTheme.spacingSM,
        childAspectRatio: 1,
      ),
      padding: EdgeInsets.zero,
      itemCount: moreVideos.length + 1,
      itemBuilder: (context, index) {
        if (index == moreVideos.length) {
          return AnimatedPressable(
            onTap: _pickVideos,
            child: Container(
              decoration: BoxDecoration(
                color: GoldTheme.cream,
                borderRadius: BorderRadius.circular(GoldTheme.radiusMD),
                border: Border.all(color: GoldTheme.goldAccent, width: 1.5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.videocam_rounded,
                    color: GoldTheme.gold,
                    size: 28,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Add'.tr,
                    style: GoldTheme.labelMedium.copyWith(
                      fontSize: 11,
                      color: GoldTheme.softGray,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        
        return Obx(() {
          return VideoGridItem(
            key: ValueKey(moreVideos[index]),
            videoPath: moreVideos[index],
            isAdding: addingItem.value,
            uploadProgress: imageUploadPercent.length > index ? imageUploadPercent[index] : null,
            onDelete: () => _removeVideo(index),
            onPreview: () => showVideo(context, moreVideos[index]),
          );
        });
      },
    );
  }

  Widget categoriesList(BuildContext context, int index) {
    return Obx(() {
      final isLoading = loadingCategoriesDropDown.value;
      final selectedCategories = selectedCategoriesMap[index] ?? [];
      final availableCategories = (index > 0
          ? selectedCatObjectList[index]
          : selectedStoreObject?.value?.categories
              ?.where((category) => category.parent == null))
          ?.toList() ??
          [];

      String? selectedValue = selectedCategories.isNotEmpty
          ? selectedCategories.last.categoryName
          : null;

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: isLoading
            ? _buildShimmerDropdown()
            : Column(
                key: ValueKey('cat_$index'),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GoldDropdown<String>(
                    hint: index == 0 ? "Select Category".tr : "Select Subcategory".tr,
                    hasError: categoryAlert.value,
                    value: availableCategories.any((cat) => cat.categoryName == selectedValue)
                        ? selectedValue
                        : null,
                    items: availableCategories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category.categoryName,
                        child: Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: category.isSelected ? GoldTheme.gold : GoldTheme.softGray,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: GoldTheme.spacingSM),
                            Expanded(
                              child: Text(
                                category.categoryName ?? '',
                                style: GoldTheme.bodyText.copyWith(color: GoldTheme.charcoal),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        bool isCategoryAdded = false;

                        Category tempCategory = globalController
                            .homeDataList.value.categories!
                            .firstWhere((element) =>
                                element.categoryName == newValue.toString());

                        int key = index;

                        selectedCategoriesMap.putIfAbsent(key, () => []);

                        bool contains = selectedCategoriesMap[key]!.any(
                            (element) =>
                                element.categoryName == tempCategory.categoryName);

                        if (!contains) {
                          tempCategory.isSelected = true;
                          selectedCategoriesMap[key]!.add(tempCategory);
                        }

                        if (!selectedCategoriesList.any((cat) => cat.id == tempCategory.id)) {
                          selectedCategoriesList.add(tempCategory);
                          selectedCategoriesList.refresh();
                        }

                        selectedCatObjectList[index] ??= [];
                        for (var element in globalController.homeDataList.value.categories!) {
                          if (element.parent == tempCategory.id) {
                            bool exists = selectedCatObjectList[index]!.any(
                                (existingCategory) =>
                                    existingCategory.categoryName == element.categoryName);

                            if (!exists) {
                              element.isSelected = true;
                              selectedCatObjectList[index]!.add(element);
                            }
                          }
                        }

                        selectedCatObjectList[index + 1] ??= [];
                        for (var element in globalController.homeDataList.value.categories!) {
                          if (element.parent == tempCategory.id) {
                            isCategoryAdded = true;

                            bool exists = selectedCatObjectList[index + 1]!.any(
                                (existingCategory) =>
                                    existingCategory.categoryName == element.categoryName);

                            if (!exists) {
                              element.isSelected = true;
                              selectedCatObjectList[index + 1]!.add(element);
                            }
                          }
                        }

                        if (isCategoryAdded) {
                          if (index + 1 < categoriesDropDown.length) {
                            categoriesDropDown[index + 1] = categoriesList(context, index + 1);
                          } else {
                            categoriesDropDown.add(categoriesList(context, index + 1));
                          }
                        }
                      });

                      setState(() {
                        selectedValue = selectedCatObjectList[index]?.isNotEmpty == true
                            ? selectedCatObjectList[index]?.first.categoryName
                            : null;
                      });
                    },
                  ),
                  if (selectedCategories.isNotEmpty) ...[
                    const SizedBox(height: GoldTheme.spacingSM),
                    Wrap(
                      spacing: GoldTheme.spacingSM,
                      runSpacing: GoldTheme.spacingXS,
                      children: selectedCategories.map((category) {
                        return _buildGoldChip(
                          label: category.categoryName ?? '',
                          onDeleted: () => _handleCategoryDelete(category, index),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
      );
    });
  }
  
  Widget _buildShimmerDropdown() {
    return Shimmer.fromColors(
      baseColor: GoldTheme.goldAccent.withOpacity(0.5),
      highlightColor: GoldTheme.cream,
      child: Container(
        height: getSize(52),
        width: Get.width,
        decoration: BoxDecoration(
          color: GoldTheme.goldAccent,
          borderRadius: BorderRadius.circular(GoldTheme.radiusMD),
        ),
      ),
    );
  }
  
  Widget _buildGoldChip({required String label, required VoidCallback onDeleted}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Chip(
        label: Text(
          label,
          style: GoldTheme.labelMedium.copyWith(
            color: GoldTheme.charcoal,
            fontSize: 12,
          ),
        ),
        backgroundColor: GoldTheme.goldAccent.withOpacity(0.5),
        side: BorderSide(color: GoldTheme.gold.withOpacity(0.3)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GoldTheme.radiusSM),
        ),
        deleteIcon: Icon(
          Icons.close_rounded,
          size: 16,
          color: GoldTheme.warmGray,
        ),
        deleteIconColor: GoldTheme.warmGray,
        onDeleted: onDeleted,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
  
  void _handleCategoryDelete(Category category, int index) {
    setState(() {
      selectedCategoriesMap[index]?.removeWhere((cat) => cat.id == category.id);
      selectedCatObjectList[index]?.removeWhere((cat) => cat.id == category.id);
      category.isSelected = false;

      selectedCategoriesList.removeWhere((cat) => cat.id == category.id);

      void removeSubcategoriesFromAllIndexes(int parentId) {
        selectedCategoriesList.removeWhere((cat) => cat.parent == parentId);

        selectedCategoriesMap.forEach((key, categoryList) {
          categoryList.removeWhere((cat) => cat.parent == parentId);
        });

        for (int i = 0; i < selectedCatObjectList.length; i++) {
          selectedCatObjectList[i]?.removeWhere((cat) => cat.parent == parentId);
        }

        categoriesDropDown.removeWhere((widget) {
          int widgetIndex = categoriesDropDown.indexOf(widget);
          if (widgetIndex > index) {
            List<Category>? subCategories = selectedCatObjectList[widgetIndex];
            return subCategories != null && subCategories.any((cat) => cat.parent == parentId);
          }
          return false;
        });

        final subcategories = selectedCategoriesList.where((cat) => cat.parent == parentId).toList();
        for (var subCat in subcategories) {
          removeSubcategoriesFromAllIndexes(subCat.id);
        }
      }

      removeSubcategoriesFromAllIndexes(category.id);

      selectedCategoriesList.refresh();
      selectedCategoriesMap.refresh();
      selectedCatObjectList.refresh();
      categoriesDropDown.refresh();
    });
  }
  
  Widget _buildPrimarySubmitButton() {
    return Obx(() {
      return AnimatedPressable(
        onTap: addingItem.value ? null : _handleSubmit,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: getVerticalSize(52),
          decoration: BoxDecoration(
            gradient: GoldTheme.goldGradient,
            borderRadius: BorderRadius.circular(GoldTheme.radiusMD),
            boxShadow: GoldTheme.goldGlow,
          ),
          child: Center(
            child: addingItem.value
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_outline_rounded, color: Colors.white, size: 20),
                      const SizedBox(width: GoldTheme.spacingSM),
                      Text(
                        "Submit".tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      );
    });
  }
  
  Widget _buildDeleteButton() {
    return AnimatedPressable(
      onTap: _showDeleteConfirmation,
      child: Container(
        height: getVerticalSize(52),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(GoldTheme.radiusMD),
          border: Border.all(color: GoldTheme.error, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_outline_rounded, color: GoldTheme.error, size: 20),
            const SizedBox(width: GoldTheme.spacingSM),
            Text(
              "Delete".tr,
              style: TextStyle(
                color: GoldTheme.error,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      if (selectedStoreObject?.value?.id == null) {
        scrollController.animateTo(
          scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );

        if (!Get.isSnackbarOpen) {
          Get.snackbar(
            "Alert".tr, 
            'Please select a store first'.tr, 
            snackPosition: SnackPosition.TOP, 
            colorText: Colors.white, 
            backgroundColor: GoldTheme.gold,
            margin: const EdgeInsets.all(GoldTheme.spacingLG),
            borderRadius: GoldTheme.radiusMD,
          );
          policyAlert.value = true;
          policyAlertText.value = true;
          Future.delayed(const Duration(seconds: 1)).then((value) {
            policyAlert.value = false;
          });
          Future.delayed(const Duration(milliseconds: 1400)).then((value) {
            policyAlertText.value = false;
          });
        }
      } else {
        String dynamicFieldsCustomFormat(Map<String, String> map) {
          return map.entries.map((entry) => '${entry.key}:${entry.value}').join(',');
        }

        dynamicFieldsJson = '{${dynamicFieldsCustomFormat(dynamicFields)}}';

        if (widget.fromKey == "edit") {
          editItem(context);
        } else {
          if (selectedCatObject?.value?.id != null) {
            addNewItem(context);
          } else {
            if (!Get.isSnackbarOpen) {
              scrollController.animateTo(
                scrollController.position.minScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              Get.snackbar(
                "Alert".tr, 
                'Please select a category first'.tr, 
                snackPosition: SnackPosition.TOP, 
                colorText: Colors.white, 
                backgroundColor: GoldTheme.gold,
                margin: const EdgeInsets.all(GoldTheme.spacingLG),
                borderRadius: GoldTheme.radiusMD,
              );
              categoryAlert.value = true;
              categoryAlertText.value = true;
              Future.delayed(const Duration(seconds: 1)).then((value) {
                categoryAlert.value = false;
              });
              Future.delayed(const Duration(milliseconds: 1400)).then((value) {
                categoryAlertText.value = false;
              });
            }
          }
        }
      }
    }
  }
  
  void _showDeleteConfirmation() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GoldTheme.radiusLG),
        ),
        contentPadding: const EdgeInsets.all(GoldTheme.spacingXL),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(GoldTheme.spacingMD),
              decoration: BoxDecoration(
                color: GoldTheme.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.warning_amber_rounded,
                color: GoldTheme.error,
                size: 40,
              ),
            ),
            const SizedBox(height: GoldTheme.spacingLG),
            Text(
              'Warning'.tr,
              style: GoldTheme.headingMedium.copyWith(color: GoldTheme.error),
            ),
            const SizedBox(height: GoldTheme.spacingSM),
            Text(
              "${'Are you sure you want to delete '.tr}${product?.value.product_name}?",
              style: GoldTheme.bodyText,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: GoldTheme.spacingXL),
            Row(
              children: [
                Expanded(
                  child: AnimatedPressable(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: GoldTheme.spacingMD),
                      decoration: BoxDecoration(
                        color: GoldTheme.lightGray,
                        borderRadius: BorderRadius.circular(GoldTheme.radiusSM),
                      ),
                      child: Center(
                        child: Text(
                          'No'.tr,
                          style: GoldTheme.labelMedium.copyWith(
                            color: GoldTheme.warmGray,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: GoldTheme.spacingMD),
                Expanded(
                  child: AnimatedPressable(
                    onTap: () {
                      deleteItem(context).then((value) => Get.back());
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: GoldTheme.spacingMD),
                      decoration: BoxDecoration(
                        color: GoldTheme.error,
                        borderRadius: BorderRadius.circular(GoldTheme.radiusSM),
                      ),
                      child: Center(
                        child: Text(
                          'Yes'.tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  Widget typeDropDown(BuildContext context, String type, List<ProductType>? metal, {int? index}) {
    RxBool isEdit = false.obs;
    
    return Obx(() {
      final currentValue = type == "Metal"
          ? selectedMetalType
          : type == "Gemstone"
              ? selectedGemstoneType
              : globalController.selectedGemstoneStyle.isNotEmpty
                  ? globalController.selectedGemstoneStyle[index ?? 0]
                  : null;
      
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: refreshDropDown.value
            ? _buildShimmerDropdown()
            : AnimatedContainer(
                key: ValueKey('type_$type$index'),
                duration: const Duration(milliseconds: 200),
                height: getSize(52),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(GoldTheme.radiusMD),
                  border: Border.all(
                    color: currentValue != null ? GoldTheme.gold : GoldTheme.goldAccent,
                    width: currentValue != null ? 2 : 1.5,
                  ),
                  boxShadow: currentValue != null ? GoldTheme.goldGlow : GoldTheme.softShadow,
                ),
                child: DropdownButtonHideUnderline(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: GoldTheme.spacingMD),
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: Row(
                        children: [
                          _getTypeIcon(type),
                          const SizedBox(width: GoldTheme.spacingSM),
                          Text(
                            'Select $type'.tr,
                            style: GoldTheme.labelMedium.copyWith(color: GoldTheme.softGray),
                          ),
                        ],
                      ),
                      items: metal?.map((element) {
                        element.items?.forEach((mainElement) {
                          mainElement.options?.forEach((value) {
                            if (value.isSelected) isEdit.value = true;
                          });
                        });

                        return DropdownMenuItem<String>(
                          value: element.name,
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: element.isEdited ? GoldTheme.gold : GoldTheme.softGray.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: GoldTheme.spacingSM),
                              Expanded(
                                child: Text(
                                  element.name ?? '',
                                  style: GoldTheme.bodyText.copyWith(
                                    color: GoldTheme.charcoal,
                                    fontWeight: element.isEdited ? FontWeight.w600 : FontWeight.w400,
                                  ),
                                ),
                              ),
                              if (element.isEdited)
                                Icon(Icons.check_circle, color: GoldTheme.gold, size: 16),
                            ],
                          ),
                        );
                      }).toList(),
                      value: currentValue,
                      onChanged: (newValue) => _handleTypeSelection(type, newValue, metal, index, isEdit),
                      buttonStyleData: const ButtonStyleData(
                        height: 50,
                        width: double.infinity,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        maxHeight: Get.height * 0.4,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(GoldTheme.radiusMD),
                          boxShadow: GoldTheme.softShadow,
                          border: Border.all(color: GoldTheme.goldAccent),
                        ),
                        offset: const Offset(0, -4),
                      ),
                      menuItemStyleData: const MenuItemStyleData(height: 44),
                      iconStyleData: IconStyleData(
                        icon: _buildTypeDropdownTrailing(type, metal, index, currentValue, isEdit),
                        openMenuIcon: _buildTypeDropdownTrailing(type, metal, index, currentValue, isEdit, isOpen: true),
                      ),
                    ),
                  ),
                ),
              ),
      );
    });
  }
  
  Widget _getTypeIcon(String type) {
    IconData icon;
    switch (type) {
      case "Metal":
        icon = Icons.diamond_outlined;
        break;
      case "Gemstone":
        icon = Icons.blur_circular;
        break;
      default:
        icon = Icons.style_outlined;
    }
    return Icon(icon, color: GoldTheme.gold, size: 18);
  }
  
  Widget _buildTypeDropdownTrailing(String type, List<ProductType>? metal, int? index, String? currentValue, RxBool isEdit, {bool isOpen = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Reset button for first gemstone style (only needs Obx for reactive check)
        if (type == "Gemstone Style" && index == 0)
          Obx(() => globalController.selectedGemstoneStyle.isNotEmpty && 
              globalController.selectedGemstoneStyle.first != null
              ? AnimatedPressable(
                  onTap: () => resetStyle(index ?? 0),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    margin: const EdgeInsets.only(right: 4),
                    decoration: BoxDecoration(
                      color: GoldTheme.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      Icons.remove_circle_outline_rounded,
                      color: GoldTheme.error,
                      size: 20,
                    ),
                  ),
                )
              : const SizedBox()),
        
        // Add button for first gemstone style
        if (type == "Gemstone Style" && index == 0)
          AnimatedPressable(
            onTap: () {
              globalController.selectedGemstoneStyle.add(null);
              globalController.gemstonStylesDropList.add(globalController.homeDataList.value.gemstoneStyles!);
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              margin: const EdgeInsets.only(right: 4),
              decoration: BoxDecoration(
                color: GoldTheme.gold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Icons.add_circle_outline_rounded,
                color: GoldTheme.gold,
                size: 20,
              ),
            ),
          ),
        
        // Remove button for additional gemstone styles
        if (type == "Gemstone Style" && index != 0)
          AnimatedPressable(
            onTap: () {
              globalController.gemstonesDropDownMap.removeWhere((key, value) => key == index);
              globalController.selectedGemstoneStyle[index!] = null;
              globalController.gemstonStylesDropList.removeAt(index);
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              margin: const EdgeInsets.only(right: 4),
              decoration: BoxDecoration(
                color: GoldTheme.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Icons.remove_circle_rounded,
                color: GoldTheme.error,
                size: 20,
              ),
            ),
          ),
        
        // Dropdown arrow
        AnimatedRotation(
          turns: isOpen ? 0.5 : 0,
          duration: const Duration(milliseconds: 200),
          child: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: GoldTheme.gold,
            size: 24,
            ),
          ),
          
          // Edit button when value is selected
          if (currentValue != null) ...[
            const SizedBox(width: 4),
            AnimatedPressable(
              onTap: () => _handleEditType(type, metal, index, currentValue, isEdit),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: GoldTheme.gold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.edit_rounded,
                  color: GoldTheme.gold,
                  size: 18,
                ),
              ),
            ),
          ],
        ],
      );
  }
  
  void _handleTypeSelection(String type, String? newValue, List<ProductType>? metal, int? index, RxBool isEdit) {
    refreshDropDown.value = true;
    setState(() {
      if (type == "Metal") {
        selectedMetalType = newValue;
      } else if (type == "Gemstone") {
        selectedGemstoneType = newValue;
      } else {
        try {
          globalController.selectedGemstoneStyle[index!] = newValue!;
        } catch (e) {
          globalController.selectedGemstoneStyle.add(newValue);
        }
      }
      
      String name = "";
      if (index == null) {
        name = type == "Gemstone" ? selectedGemstoneType ?? '' : selectedMetalType ?? '';
      } else {
        name = globalController.selectedGemstoneStyle[index] ?? '';
      }

      String? metalName;
      try {
        metalName = globalController.gemstonesDropDownMap[index]?.firstWhere((element) => element.isEdited).metalName;
      } catch (e) {
        metalName = metal?.firstWhere((element) => element.name == name).metalName;
      }

      if (type == "Gemstone Style") {
        try {
          gemstoneStylesIds[index!] = int.parse(metal!.firstWhere((element) => element.name == newValue).id.toString());
        } catch (e) {
          gemstoneStylesIds.add(int.parse(metal!.firstWhere((element) => element.name == newValue).id.toString()));
        }
      }

      showBottomSheet(context, type,
          properties: metal!.firstWhere((element) => element.name == newValue).items,
          gemstoneProperties: type == "Gemstone Style" ? metal : null,
          styleType: type == "Gemstone Style" ? newValue : null,
          gemstoneStyleName: metalName,
          selectedName: name,
          isAdd: (widget.product == null || isStyleEmpty) ? true : false,
          metal: metal.firstWhere((element) => element.name == newValue),
          index: index ?? 0)
          .then((value) {
        isEdit.value = true;
        Future.delayed(const Duration(milliseconds: 500), () {
          isEdit.value = value;
          refreshDropDown.value = false;
        });
      });
    });
  }
  
  void _handleEditType(String type, List<ProductType>? metal, int? index, String currentValue, RxBool isEdit) {
    String name = "";
    if (index == null) {
      name = type == "Gemstone" ? selectedGemstoneType ?? '' : selectedMetalType ?? '';
    } else {
      name = globalController.selectedGemstoneStyle[index] ?? '';
    }

    String? metalName;
    if (type == "Metal") {
      globalController.itemMetal.value = metal!.firstWhere((element) => element.name == name);
      metalName = name;
    } else if (type == "Gemstone") {
      globalController.itemGemstone.value = metal!.firstWhere((element) => element.name == name);
      metalName = name;
    } else {
      try {
        metalName = globalController.gemstonStylesDropList[index!].firstWhere((element) => element.isEdited && element.name == name).metalName;
      } catch (e) {
        metalName = metal?.firstWhere((element) => element.name == name).metalName;
      }
      for (var gemstoneList in globalController.gemstonStylesDropList) {
        for (var gemstone in gemstoneList) {
          if (gemstone.id != null) {
            gemstone = metal!.firstWhere((element) => element.name == name);
          } else {
            gemstoneList.add(metal!.firstWhere((element) => element.name == name));
          }
        }
      }
    }

    showBottomSheet(context, type,
        properties: metal!.firstWhere((element) => element.name == name).items,
        gemstoneProperties: type == "Gemstone Style" ? metal : null,
        styleType: type == "Gemstone Style" ? globalController.selectedGemstoneStyle[index!] : null,
        gemstoneStyleName: metalName,
        selectedName: name,
        isAdd: false,
        metal: metal.firstWhere((element) => element.name == name),
        index: index ?? 0)
        .then((value) {
      isEdit.value = true;
      Future.delayed(const Duration(milliseconds: 500), () {
        isEdit.value = value;
        refreshDropDown.value = false;
      });
    });
  }

  Future<bool> showBottomSheet(BuildContext context, String type, {List<ItemFormField>? properties, List<ProductType>? gemstoneProperties, String? styleType, bool isAdd = false, String? gemstoneStyleName, int? index, ProductType? metal, String? selectedName}) async {
    RxBool isEdit = false.obs;

    await Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(GoldTheme.radiusLG)),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: GoldTheme.spacingMD,
            left: GoldTheme.spacingLG,
            right: GoldTheme.spacingLG,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.4,
            maxChildSize: 0.9,
            expand: false,
            builder: (context, scrollController) {
              return Column(
                children: [
                  // Drag Handle
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: GoldTheme.spacingMD),
                    decoration: BoxDecoration(
                      color: GoldTheme.goldAccent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          _getTypeIcon(type),
                          const SizedBox(width: GoldTheme.spacingSM),
                          Text(
                            '$type Properties'.tr,
                            style: GoldTheme.headingMedium,
                          ),
                        ],
                      ),
                      AnimatedPressable(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: const EdgeInsets.all(GoldTheme.spacingSM),
                          decoration: BoxDecoration(
                            color: GoldTheme.lightGray,
                            borderRadius: BorderRadius.circular(GoldTheme.radiusSM),
                          ),
                          child: Icon(Icons.close_rounded, color: GoldTheme.warmGray, size: 20),
                        ),
                      ),
                    ],
                  ),
                  
                  Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(vertical: GoldTheme.spacingMD),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          GoldTheme.goldAccent.withOpacity(0),
                          GoldTheme.gold.withOpacity(0.3),
                          GoldTheme.goldAccent.withOpacity(0),
                        ],
                      ),
                    ),
                  ),
                  
                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: type != "Gemstone Style"
                          ? BottomSheetContent(
                              fields: properties!,
                              type: type,
                              metalType: selectedName!,
                            )
                          : StyleSheetContent(
                              fields: gemstoneProperties!,
                              type: styleType ?? type,
                              metalName: gemstoneStyleName,
                              index: index ?? 0,
                              isAdd: isAdd,
                              isStyleEmpty: isStyleEmpty,
                            ),
                    ),
                  ),

                  // Save Button
                  Padding(
                    padding: EdgeInsets.only(
                      top: GoldTheme.spacingMD,
                      bottom: getBottomPadding() + GoldTheme.spacingMD,
                    ),
                    child: AnimatedPressable(
                      onTap: () {
                        if (globalController.isRequiredCheck.value) {
                          Ui.flutterToast("Please fill all required fields".tr, Toast.LENGTH_SHORT, GoldTheme.gold, whiteA700);
                        } else {
                          if (type != "Gemstone Style") {
                            properties?.forEach((mainElement) {
                              if (mainElement.isEdited) isEdit.value = true;
                              mainElement.options?.forEach((value) {
                                if (value.isSelected) isEdit.value = true;
                              });
                            });
                          } else {
                            gemstoneProperties?.forEach((mainElement) {
                              if (mainElement.isEdited) isEdit.value = true;
                              for (var element in mainElement.items ?? []) {
                                if (element.isEdited) isEdit.value = true;
                                element.options?.forEach((value) {
                                  if (value.isSelected) isEdit.value = true;
                                });
                              }
                            });
                          }
                          Get.back(result: true);
                        }
                      },
                      child: Container(
                        width: Get.width * 0.5,
                        padding: const EdgeInsets.symmetric(vertical: GoldTheme.spacingMD),
                        decoration: BoxDecoration(
                          gradient: GoldTheme.goldGradient,
                          borderRadius: BorderRadius.circular(GoldTheme.radiusMD),
                          boxShadow: GoldTheme.goldGlow,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_rounded, color: Colors.white, size: 20),
                            const SizedBox(width: GoldTheme.spacingSM),
                            Text(
                              "Save".tr,
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
                  ),
                ],
              );
            },
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: false,
    ).then((value) {
      if (type != "Gemstone Style") {
        properties?.forEach((mainElement) {
          if (mainElement.isEdited) isEdit.value = true;
          mainElement.options?.forEach((value) {
            if (value.isSelected) isEdit.value = true;
          });
        });
      } else {
        gemstoneProperties?.forEach((mainElement) {
          if (mainElement.isEdited) isEdit.value = true;
          for (var element in mainElement.items ?? []) {
            if (element.isEdited) isEdit.value = true;
            element.options?.forEach((value) {
              if (value.isSelected) isEdit.value = true;
            });
          }
        });
      }
    });

    return isEdit.value;
  }

  Widget cutDropDown(BuildContext context,) {
    return Obx(() {
      return Container(
        height: getSize(50),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: DropdownButtonFormField(
          value: selectedCut?.value,
          items: cut.map((cutValue) {
            return DropdownMenuItem<String>(
              value: cutValue,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15.0), // Add padding here
                child: Text(cutValue ?? ''),
              ),
            );
          }).toList(),
          decoration: InputDecoration(
            labelText: "Cut".tr,
            hintText: "Select cut".tr,
            contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
            labelStyle: TextStyle(
              color: ColorConstant.gray500,
            ),
            hintStyle: TextStyle(
              color: ColorConstant.gray500,
            ),
            focusColor: ColorConstant.logoFirstColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            filled: false,
            fillColor: ColorConstant.whiteA700,
          ),
          onChanged: (newValue) {
            setState(() {
              selectedCut?.value = newValue!;
            });
          },
          hint: Text('Select cut'.tr),
        ),
      );
    });
  }

  Widget clarityDropDown(BuildContext context,) {
    return Obx(() {
      return Container(
        height: getSize(50),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: DropdownButtonFormField(
          value: selectedClarity?.value,
          items: clarity.map((clarityValue) {
            return DropdownMenuItem<String>(
              value: clarityValue,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15.0), // Add padding here
                child: Text(
                  clarityValue ?? '',
                  style: TextStyle(fontSize: getFontSize(13)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          }).toList(),
          decoration: InputDecoration(
            labelText: "clarity".tr,
            hintText: "Select clarity".tr,
            contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
            labelStyle: TextStyle(
              color: ColorConstant.gray500,
            ),
            hintStyle: TextStyle(
              color: ColorConstant.gray500,
            ),
            focusColor: ColorConstant.logoFirstColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            filled: false,
            fillColor: ColorConstant.whiteA700,
          ),
          onChanged: (newValue) {
            setState(() {
              selectedClarity?.value = newValue!;
            });
          },
          hint: Text('Select clarity'.tr),
        ),
      );
    });
  }

  Widget colorDropDown(BuildContext context,) {
    return Obx(() {
      return Container(
        height: getSize(50),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: DropdownButtonFormField(
          value: selectedColor?.value,
          items: diamondColors?.map((color) {
            return DropdownMenuItem<String>(
              value: color,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15.0), // Add padding here
                child: Text(color ?? ''),
              ),
            );
          }).toList(),
          decoration: InputDecoration(
            labelText: "Diamond color".tr,
            hintText: "Select color".tr,
            contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
            labelStyle: TextStyle(
              color: ColorConstant.gray500,
            ),
            hintStyle: TextStyle(
              color: ColorConstant.gray500,
            ),
            focusColor: ColorConstant.logoFirstColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            filled: false,
            fillColor: ColorConstant.whiteA700,
          ),
          onChanged: (newValue) {
            setState(() {
              selectedColor?.value = newValue!;
            });
          },
          hint: Text('Select Color'.tr),
        ),
      );
    });
  }

  showVideo(context, String video) {
    AlertDialog alert = AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.white,
      content: Container(
        padding: getPadding(all: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.white),
        ),
        child: ChewieVideoPlayer(
          initialQuality: video,
          isMuted: false,
          videoThumb: AssetPaths.placeholder,
          videoQualities: {
            "360": video,
            "720": video,
          },
          isGeneral: true,
          looping: false,
          allowFullScreen: false,
          allowMute: false,
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            Get.back();
          },
          behavior: HitTestBehavior.translucent,
          child: Padding(
            padding: getPadding(left: 8),
            child: Container(
              height: 40,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: MainColor,
              ),
              alignment: Alignment.center,
              child: Text(
                "Close".tr,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
      actionsAlignment: MainAxisAlignment.spaceAround,
    );

    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  descriptionBottomSheet() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(GoldTheme.radiusLG)),
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag Handle
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(top: GoldTheme.spacingMD, bottom: GoldTheme.spacingSM),
                  decoration: BoxDecoration(
                    color: GoldTheme.goldAccent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: GoldTheme.spacingLG),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.description_outlined, color: GoldTheme.gold, size: 20),
                          const SizedBox(width: GoldTheme.spacingSM),
                          Text(
                            'Product Description'.tr,
                            style: GoldTheme.headingMedium,
                          ),
                        ],
                      ),
                      AnimatedPressable(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: const EdgeInsets.all(GoldTheme.spacingSM),
                          decoration: BoxDecoration(
                            color: GoldTheme.lightGray,
                            borderRadius: BorderRadius.circular(GoldTheme.radiusSM),
                          ),
                          child: Icon(Icons.close_rounded, color: GoldTheme.warmGray, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                
                Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(vertical: GoldTheme.spacingMD),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        GoldTheme.goldAccent.withOpacity(0),
                        GoldTheme.gold.withOpacity(0.3),
                        GoldTheme.goldAccent.withOpacity(0),
                      ],
                    ),
                  ),
                ),
                
                // Editor
                Expanded(
                  child: DescriptionEditor(
                    args: product?.value.description,
                    isLoading: isLoading,
                  ),
                ),
              ],
            ),
            
            // Save Button
            Padding(
              padding: EdgeInsets.only(
                bottom: getBottomPadding() + GoldTheme.spacingMD,
                right: GoldTheme.spacingLG,
              ),
              child: AnimatedPressable(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(GoldTheme.spacingMD),
                  decoration: BoxDecoration(
                    gradient: GoldTheme.goldGradient,
                    borderRadius: BorderRadius.circular(GoldTheme.radiusMD),
                    boxShadow: GoldTheme.goldGlow,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }
}

/// Gold-themed input field widget with focus animations
class _GoldInputFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType inputType;
  final bool required;
  final bool isSwitch;
  final bool readOnly;
  final bool flatDiscount;
  final ValueChanged<bool>? onFlatDiscountChanged;
  final ValueChanged<String>? onChanged;
  
  const _GoldInputFieldWidget({
    Key? key,
    required this.controller,
    required this.label,
    required this.hint,
    this.inputType = TextInputType.text,
    this.required = true,
    this.isSwitch = false,
    this.readOnly = false,
    this.flatDiscount = true,
    this.onFlatDiscountChanged,
    this.onChanged,
  }) : super(key: key);
  
  @override
  State<_GoldInputFieldWidget> createState() => _GoldInputFieldWidgetState();
}

class _GoldInputFieldWidgetState extends State<_GoldInputFieldWidget> {
  bool _isFocused = false;
  final FocusNode _focusNode = FocusNode();
  
  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (mounted) {
        setState(() => _isFocused = _focusNode.hasFocus);
      }
    });
  }
  
  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(GoldTheme.radiusMD),
            border: Border.all(
              color: _isFocused ? GoldTheme.gold : GoldTheme.goldAccent,
              width: _isFocused ? 2 : 1.5,
            ),
            boxShadow: _isFocused ? GoldTheme.goldGlow : null,
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            readOnly: widget.readOnly,
            onChanged: widget.onChanged,
            style: GoldTheme.bodyText.copyWith(
              color: GoldTheme.charcoal,
              fontSize: 15,
            ),
            decoration: InputDecoration(
              labelText: widget.label,
              hintText: widget.hint,
              contentPadding: EdgeInsets.only(
                left: GoldTheme.spacingLG,
                right: widget.isSwitch ? getSize(130) : GoldTheme.spacingLG,
                top: GoldTheme.spacingMD,
                bottom: GoldTheme.spacingMD,
              ),
              labelStyle: GoldTheme.labelMedium.copyWith(
                color: _isFocused ? GoldTheme.gold : GoldTheme.softGray,
              ),
              hintStyle: GoldTheme.labelMedium.copyWith(
                color: GoldTheme.softGray.withOpacity(0.6),
              ),
              floatingLabelStyle: GoldTheme.labelMedium.copyWith(
                color: GoldTheme.gold,
                fontWeight: FontWeight.w600,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              filled: false,
            ),
            keyboardType: widget.inputType,
            validator: widget.required
                ? (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter ${widget.label}';
                    }
                    return null;
                  }
                : null,
          ),
        ),
        if (widget.isSwitch) _buildDiscountSwitch(),
      ],
    );
  }
  
  Widget _buildDiscountSwitch() {
    return Padding(
      padding: const EdgeInsets.only(right: GoldTheme.spacingMD),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: GoldTheme.spacingSM,
          vertical: GoldTheme.spacingXS,
        ),
        decoration: BoxDecoration(
          color: GoldTheme.cream,
          borderRadius: BorderRadius.circular(GoldTheme.radiusSM),
          border: Border.all(color: GoldTheme.goldAccent),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedOpacity(
              opacity: !widget.flatDiscount ? 1.0 : 0.4,
              duration: const Duration(milliseconds: 150),
              child: Icon(
                FontAwesomeIcons.percent,
                size: 12,
                color: GoldTheme.gold,
              ),
            ),
            SizedBox(
              width: 44,
              height: 24,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Switch(
                  value: widget.flatDiscount,
                  activeTrackColor: GoldTheme.goldLight,
                  inactiveTrackColor: GoldTheme.goldLight,
                  activeColor: GoldTheme.gold,
                  inactiveThumbColor: GoldTheme.gold,
                  onChanged: widget.onFlatDiscountChanged,
                ),
              ),
            ),
            AnimatedOpacity(
              opacity: widget.flatDiscount ? 1.0 : 0.4,
              duration: const Duration(milliseconds: 150),
              child: Icon(
                Icons.monetization_on_outlined,
                size: 16,
                color: GoldTheme.gold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
