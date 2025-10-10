List<orderdetailsclass> orderdetaillist = <orderdetailsclass>[];

class orderdetailsclass {
  String? id;
  String? r_product_id;
  String? product_code;
  String? product_name;
  String? brand;
  String? product_price;
  String? quantity;
  String? product_condition;
  String? discount;
  String? shipping;
  String? main_image;
  String? status;

  Map<int, String>? statusMap = {};

  orderdetailsclass({
    this.id,
    this.status,
    this.r_product_id,
    this.product_code,
    this.product_name,
    this.brand,
    this.product_price,
    this.quantity,
    this.product_condition,
    this.discount,
    this.shipping,
    this.main_image,
    this.statusMap,
  });

  orderdetailsclass.fromJson(Map<String, dynamic> json) {
    orderdetaillist.add(orderdetailsclass(
      id: json['id'].toString(),
      r_product_id: json['r_product_id'].toString(),
      product_code: json['product_code'].toString(),
      product_name: json['product_name'].toString(),
      brand: json['brand'].toString(),
      product_price: json['product_price'].toString(),
      quantity: json['quantity'].toString(),
      product_condition: json['product_condition']?.toString(),
      discount: json['discount'].toString(),
      shipping: json['shipping'].toString(),
      main_image: json['main_image'].toString(),
      status: json['status'].toString(),
    ));
  }
}
