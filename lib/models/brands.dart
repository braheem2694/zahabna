List brandlist = <brandclass>[];

class brandclass {
  String? id;
  String? name;
  String? file_path;

  brandclass({
    this.id,
    this.name,
    this.file_path,
  });

  brandclass.fromJson(Map<String, dynamic> json) {
    brandlist.add(brandclass(
      id: json['id'].toString(),
      name: json['brand_name'].toString(),
      file_path: json['file_path'].toString(),
    ));
  }
}
