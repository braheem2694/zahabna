List orderslist = <ordersclass>[];



class ordersclass {
  String? id;
  String? total;
  String? created_at;
  String? status;
  String? address_first_name;
  String? address_last_name;
  String? address_country_code;
  String? address_phone_number;
  String? address;
  String? country;
  String? city;
  String? state;
  String? route_name;
  String? building_name;
  String? floor_number;
  double? shipping_amount;
  String? notes;
  String? client_notes;
  String? payment_type_name;
  String? discount;
  String? coupon_code;
  Map<int, String>? statusMap = {};

  ordersclass({
    this.id,
    this.total,
    this.created_at,
    this.status,
    this.address_first_name,
    this.address_last_name,
    this.address_country_code,
    this.address_phone_number,
    this.address,
    this.country,
    this.city,
    this.state,
    this.route_name,
    this.building_name,
    this.floor_number,
    this.shipping_amount,
    this.notes,
    this.client_notes,
    this.payment_type_name,
    this.discount,
    this.coupon_code,
    this.statusMap,

  });

  static ordersclass fromJson(Map<String, dynamic> json) {
    return ordersclass(
      id: json['id'].toString(),
      total: json['total'].toString(),
      created_at: json['created_at'].toString(),
      status: json['status'].toString(),
      address_first_name: json['address_first_name'].toString(),
      address_last_name: json['address_last_name'].toString(),
      address_country_code: json['address_country_code'].toString(),
      address_phone_number: json['address_phone_number'].toString(),
      address: json['address'].toString(),
      country: json['country'].toString(),
      city: json['city'].toString(),
      state: json['state'].toString(),
      route_name: json['route_name'].toString(),
      building_name: json['building_name'].toString(),
      floor_number: json['floor_number']?.toString(),
      shipping_amount: json['shipping_amount']?.toDouble(),
      notes: json['notes']?.toString(),
      client_notes: json['client_notes']?.toString(),
      payment_type_name: json['payment_type_name'].toString(),
      discount: json['discount']?.toString(),
      coupon_code: json['coupon_code']?.toString(),
    );
  }
}
