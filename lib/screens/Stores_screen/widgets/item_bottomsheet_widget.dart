import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:iq_mall/cores/math_utils.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../../../main.dart';
import '../../../models/HomeData.dart';
import '../../../utils/ShColors.dart';
import '../../../widgets/custom_button.dart';

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
      height: Get.height * 0.9,
      child: Padding(
        padding: getPadding(left: 16.0, right: 16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: getPadding(bottom: 8.0),
                child: Text(
                  "${widget.type} Details".tr,
                  style: TextStyle(color: ColorConstant.logoSecondColor, fontSize: getFontSize(16)),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: (widget.fields.length / 2).ceil(), // Group items into rows of 2
                itemBuilder: (context, rowIndex) {
                  // Get items for the current row
                  final firstItemIndex = rowIndex * 2;
                  final secondItemIndex = firstItemIndex + 1;
                  final TextEditingController _textEditingController = TextEditingController();

                  return Padding(
                    padding: getPadding(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // First item in the row
                        Expanded(
                          child: _buildField(widget.fields[firstItemIndex], firstItemIndex, _textEditingController),
                        ),
                        // Second item in the row, if it exists
                        if (secondItemIndex < widget.fields.length) const SizedBox(width: 8), // Space between columns
                        if (secondItemIndex < widget.fields.length)
                          Expanded(
                            child: _buildField(widget.fields[secondItemIndex], secondItemIndex, _textEditingController),
                          ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 16), // Fixed spacing
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build individual field widgets
  Widget _buildField(ItemFormField item, int index, TextEditingController textEditingController) {
    if (item.fieldType != 'Select') {
      textEditingController.text=item.fieldValue??'';
      return TextFormField(
        controller: textEditingController,
        onChanged: (value) {
          item.isEdited = true;
          widget.fields[index].fieldValue = value;
          updateFinalData();
          checkRequiredFields();


        },
        keyboardType: item.fieldType == "Text" ? TextInputType.text : TextInputType.number,
        style: TextStyle(color: Colors.black, fontSize: getFontSize(14)),
        decoration: InputDecoration(
          labelText: item.field ?? '',
          suffix: Text(
            item.unit ?? '',
            style: TextStyle(
              color: ColorConstant.logoSecondColor,
              fontSize: getFontSize(12),
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: getSize(20), // Adjust for height
            horizontal: getSize(16),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),

        ),

        validator: (value) {
          if ( value == null || value.trim().isEmpty) {

            return 'This field is required'.tr;
          }
          else{
            return null;

          }
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
      );
    }
    else if (item.fieldType == 'Select') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => _showMultiSelectDialog(item, index),
            child: Container(
              height: getSize(60),
              padding: EdgeInsets.symmetric(horizontal: 12, ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                   item.field??'',
                    style: TextStyle(color: Colors.black54),
                  ),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
          if (item.isRequired==true && (item.options == null || !item.options!.any((element) => element.isSelected)))
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                '${item.field??''} is required'.tr,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          if (item.options != null)
            item.options!.where((element) => element.isSelected).isNotEmpty
                ? Wrap(
              spacing: 4.0,
              runSpacing: 2.0,
              children: item.options!
                  .where((element) => element.isSelected)
                  .map((element) => Chip(
                label: Text(element.value ?? 'No name'),
                deleteIcon: Icon(Icons.close),
                onDeleted: () {
                  setState(() {
                    item.options!.firstWhere((value) => value.value == element.value).isSelected = false;
                    checkRequiredFields();

                    // if (item.isRequired==true && (item.options == null || !item.options!.any((element) => element.isSelected))){
                    //   globalController.isRequiredCheck.value=true;
                    // }
                    // else{
                    //   globalController.isRequiredCheck.value=false;
                    //
                    // }
                  });
                },
              ))
                  .toList(),
            )
                : Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                'No options selected'.tr,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      );
    }
    return SizedBox.shrink();
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
    final List<ItemOption>? results = await showDialog<List<ItemOption>>(
      context: context,
      builder: (BuildContext context) {
        RxList<ItemOption> tempSelectedItems = <ItemOption>[].obs;
        item.options?.forEach((element) {
          if (element.isSelected) {
            tempSelectedItems.add(element);
          }
        });

        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: item.options == null
                  ? []
                  : item.options!.map((element) {
                      return Obx(() {
                        return CheckboxListTile(
                          title: Text(element.value ?? "no name"),
                          value: tempSelectedItems.contains(element),
                          checkColor: ColorConstant.whiteA700,
                          activeColor: ColorConstant.logoFirstColor,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                item.options!.firstWhere((value) => value.value == element.value).isSelected = true;
                                tempSelectedItems.add(element);
                              } else {
                                item.options!.firstWhere((value) => value.value == element.value).isSelected = false;

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
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text('Cancel',style: TextStyle(color: ColorConstant.redA700),),
            ),
            TextButton(
              onPressed: () => Get.back(),
              child: Text('Confirm',style: TextStyle(color: ColorConstant.logoFirstColor),),
            ),
          ],
        );
      },
    );

    if (results != null) {
      setState(() {
        item.options = results;
      });
    }
  }
}
