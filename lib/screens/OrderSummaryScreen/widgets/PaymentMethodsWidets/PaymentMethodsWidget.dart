import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/widgets/ShWidget.dart';
import '../../../../main.dart';
import '../../../Stores_screen/controller/Stores_screen_controller.dart';
import '../../controller/OrderSummaryScreen_controller.dart';
import '../Stripe.dart';

List payment_methods = [];
List GiftCards_payment_methods = [];

class PaymentMethodsWidget extends StatefulWidget {
  var controller;
  var unique_id;

  PaymentMethodsWidget({this.controller});

  @override
  PaymentMethodsWidgetState createState() => PaymentMethodsWidgetState();
}

class PaymentMethodsWidgetState extends State<PaymentMethodsWidget> {
  RxBool payment_methods_loading = false.obs;

  OrderSummaryScreenController controller = Get.find();
  final ImagePicker _picker = ImagePicker();
  int val = -1;

  List countriesInfo = [];
  List branchesInfo = [];
  bool countiresloading = true;
  bool citiesloading = false;
  bool branchesloading = false;
  static bool country_selected = false;
  static bool city_selected = false;
  static bool branch_selected = false;
  List citiesInfo = [];
  static String? countrychoosen;
  static String? countrychoosenID;
  static String? citychoosen;
  static String? citychoosenID;
  static String? branchchoosen;
  static String? branchchoosenID;
  static DateTime? selecteddate;
  List<String> countries = <String>[];
  List<String> cities = <String>[];
  List<String> branches = <String>[];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    controller.image = null;
    SelectPaymentMethod();
    super.initState();
  }
  SelectPaymentMethod() {
    for (int i = 0; i < payment_methods.length; i++) {
      if (payment_methods[i]['name'] == 'Cash on delivery') {
        controller.paying_method!.value = payment_methods[i]['name'];
        val = i;
        controller.PaymentMethod = payment_methods[i]['id'];
      }
    }
  }
  var webimage;
  static String? webimageString;
  static String? usrImgBase64;

  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true, // Makes the ListView wrap content
          physics: NeverScrollableScrollPhysics(), // Makes it non-scrollable
          itemCount: payment_methods.length,
          itemBuilder: (context, index) {
            return SizedBox(
              height: 70,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    controller.paying_method!.value = payment_methods[index]['name'];
                    val = index;
                    controller.PaymentMethod = payment_methods[index]['id'];
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      color: val == index ? MainColor : Colors.grey,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            payment_methods[index]['name'],
                            style: const TextStyle(
                              color: sh_white,
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        Obx(() => controller.paying_method!.value == 'Pick Up' ? pickup_Location(context) :controller.paying_method!.value=='Bank Transfer'?BankMoneyTransfer(context):controller.paying_method!.value=='Stripe'?Container():Container()),
        // AddNewCardScreen()
      ],
    );
  }
  Widget BankMoneyTransfer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28.0),
      child: Column(
        children: [
          controller.image.toString() == 'null'
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 5),
                  child: Image.file(
                    controller.image!,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.25,
                    fit: BoxFit.cover,
                  ),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(''),
              GestureDetector(
                onTap: () async {
                  // if(kIsWeb){
                  //   imagePicked.value = await ImagePickerWeb.getImageInfo;
                  // }else{
                  _showPicker(context);
                  //    }
                },
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 18.0, right: 18, top: 10, bottom: 10),
                        child: Icon(
                          Icons.camera_alt,
                          color: MainColor,
                          size: 40,
                        )),
                    Text(
                      'Add Payment bill here'.tr,
                      style: TextStyle(color: MainColor),
                    )
                  ],
                ),
              ),
              const Text(''),
            ],
          ),
        ],
      ),
    );
  }

  Widget pickup_Location(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28.0),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18, top: 10, bottom: 10),
                child: DropdownButton<String>(
                  focusColor: Colors.white,
                  value: countrychoosen,
                  style: const TextStyle(color: Colors.white),
                  iconEnabledColor: Colors.black,
                  items: (branches_countries?.where((item) => item is Map<String, dynamic>).map<DropdownMenuItem<String>>((item) {
                    Map<String, dynamic> countryInfo = item as Map<String, dynamic>;
                    return DropdownMenuItem<String>(
                      value: countryInfo['name'],
                      child: Text(
                        countryInfo['name'],
                        style: const TextStyle(color: Colors.black),
                      ),
                    );
                  }))?.toList(),
                  hint: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 2.0, right: 2),
                        child: Icon(
                          Icons.flag,
                          color: MainColor,
                        ),
                      ),
                      Text(
                        "choose country".tr,
                        style: TextStyle(color: MainColor, fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      citiesloading = false;
                      branchesloading = false;
                      country_selected = false;
                      city_selected = false;
                      branch_selected = false;
                      citychoosen = null;
                      branchchoosen = null;
                      country_selected = true;
                      countrychoosen = value;
                      city_selected = false;

                      // find the selected country's ID from branches_countries
                      var selectedCountryInfo = branches_countries?.firstWhere((countryInfo) => countryInfo['name'] == value);
                      countrychoosenID = selectedCountryInfo!['id'].toString();
                      getcities(selectedCountryInfo['id'].toString());
                    });
                  },
                ),
              ),
              country_selected
                  ? citiesloading
                      ? Padding(
                          padding: const EdgeInsets.only(left: 22.0, right: 22, top: 10, bottom: 10),
                          child: SizedBox(
                            width: 120,
                            child: LinearProgressIndicator(
                              color: MainColor,
                              backgroundColor: MainColor,
                              semanticsLabel: 'Linear progress indicator',
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            toaster(context, 'Select Country first'.tr);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 18.0, right: 18, top: 10, bottom: 10),
                            child: DropdownButton<String>(
                              focusColor: Colors.white,
                              value: citychoosen,
                              style: const TextStyle(color: Colors.white),
                              iconEnabledColor: Colors.black,
                              items: cities.map<DropdownMenuItem<String>>((String? value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value!,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                );
                              }).toList(),
                              hint: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 2.0, right: 2),
                                    child: Icon(
                                      Icons.location_city,
                                      color: MainColor,
                                    ),
                                  ),
                                  Text(
                                    "Choose city".tr,
                                    style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              onChanged: (String? value) {
                                setState(() {
                                  city_selected = true;
                                  citychoosen = value;
                                  for (int i = 0; i < citiesInfo.length; i++) {
                                    if (value.toString() == citiesInfo[i]['name']) {
                                      citychoosenID = citiesInfo[i]['id'].toString();
                                      getbranches(citiesInfo[i]['id'].toString());
                                    }
                                  }
                                });
                              },
                            ),
                          ),
                        )
                  : Padding(
                      padding: const EdgeInsets.only(left: 18.0, right: 18, top: 10, bottom: 10),
                      child: IgnorePointer(
                        ignoring: true,
                        child: DropdownButton(
                          hint: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 2.0, right: 2),
                                child: Icon(
                                  Icons.location_city,
                                  color: MainColor,
                                ),
                              ),
                              Text("Choose city".tr),
                            ],
                          ),
                          items: ["asdf", "wehee", "asdf2", "qwer"].map(
                            (String? value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text('$value'),
                              );
                            },
                          ).toList(),
                          onChanged: (value) {},
                        ),
                      ),
                    )
            ],
          ),
          Row(
            children: [
              city_selected
                  ? branchesloading
                      ? Padding(
                          padding: const EdgeInsets.only(left: 22.0, right: 22, top: 10, bottom: 10),
                          child: Container(
                            width: 120,
                            child: LinearProgressIndicator(
                              color: MainColor,
                              backgroundColor: MainColor,
                              semanticsLabel: 'Linear progress indicator',
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(left: 22.0, right: 22, top: 10, bottom: 10),
                          child: DropdownButton<String>(
                            focusColor: Colors.white,
                            value: branchchoosen,
                            style: const TextStyle(color: Colors.white),
                            iconEnabledColor: Colors.black,
                            items: branches.map<DropdownMenuItem<String>>((String? value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value!,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),
                            hint: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 2.0, right: 2),
                                  child: Icon(
                                    Icons.location_pin,
                                    color: MainColor,
                                  ),
                                ),
                                Text(
                                  "Choose branch".tr,
                                  style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            onChanged: (String? value) {
                              setState(() {
                                branch_selected = true;
                                branchchoosen = value;
                                for (int i = 0; i < branchesInfo.length; i++)
                                  if (value.toString() == branchesInfo[i]['branch_name']) {
                                    branchchoosenID = branchesInfo[i]['id'].toString();
                                  }
                              });
                            },
                          ),
                        )
                  : GestureDetector(
                      onTap: () {
                        toaster(context, 'Select City first'.tr);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 18.0, right: 18, top: 10, bottom: 10),
                        child: IgnorePointer(
                          ignoring: true,
                          child: DropdownButton(
                            hint: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 2.0, right: 2),
                                  child: Icon(
                                    Icons.location_pin,
                                    color: MainColor,
                                  ),
                                ),
                                Text("Choose branch".tr),
                              ],
                            ),
                            items: ["asdf", "wehee", "asdf2", "qwer"].map(
                              (String? value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text('$value'),
                                );
                              },
                            ).toList(),
                            onChanged: (value) {},
                          ),
                        ),
                      ),
                    ),
              TextButton(
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 5475)),
                    ).then((date) {
                      if (date != null) {
                        setState(() {
                          selecteddate = date;
                        });
                      }
                    });
                  },
                  child: selecteddate.toString() == 'null'
                      ? Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 2.0, right: 2),
                              child: Icon(
                                Icons.location_pin,
                                color: MainColor,
                              ),
                            ),
                            Text(
                              'Choose Piking Date'.tr,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 2.0, right: 2),
                              child: Icon(
                                Icons.location_pin,
                                color: MainColor,
                              ),
                            ),
                            Text(
                              'Choose Piking Date\n'.tr + selecteddate.toString().substring(0, 10),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ))
            ],
          )
        ],
      ),
    );
  }

  Future<bool> getbranches(id) async {
    bool success = false;

    Map<String, dynamic> response = await api.getData({
      'country_id': countrychoosenID,
      'city_id': id,
    }, "stores/get-branches");

    if (response.isNotEmpty) {
      branchesInfo = response["branches_cities"];

      branches.clear();
      for (int i = 0; i < branchesInfo.length; i++) {
        setState(() {
          branches.add(branchesInfo[i]['branch_name'].toString());
        });
      }
      setState(() {
        branchesloading = false;
      });
    }
    if (success) {
      prefs?.setString('logged_in', 'true');
    } else {
      
    }
    return success;
  }

  Future<bool> getcities(id) async {
    bool success = false;

    Map<String, dynamic> response = await api.getData({
      'country_id': id,
    }, "stores/get-branches-cities");

    if (response.isNotEmpty) {
      citiesInfo = response["branches_cities"];
      cities.clear();
      for (int i = 0; i < citiesInfo.length; i++) {
        cities.add(citiesInfo[i]['name'].toString());
      }
      setState(() {
        citiesloading = false;
      });
    }
    if (success) {
      prefs?.setString('logged_in', 'true');
    } else {
      
    }
    return success;
  }

  _imgFromGallery() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
    if (mounted) {
      setState(() {
        webimage = photo;
        webimageString = photo!.path;
        controller.image = File(photo.path);
      });
    }
  }

  _imgFromCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      webimage = photo;
      webimageString = photo!.path;
      controller.image = File(photo.path);
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title:  Text('Gallery'.tr),
                    onTap: () {
                      _imgFromGallery();
                      Get.back();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: Text('Camera'.tr),
                  onTap: () {
                    _imgFromCamera();
                    Get.back();
                  },
                ),
              ],
            ),
          );
        });
  }
}
