import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:iq_mall/main.dart';
import 'package:iq_mall/models/category.dart';
import 'package:iq_mall/screens/Stores_details/models/MainSlider.dart';

import '../screens/tabs_screen/models/SocialMedia.dart';
import 'HomeData.dart';

List<StoreClass> storeList = <StoreClass>[];

class StoreClass {
  String? id;
  String? store_name;
  List<StoreWorkDay>? storeWorkingDays;
  List<StoreSliderImage>? storeSliderImages;
  String? store_type;
  String? phone_number;
  String? whatsapp_number;
  String? email;
  String? address;
  String? cityName;
  int? cityId;
  int? ownerId;
  String? slug;
  String? description;
  String? longitude;
  String? latitude;
  String? main_image;
  String? store_image;
  String? country_name;
  String? button_background_color;
  String? button_color;
  String? price_color;
  String? dicount_price_color;
  String? grid_type;
  String? main_color;
  String? icon_color;
  String? slider_type;
  int? show_add_to_cart;
  String? setting_image;
  String? delivery_amount;
  String? terms_conditions;
  String? privacy_policy;
  String? category_grid;
  List<MainSlider>? images;
  List<Category>? categories;
  List<SocialMedia>? socials;

  StoreClass({
    this.id,
    this.store_name,
    this.store_type,
    this.cityName,
    this.cityId,
    this.categories,
    this.phone_number,
    this.whatsapp_number,
    this.email,
    this.ownerId,
    this.address,
    this.slug,
    this.description,
    this.longitude,
    this.latitude,
    this.main_image,
    this.store_image,
    this.country_name,
    this.button_background_color,
    this.button_color,
    this.price_color,
    this.dicount_price_color,
    this.grid_type,
    this.main_color,
    this.icon_color,
    this.slider_type,
    this.show_add_to_cart,
    this.setting_image,
    this.delivery_amount,
    this.terms_conditions,
    this.privacy_policy,
    this.category_grid,
    this.storeWorkingDays,
    this.storeSliderImages,
    this.images,
    this.socials,
  });

  StoreClass.fromJson(Map<String, dynamic> json) {
    storeList.add(StoreClass(
      category_grid: json['category_grid'].toString(),
      id: json['id'].toString(),
      storeWorkingDays: json["stores_working_days"] == null ? [] : List<StoreWorkDay>.from(json["stores_working_days"]!.map((x) => StoreWorkDay.fromJson(x))),
      storeSliderImages: json["store_slider_images"] == null ? [] : List<StoreSliderImage>.from(json["store_slider_images"]!.map((x) => StoreSliderImage.fromJson(x))),
      categories: json["categories"] == null ? [] : List<Category>.from(json["categories"]!.map((x) => Category.fromJson(x))),
      store_name: json['store_name'].toString(),
      cityName: json['city_name'],
      cityId: json['r_city_id'],
      ownerId: json['owner_id'],
      delivery_amount: json['delivery_amount'].toString(),
      store_type: json['store_type'].toString(),
      phone_number: json['phone_number'].toString(),
      whatsapp_number: json['whatsapp_number'].toString(),
      email: json['email'].toString(),
      address: json['address'].toString(),
      slug: json['slug'].toString(),
      description: json['description'].toString(),
      longitude: json['longitude'].toString(),
      latitude: json['latitude'].toString(),
      main_image: json['main_image'],
      store_image: json['store_image'].toString(),
      country_name: json['country_name'].toString(),
      button_background_color: json['button_background_color'].toString(),
      button_color: json['button_color'].toString(),
      price_color: json['price_color'].toString(),
      dicount_price_color: json['dicount_price_color'].toString(),
      grid_type: json['grid_type'].toString(),
      main_color: json['main_color'].toString(),
      icon_color: json['icon_color'].toString(),
      slider_type: json['slider_type'].toString(),
      show_add_to_cart: json['show_add_to_cart'] as int? ?? 0,
      setting_image: json['setting_image'].toString(),
      terms_conditions: json['terms_conditions'].toString(),
      privacy_policy: json['privacy_policy'].toString(),
      images: json["images"] == null ? [] : List<MainSlider>.from(json["images"]!.map((x) => MainSlider.fromJson(x))),
      socials: List<SocialMedia>.from(json["socials"]?.map((x) => SocialMedia.fromJson(x)) ?? []),


    ));
  }

  factory StoreClass.userFromJson(Map<String, dynamic> json) {
    return StoreClass(
      category_grid: json['category_grid']?.toString() ?? '',
      id: json['id']?.toString() ?? '',
      storeWorkingDays: json["stores_working_days"] == null
          ? []
          : List<StoreWorkDay>.from(json["stores_working_days"].map((x) => StoreWorkDay.fromJson(x))),
      storeSliderImages: json["store_slider_images"] == null
          ? []
          : List<StoreSliderImage>.from(json["store_slider_images"].map((x) => StoreSliderImage.fromJson(x))),
      categories: json["categories"] == null ? [] : List<Category>.from(json["categories"]!.map((x) => Category.fromJson(x))),
      socials: List<SocialMedia>.from(json["socials"]?.map((x) => SocialMedia.fromJson(x)) ?? []),

      store_name: json['store_name']?.toString() ?? '',
      cityName: json['city_name'] ?? '',
      cityId: json['r_city_id'],
      ownerId: json['owner_id'],
      delivery_amount: json['delivery_amount']?.toString() ?? '',
      store_type: json['store_type']?.toString() ?? '',
      phone_number: json['phone_number']?.toString() ?? '',
      whatsapp_number: json['whatsapp_number']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      longitude: json['longitude']?.toString() ?? '',
      latitude: json['latitude']?.toString() ?? '',
      main_image: json['main_image'],
      store_image: json['store_image']?.toString() ?? '',
      country_name: json['country_name']?.toString() ?? '',
      button_background_color: json['button_background_color']?.toString() ?? '',
      button_color: json['button_color']?.toString() ?? '',
      price_color: json['price_color']?.toString() ?? '',
      dicount_price_color: json['dicount_price_color']?.toString() ?? '',
      grid_type: json['grid_type']?.toString() ?? '',
      main_color: json['main_color']?.toString() ?? '',
      icon_color: json['icon_color']?.toString() ?? '',
      slider_type: json['slider_type']?.toString() ?? '',
      show_add_to_cart: json['show_add_to_cart'] as int? ?? 0,
      setting_image: json['setting_image']?.toString() ?? '',
      terms_conditions: json['terms_conditions']?.toString() ?? '',
      privacy_policy: json['privacy_policy']?.toString() ?? '',
      images: json["images"] == null
          ? []
          : List<MainSlider>.from(json["images"].map((x) => MainSlider.fromJson(x))),
    );
  }

}

class newsLetter {
  int id;
  String title;
  String subtitle;
  String short_description;
  String main_image;
  int show_hide;
  int r_store_id;

  newsLetter({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.short_description,
    required this.main_image,
    required this.show_hide,
    required this.r_store_id,
  });

  factory newsLetter.fromJson(Map<String, dynamic> json) => newsLetter(
        id: json["id"],
        title: json["title"],
        subtitle: json["subtitle"],
        short_description: json["short_description"],
        main_image: json["main_image"].toString(),
        show_hide: json["show_hide"],
        r_store_id: json["r_store_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "subtitle": subtitle,
        "short_description": short_description,
        "main_image": main_image,
        "show_hide": show_hide,
        "r_store_id": r_store_id,
      };
}
class CompanySettings {
  String? name;
  String? email;
  String? phone;
  String? address;
  double? latitude;
  double? longitude;
  String? termsAndConditions;

  CompanySettings({
     this.name,
     this.email,
     this.phone,
     this.address,
     this.latitude,
     this.longitude,
     this.termsAndConditions,
  });

  factory CompanySettings.fromJson(Map<String, dynamic> json) => CompanySettings(
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    address: json["address"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    termsAndConditions: json["terms_and_conditions"],
  );


}

class StoreWorkDay {
  String? day;
  String? openTime;
  String? closeTime;
  int? isOff;

  StoreWorkDay({
    required this.day,
    required this.openTime,
    required this.closeTime,
    required this.isOff,
  });

  // Factory constructor to create an instance from JSON
  factory StoreWorkDay.fromJson(Map<String, dynamic> json) => StoreWorkDay(
    day: json["day"],
    openTime: json["open_time"]??"09:00:00",
    closeTime: json["close_time"]??"17:00:00",
    isOff: json["is_off"] ?? 0,
  );

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() => {
    "day": day,
    "open_time": openTime,
    "close_time": closeTime,
    "is_off": isOff,
  };
}

class StoreSliderImage {
  String? id;
  String? filePath;
  String? type;
  bool? isVideo;

  StoreSliderImage({
    required this.id,
    required this.filePath,
    required this.type,
    required this.isVideo,
  });

  factory StoreSliderImage.fromJson(Map<String, dynamic> json) => StoreSliderImage(
    id: json["id"].toString(),
    filePath: json["file_path"],
    type: json["type"].toString(),
    isVideo: json["is_video"]==0?false:true,
  );


}

Color hexToColor(String code) {
  if (code.length < 7) {
    // handle error, maybe return a default color
    return Colors.black;
  }
  return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}
