import 'package:flutter/material.dart';
import 'package:iq_mall/screens/OrderSummaryScreen/controller/OrderSummaryScreen_controller.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'package:iq_mall/widgets/CommonWidget.dart';
import 'package:get/get.dart';
class PickupSetup extends StatelessWidget {


  // Declare all your variables and methods here...

  @override
  Widget build(BuildContext context) {
    OrderSummaryScreenController controller = Get.find();
    return Padding(
      padding: const EdgeInsets.only(bottom: 28.0),
      child: Column(
        children: [
          Row(
            children: [
              controller.countiresloading
                  ? Progressor_indecator()
                  : Padding(
                padding: const EdgeInsets.only(
                    left: 18.0, right: 18, top: 10, bottom: 10),
                child: DropdownButton<String>(
                  focusColor: Colors.white,
                  value: controller.countrychoosen,
                  style: TextStyle(color: Colors.white),
                  iconEnabledColor: Colors.black,
                  items: controller.countries
                      .map<DropdownMenuItem<String>>((String? value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value!,
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                  hint: Row(
                    children: [
                      Padding(
                        padding:
                        const EdgeInsets.only(left: 2.0, right: 2),
                        child: Icon(
                          Icons.flag,
                          color: MainColor,
                        ),
                      ),
                      Text(
                        "choose country".tr,
                        style: TextStyle(
                            color: MainColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  onChanged: (String? value) {
                      controller.citiesloading = false;
                      controller.branchesloading = false;
                      controller.country_selected = false;
                      controller.city_selected = false;
                      controller.branch_selected = false;
                      controller.citychoosen = null;
                      controller.branchchoosen = null;
                      controller.country_selected = true;
                      controller.countrychoosen = value;
                      controller.city_selected = false;
                      for (int i = 0; i < controller.countriesInfo.length; i++)
                        if (value.toString() ==
                            controller.countriesInfo[i]['country_name']) {
                          controller.countrychoosenID = controller.countriesInfo[i]['id'];
                          controller.getcities(controller.countriesInfo[i]['id']);
                        }
                  },
                ),
              ),
              controller.country_selected
                  ? controller.citiesloading
                  ? Padding(
                padding: const EdgeInsets.only(
                    left: 22.0, right: 22, top: 10, bottom: 10),
                child: Container(
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
                  toaster(context, 'Select Country first');
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 18.0, right: 18, top: 10, bottom: 10),
                  child: DropdownButton<String>(
                    focusColor: Colors.white,
                    value: controller.citychoosen,
                    style: TextStyle(color: Colors.white),
                    iconEnabledColor: Colors.black,
                    items: controller.cities.map<DropdownMenuItem<String>>(
                            (String? value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value!,
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                    hint: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 2.0, right: 2),
                          child: Icon(
                            Icons.location_city,
                            color: MainColor,
                          ),
                        ),
                        Text(
                          "Choose city".tr,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    onChanged: (String? value) {

                      controller.city_selected = true;
                      controller.citychoosen = value;
                        for (int i = 0; i < controller.citiesInfo.length; i++)
                          if (value.toString() ==
                              controller.citiesInfo[i]['city_name']) {
                            controller.citychoosenID = controller.citiesInfo[i]['id'];
                            controller.getbranches(controller.citiesInfo[i]['id']);
                          }

                    },
                  ),
                ),
              )
                  : Padding(
                padding: const EdgeInsets.only(
                    left: 18.0, right: 18, top: 10, bottom: 10),
                child: IgnorePointer(
                  ignoring: true,
                  child: DropdownButton(
                    hint: Row(
                      children: [
                        Padding(
                          padding:
                          const EdgeInsets.only(left: 2.0, right: 2),
                          child: Icon(
                            Icons.location_city,
                            color: MainColor,
                          ),
                        ),
                        new Text("Choose city".tr),
                      ],
                    ),
                    items: ["asdf", "wehee", "asdf2", "qwer"].map(
                          (String? value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: new Text('$value'),
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
              controller.city_selected
                  ? controller.branchesloading
                  ? Padding(
                padding: const EdgeInsets.only(
                    left: 22.0, right: 22, top: 10, bottom: 10),
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
                padding: const EdgeInsets.only(
                    left: 22.0, right: 22, top: 10, bottom: 10),
                child: DropdownButton<String>(
                  focusColor: Colors.white,
                  value: controller.branchchoosen,
                  style: TextStyle(color: Colors.white),
                  iconEnabledColor: Colors.black,
                  items:controller.branches
                      .map<DropdownMenuItem<String>>((String? value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value!,
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                  hint: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 2.0, right: 2),
                        child: Icon(
                          Icons.location_pin,
                          color: MainColor,
                        ),
                      ),
                      Text(
                        "Choose branch".tr,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  onChanged: (String? value) {

                    controller.branch_selected = true;
                    controller.branchchoosen = value;
                      for (int i = 0; i < controller.branchesInfo.length; i++)
                        if (value.toString() ==
                            controller.branchesInfo[i]['branch_name']) {
                          controller.branchchoosenID = controller.branchesInfo[i]['id'];
                        }

                  },
                ),
              )
                  : GestureDetector(
                onTap: () {
                  toaster(context, 'Select City first'.tr);
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 18.0, right: 18, top: 10, bottom: 10),
                  child: IgnorePointer(
                    ignoring: true,
                    child:  DropdownButton(
                      hint: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 2.0, right: 2),
                            child: Icon(
                              Icons.location_pin,
                              color: MainColor,
                            ),
                          ),
                          new Text("Choose branch".tr),
                        ],
                      ),
                      items: ["asdf", "wehee", "asdf2", "qwer"].map(
                            (String? value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text('$value'),
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
                    // DatePicker.showDatePicker(context,
                    //     showTitleActions: true,
                    //     minTime: DateTime.now(),
                    //     maxTime: DateTime.now().add(Duration(days: 5475)),
                    //
                    //     onChanged: (date) {}, onConfirm: (date) {
                    //
                    //       controller.selecteddate = date;
                    //
                    //     }, currentTime: DateTime.now(), locale: LocaleType.en);
                  },
                  child: controller.selecteddate.toString() == 'null'
                      ? Row(
                    children: [
                      Padding(
                        padding:
                        const EdgeInsets.only(left: 2.0, right: 2),
                        child: Icon(
                          Icons.location_pin,
                          color: MainColor,
                        ),
                      ),
                      Text(
                        'Choose Piking Date'.tr,
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  )
                      : Row(
                    children: [
                      Padding(
                        padding:
                        const EdgeInsets.only(left: 2.0, right: 2),
                        child: Icon(
                          Icons.location_pin,
                          color: MainColor,
                        ),
                      ),
                      Text(
                        'Choose Piking Date'.tr +"\n"+
                            controller.selecteddate.toString().substring(0, 10),
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ))
            ],
          )
        ],
      ),
    );
  }
}
