List providerslist = <providersclass>[];

class providersclass {
  String? user_id;
  String? company;
  String? file_path;
  String? qoat;

  providersclass({
    this.user_id,
    this.company,
    this.file_path,
    this.qoat,
  });

   providersclass.fromJson(Map<String, dynamic> json) {
    providerslist.add(providersclass(
      user_id: json['user_id'].toString(),
      company: json['company'].toString(),
      file_path: json['file_path'].toString(),
      qoat: json['qoat'].toString(),
    ));
  }
}
