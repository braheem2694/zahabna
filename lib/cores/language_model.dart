import 'package:get/get_rx/src/rx_types/rx_types.dart';
RxList<Language> languages = <Language>[].obs;

class Language {

  Language({
    this.id,
    this.languageName,
    this.shortcut,
    this.isDefault,
    this.active,
    this.termsAndConditions,
  });

  String? id;
  String? languageName;
  String? shortcut;
  String? isDefault;
  String? active;
  String? termsAndConditions;

  Language.fromJson(Map<String, dynamic> json) {
    languages.add(Language(
      id: json["id"].toString(),
      languageName: json["name"],
      shortcut: json["code"],
      isDefault: json["default_lang"].toString(),
      active: json["active"].toString(),
      termsAndConditions: json["terms_and_conditions"].toString(),
    ));
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "language_name": languageName,
      };
}
