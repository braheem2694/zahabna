// To parse this JSON data, do
//
//     final variation = variationFromJson(jsonString);

import 'dart:convert';
import 'dart:ui';

Variation variationFromJson(String str) => Variation.fromJson(json.decode(str));

String variationToJson(Variation data) => json.encode(data.toJson());

class Variation {
  List<VariationElement> variations;

  Variation({
    required this.variations,
  });

  factory Variation.fromJson(Map<String, dynamic> json) => Variation(
        variations: json["variations"] == null ? [] : List<VariationElement>.from(json["variations"].map((x) => VariationElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "variations": List<dynamic>.from(variations.map((x) => x.toJson())),
      };
}

class VariationElement {
  int variationId;
  int optionId;
  int valueId;
  double price;
  int defaultOption;
  double? priceAfterDiscount;
  String type;
  bool isColor;
  String name;
  Color color;
  bool isAvailable;
  bool hide;
  int quantity;

  final List<int> variationIds;

  @override
  String toString() {
    return 'VariationElement {variationId: $variationId, optionId: $optionId, valueId: $valueId, price: $price, defaultOption: $defaultOption, priceAfterDiscount: $priceAfterDiscount, type: $type, isColor: $isColor, name: $name, color: $color, isAvailable: $isAvailable, hide: $hide}';
  }

  VariationElement({
    required this.variationId,
    required this.variationIds,
    required this.hide,
    required this.optionId,
    required this.valueId,
    required this.price,
    required this.defaultOption,
    required this.priceAfterDiscount,
    required this.type,
    required this.isColor,
    required this.name,
    required this.color,
    required this.isAvailable,
    required this.quantity,
  });

  factory VariationElement.fromJson(Map<String, dynamic> json) {
    String colorHexString = json["color"] ?? "000000"; // Default to black if color is null
    colorHexString = colorHexString.replaceAll("#", ""); // Remove the '#' symbol if present

    return VariationElement(
      variationId: json["variation_id"],
      hide: false,
      variationIds: [],
      optionId: json["option_id"],
      valueId: json["value_id"],
      price: (json["price"] ?? 0).toDouble(),
      defaultOption: json["default_option"],
      priceAfterDiscount : json["price_after_discount"]!=null?(json["price_after_discount"]).toDouble():null,
      type: json["type"],
      isColor: json["is_color"] == 1 ? true : false,
      name: json["name"],
      color: Color(0xFF000000 | int.parse(colorHexString, radix: 16)),
      isAvailable: true,
      quantity:  json["quantity"],
    );
  }

  Map<String, dynamic> toJson() => {
        "variation_id": variationId,
        "hide": false,
        "option_id": optionId,
        "value_id": valueId,
        "price": price,
        "default_option": defaultOption,
        "priceAfterDiscount": priceAfterDiscount,
        "type": type,
        "is_color": isColor,
        "name": name,
        "color": color,
        "is_available": isAvailable,
      };
}
