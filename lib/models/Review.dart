List reviewlist = <reviewclass>[];

class reviewclass {
  String? id;
  String? product_id;
  String? review;
  String? user_id;
  String? file_path;
  String? user_name;
  String? first_name;
  String? last_name;
  String? review_date;
  String? rate;
  reviewclass(
      {this.id,
      this.product_id,
      this.review,
      this.user_id,
      this.file_path,
      this.user_name,
        this.first_name,
        this.last_name,
        this.rate,

      this.review_date});

   reviewclass.fromJson(Map<String, dynamic> json) {
    reviewlist.add(reviewclass(
      id: json['id'].toString(),
      product_id: json['product_id'].toString(),
      review: json['review'].toString(),
      user_id: json['user_id'].toString(),
      file_path: json['profile'].toString(),
      user_name: json['user_name'].toString(),
      first_name: json['first_name'].toString(),
      last_name: json['last_name'].toString(),
      review_date: json['created_at'].toString(),
      rate: json['rate'].toString()==null||json['rate'].toString()=='null'?'0.0':json['rate'].toString(),



    ));
  }
}
