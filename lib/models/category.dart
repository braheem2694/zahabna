import 'dart:convert';

import 'HomeData.dart';

Categories categoriesFromJson(String str) => Categories.fromJson(json.decode(str));

String categoriesToJson(Categories data) => json.encode(data.toJson());

class Categories {
  bool? succeeded;
  List<Category>? categories;
  String? message;
  bool? isEnd;

  Categories({
    this.succeeded,
    this.categories,
    this.message,
    this.isEnd,
  });

  factory Categories.fromJson(Map<dynamic, dynamic> json) => Categories(
        succeeded: json["succeeded"],
        categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
        message: json["message"],
        isEnd: json["is_end"],
      );

  Map<String, dynamic> toJson() => {
        "succeeded": succeeded,
        "categories": List<dynamic>.from(categories!.map((x) => x.toJson())),
        "message": message,
        "is_end": isEnd,
      };
}


