import '../../../cores/assets.dart';

class SocialMedia {
  String? id;
  String? link;
  String? mainImage;
  String? name;

  SocialMedia({
    this.id,
    this.link,
    this.mainImage,
    this.name,
  });

  SocialMedia copyWith({
    String? id,
    String? link,
    String? mainImage,
    int? name,
  }) =>
      SocialMedia(
        id: id ?? this.id,
        link: link ?? this.link,
        mainImage: mainImage ?? this.mainImage,
      );

  factory SocialMedia.fromJson(Map<String, dynamic> json) => SocialMedia(
        id: json["id"].toString(),
        link: json["link"],
        mainImage: json["main_image"],
    name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "link": link,
        "main_image": mainImage,
      };
}
