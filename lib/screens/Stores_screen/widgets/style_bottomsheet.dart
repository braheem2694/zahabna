import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../../../cores/math_utils.dart';
import '../../../main.dart';
import '../../../models/HomeData.dart';
import '../../../utils/ShColors.dart';

class StyleSheetContent extends StatefulWidget {
  final List<ProductType> fields;
  final String type;
  final String? metalName;
  final int index;
  final bool isAdd;
  final bool isStyleEmpty;

  const StyleSheetContent({
    super.key,
    required this.fields,
    required this.type,
    this.metalName,
    required this.index,
    required this.isAdd,
    required this.isStyleEmpty,
  });

  @override
  _StyleSheetContentState createState() => _StyleSheetContentState();
}

class _StyleSheetContentState extends State<StyleSheetContent> {
  final TextEditingController _textEditingController = TextEditingController();
  RxList<RxList> selectedItems = <RxList>[].obs;
  RxList<ItemFormField> fields = <ItemFormField>[].obs;
  RxList<ProductType> typeFields = <ProductType>[].obs;
  Rx<String?>? selectedType;
  Rx<String?>? oldSelectedType;
  Rx<int?>? selectedTypeId;
  String? metalName;

  RxDouble? imageUploadPercent = 0.0.obs;

  @override
  void initState() {
    super.initState();

    // if( globalController.gemstonStylesDropList[widget.index].isNotEmpty){
    //   typeFields.addAll(
    //     globalController.gemstonStylesDropList[widget.index]
    //         .where((element) => element.type == "Gemstone")
    //         .map((productType) => productType.copyWith())
    //         .toList(),
    //   );
    // }
    typeFields.addAll(
      globalController.homeDataList.value.productTypes!
          .where((element) => element.type == "Gemstone")
          .map((productType) => productType.copyWith())
          .toList(),
    );

    try {
      if (widget.isAdd || widget.isStyleEmpty) {
        var sourceList = globalController.gemstonStylesDropList[widget.index]
            .firstWhereOrNull((element) => element.name == widget.metalName)
            ?.items;

        if (sourceList != null) {
          fields.addAll(sourceList.map((item) => item.copyWith()).toList());
        }
      } else {
        var sourceList = widget.fields
            .firstWhereOrNull((element) => element.metalName == widget.metalName && element.name == widget.type)
            ?.items;

        if (sourceList != null) {
          fields.addAll(sourceList.map((item) => item.copyWith()).toList());
        }
      }
    } catch (e) {
      print("Error in deep copying fields: $e");
    }

    oldSelectedType = widget.metalName.obs;
    metalName = widget.metalName;
    selectedTypeId = widget.fields[0].metalId != null ? int.parse(widget.fields[0].metalId.toString()).obs : 000.obs;
    for (var i = 0; i < widget.fields.length; i++) {
      selectedItems.add([].obs);
    }
    globalController.isRequiredCheck.value=false;

    checkRequiredFields();
  }



  checkRequiredFields(){




    globalController.isRequiredCheck.value = false;
    for(int i=0;i<fields.length;i++) {
      if (fields![i].isRequired == true) {
        if (fields[i].fieldType == 'Select') {
          globalController.isRequiredCheck.value = true;
          fields[i].options?.forEach((element) {
            if (element.isSelected) {
              globalController.isRequiredCheck.value = false;
            }
          });
        }
        else{
          globalController.isRequiredCheck.value = true;
          if(fields[i].fieldValue!=''){
            globalController.isRequiredCheck.value = false;

          }
        }
      }
    }




  }



  initGemstonStylesList(int index) {
    globalController.gemstonStylesDropList[widget.index].forEach((element) {
      if (element.name == widget.type) {
        element.isEdited=true;
      }
      else{
        element.isEdited=false;
      }
    });
  }

  Widget typeDropDown(BuildContext context) {
    // if(selectedType?.value!=null){
    //   gemstonesDropDownMap.value = widget.fields.firstWhere((element) => element.metalName==selectedType?.value,).gemstoneMetals!.toList().obs;
    // }
    // else{
    //   globalController.gemstonesDropDownMap.value = globalController.homeDataList.value.productTypes!.where((element) => element.type == "Gemstone").toList().obs;

    // }
    return Container(
      height: getSize(50),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.white, // Dropdown background color
          cardTheme: CardThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
              side: BorderSide(color: Colors.black12),
              // Rounded corners for dropdown menu
            ),
            shadowColor: Colors.black26,

            elevation: 1, // Elevation for the dropdown menu
          ),
        ),
        child: DropdownButtonFormField<String>(
          value: selectedType!=null?selectedType?.value:oldSelectedType?.value,
          items: typeFields.map((type) {
            return DropdownMenuItem<String>(
              value: type.name,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  type.name ?? '',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            );
          }).toList(),
          decoration: InputDecoration(
            labelText: "Metal".tr,
            hintText: "Select metal".tr,
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

            metalName = newValue;
            fields.clear();
            // if (!globalController.gemstonesDropDownMap.containsKey(widget.index)) {
            //   globalController.gemstonesDropDownMap[widget.index] = [];
            // }
            // // widget.fields.firstWhere((element) => element.metalName == selectedType?.value).items?.clear();
            //
            // if(widget.isAdd ||  globalController.gemstonesDropDownMap[widget.index]!.isEmpty){
            //   globalController.gemstonesDropDownMap[widget.index] = widget.fields.map((e) => e.copyWith()).toList();
            //
            // }
            globalController.gemstonStylesDropList[widget.index].firstWhere((element) => element.name==widget.type,).metalName= metalName;
            globalController.gemstonStylesDropList[widget.index].firstWhere((element) => element.name==widget.type,).items?.clear();


            if( globalController.gemstonStylesDropList[widget.index].isNotEmpty ){
              resetGemstonStylesList(widget.index);
              List<ProductType> tempType =    globalController.gemstonStylesDropList[widget.index]
                  .where((element) => element.name ==widget.type && element.metalName == widget.metalName)
                  .map((productType) => productType.copyWith())
                  .toList();
              print(tempType);
              // fields.addAll(
              //   tempType.firstWhereOrNull((element) => element.name == widget.type)?.items ?? [],
              // );
              if(fields.isEmpty){
               try{
                 fields.addAll(typeFields.firstWhere((element) => element.name == newValue).items ?? []);
               }catch(e){
                 print(e);
               }
              }
              fields.forEach((element) {
                element.isEdited = false;
                element.options?.forEach((element) => element.isSelected=false,);

              });
            }
            globalController.gemstonStylesDropList[widget.index].firstWhere((element) => element.name==widget.type,).isEdited= true;


            fields.forEach((element) {
              element.isEdited = true;
              try {


                // if(!widget.isAdd){
                // globalController.gemstonesDropDownMap[widget.index]?.firstWhere((element) => element.metalName == oldSelectedType?.value).metalName = newValue;
                // globalController.gemstonesDropDownMap[widget.index]?.firstWhere((element) => element.metalName == oldSelectedType?.value).items?.clear();
                // globalController.gemstonesDropDownMap[widget.index]?.firstWhere((element) => element.metalName == oldSelectedType?.value).items?.addAll(fields);
                // globalController.gemstonesDropDownMap[widget.index]?.forEach((element) => element.isEdited=false,);
                // globalController.gemstonesDropDownMap[widget.index]?.firstWhere((element) => element.metalName == oldSelectedType?.value).isEdited = true;
                oldSelectedType?.value=newValue;

                globalController.gemstonStylesDropList[widget.index].forEach((element) => element.isEdited=false,);
                globalController.gemstonStylesDropList[widget.index].firstWhere((element) => element.name == widget.type).isEdited = true;
                globalController.gemstonStylesDropList[widget.index].firstWhere((element) => element.name == widget.type).metalName = newValue;
                globalController.gemstonStylesDropList[widget.index].firstWhere((element) => element.name == widget.type).items?.clear();
                globalController.gemstonStylesDropList[widget.index].firstWhere((element) => element.name == widget.type).items?.addAll(fields);
                // globalController.selectedGemstoneStyle[widget.index]=newValue;

                globalController.gemstonStylesDropList[widget.index]?.firstWhere((element) => element.metalName == oldSelectedType?.value).metalId = int.parse(globalController.homeDataList.value.productTypes!.firstWhere((element) => element.name == oldSelectedType?.value).id.toString());
                if (selectedType == null) {
                  selectedType = Rx<String?>(newValue);
                } else {
                  selectedType!.value = newValue;
                }




              } catch (e) {
                print(e);
              }
            });

            for(int i=0;i<fields.length;i++){
              if(fields[i].isRequired==true){
                globalController.isRequiredCheck.value=true;

              }
            }
            checkRequiredFields();
            // Handle value change
          },
          hint: Text(
            'Select metal'.tr,
            style: TextStyle(color: ColorConstant.gray500),
          ),
          validator: (value) {
            if (value == null) {
              return 'Please select a metal'.tr;
            }
            return null;
          },
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87, // Dropdown item text color
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.9,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: getPadding(bottom: 8.0),
                child: typeDropDown(context),
              ),

              Obx(() {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: (fields.length / 2).ceil(), // Group items into rows of 2
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
                            child: _buildField(fields[firstItemIndex], firstItemIndex, _textEditingController),
                          ),
                          // Second item in the row, if it exists
                          if (secondItemIndex < fields.length) SizedBox(width: 8), // Space between columns
                          if (secondItemIndex < fields.length)
                            Expanded(
                              child: _buildField(fields[secondItemIndex], secondItemIndex, _textEditingController),
                            ),
                        ],
                      ),
                    );
                  },
                );
              }),
              SizedBox(height: 16), // Fixed spacing
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build individual field widgets
  Widget _buildField(ItemFormField item, int index, TextEditingController textEditingControllerA) {
    final TextEditingController textEditingController = TextEditingController();
    if (item.fieldType != 'Select') {
      textEditingController.text = item.fieldValue ?? "";
      return TextFormField(
        controller: textEditingController,
        onChanged: (value) {
          try {
            item.isEdited = true;
            item.fieldValue = value;

            if (widget.isAdd) {
              globalController.gemstonStylesDropList[widget.index]
                  ?.firstWhere((element) => element.name == widget.type)
                  .items
                  ?.firstWhere((element) => element.id == item.id)
                  .fieldValue = value;
            } else {
              globalController.gemstonStylesDropList[widget.index]
                  ?.firstWhere((element) => element.metalName == oldSelectedType?.value)
                  .items
                  ?.firstWhere((element) => element.id == item.id)
                  .fieldValue = value;
            }
            checkRequiredFields();

          } catch (e) {}
        },
        keyboardType: item.fieldType == "text" ? TextInputType.text : TextInputType.number,
        style: TextStyle(color: Colors.black, fontSize: getFontSize(14)),
        decoration: InputDecoration(
          labelText: item.field,
          floatingLabelBehavior: FloatingLabelBehavior.always, // Keeps label in place
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
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
        ),
        validator: (value) {
          if (item.isRequired == true && (value == null || value.trim().isEmpty)) {
            globalController.isRequiredCheck.value = true;
            return 'This field is required';
          } else {
            globalController.isRequiredCheck.value = false;
          }
          return null;
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                   item.field??"",
                    style: TextStyle(color: Colors.black54),
                  ),
                  Spacer(),
                  Text(
                    item.unit!=null && item.unit!.isNotEmpty ?  item.unit!:'',
                    style: TextStyle(color: ColorConstant.logoSecondColor, fontSize: getFontSize(12)),
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
                'This field is required'.tr,
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
                      // 1. Update isSelected in item.options
                      item.options!.firstWhere((value) => value.value == element.value).isSelected = false;

                      // 2. Update isSelected in gemstonStylesDropList
                      if (globalController.gemstonStylesDropList.length > widget.index) {
                        var gemstone = globalController.gemstonStylesDropList[widget.index]
                            .firstWhereOrNull((element) => element.name == widget.type);

                        if (gemstone != null) {
                          // Find the corresponding item and update the option
                          var targetItem = gemstone.items?.firstWhereOrNull((tempItem) => tempItem.id == item.id);
                          if (targetItem != null) {
                            targetItem.options?.firstWhere((opt) => opt.value == element.value).isSelected = false;
                          }
                        }
                      }

                      // 3. Handle required check status
                      checkRequiredFields();

                    });
                  }

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
          title: const Text('Select Options'),
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
                        ItemOption tempOption =  item.options!.firstWhere((value) => value.value == element.value);
                        if (value == true) {
                          item.options!.firstWhere((value) => value.value == element.value).isSelected = true;
                          if (widget.isAdd) {
                            if( globalController.gemstonStylesDropList[widget.index]!.firstWhere((element) => element.name == widget.type).items!.isNotEmpty){
                              globalController.gemstonStylesDropList[widget.index]?.firstWhere((element) => element.name == widget.type).items?.firstWhere((element) => element.id == item.id).isEdited = value??false;
                              globalController.gemstonStylesDropList[widget.index]?.firstWhere((element) => element.name == widget.type).items?.firstWhere((element) => element.id == item.id).options?.firstWhere((tempElement) => tempElement.id == tempOption.id).isSelected =  value??false;


                            }
                            else{
                              globalController.gemstonStylesDropList[widget.index]?.firstWhere((element) => element.name == widget.type).items?.add(item.copyWith());
                              globalController.gemstonStylesDropList[widget.index]?.firstWhere((element) => element.name == widget.type).items?.firstWhere((element) => element.id == item.id).isEdited = value??false;
                              globalController.gemstonStylesDropList[widget.index]?.firstWhere((element) => element.name == widget.type).items?.firstWhere((element) => element.id == item.id).options?.firstWhere((tempElement) => tempElement.id == tempOption.id).isSelected =  value??false;


                            }
                          } else {
                            print( selectedType?.value);
                            print( oldSelectedType?.value);
                            if(globalController.gemstonStylesDropList[widget.index]!.firstWhere((element) => element.name == widget.type).items!.isNotEmpty){
                              globalController.gemstonStylesDropList[widget.index]?.firstWhere((element) => element.name == widget.type).items?.firstWhere((element) => element.id == item.id).isEdited =  value??false;
                              globalController.gemstonStylesDropList[widget.index]?.firstWhere((element) => element.name == widget.type).items?.firstWhere((element) => element.id == item.id).options?.firstWhere((tempElement) => tempElement.id == tempOption.id).isSelected =  value??false;


                            }
                            else{
                              globalController.gemstonStylesDropList[widget.index]?.firstWhere((element) => element.name == widget.type).items?.add(item.copyWith());
                              globalController.gemstonStylesDropList[widget.index]?.firstWhere((element) => element.name == widget.type).items?.firstWhere((element) => element.id == item.id).isEdited = value??false;
                              globalController.gemstonStylesDropList[widget.index]?.firstWhere((element) => element.name == widget.type).items?.firstWhere((element) => element.id == item.id).options?.firstWhere((tempElement) => tempElement.id == tempOption.id).isSelected =  value??false;


                            }
                          }

                          tempSelectedItems.add(element);
                        }

                        else {
                          item.options!.firstWhere((value) => value.value == element.value).isSelected =  value??false;
                          if (widget.isAdd) {
                            if( globalController.gemstonStylesDropList[widget.index]!.firstWhere((element) => element.name == widget.type).items!.isNotEmpty){
                              globalController.gemstonStylesDropList[widget.index]?.firstWhere((element) => element.name == widget.type).items?.firstWhere((element) => element.id == item.id).isEdited =  value??false;

                            }
                            else{
                              globalController.gemstonStylesDropList[widget.index]?.firstWhere((element) => element.name == widget.type).items!.add(item.copyWith());
                              globalController.gemstonStylesDropList[widget.index]?.firstWhere((element) => element.name == widget.type).items?.firstWhere((element) => element.id == item.id).isEdited =  value??false;


                            }
                          } else {
                            if( globalController.gemstonStylesDropList[widget.index]!.firstWhere((element) => element.name == widget.type).items!.isNotEmpty){
                              globalController.gemstonStylesDropList[widget.index]?.firstWhere((element) => element.name == widget.type).items?.firstWhere((element) => element.id == item.id).isEdited =  value??false;
                              globalController.gemstonStylesDropList[widget.index]?.firstWhere((element) => element.name == widget.type).items?.firstWhere((element) => element.id == item.id).options?.firstWhere((tempElement) => tempElement.id == tempOption.id).isSelected = value??false;

                            }
                            else{
                              globalController.gemstonStylesDropList[widget.index]?.firstWhere((element) => element.name == widget.type).items!.add(item.copyWith());
                              globalController.gemstonStylesDropList[widget.index]?.firstWhere((element) => element.name == widget.type).items?.firstWhere((element) => element.id == item.id).isEdited =  value??false;

                            }
                          }
                          tempSelectedItems.remove(element);
                        }
                        checkRequiredFields();


                      });
                    },
                  );
                });
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('Cancel',style: TextStyle(color: ColorConstant.redA700),),
            ),
            TextButton(
              onPressed: () {
                Get.back(result: item.options);
              },
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
  void resetGemstonStylesList(int index) {
    // Ensure the index exists in the list
    if (globalController.gemstonStylesDropList.length > index) {
      // Perform a deep copy to avoid modifying other indexes
      var deepCopiedList = globalController.gemstonStylesDropList[index]
          .map((productType) => productType.copyWith(
        items: productType.items?.map((item) {
          return item.copyWith(
            fieldValue: "", // Reset fieldValue
            options: item.options?.map((option) {
              return option.copyWith(isSelected: false); // Unselect all options
            }).toList(),
          );
        }).toList(),
      ))
          .toList();

      // Assign the deep copied and modified list back to the index
      globalController.gemstonStylesDropList[index] = deepCopiedList;
    }
  }

}
