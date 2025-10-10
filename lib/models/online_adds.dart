List onlineaddslist = <onlineaddsclass>[];

class onlineaddsclass {
  String? id;
  String? file_path;
  String? url;
  String? category_id;
  String? product_id;
  String? ad_type;
  String? category_name ;

  onlineaddsclass({
    this.id,
    this.file_path,
    this.url,
    this.category_id,
    this.product_id,
    this.ad_type,
    this.category_name ,
  });

   onlineaddsclass.fromJson(Map<String, dynamic> json) {
    onlineaddslist.add(onlineaddsclass(
      id: json['id'].toString(),
      file_path: json['main_image'].toString(),
      url: json['url'].toString(),
      category_id: json['category_id'].toString(),
      product_id: json['product_id'].toString(),
      ad_type: json['ad_type'].toString(),
      category_name : json['category_name'].toString(),
    ));
  }
}
