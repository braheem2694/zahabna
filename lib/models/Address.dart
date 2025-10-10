import 'package:get/get.dart';

RxList addresseslist = <addressesclass>[].obs;

class addressesclass {
  String? id;
  String? user_id;
  String? address;
  String? city;
  String? state;
  String? phone_number;
  String? pin_code;
  String? first_name;
  String? last_name;
  String? route_name;
  String? building_name;
  String? floor_number;
  String? r_country_id;
  String? country_name;
  String? city_name;
  String? r_city_id;

  addressesclass({
    this.r_country_id,
    this.country_name,
    this.city_name,
    this.r_city_id,
    this.id,
    this.user_id,
    this.address,
    this.city,
    this.state,
    this.phone_number,
    this.pin_code,
    this.last_name,
    this.first_name,
    this.building_name,
    this.route_name,
    this.floor_number,
  });

  addressesclass.fromJson(Map<String, dynamic> json) {
    addresseslist.add(addressesclass(
      r_country_id: json['r_country_id'].toString(),
      country_name: json['country_name'].toString(),
      city_name: json['city_name'].toString(),
      r_city_id: json['r_city_id'].toString(),
      id: json['id'].toString(),
      user_id: json['user_id'].toString(),
      address: json['address'].toString(),
      city: json['city'].toString(),
      state: json['state'].toString(),
      phone_number: json['phone_number'].toString(),
      pin_code: json['pin_code'].toString(),
      last_name: json['last_name'].toString(),
      first_name: json['first_name'].toString(),
      route_name: json['route_name'].toString(),
      building_name: json['building_name'].toString(),
      floor_number: json['floor_number'].toString(),
    ));
  }
}
