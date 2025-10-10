import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iq_mall/cores/math_utils.dart';

import '../../../models/Variations.dart';
import '../controller/ProductDetails_screen_controller.dart';

class Variants extends StatefulWidget {
  final List<VariationElement> productVariations;
  ProductDetails_screenController controller;

  Variants({required this.productVariations,required this.controller});

  @override
  _VariantsState createState() => _VariantsState();
}

class _VariantsState extends State<Variants> {
  Map<String, List<OptionValue>> _groupedOptions = {};
  Map<String, OptionValue> _selectedOptions = {};
  bool? isAvailable;

  Map<String, List<VariationElement>> groupedByVariationId = {};

  @override
  void initState() {
    super.initState();
    _groupedOptions = _getProductOptions(widget.productVariations);

    // Create a map to group variations by their variation_id
    if (widget.controller.product.value?.has_option == 1) {
      for (var variation in widget.productVariations) {
        final variationId = variation.variationId.toString();

        if (!groupedByVariationId.containsKey(variationId)) {
          groupedByVariationId[variationId] = [];
        }

        groupedByVariationId[variationId]!.add(variation);
      }

      // Find a variation_id where all associated variations have default_option set to 1
      for (var entry in groupedByVariationId.entries) {
        if (entry.value.every((v) => v.defaultOption == 1)) {
          for (var variation in entry.value) {
            final optionType = variation.type;
            _selectedOptions[optionType] = OptionValue.fromVariationElement(variation);
          }
          break; // Stop the loop once a default combination is found
        }
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _selectedOptions;
        List<int> optionIds = _selectedOptions.values.map((option) => int.parse(option.valueId)).toList();

        VariationElement? result = findVariationElementWithMultipleOptionIds(optionIds, groupedByVariationId);

        if (result != null) {
          widget.controller.loading.value = true;
          widget.controller.updatePriceInAddToCart.value = true;
          if(widget.controller.product.value?.has_option==1){
            widget.controller.product.value?.product_qty_left = result.quantity;
            // widget.controller.update();
          }

          widget.controller.variationChoosen = result.variationId;
          widget.controller.product.value?.product_price = result.price;
          widget.controller.product.value?.price_after_discount = result.priceAfterDiscount;

          widget.controller.loading.value = false;
          widget.controller.updatePriceInAddToCart.value = false;
        }
      });
    }
  }

  VariationElement? findVariationElementWithMultipleOptionIds(List<int> optionIds, Map<String, List<VariationElement>> groupedMap) {
    for (var valueList in groupedMap.values) {
      var foundOptionIds = <int>[];

      for (var element in valueList) {
        if (optionIds.contains(element.valueId)) {
          foundOptionIds.add(element.valueId);
        }

        if (foundOptionIds.length == optionIds.length) {
          return element;
        }
      }
    }

    return null; // Return null if not found
  }

  Map<String, List<OptionValue>> _getProductOptions(List<VariationElement> variations) {
    Map<String, List<OptionValue>> groupedOptions = {};

    for (var variation in variations) {
      if (!variation.hide) {
        final optionId = variation.optionId.toString();
        final valueId = variation.valueId.toString();
        final title = variation.type;

        // Check if the title already exists in the groupedOptions
        if (groupedOptions.containsKey(title)) {
          // Check if the value_id exists in the existing values list
          bool valueExists = groupedOptions[title]!.any(
            (value) => value.valueId == valueId,
          );

          if (!valueExists) {
            // Add a new OptionValue with the same properties
            groupedOptions[title]!.add(OptionValue.fromVariationElement(variation));
          }
        } else {
          // Create a new title entry and add the value to it
          groupedOptions[title] = [OptionValue.fromVariationElement(variation)];
        }
      }
    }

    return groupedOptions;
  }

  void handleOptionChange(
    OptionValue selectedOption,
    String optionId,
  ) {
    setState(() {
      if (_selectedOptions.containsKey(optionId) && _selectedOptions[optionId] == selectedOption) {
        // Item already exists, so remove it
        //  _selectedOptions.remove(optionId);
      } else {
        _selectedOptions[optionId] = selectedOption;
      }

      // Update the grouped options based on the new selections
      // _groupedOptions.forEach((key, values) {
      //   values.forEach((optionValue) {
      //     if (_selectedOptions.values.contains(optionValue)) {
      //       optionValue.hide = false; // Show the option if it's selected
      //     } else {
      //       // Hide or show based on some condition, here's a simple example:
      //         optionValue.hide = !optionValue.isAvailable;
      //       // Note: You may want to update this condition to match your original JS logic
      //     }
      //   });
      // });
      List<int> optionIds = _selectedOptions.values.map((option) => int.parse(option.valueId)).toList();

      VariationElement? result = findVariationElementWithMultipleOptionIds(optionIds, groupedByVariationId);
      widget.controller.loading.value = true;
      widget.controller.updatePriceInAddToCart.value = true;
      widget.controller.variationChoosen = result?.variationId;
      widget.controller.product.value?.product_price = result?.price ?? 0.0;
      widget.controller.product.value?.price_after_discount = result?.priceAfterDiscount;
      if(widget.controller.product.value?.has_option==1){
        widget.controller.product.value?.product_qty_left = result!.quantity;


      }
      // handleOptionChange(_groupedOptions[0]!.first, _groupedOptions[0]!.first.type);
      widget.controller.loading.value = false;
      widget.controller.updatePriceInAddToCart.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _groupedOptions.keys.map((type) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$type:',
                style: TextStyle(
                  fontSize: getFontSize(14),
                  color: Color(0xFF999999),
                ),
              ),
              Wrap(
                spacing: 5,
                runSpacing: 5,
                children: _groupedOptions[type]!.map((value) {
                  // Changes here: remove the if statement
                  return GestureDetector(
                    onTap: () => handleOptionChange(value, type),
                    child: value.isColor
                        ? ColorOptionWidget(value: value, selected: _selectedOptions[type]?.valueId == value.valueId, isAvailable: value.isAvailable) // Pass the availability
                        : TextOptionWidget(value: value, selected: _selectedOptions[type]?.valueId == value.valueId, isAvailable: value.isAvailable), // Pass the availability
                  );
                }).toList(),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class OptionValue {
  final String valueId;
  final double price;
  final bool isColor;
  final Color color;
  final String name;
  final String type; // Add this line
  bool hide;
  final List<String> variationIds; // Add this property
  final bool isAvailable;

  OptionValue({
    this.hide = false,
    this.isAvailable = true,
    required this.valueId,
    required this.price,
    required this.isColor,
    required this.color,
    required this.name,
    required this.type, // Add this line
    required this.variationIds,
  });

  static OptionValue fromVariationElement(VariationElement element) {
    return OptionValue(
      valueId: element.valueId.toString(),
      isAvailable: element.isAvailable,
      price: element.price.toDouble(),
      isColor: element.isColor,
      color: element.color,
      name: element.name,
      type: element.type,
      // Add this line
      variationIds: [element.variationId.toString()], // Initialize with a list containing the variationId
    );
  }
}

class ColorOptionWidget extends StatelessWidget {
  final OptionValue value;
  final bool selected;
  final bool isAvailable;

  ColorOptionWidget({required this.value, required this.selected, required this.isAvailable}); // Add the new variable

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
        ignoring: !isAvailable, // Use the new variable
        child: Opacity(
            opacity: isAvailable ? 1 : 0.4, // New line for opacity
            child: Container(
              width: 40,
              height: 35,
              decoration: BoxDecoration(
                color: value.color,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: (selected && value.color == Colors.black) ? Colors.blue : (selected ? Colors.black : Colors.transparent),
                  width: 2,
                ),
              ),
            )));
  }
}

class TextOptionWidget extends StatelessWidget {
  final OptionValue value;
  final bool selected;
  final bool isAvailable; // New variable

  TextOptionWidget({required this.value, required this.selected, required this.isAvailable}); // Add the new variable

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
        ignoring: !isAvailable, // Use the new variable
        child: Opacity(
            opacity: isAvailable ? 1 : 0.4, // New line for opacity
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                border: Border.all(
                  color: selected ? Colors.blue : Colors.grey.shade400,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(value.name),
            )));
  }
}
