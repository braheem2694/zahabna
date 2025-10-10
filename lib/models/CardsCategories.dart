class CardCategory {
   int? id;
   String? name;
   CardCategory({
     required this.id,
     required this.name,

   });

   factory CardCategory.fromJson(Map<String, dynamic> json) => CardCategory(
     id: json["id"],
     name: json["name"],

   );
}