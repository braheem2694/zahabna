import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:iq_mall/cores/math_utils.dart';

import '../../../main.dart';
import '../../../models/HomeData.dart';
import '../../../utils/ShColors.dart';

// ═══════════════════════════════════════════════════════════════════════════
// 🎨 BOTTOM SHEET THEME - Using App Brand Colors
// ═══════════════════════════════════════════════════════════════════════════

class _BottomSheetTheme {
  // Brand Colors
  static Color get primary => ColorConstant.logoFirstColor;
  static Color get accent => ColorConstant.logoSecondColor;
  static Color get error => ColorConstant.redA700;
  
  // Neutral Colors
  static Color get background => Colors.white;
  static Color get surface => ColorConstant.gray50;
  static Color get border => ColorConstant.gray300;
  static Color get textPrimary => ColorConstant.logoFirstColor;
  static Color get textSecondary => ColorConstant.gray500;
  
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
  
  static List<BoxShadow> get accentGlow => [
    BoxShadow(
      color: accent.withOpacity(0.2),
      blurRadius: 10,
      offset: const Offset(0, 3),
    ),
  ];
}

/// Animated pressable wrapper for tap feedback
class _AnimatedPressable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  
  const _AnimatedPressable({Key? key, required this.child, this.onTap}) : super(key: key);
  
  @override
  State<_AnimatedPressable> createState() => _AnimatedPressableState();
}

class _AnimatedPressableState extends State<_AnimatedPressable> {
  bool _isPressed = false;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOutCubic,
        child: AnimatedOpacity(
          opacity: _isPressed ? 0.8 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: widget.child,
        ),
      ),
    );
  }
}

class BottomSheetContent extends StatefulWidget {
  final List<ItemFormField> fields;
  final String type;
  final String metalType;

  const BottomSheetContent({super.key, required this.fields, required this.type, required this.metalType});

  @override
  _BottomSheetContentState createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  RxList<RxList> selectedItems = <RxList>[].obs;

  RxBool saving = true.obs;

  RxDouble? imageUploadPercent = 0.0.obs;

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.fields.length; i++) {
      selectedItems.add([].obs);
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      updateFinalData();
    });
    globalController.isRequiredCheck.value=false;

    for(int i=0;i<widget.fields.length;i++){
     if(widget.fields[i].isRequired==true){
       globalController.isRequiredCheck.value=true;

     }
    }
    checkRequiredFields();


  }


  checkRequiredFields(){
    for(int i=0;i<widget.fields.length;i++) {
      if (widget.fields[i].isRequired == true) {
        if (widget.fields[i].fieldType == 'Select') {
          globalController.isRequiredCheck.value = true;

          bool isOptionSelected =false;

          widget.fields[i].options?.forEach((element) {
            if (element.isSelected) {
              isOptionSelected = true;
            }
          });
          if(!isOptionSelected){
            globalController.isRequiredCheck.value = true;
            break;
          }
          else{
            globalController.isRequiredCheck.value = false;

          }
        }
        else{
          globalController.isRequiredCheck.value = true;

          if(widget.fields[i].fieldValue!=''){
            globalController.isRequiredCheck.value = false;

          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.85,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: _BottomSheetTheme.spacingLG),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.only(bottom: _BottomSheetTheme.spacingMD),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 20,
                      decoration: BoxDecoration(
                        color: _BottomSheetTheme.accent,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: _BottomSheetTheme.spacingSM),
                    Text(
                      "${widget.type} Details".tr,
                      style: TextStyle(
                        color: _BottomSheetTheme.primary,
                        fontSize: getFontSize(17),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Fields Grid
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: (widget.fields.length / 2).ceil(),
                itemBuilder: (context, rowIndex) {
                  final firstItemIndex = rowIndex * 2;
                  final secondItemIndex = firstItemIndex + 1;
                  final TextEditingController textEditingController = TextEditingController();

                  return Padding(
                    padding: const EdgeInsets.only(bottom: _BottomSheetTheme.spacingMD),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildField(widget.fields[firstItemIndex], firstItemIndex, textEditingController),
                        ),
                        if (secondItemIndex < widget.fields.length) 
                          const SizedBox(width: _BottomSheetTheme.spacingSM),
                        if (secondItemIndex < widget.fields.length)
                          Expanded(
                            child: _buildField(widget.fields[secondItemIndex], secondItemIndex, textEditingController),
                          ),
                      ],
                    ),
                  );
                },
              ),
              
              // Bottom padding for save button
              const SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build individual field widgets
  Widget _buildField(ItemFormField item, int index, TextEditingController textEditingController) {
    if (item.fieldType != 'Select') {
      textEditingController.text = item.fieldValue ?? '';
      return _buildTextInputField(item, index, textEditingController);
    } else if (item.fieldType == 'Select') {
      return _buildSelectField(item, index);
    }
    return const SizedBox.shrink();
  }
  
  Widget _buildTextInputField(ItemFormField item, int index, TextEditingController textEditingController) {
    return TextFormField(
      controller: textEditingController,
      onChanged: (value) {
        item.isEdited = true;
        widget.fields[index].fieldValue = value;
        updateFinalData();
        checkRequiredFields();
      },
      keyboardType: item.fieldType == "Text" ? TextInputType.text : TextInputType.number,
      style: TextStyle(
        color: _BottomSheetTheme.textPrimary,
        fontSize: getFontSize(14),
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: item.field ?? '',
        labelStyle: TextStyle(
          color: _BottomSheetTheme.textSecondary,
          fontSize: getFontSize(13),
        ),
        floatingLabelStyle: TextStyle(
          color: _BottomSheetTheme.accent,
          fontWeight: FontWeight.w600,
        ),
        suffix: item.unit != null && item.unit!.isNotEmpty
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _BottomSheetTheme.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  item.unit!,
                  style: TextStyle(
                    color: _BottomSheetTheme.accent,
                    fontSize: getFontSize(11),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : null,
        contentPadding: EdgeInsets.symmetric(
          vertical: getSize(16),
          horizontal: getSize(14),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_BottomSheetTheme.radiusMD),
          borderSide: BorderSide(color: _BottomSheetTheme.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_BottomSheetTheme.radiusMD),
          borderSide: BorderSide(color: _BottomSheetTheme.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_BottomSheetTheme.radiusMD),
          borderSide: BorderSide(color: _BottomSheetTheme.accent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_BottomSheetTheme.radiusMD),
          borderSide: BorderSide(color: _BottomSheetTheme.error),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required'.tr;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
  
  Widget _buildSelectField(ItemFormField item, int index) {
    final hasSelection = item.options?.any((e) => e.isSelected) ?? false;
    final isError = item.isRequired == true && !hasSelection;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _AnimatedPressable(
          onTap: () => _showMultiSelectDialog(item, index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: getSize(54),
            padding: const EdgeInsets.symmetric(horizontal: _BottomSheetTheme.spacingMD),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: isError ? _BottomSheetTheme.error : _BottomSheetTheme.border,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(_BottomSheetTheme.radiusMD),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item.field ?? '',
                    style: TextStyle(
                      color: _BottomSheetTheme.textSecondary,
                      fontSize: getFontSize(13),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: _BottomSheetTheme.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: _BottomSheetTheme.accent,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Error message
        if (isError)
          Padding(
            padding: const EdgeInsets.only(top: _BottomSheetTheme.spacingXS, left: _BottomSheetTheme.spacingXS),
            child: Text(
              '${item.field ?? ''} is required'.tr,
              style: TextStyle(
                color: _BottomSheetTheme.error,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        
        // Selected chips
        if (item.options != null && hasSelection)
          Padding(
            padding: const EdgeInsets.only(top: _BottomSheetTheme.spacingSM),
            child: Wrap(
              spacing: _BottomSheetTheme.spacingXS,
              runSpacing: _BottomSheetTheme.spacingXS,
              children: item.options!
                  .where((element) => element.isSelected)
                  .map((element) => _buildSelectedChip(element, item))
                  .toList(),
            ),
          )
        else if (item.options != null && !hasSelection)
          Padding(
            padding: const EdgeInsets.only(top: _BottomSheetTheme.spacingXS, left: _BottomSheetTheme.spacingXS),
            child: Text(
              'No options selected'.tr,
              style: TextStyle(
                color: _BottomSheetTheme.textSecondary,
                fontSize: 11,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }
  
  Widget _buildSelectedChip(ItemOption element, ItemFormField item) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Chip(
        label: Text(
          element.value ?? 'No name',
          style: TextStyle(
            color: _BottomSheetTheme.primary,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: _BottomSheetTheme.accent.withOpacity(0.15),
        side: BorderSide(color: _BottomSheetTheme.accent.withOpacity(0.3)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_BottomSheetTheme.radiusSM),
        ),
        deleteIcon: Icon(
          Icons.close_rounded,
          size: 16,
          color: _BottomSheetTheme.primary.withOpacity(0.7),
        ),
        onDeleted: () {
          setState(() {
            item.options!.firstWhere((value) => value.value == element.value).isSelected = false;
            checkRequiredFields();
          });
        },
        padding: const EdgeInsets.symmetric(horizontal: 2),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  updateFinalData() {
    if (widget.type == 'Metal') {
      globalController.itemMetal.value = globalController.homeDataList.value.productTypes!
          .firstWhere((element) => element.name == widget.metalType)
          .copyWith(); // Copy to avoid modifying the original list

      // Update `fieldValue` and `options` in `widget.fields`
      for (var field in widget.fields) {
        field.fieldValue = field.fieldValue ?? ''; // Assign default value if null
        field.options = field.options ?? []; // Ensure options are not null
      }

      globalController.itemMetal.value.items = List.from(widget.fields); // Assign updated fields list

      // Update metals list
      int index = globalController.metals.indexWhere((element) => element.name == widget.metalType);
      if (index != -1) {
        globalController.metals[index] = globalController.itemMetal.value;
      } else {
        globalController.metals.add(globalController.itemMetal.value);
      }

    }
    else if (widget.type == "Gemstone") {
      globalController.itemGemstone.value = globalController.homeDataList.value.productTypes!
          .firstWhere((element) => element.name == widget.metalType)
          .copyWith(); // Copy to avoid modifying the original list

      // Update `fieldValue` and `options` in `widget.fields`
      for (var field in widget.fields) {
        field.fieldValue = field.fieldValue ?? ''; // Assign default value if null
        field.options = field.options ?? []; // Ensure options are not null
      }

      globalController.itemGemstone.value.items = List.from(widget.fields); // Assign updated fields list

      // Update gemstones list
      int index = globalController.gemstones.indexWhere((element) => element.name == widget.metalType);
      if (index != -1) {
        globalController.gemstones[index] = globalController.itemGemstone.value;
      } else {
        globalController.gemstones.add(globalController.itemGemstone.value);
      }
    }
    print("e");
  }

  void _showMultiSelectDialog(ItemFormField item, int i) async {
    final RxList<ItemOption> tempSelectedItems = <ItemOption>[].obs;
    item.options?.forEach((element) {
      if (element.isSelected) {
        tempSelectedItems.add(element);
      }
    });

    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 250),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          ),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: Get.width * 0.85,
              constraints: BoxConstraints(maxHeight: Get.height * 0.6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(_BottomSheetTheme.radiusLG),
                boxShadow: _BottomSheetTheme.softShadow,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(_BottomSheetTheme.spacingLG),
                    decoration: BoxDecoration(
                      color: _BottomSheetTheme.accent.withOpacity(0.08),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(_BottomSheetTheme.radiusLG),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(_BottomSheetTheme.spacingSM),
                          decoration: BoxDecoration(
                            color: _BottomSheetTheme.accent.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(_BottomSheetTheme.radiusSM),
                          ),
                          child: Icon(
                            Icons.checklist_rounded,
                            color: _BottomSheetTheme.accent,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: _BottomSheetTheme.spacingMD),
                        Expanded(
                          child: Text(
                            'Select ${item.field ?? "Options"}'.tr,
                            style: TextStyle(
                              color: _BottomSheetTheme.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        _AnimatedPressable(
                          onTap: () => Get.back(),
                          child: Container(
                            padding: const EdgeInsets.all(_BottomSheetTheme.spacingSM),
                            decoration: BoxDecoration(
                              color: _BottomSheetTheme.border.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(_BottomSheetTheme.radiusSM),
                            ),
                            child: Icon(
                              Icons.close_rounded,
                              color: _BottomSheetTheme.textSecondary,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Options List
                  Flexible(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(vertical: _BottomSheetTheme.spacingSM),
                      child: Column(
                        children: item.options == null
                            ? []
                            : item.options!.map((element) {
                                return Obx(() {
                                  final isSelected = tempSelectedItems.contains(element);
                                  return _buildModernCheckboxTile(
                                    element: element,
                                    isSelected: isSelected,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (value == true) {
                                          item.options!.firstWhere((v) => v.value == element.value).isSelected = true;
                                          tempSelectedItems.add(element);
                                        } else {
                                          item.options!.firstWhere((v) => v.value == element.value).isSelected = false;
                                          tempSelectedItems.remove(element);
                                        }
                                      });
                                      updateFinalData();
                                      checkRequiredFields();
                                    },
                                  );
                                });
                              }).toList(),
                      ),
                    ),
                  ),
                  
                  // Actions
                  Container(
                    padding: const EdgeInsets.all(_BottomSheetTheme.spacingMD),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: _BottomSheetTheme.border.withOpacity(0.5)),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _AnimatedPressable(
                            onTap: () => Get.back(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: _BottomSheetTheme.spacingMD),
                              decoration: BoxDecoration(
                                color: _BottomSheetTheme.surface,
                                borderRadius: BorderRadius.circular(_BottomSheetTheme.radiusSM),
                                border: Border.all(color: _BottomSheetTheme.border),
                              ),
                              child: Center(
                                child: Text(
                                  'Cancel'.tr,
                                  style: TextStyle(
                                    color: _BottomSheetTheme.textSecondary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: _BottomSheetTheme.spacingMD),
                        Expanded(
                          child: _AnimatedPressable(
                            onTap: () => Get.back(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: _BottomSheetTheme.spacingMD),
                              decoration: BoxDecoration(
                                color: _BottomSheetTheme.primary,
                                borderRadius: BorderRadius.circular(_BottomSheetTheme.radiusSM),
                              ),
                              child: Center(
                                child: Text(
                                  'Confirm'.tr,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  
  /// Modern checkbox tile with animations
  Widget _buildModernCheckboxTile({
    required ItemOption element,
    required bool isSelected,
    required ValueChanged<bool?> onChanged,
  }) {
    return _AnimatedPressable(
      onTap: () => onChanged(!isSelected),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(
          horizontal: _BottomSheetTheme.spacingMD,
          vertical: _BottomSheetTheme.spacingXS,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: _BottomSheetTheme.spacingMD,
          vertical: _BottomSheetTheme.spacingMD,
        ),
        decoration: BoxDecoration(
          color: isSelected 
              ? _BottomSheetTheme.accent.withOpacity(0.1) 
              : Colors.white,
          borderRadius: BorderRadius.circular(_BottomSheetTheme.radiusMD),
          border: Border.all(
            color: isSelected 
                ? _BottomSheetTheme.accent 
                : _BottomSheetTheme.border.withOpacity(0.5),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Custom animated checkbox
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isSelected ? _BottomSheetTheme.primary : Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isSelected 
                      ? _BottomSheetTheme.primary 
                      : _BottomSheetTheme.border,
                  width: 2,
                ),
                boxShadow: isSelected ? _BottomSheetTheme.accentGlow : null,
              ),
              child: AnimatedOpacity(
                opacity: isSelected ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 150),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
            const SizedBox(width: _BottomSheetTheme.spacingMD),
            
            // Label
            Expanded(
              child: Text(
                element.value ?? "No name",
                style: TextStyle(
                  color: isSelected 
                      ? _BottomSheetTheme.primary 
                      : _BottomSheetTheme.textPrimary,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
            
            // Selection indicator
            AnimatedOpacity(
              opacity: isSelected ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 150),
              child: Icon(
                Icons.check_circle_rounded,
                color: _BottomSheetTheme.accent,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
