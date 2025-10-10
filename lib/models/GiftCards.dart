import 'HomeData.dart';

class GiftCards {
  int? id;
  String? title;
  String? description;
  int? min_amount;
  int? max_amount;
  String? main_image;
  String? slug;
  int? r_category_id;
  int? bonus;
  int? fees;
  String? name;
  List<MoreImage> moreImages;
  List<amounts> Amounts;

  GiftCards({
    required this.id,
    required this.name,
    required this.title,
    required this.description,
    required this.min_amount,
    required this.max_amount,
    required this.main_image,
    required this.slug,
    required this.moreImages,
    required this.r_category_id,
    required this.bonus,
    required this.fees,
    required this.Amounts,
  });

  factory GiftCards.fromJson(Map<String, dynamic> json) => GiftCards(
        id: json["id"],
        title: json["title"],
        name: json["name"],
        moreImages: json["moreImages"] == null ? [] : List<MoreImage>.from(json["moreImages"].map((x) => MoreImage.fromJson(x))),
        Amounts: json["amounts"] == null ? [] : List<amounts>.from(json["amounts"].map((x) => amounts.fromJson(x))),
        description: json["description"],
        min_amount: json["min_amount"],
        max_amount: json["max_amount"],
        main_image: json["main_image"],
        slug: json["slug"],
        r_category_id: json["r_category_id"],
        bonus: json["bonus"],
        fees: json["fees"],
      );
}

class amounts {
  int purchase_amount;
  int default_option;

  amounts({
    required this.purchase_amount,
    required this.default_option,
  });

  factory amounts.fromJson(Map<String, dynamic> json) => amounts(
        purchase_amount: json["purchase_amount"],
        default_option: json["default_option"],
      );

  Map<String, dynamic> toJson() => {
        "purchase_amount": purchase_amount,
        "default_option": default_option,
      };
}

