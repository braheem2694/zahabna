// class SettingsModel {}
// class Language {
//   Language({
//     this.id,
//     this.languageName,
//     this.shortcut,
//     this.isApp,
//     this.isGrade,
//   });
//
//   String? id;
//   String? languageName;
//   String? shortcut;
//   String? isApp;
//   String? isGrade;
//
//   factory Language.fromJson(Map<String, dynamic> json) => Language(
//     id: json["id"].toString(),
//     languageName: json["language_name"],
//     shortcut: json["shortcut"],
//     isApp: json["is_app"].toString(),
//     isGrade: json["is_grade"].toString(),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "language_name": languageName,
//   };
// }