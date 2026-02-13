// To parse this JSON data, do
//
//     final HomeData = HomeDataFromJson(jsonString);

// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:ffi';

import 'package:get/get.dart';

import '../screens/tabs_screen/models/SocialMedia.dart';

HomeData HomeDataFromJson(String str) => HomeData.fromJson(json.decode(str));

String HomeDataToJson(HomeData data) => json.encode(data.toJson());

class HomeData {
  bool? succeeded;
  String? message;
  String? categoryType;
  String? requestTerms;
  String? deleteTermsConditions;
  String? renewTermsConditions;
  String? paymentRequestTerms;
  bool? isRetail;
  double? requestPrice;
  double? requestFees;
  List<Category>? categories;
  RxList<ProductSection>? productSections;
  List<Product>? products;
  List<Brand>? brands;
  List<FlashSale>? flashSales;
  List<Product>? flashProducts;
  List<Hour>? hours;
  List<GridElement>? gridElements;
  List<SocialMedia>? socials;
  List<SocialMedia>? socialMedia;
  List<ProductType>? productTypes;
  List<ProductType>? gemstoneStyles;

  HomeData({
    this.succeeded,
    this.categoryType,
    this.message,
    this.isRetail,
    this.categories,
    this.productSections,
    this.paymentRequestTerms,
    this.products,
    this.brands,
    this.flashSales,
    this.flashProducts,
    this.hours,
    this.gridElements,
    this.socials,
    this.socialMedia,
    this.productTypes,
    this.gemstoneStyles,
    this.requestPrice,
    this.requestFees,
    this.requestTerms,
    this.deleteTermsConditions,
    this.renewTermsConditions,
  });

  factory HomeData.fromJson(Map<dynamic, dynamic> json) => HomeData(
        succeeded: json["succeeded"],
        message: json["message"],
        isRetail: json["is_retail"],
        requestPrice:
            double.tryParse(json["request_price"]?.toString() ?? "0") ?? 0.0,
        requestFees:
            double.tryParse(json["request_fees"]?.toString() ?? "0") ?? 0.0,
        requestTerms: json["request_terms_conditions"],
        deleteTermsConditions: json["delete_terms_conditions"],
        renewTermsConditions: json["renew_terms_conditions"],
        paymentRequestTerms: json["payment_request_terms_conditions"],
        categoryType: json["categoryType"],
        categories: List<Category>.from(
            json["categories"]?.map((x) => Category.fromJson(x)) ?? []),
        productTypes: List<ProductType>.from(
            json["metals"]?.map((x) => ProductType.fromJson(x)) ?? []),
        productSections: List<ProductSection>.from(json["product_sections"]
                    ?.map((x) => ProductSection.fromJson(x)) ??
                [])
            .obs,
        products: List<Product>.from(
            json["products"]?.map((x) => Product.fromJson(x)) ?? []),
        brands: List<Brand>.from(
            json["brands"]?.map((x) => Brand.fromJson(x)) ?? []),
        flashSales: List<FlashSale>.from(
            json["flash_sales"]?.map((x) => FlashSale.fromJson(x)) ?? []),
        flashProducts: List<Product>.from(
            json["flash_products"]?.map((x) => Product.fromJson(x)) ?? []),
        hours:
            List<Hour>.from(json["hours"]?.map((x) => Hour.fromJson(x)) ?? []),
        gridElements: List<GridElement>.from(
            json["grid_elements"]?.map((x) => GridElement.fromJson(x)) ?? []),
        socials: List<SocialMedia>.from(
            json["socials"]?.map((x) => SocialMedia.fromJson(x)) ?? []),
        socialMedia: List<SocialMedia>.from(
            json["owner_data"]?.map((x) => SocialMedia.fromJson(x)) ?? []),
        gemstoneStyles: List<ProductType>.from(
            json["gemstones_styles"]?.map((x) => ProductType.fromJson(x)) ??
                []),
      );

  Map<String, dynamic> toJson() => {
        "succeeded": succeeded,
        "message": message,
        "is_retail": isRetail,
        "categories": List<dynamic>.from(categories!.map((x) => x.toJson())),
        "product_sections":
            List<dynamic>.from(productSections!.map((x) => x.toJson())),
        "products": List<dynamic>.from(products!.map((x) => x.toJson())),
        "brands": List<dynamic>.from(brands!.map((x) => x.toJson())),
        "flash_sales": List<dynamic>.from(flashSales!.map((x) => x.toJson())),
        "flash_products":
            List<dynamic>.from(flashProducts!.map((x) => x.toJson())),
        "hours": List<dynamic>.from(hours!.map((x) => x.toJson())),
        "grid_elements":
            List<dynamic>.from(gridElements!.map((x) => x.toJson())),
        "socials": List<dynamic>.from(socials!.map((x) => x.toJson())),
      };
}

class ProductType {
  String? id;
  String? type;
  String? name;
  String? unit;
  String? metalName;
  int? metalId;
  bool isEdited;
  List<ItemFormField>? items;
  List<GemstoneMetal>? gemstoneMetals;

  ProductType({
    this.id,
    this.unit,
    this.name,
    this.type,
    this.metalName,
    this.metalId,
    this.gemstoneMetals,
    this.isEdited = false,
    this.items,
  });

  /// ✅ Corrected `copyWith` method (preserves all fields)
  ProductType copyWith({
    String? id,
    String? unit,
    String? name,
    String? type,
    String? metalName,
    int? metalId,
    bool? isEdited,
    List<ItemFormField>? items,
    List<GemstoneMetal>? gemstoneMetals,
  }) {
    return ProductType(
      id: id ?? this.id,
      unit: unit ?? this.unit,
      name: name ?? this.name,
      type: type ?? this.type,
      metalName: metalName ?? this.metalName,
      metalId: metalId ?? this.metalId,
      isEdited: isEdited ?? this.isEdited,
      items: items != null
          ? List<ItemFormField>.from(
              items.map((item) => item.copyWith())) // ✅ Deep copy items
          : this.items != null
              ? List<ItemFormField>.from(this
                  .items!
                  .map((item) => item.copyWith())) // ✅ Deep copy fallback
              : [],
      // ✅ Ensure non-null
      gemstoneMetals: gemstoneMetals != null
          ? List<GemstoneMetal>.from(gemstoneMetals
              .map((g) => g.copyWith())) // ✅ Deep copy gemstoneMetals
          : this.gemstoneMetals != null
              ? List<GemstoneMetal>.from(
                  this.gemstoneMetals!.map((g) => g.copyWith()))
              : [],
    );
  }

  factory ProductType.fromJson(Map<String, dynamic> json) => ProductType(
        id: json["id"].toString(),
        name: json["name"],
        type: json["type"],
        metalName: json["metalName"],
        metalId: json["metalId"] != null && json["metalId"] != ""
            ? int.parse(json["metalId"].toString())
            : null,
        isEdited: json["isEdited"] ?? false,
        items: json["properties"] != null
            ? List<ItemFormField>.from(
                json["properties"]?.map((x) => ItemFormField.fromJson(x)) ?? [])
            : [],
      );

  /// ✅ Ensures all fields are properly serialized to JSON
  Map<String, dynamic> toJson() => {
        "id": id ?? "",
        "unit": unit ?? "",
        "name": name ?? "",
        "type": type ?? "",
        "metalName": metalName ?? "",
        "metalId": metalId ?? 0,
        "isEdited": isEdited,
        "items": items != null
            ? List<dynamic>.from(items!.map((x) => x.toJson()))
            : [],
        "gemstoneMetals": gemstoneMetals != null
            ? List<dynamic>.from(gemstoneMetals!.map((x) => x.toJson()))
            : [],
      };
}

class GemstoneMetal {
  int id;
  String name;

  GemstoneMetal({
    required this.id,
    required this.name,
  });

  /// ✅ Deep copy method for GemstoneMetal
  GemstoneMetal copyWith({String? id, String? name}) {
    return GemstoneMetal(
      id: this.id,
      name: name ?? this.name,
    );
  }

  factory GemstoneMetal.fromJson(Map<String, dynamic> json) => GemstoneMetal(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class ItemFormField {
  int? id;
  String? field;
  String? fieldValue;
  bool? isRequired;
  bool isEdited;
  String? fieldType;
  String? unit;
  List<ItemOption>? options;

  ItemFormField({
    this.id,
    this.field,
    this.fieldValue,
    this.isRequired = false,
    this.fieldType = "Text",
    this.options,
    this.unit,
    this.isEdited = false,
  });

  /// ✅ Fixed copyWith method
  ItemFormField copyWith({
    int? id,
    String? field,
    String? fieldValue,
    bool? isRequired,
    bool? isEdited,
    String? fieldType,
    String? unit,
    List<ItemOption>? options,
  }) {
    return ItemFormField(
      id: id ?? this.id,
      field: field ?? this.field,
      fieldValue: fieldValue ?? this.fieldValue,
      isRequired: isRequired ?? this.isRequired,
      isEdited: isEdited ?? this.isEdited,
      fieldType: fieldType ?? this.fieldType,
      unit: unit ?? this.unit,
      options: options != null
          ? List<ItemOption>.from(
              options.map((option) => option.copyWith())) // ✅ Ensure new list
          : this.options != null
              ? List<ItemOption>.from(this
                  .options!
                  .map((option) => option.copyWith())) // ✅ Deep copy fallback
              : [], // ✅ Ensure non-null value
    );
  }

  factory ItemFormField.fromJson(Map<String, dynamic> json) => ItemFormField(
        id: int.parse(json["id"].toString()),
        field: json["field"],
        fieldValue: json["fieldValue"],
        unit: json["unit_of_measurement"],
        isRequired: json["is_required"] == 0 ? false : true,
        fieldType: json["type"] ?? "Text",
        options: json["values"] is List
            ? List<ItemOption>.from(
                json["values"].map((x) => ItemOption.fromJson(x)))
            : (json["values"] is Map<String, dynamic>)
                ? [ItemOption.fromJson(json["values"])]
                : [],
      );

  void resetField() {
    fieldValue = ""; // ✅ Reset fieldValue to an empty string
    isEdited = false; // ✅ Reset isEdited to false
    options?.forEach(
        (option) => option.resetOption()); // ✅ Reset all options inside
  }

  /// ✅ Properly serializes all fields to JSON
  Map<String, dynamic> toJson() => {
        "id": id ?? "",
        "field": field ?? "",
        "fieldValue": fieldValue ?? "",
        "unit_of_measurement": unit ?? "",
        "is_required": isRequired == true ? 1 : 0, // Convert boolean to integer
        "type": fieldType ?? "Text",
        "values": options != null
            ? List<dynamic>.from(options!.map((x) => x.toJson()))
            : [],
      };
}

class ItemOption {
  int? id;
  String? value;
  bool isRequired;
  bool isSelected;

  ItemOption({
    this.id,
    this.value,
    this.isRequired = false,
    this.isSelected = false,
  });

  /// ✅ Proper deep copy method
  ItemOption copyWith({
    int? id,
    String? value, // ✅ Fixed incorrect parameter name
    bool? isSelected, // ✅ Nullable to allow optional updates
    bool? isRequired, // ✅ Nullable to allow optional updates
  }) {
    return ItemOption(
      id: id ?? this.id,
      value: value ?? this.value,
      isSelected:
          isSelected ?? this.isSelected, // ✅ Properly updates `isSelected`
      isRequired:
          isRequired ?? this.isRequired, // ✅ Properly updates `isRequired`
    );
  }

  void resetOption() {
    isSelected = false; // ✅ Reset isSelected to false
  }

  /// ✅ Factory constructor to parse JSON
  factory ItemOption.fromJson(Map<String, dynamic> json) {
    return ItemOption(
      id: json["id"],
      value: json["value"] ?? "",
      isSelected: json["isSelected"] ?? false,
      isRequired: json["isRequired"] ?? false,
    );
  }

  /// ✅ Converts instance to JSON format
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "value": value ?? "",
      "isSelected": isSelected,
      "isRequired": isRequired,
    };
  }
}

class Brand {
  int id;
  String brandName;
  String slug;
  String main_image;
  int productCount;
  String backgroundImg;
  bool isSelected;

  Brand({
    required this.brandName,
    required this.id,
    required this.isSelected,
    required this.slug,
    required this.main_image,
    required this.productCount,
    required this.backgroundImg,
  });

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
        id: json["id"],
        brandName: json["brand_name"],
        isSelected: false,
        slug: json["slug"],
        main_image: json["background_img"].toString(),
        productCount: json["product_count"],
        backgroundImg: json["background_img"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "brand_name": brandName,
        "slug": slug,
        "main_image": main_image,
        "product_count": productCount,
        "background_img": backgroundImg,
      };
}

class Category {
  int id;
  String categoryName;
  String slug;
  int? parent;
  String? main_image;
  int showInNavbar;
  int productCount;
  bool isSelected;
  bool hasProduct;

  Category({
    required this.id,
    required this.categoryName,
    required this.slug,
    required this.parent,
    required this.main_image,
    required this.showInNavbar,
    required this.productCount,
    required this.hasProduct,
    this.isSelected = false,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        isSelected: false,
        id: json["id"],
        categoryName: json["category_name"],
        slug: json["slug"] ?? "",
        parent: json["parent"],
        main_image: json["main_image"],
        hasProduct: json["has_products"] == 0 ? false : true,
        showInNavbar: json["show_in_navbar"] ?? 0,
        productCount: json["product_count"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_name": categoryName,
        "slug": slug,
        "parent": parent,
        "main_image": main_image,
        "show_in_navbar": showInNavbar,
        "product_count": productCount,
        "has_products": hasProduct,
      };
}

class Variation {
  final int? variation_id;
  final int? option_id;
  final int? value_id;
  double? price;
  final int? default_option;
  final String? type;
  final int? is_color;
  final String? name;
  final String? color;
  final double? price_after_discount;

  Variation.fromJson(Map<String, dynamic> json)
      : variation_id = json['variation_id'],
        option_id = json['option_id'],
        value_id = json['value_id'],
        price = json['price']?.toDouble(),
        default_option = json['default_option'],
        type = json['type'],
        is_color = json['is_color'],
        name = json['name'],
        color = json['color'],
        price_after_discount = json['price_after_discount']?.toDouble();

  Map<String, dynamic> toJson() => {
        'variation_id': variation_id,
        'option_id': option_id,
        'value_id': value_id,
        'price': price,
        'default_option': default_option,
        'type': type,
        'is_color': is_color,
        'name': name,
        'color': color,
        'price_after_discount': price_after_discount,
      };
}

class Product {
  final int product_id;
  int? r_flash_id;
  int? category_id;
  final String? product_name;
  final String? product_section;
  final String? description;
  double product_price;
  final String? slug;
  final int has_option;
  String? join;
  double? price_after_discount;
  final String? main_image;
  int? is_liked;
  Store store;
  final List<MoreImage>? more_images;
  final String? product_code;
  final int? is_ordered_before;
  final int? opening_qty;
  int product_qty_left;
  final int? vat;
  final double? product_weight;
  final int? product_kerat;
  final int? boolean_percent_discount;
  final int? sales_discount;
  final int? free_shipping;
  final int? flat_rate;
  final int? multi_shipping;
  final double? shipping_cost;
  int? rate;
  final int? reviews_count;
  int? orders_count;
  final int? cart_btn;
  final int? outOfStock;
  final int? express_delivery;
  int? in_cart;
  bool? loading;
  String? quantity;
  String? cart_id;
  String? removing;
  String? cityId;
  String? cityName;
  String? options;
  String? variationfound;
  String? variant_id;
  String? model;
  String? productTypeName;
  int? productTypeId;

  List<Variation>? variations;
  List<ItemFormField> fields;

  Product.fromJson(Map<String, dynamic> json)
      : product_id = json["id"] ?? json["product_id"],
        product_name = json["product_name"],
        variations = (json["variations"] != null &&
                (json["variations"] as List).isNotEmpty)
            ? (json["variations"] as List)
                .map((v) => Variation.fromJson(v))
                .toList()
            : null,
        fields = List<ItemFormField>.from(
            json["fields"]?.map((x) => ItemFormField.fromJson(x)) ?? []),
        join = json['in_cart'].toString() == '0' ? '0' : '1',
        quantity = json['quantity'],
        cityName = json['city_name'],
        cityId = json['city_id'].toString(),
        cart_btn = json['cart_btn'],
        category_id = json['category_id'],
        product_kerat = json['karat'],
        model = json['model'],
        express_delivery = json['express_delivery'],
        product_section = json['product_section'].toString(),
        cart_id = json['cart_id'].toString(),
        outOfStock = json['out_of_stock'],
        removing = "0",
        variant_id = json['variant_id'].toString(),
        variationfound = json['variationfound'].toString(),
        options = json['options'].toString(),
        is_ordered_before = json["is_ordered_before"] == null ? 0 : 1,
        r_flash_id = json["r_flash_id"],
        description = json["description"],
        product_price = double.parse(json["product_price"].toString()),
        slug = json["slug"].toString(),
        has_option = json["has_option"] ?? 0,
        price_after_discount = json["price_after_discount"]?.toDouble(),
        main_image = json["main_image"],
        is_liked = json["is_liked"] ?? 0,
        more_images = json["more_images"] != null
            ? List<MoreImage>.from(
                json["more_images"].map((x) => MoreImage.fromJson(x)))
            : [],
        productTypeName = json["product_type"],
        productTypeId = json["product_type_id"],
        store = Store.fromJson({
          "store_id": json["store_id"],
          "store_name": json["store_name"],
          "store_image": json["store_image"],
          "store_whatsapp_number": json["store_whatsapp_number"],
        }),
        product_code = json["product_code"],
        opening_qty = json["opening_qty"],
        product_qty_left =
            int.tryParse(json["product_qty_left"].toString()) ?? 0,
        vat = json["vat"],
        product_weight = json["product_weight"] == null
            ? null
            : double.parse(json["product_weight"].toString()),
        boolean_percent_discount = json["boolean_percent_discount"],
        sales_discount = json["sales_discount"] != null
            ? json["sales_discount"].toInt()
            : null,
        free_shipping = json["free_shipping"],
        loading = false,
        flat_rate = json["flat_rate"],
        multi_shipping = json["multi_shipping"],
        shipping_cost = json["shipping_cost"] == null
            ? null
            : double.parse(json["shipping_cost"].toString()),
        rate = json["rating"] == null
            ? 0
            : int.parse(double.parse(json["rating"]).toStringAsFixed(0)),
        reviews_count = json["reviews_count"],
        in_cart = json["in_cart"],
        orders_count = json["orders_count"];

  Map<String, dynamic> toJson() => {
        "quantity": quantity,
        "cart_id": cart_id,
        "cart_btn": cart_btn,
        "removing": "0",
        "variant_id": variant_id,
        "express_delivery": express_delivery,
        "product_section": product_section,
        "variationfound": variationfound,
        "options": options,
        "id": product_id,
        "in_cart": in_cart,
        "product_name": product_name,
        "r_flash_id": r_flash_id,
        "description": description,
        "product_price": product_price,
        "slug": slug,
        "has_option": has_option,
        "price_after_discount": price_after_discount,
        "main_image": main_image,
        "is_liked": is_liked,
        "more_images": more_images == null
            ? []
            : List<dynamic>.from(more_images!.map((x) => x)),
        // New fields
        "product_code": product_code,
        "model": model,

        "opening_qty": opening_qty,
        "product_qty_left": product_qty_left,
        "vat": vat,
        "product_weight": product_weight,
        "boolean_percent_discount": boolean_percent_discount,
        "sales_discount": sales_discount,
        "free_shipping": free_shipping,
        "flat_rate": flat_rate,
        "multi_shipping": multi_shipping,
        "shipping_cost": shipping_cost,
        "rating": rate,
        "reviews_count": reviews_count,
        "orders_count": orders_count,
      };
}

class ProductMetals {
  List<ProductType>? metal;
  List<ProductType>? gemstoneStyle;

  ProductMetals({
    required this.metal,
    required this.gemstoneStyle,
  });

  factory ProductMetals.fromJson(Map<String, dynamic> json) => ProductMetals(
        metal: List<ProductType>.from(
            json["metals"]?.map((x) => ProductType.fromJson(x)) ?? []),
        gemstoneStyle: List<ProductType>.from(
            json["gemstones_styles"]?.map((x) => ProductType.fromJson(x)) ??
                []),
      );

  Map<String, dynamic> toJson() => {
        "metal": metal,
        "gemstoneStyle": gemstoneStyle,
      };
}

class FlashSale {
  int id;
  String title;
  int sliderType;
  String? color1;
  String? color2;
  String? color3;
  DateTime endTime;

  FlashSale({
    required this.id,
    required this.title,
    required this.sliderType,
    required this.color1,
    required this.color2,
    required this.color3,
    required this.endTime,
  });

  factory FlashSale.fromJson(Map<String, dynamic> json) => FlashSale(
        id: json["id"],
        title: json["title"],
        sliderType: json["slider_type"],
        color1: json["color_1"],
        color2: json["color_2"],
        color3: json["color_3"],
        endTime: DateTime.parse(json["end_time"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "slider_type": sliderType,
        "color_1": color1,
        "color_2": color2,
        "color_3": color3,
        "end_time": endTime.toIso8601String(),
      };
}

class GridElement {
  int id;
  String x;
  String y;
  String w;
  String h;
  String main_image;
  List<Actions> actions;
  List<MoreImage> more_images;

  GridElement({
    required this.id,
    required this.x,
    required this.y,
    required this.w,
    required this.h,
    required this.main_image,
    required this.actions,
    required this.more_images,
  });

  factory GridElement.fromJson(Map<String, dynamic> json) {
    List<dynamic> actionsList = [];

    if (json["actions"] is String) {
      actionsList = jsonDecode(json["actions"]);
    } else if (json["actions"] is List) {
      actionsList = json["actions"];
    }

    return GridElement(
      id: json["id"],
      x: json["x"],
      y: json["y"],
      w: json["w"],
      h: json["h"],
      main_image: json["main_image"].toString(),
      actions: actionsList.map<Actions>((x) => Actions.fromJson(x)).toList(),
      more_images: json["more_images"] == null
          ? []
          : List<MoreImage>.from(
              json["more_images"].map((x) => MoreImage.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "x": x,
        "y": y,
        "w": w,
        "h": h,
        "main_image": main_image,
        "actions": List<dynamic>.from(actions.map((x) => x.toJson())),
        "more_images": List<dynamic>.from(more_images.map((x) => x.toJson())),
      };
}

class Actions {
  int id;
  String target_type;
  String targetId;
  String slug;

  Actions({
    required this.id,
    required this.target_type,
    required this.slug,
    required this.targetId,
  });

  factory Actions.fromJson(Map<String, dynamic> json) => Actions(
        id: json["id"],
        target_type: json["target_type"],
        targetId: json["target_id"].toString(),
        slug: json["slug"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "target_type": target_type,
        "slug": slug,
      };
}

class MoreImage {
  int id;
  String? file_path;
  int? type;
  int? isVideo;

  MoreImage({
    required this.id,
    required this.file_path,
    required this.type,
    required this.isVideo,
  });

  factory MoreImage.fromJson(Map<String, dynamic> json) => MoreImage(
        id: json["id"],
        file_path: json["file_path"],
        type: json["type"],
        isVideo: json["is_video"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "file_path": file_path,
      };
}

class Hour {
  String? day;
  String? openTime;
  String? closeTime;

  Hour({
    required this.day,
    required this.openTime,
    required this.closeTime,
  });

  factory Hour.fromJson(Map<String, dynamic> json) => Hour(
        day: json["day"],
        openTime: json["open_time"],
        closeTime: json["close_time"],
      );

  Map<String, dynamic> toJson() => {
        "day": day,
        "open_time": openTime,
        "close_time": closeTime,
      };
}

class ProductSection {
  int id;
  String slug;
  String sectionName;
  int slider_type;
  int? rGridId;
  List<GridElement>? gridElements;

  ProductSection({
    required this.id,
    required this.slug,
    required this.sectionName,
    required this.slider_type,
    required this.rGridId,
    required this.gridElements,
  });

  factory ProductSection.fromJson(Map<String, dynamic> json) => ProductSection(
        id: json["id"],
        slug: json["slug"],
        sectionName: json["section_name"],
        slider_type: json["slider_type"],
        rGridId: json["r_grid_id"],
        gridElements: json["grid_elements"] == null
            ? []
            : List<GridElement>.from(
                json["grid_elements"]!.map((x) => GridElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "slug": slug,
        "section_name": sectionName,
        "slider_type": slider_type,
        "r_grid_id": rGridId,
        "grid_elements": gridElements == null
            ? []
            : List<dynamic>.from(gridElements!.map((x) => x.toJson())),
      };
}

class Social {
  int? id;
  String? icon;
  String? link;

  Social({
    required this.id,
    required this.icon,
    required this.link,
  });

  factory Social.fromJson(Map<String, dynamic> json) => Social(
        id: json["id"],
        icon: json["icon"],
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "icon": icon,
        "link": link,
      };
}

class Store {
  int? id;
  String? name;
  String? image;
  String? storeWhatsappNumber;

  Store({
    required this.id,
    required this.name,
    required this.image,
    required this.storeWhatsappNumber,
  });

  factory Store.fromJson(Map<String, dynamic> json) => Store(
        id: json["store_id"],
        name: json["store_name"],
        image: json["store_image"],
        storeWhatsappNumber: json["store_whatsapp_number"],
      );
}

class ProductCategories {
  int? id;
  String? categoryImage;
  String? categoryName;

  ProductCategories({
    required this.id,
    required this.categoryImage,
    required this.categoryName,
  });

  factory ProductCategories.fromJson(Map<String, dynamic> json) =>
      ProductCategories(
        id: json["id"],
        categoryImage: json["main_image"],
        categoryName: json["category_name"],
      );
}
