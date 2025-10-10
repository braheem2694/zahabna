import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:iq_mall/routes/app_routes.dart';
import 'package:iq_mall/models/Address.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/main.dart';
import 'package:iq_mall/screens/SignIn_screen/controller/SignIn_controller.dart';
import 'dart:convert';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'package:http/http.dart' as http;
import 'package:iq_mall/cores/assets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../NoInternet_screen/NoInternet_screen.dart';

class Add_new_address_screenController extends GetxController {
  var primaryColor;
  List addressesInfo = [];
  final formKey = GlobalKey<FormState>();
  var firstNamecontroller = TextEditingController();

  var lastNamecontroller = TextEditingController();
  var citycontroller = TextEditingController();
  var statecontroller = TextEditingController();
  var addresscontroller = TextEditingController();
  var phoneNumbercontroller = TextEditingController();
  var routnamecontroller = TextEditingController();
  var buildingnamecontroller = TextEditingController();
  var floornumbercontroller = TextEditingController();
  RxBool loading = false.obs;
  var type;
  var navigation;
  var edit;
  var addressModel;
  RxList <Country>Countries = <Country>[].obs;
  RxList<Country> Cities = <Country>[].obs;
  var selectedCountry;
  var selectedCity;

  RxBool loadCities = true.obs;

  Future<void> getLocation() async {
    // Request permission
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print('Location permission denied.');
      return;
    }

    try {
      // Try to get the last known position first for quicker response
      Position? lastPosition = await Geolocator.getLastKnownPosition();
      Position position;

      if (lastPosition != null) {
        position = lastPosition;
      } else {
        // Get current position with lower accuracy for faster retrieval
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
        );
      }

      // Get placemarks from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      // Check if we got any placemarks
      if (placemarks.isNotEmpty) {
        Placemark first = placemarks.first;

        // Safely assign values using null-aware operators
        addresscontroller.text = first.street ?? 'Unknown Street';
        citycontroller.text = first.subAdministrativeArea ?? 'Unknown City';
        statecontroller.text = first.administrativeArea ?? 'Unknown State';
      }
    } catch (error) {
      print('Failed to get location: $error');
    }
  }

  @override
  void onInit() {
    final arguments = Get.arguments;
    type = arguments['type'];
    navigation = arguments['navigation'];
    edit = arguments['edit'];
    addressModel = arguments['addressModel'];

    GetCountries();
    if (edit!) {
      update_form_on_edit(addressModel!.first_name, addressModel!.last_name, addressModel!.city, addressModel!.state, addressModel!.address,
          addressModel!.phone_number, addressModel!.route_name, addressModel!.building_name, addressModel!.floor_number, addressModel!.route_name);
    }
    super.onInit();
  }

  Future<bool?> GetAddresses() async {
    loading.value = true;
    addresseslist.clear();
    addressesInfo.clear();

    bool success = false;
    loading.value = true;
    Map<String, dynamic> response = await api.getData({
      'token': prefs!.getString("token") ?? "",
    }, "addresses/get-addresses");

    if (response.isNotEmpty) {
      success = response["succeeded"];
      if (success) {
        List productsInfo = response["addresses"];
        addresseslist.clear();
        for (int i = 0; i < productsInfo.length; i++) {
          addressesclass.fromJson(productsInfo[i]);
        }
      }
      loading.value = false;
      return success;
    }
    else {
      loading.value = false;
    }
    loading.value = false;
    return null;
  }

  Future<int?> GetCountries() async {
    var url = "${con!}addresses/get-countries";
    final http.Response response = await http.post(
      Uri.parse(url),
    );
    final List<dynamic> decodedJsonList = json.decode(response.body);
    final List<Country> countryList = decodedJsonList.map((item) => Country.fromJson(item)).toList();
    Countries.value = countryList.obs;
    for (int i = 0; i < Countries.length; i++) {
      if (Countries[i].name == 'LEBANON') {
        selectedCountry = Countries[i];
        getCities(selectedCountry.id);
      }
    }

    for (int i = 0; i < Countries.length; i++) {
      if (Countries[i].id.toString() == addressModel?.r_country_id.toString()) {
        selectedCountry = Countries[i];
        getCities(addressModel.r_country_id);
      }
    }
  }

  Future<bool?> getCities(CountryId) async {
    bool success = false;
    loadCities.value= true;
    Map<String, dynamic> response = await api.getData({
      'country_id': CountryId.toString(),
    }, "addresses/get-cities");

    if (response.isNotEmpty) {
      success = response["succeeded"];
      if (success) {
        final List<dynamic> decodedJsonList = response["cities"];
        final List<Country> countryList = decodedJsonList.map((item) => Country.fromJson(item)).toList();
        Cities.value = countryList.obs;
        selectedCity = Cities[0];

        for (int i = 0; i < Cities.length; i++) {
          if (Cities[i].id.toString() == addressModel?.r_city_id.toString()) {
            selectedCity = Cities[i];
          }
        }
        loadCities.value= false;

      }
      return success;
    } else {
      loading.value = false;
    }
    return null;
  }

  Future<bool?> AddUpdateAddress(context) async {
    bool success = false;
    loading.value = true;
    Map<String, dynamic> response = await api.getData({
      'token': prefs!.getString("token") ?? "",
      'first_name': firstNamecontroller.text.toString(),
      'last_name': lastNamecontroller.text.toString(),
      'country_code': country_code.toString(),
      'phone_number': phoneNumbercontroller.text.toString(),
      'address': addresscontroller.text.toString(),
      'country_id': selectedCountry.id.toString(),
      'city_id': selectedCity.id.toString(),
      'state': statecontroller.text.toString(),
      'route': routnamecontroller.text.toString(),
      'building': buildingnamecontroller.text.toString(),
      'floor': floornumbercontroller.text.toString(),
      'address_id': (edit ? addressModel!.id : ''),
    }, "addresses/add-update-address");
    if (response.isNotEmpty) {
      success = response["succeeded"];
      if (success) {
        GetAddresses();

        Get.back();
      } else {
        toaster(context, response["message"]);
      }
      loading.value = false;

      return success;
    } else {
      toaster(context, response["message"]);
      loading.value = false;
    }
    loading.value = false;
  }

  update_form_on_edit(firstName, lastName, city, state, address, phoneNumber, routeName, buildingName, floorNumber, routName) {
    firstNamecontroller = TextEditingController(
      text: firstName,
    );
    lastNamecontroller = TextEditingController(text: lastName);
    citycontroller = TextEditingController(text: city);
    statecontroller = TextEditingController(text: state);
    addresscontroller = TextEditingController(text: address);
    phoneNumbercontroller = TextEditingController(text: phoneNumber);
    routnamecontroller = TextEditingController(text: routName);
    buildingnamecontroller = TextEditingController(text: buildingName);
    floornumbercontroller = TextEditingController(text: floorNumber);
  }
}

class Country {
  final int id;
  final String name;

  Country({required this.id, required this.name});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}
