import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/utils/ShColors.dart';

import '../../../main.dart';
import '../../../models/HomeData.dart';
import '../../../widgets/custom_button.dart';
import '../controller/Filter_Products_controller.dart';
import 'SelectedItems.dart';
import 'package:flutter/src/services/text_formatter.dart';

// This is just a basic scaffold. You'll need to implement state management, HTTP requests, etc.

class FilterMenu extends StatefulWidget {
  final String tag;
  const FilterMenu({super.key, required this.tag});

  @override
  _FilterMenuState createState() => _FilterMenuState();
}

class _FilterMenuState extends State<FilterMenu> {
  int? selectedBrandIds;
  RxString tempCategory = ''.obs;
  Map<String, dynamic> f = <String, dynamic>{};
  RxList<Category> categories = <Category>[].obs;
  RxList<Brand> brands = <Brand>[].obs;
  var unescape = HtmlUnescape();

  late Filter_ProductsController controller;

  @override
  void initState() {
    controller = Get.find(tag: widget.tag);
    controller.categories.forEach((cat) {
      if (cat.id == controller.selectedCategory?.value.id) {
        cat.isSelected = true; // Deselect all categories
      } else {
        cat.isSelected = false; // Deselect all categories
      }
    });

    // iniPrices = action.value == PropAction.rent ? priceRangeRent.obs : priceRange.obs;
    super.initState();
  }

  @override
  void dispose() {
    controller.categories.forEach((cat) {
      if (cat.id == controller.selectedCategory?.value.id) {
        cat.isSelected = true; // Deselect all categories
      } else {
        cat.isSelected = false; // Deselect all categories
      }
    });

    // TODO: implement dispose
    super.dispose();
  }

  Widget priceFilter() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Obx(
            () => RangeSlider(
              values: controller.priceValues.value,
              onChanged: (value) {
                final double start = ((value.start / controller.priceDivider.value).round() * controller.priceDivider.value).toDouble();
                final double end = ((value.end / controller.priceDivider.value).round() * controller.priceDivider.value).toDouble();

                if (start != controller.priceValues.value.start) {
                  controller.minPriceController.text = controller.pretifier(start.toString());
                }

                if (end != controller.priceValues.value.end) {
                  controller.maxPriceController.text = controller.pretifier(end.toString());
                }
                if (start > end) {
                  controller.priceValues.value = RangeValues(start, start);
                } else {
                  controller.priceValues.value = RangeValues(start, end);
                }
              },
              min: 0,
              max: controller.maxPriceFinal.value,
              divisions: null,
              activeColor: ColorConstant.logoSecondColor,
              inactiveColor: ColorConstant.logoFirstColorConstant.withOpacity(0.2),
            ),
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 140,
                padding: EdgeInsets.symmetric(vertical: 10.5, horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color(0XFFF3F4F6),
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(color: ColorConstant.gray300, width: 1.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "min price".tr,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "\$ ",
                          overflow: TextOverflow.ellipsis,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 30,
                            child: TextField(
                              controller: controller.minPriceController,
                              focusNode: controller.minPriceNode,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(width: 0.0),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(width: 0.0),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(width: 0.0),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(width: 0.0),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(width: 0.0),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.only(
                                  left: 5,
                                ),
                              ),
                              onChanged: (value) {
                                controller.minPriceController.value = inputIntegerFormatter(value, controller.minPriceController);

                                if (controller.minPriceController.text.isNotEmpty && controller.maxPriceController.text.isNotEmpty) {
                                  double minPrice = double.parse(controller.minPriceController.text.replaceAll(",", ""));
                                  double maxPrice = double.parse(controller.maxPriceController.text.replaceAll(",", ""));

                                  if (minPrice > maxPrice) {
                                    minPrice = maxPrice;

                                    controller.minPriceController.text = controller.maxPriceController.text; // Optionally update the min controller to reflect this change
                                  }
                                  controller.maxPriceFinal.value = maxPrice;
                                  controller.minPriceFinal.value = minPrice;

                                  controller.priceValues.value = RangeValues(minPrice, maxPrice);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 20,
                child: Divider(
                  thickness: 1.0,
                ),
              ),
              Container(
                width: 140,
                padding: EdgeInsets.symmetric(vertical: 10.5, horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color(0XFFF3F4F6),
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(color: ColorConstant.gray300, width: 1.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "max price".tr,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "\$ ",
                          overflow: TextOverflow.ellipsis,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 30,
                            child: TextField(
                              controller: controller.maxPriceController,
                              focusNode: controller.maxPriceNode,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(width: 0.0),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(width: 0.0),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(width: 0.0),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(width: 0.0),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(width: 0.0),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                filled: true,
                                fillColor: ColorConstant.white,
                                contentPadding: EdgeInsets.only(
                                  left: 5,
                                ),
                              ),
                              onChanged: (value) {
                                controller.maxPriceController.value = inputIntegerFormatter(value, controller.maxPriceController);

                                if (controller.maxPriceController.text.isNotEmpty && controller.minPriceController.text.isNotEmpty) {
                                  double minPrice = double.parse(controller.minPriceController.text.replaceAll(",", ""));
                                  double maxPrice = double.parse(controller.maxPriceController.text.replaceAll(",", ""));

                                  if (minPrice > maxPrice) {
                                    maxPrice = minPrice;
                                    controller.maxPriceController.text = controller.minPriceController.text; // Optionally update the max controller to reflect this change
                                  }

                                  controller.priceValues.value = RangeValues(minPrice, maxPrice);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  TextEditingValue inputIntegerFormatter(String value, TextEditingController controller) {
    String clearNum = value.replaceAll(',', '');
    String amount = clearNum;

    int cursorPos = controller.selection.extentOffset;
    int periodsInitialBeforeCursor = value.substring(0, cursorPos).split(',').length - 1;

    int cursorPosForClear = cursorPos - periodsInitialBeforeCursor;
    if (cursorPosForClear < 0) {
      cursorPosForClear = 0;
    }

    String result = "";
    List<int> commaAddedPositions = [];
    for (int i = amount.length; i > 0; i -= 3) {
      if (i - 3 > 0) {
        result = ",${amount.substring(i - 3, i)}$result";
        commaAddedPositions.add(i - 3);
      } else {
        result = amount.substring(0, i) + result;
      }
    }
    amount = result;

    int periodsBeforCursor = commaAddedPositions.where((pos) => pos < cursorPosForClear).length;
    cursorPos += (periodsBeforCursor - periodsInitialBeforeCursor);
    if (cursorPos > amount.length) {
      cursorPos = amount.length;
    }

    return TextEditingValue(
      text: amount,
      selection: TextSelection.collapsed(offset: cursorPos),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: getTopPadding(), left: 18, right: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter'.tr,
                style: TextStyle(fontSize: getFontSize(25), color: Colors.black, fontWeight: FontWeight.w800),
              ),
              TextButton(
                  onPressed: () {
                    controller.categories.forEach((category) {
                      category.isSelected = false;
                    });
                    controller.categories.refresh();
                    controller.brands.forEach((brand) {
                      brand.isSelected = false;
                    });
                    controller.brands.refresh();
                  },
                  child: Obx(() => MyCustomButton(
                        height: 40,
                        text: "Save".tr,
                        fontSize: getFontSize(20),
                        circularIndicatorColor: Colors.white,
                        buttonColor: ColorConstant.logoSecondColor,
                        borderColor: Colors.transparent,
                        width: getSize(80),
                        isExpanded: controller.loader.value,
                        onTap: () {
                          controller.selectedCategoryIds = controller.selectedCategoryIds;
                          // controller.category.value = tempCategory.value;
                          controller.loading.value = true;
                          controller.Products?.clear();
                          if (controller.selectedCategoryIds != null) {
                            f.addAll({
                              "categories": [
                                controller.selectedCategoryIds.toString(),
                              ],
                            });
                          }

                          if (controller.selectedCity.value != null && controller.selectedCity.value.toString() != "All") {
                            f.addAll({
                              "city": [controller.selectedCityId.value]
                            });
                          }
                          if (controller.minPriceController.text != "" && controller.maxPriceController.text != "") {
                            f.addAll({
                              "min": [controller.minPriceController.text],
                              "max": [controller.maxPriceController.text]
                            });
                          }

                          controller.title.value = controller.selectedCategory!.value.categoryName;
                          controller.type = jsonEncode(f);
                          controller.loader.value = true;
                          controller.page.value = 1;
                          Future.delayed(Duration(milliseconds: 500)).then((value) {
                            controller.category.value = controller.selectedCategory!.value.id.toString();
                            controller.subCategoriesList.value = globalController.homeDataList.value.categories!.where((category) => category.parent == int.parse(controller.category.value)).toList();
                          });
                          controller.getProducts(controller.page.value).then((value) {
                            Get.back();
                          });
                        },
                      ))), // Implement handleClearAll
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
          child: SizedBox(
              height: getSize(30),
              child: SelectedItemsWidget(
                categories: controller.categories,
                brands: controller.brands,
                tag: widget.tag,
              )),
        ),
        const Divider(),
        Expanded(
          child: Obx(() => ListView(
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                children: [
                  // DropdownButtonHideUnderline(
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       color:  ColorConstant.whiteA700,
                  //       border: Border.all(color: Colors.grey),
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //     padding: EdgeInsets.symmetric(horizontal: 10),
                  //     child: DropdownButton2(
                  //       iconSize: getSize(25),
                  //       dropdownPadding: getPadding(all: 0),
                  //       alignment: Alignment.center,
                  //       dropdownWidth: getHorizontalSize(200),
                  //       dropdownScrollPadding: getPadding(all: 0),
                  //       hint: Row(
                  //         children: [
                  //           Text(
                  //             'العام الدراسي',
                  //             style: TextStyle(
                  //               fontSize: getFontSize(14),
                  //               color: Theme.of(context).hintColor,
                  //             ),
                  //           ),
                  //           SizedBox(
                  //             width: 20,
                  //           ),
                  //           Obx(() {
                  //             return controller.years.isEmpty ? Ui.circularIndicator(color: ColorConstant.mainColor, width: getSize(15), height: getSize(15), strokeWidth: 1) : SizedBox();
                  //           })
                  //         ],
                  //       ),
                  //       items: controller.years
                  //           .map((item) => DropdownMenuItem<String>(
                  //         value: item.year.toString(),
                  //         child: Text(
                  //           item.year.toString(),
                  //           textAlign: TextAlign.start,
                  //           style: TextStyle(fontSize: getFontSize(14), color: ColorConstant.mainColor),
                  //         ),
                  //       ))
                  //           .toList(),
                  //       value: controller.selectedYear.value.isEmpty ? null : controller.selectedYear.value,
                  //       onChanged: (value) {
                  //         controller.selectedYear.value = value.toString();
                  //         controller.selectedYearId.value = controller.years.firstWhere((element) => element.year.toString() == value).id.toString();
                  //         controller.getLevels();
                  //       },
                  //       buttonHeight: getVerticalSize(40),
                  //       itemHeight: 40,
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(left: 14.0),
                    child: Text(
                      'City'.tr,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: getPadding(
                      all: 16.0,
                    ),
                    child: Obx(
                      () => Container(
                        constraints: BoxConstraints(minWidth: Get.width / 3, maxWidth: Get.width / 2),
                        height: getSize(50),
                        width: getHorizontalSize(200),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(color: Colors.white.withOpacity(0.5)),
                          color: sh_light_grey, // Use sh_light_grey here
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 1,
                              offset: const Offset(1, 2),
                            ),
                          ],
                        ),
                        padding: getPadding(left: 8, right: 12),
                        alignment: Alignment.bottomCenter,
                        child: DropdownButtonHideUnderline(
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              canvasColor: sh_light_grey, // Dropdown background color
                              popupMenuTheme: PopupMenuThemeData(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ),
                            child: DropdownButton<String>(
                              value: controller.selectedCity.value,
                              items: List.generate(
                                  controller.cities.length,
                                  (index) => DropdownMenuItem(
                                        value: controller.cities[index].values.last,
                                        child: Text(
                                          controller.cities[index].values.last.tr,
                                          style: TextStyle(color: Colors.black87, fontSize: getFontSize(13)), // Text color
                                        ),
                                      )),
                              onChanged: (value) {
                                controller.selectedCity.value = value!;
                                controller.selectedCityId.value = controller.cities.firstWhere((element) => element.values.first == value).keys.first;

                                String jsonString = jsonEncode(f);
                                controller.type = jsonString;
                                // controller.getProducts(1).then((value) {
                                //   controller.loader.value = false;
                                //   Get.back();
                                // });
                                // ... Your existing onChanged logic ...
                              },
                              hint: Text(
                                'Select City'.tr,
                                style: TextStyle(color: Colors.black54), // Hint text style
                              ),
                              icon: const Icon(
                                Icons.arrow_drop_down_sharp,
                                color: Colors.black, // Icon color
                              ),
                              style: TextStyle(color: Colors.black),
                              // Selected item style
                              isExpanded: true,
                              dropdownColor: sh_light_grey,
                              elevation: 16,
                              // Shadow elevation
                              borderRadius: BorderRadius.circular(15),
                              // Border radius of dropdown
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), // Inner padding
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: getVerticalSize(150), child: priceFilter()),
                  Padding(
                    padding: const EdgeInsets.only(left: 14.0),
                    child: Text(
                      'Category'.tr,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                  ...controller.categories.map((category) {
                    return InkWell(onTap: () {
                      // If this category is being selected
                      controller.categories.forEach((cat) {
                        cat.isSelected = false; // Deselect all categories
                      });
                      setState(() {
                        category.isSelected = true;
                      }); // Select this specific category
                      controller.selectedCategory?.value = category;
                      controller.selectedCategoryIds = category.id;
                      tempCategory.value = category.id.toString();
                    }, child: Obx(() {
                      return Container(
                        padding: const EdgeInsets.all(8), // Add padding around the text
                        decoration: BoxDecoration(
                          color: controller.selectedCategory?.value.id == category.id ? ColorConstant.logoSecondColor : Colors.transparent, // Change the color based on selection
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            unescape.convert(category.categoryName),
                            style: TextStyle(color: controller.selectedCategory?.value.id == category.id ? Colors.white : Colors.black), // Change text color based on selection
                          ),
                        ),
                      );
                    }));

                    // CheckboxListTile(
                    //   dense: true,
                    //   title: Text(category.categoryName),
                    //   value: category.isSelected,
                    //   onChanged: (bool? value) {
                    //     if (value == true) {
                    //       // If this category is being selected
                    //       controller.categories.forEach((cat) {
                    //         cat.isSelected = false; // Deselect all categories
                    //       });
                    //       category.isSelected = true; // Select this specific category
                    //     } else {
                    //       category.isSelected = false; // If this category is being deselected, just update its value
                    //     }
                    //     controller.loading.value = true;
                    //     controller.Products?.clear();
                    //     controller.selectedCategoryIds = category.id;
                    //     controller.category.value = category.id.toString();
                    //     var f = {
                    //       "categories": [
                    //         controller.selectedCategoryIds.toString(),
                    //       ],
                    //       "Brands": [
                    //         controller.selectedBrandIds.toString(),
                    //       ],
                    //     };
                    //     controller.type = jsonEncode(f);
                    //   },
                    // );
                  }),
                  // const Divider(),
                  // Padding(
                  //   padding: EdgeInsets.only(left: 14.0),
                  //   child: Text(
                  //     'Brands'.tr,
                  //     style: TextStyle(fontSize: 20),
                  //   ),
                  // ),
                  // ...controller.brands.map((brand) {
                  //   return CheckboxListTile(
                  //     title: Text(brand.brandName),
                  //     value: brand.isSelected,
                  //     onChanged: (bool? value) {
                  //       if (value == true) {
                  //         controller.brands.forEach((bran) {
                  //           bran.isSelected = false;
                  //         });
                  //         brand.isSelected = true;
                  //       } else {
                  //         brand.isSelected = false;
                  //       }
                  //
                  //       controller.loading.value = true;
                  //       controller.Products?.clear();
                  //       controller.selectedBrandIds = brand.id;
                  //       var f = {
                  //         "categories": [
                  //           controller.selectedCategoryIds.toString(),
                  //         ],
                  //         "Brands": [
                  //           controller.selectedBrandIds.toString(),
                  //         ],
                  //       };
                  //       controller.type = jsonEncode(f);
                  //       controller.page.value = 1;
                  //       controller.getProducts(controller.page.value);
                  //     },
                  //   );
                  // }),
                  // Container(
                  //   height: 30,
                  // )
                ],
              )),
        ),
      ],
    );
  }
}
