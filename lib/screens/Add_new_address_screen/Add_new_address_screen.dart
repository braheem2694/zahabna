import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/screens/Add_new_address_screen/controller/Add_new_address_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/screens/Add_new_address_screen/widgets/SaveButton.dart';
import 'package:iq_mall/screens/Add_new_address_screen/widgets/UseCurrentLocation.dart';
import 'package:iq_mall/screens/SignIn_screen/controller/SignIn_controller.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/utils/ShConstant.dart';
import 'package:iq_mall/widgets/CommonWidget.dart';
import 'package:get/get.dart';
import 'package:iq_mall/widgets/ui.dart';
import '../../widgets/custom_drop.dart';
import '../../widgets/custom_text_form_field.dart';

class Add_new_address_screen extends GetView<Add_new_address_screenController> {
  @override
  Widget build(BuildContext context) {
    final firstName = CustomTextFormField(
      controller: controller.firstNamecontroller,
      textInputAction: TextInputAction.next,
      autofocus: false,
      hintText: 'First Name',
      variant: TextFormFieldVariant.OutlineGray300,
      shape: TextFormFieldShape.RoundedBorder10,
      padding: TextFormFieldPadding.PaddingT4,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'First Name is Required'.tr;
        }
        return null;
      },
    );
    final lastName = CustomTextFormField(
      controller: controller.lastNamecontroller,
      textInputAction: TextInputAction.next,
      autofocus: false,
      hintText: 'Last Name',
      variant: TextFormFieldVariant.OutlineGray300,
      shape: TextFormFieldShape.RoundedBorder10,
      padding: TextFormFieldPadding.PaddingT4,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Last Name is Required'.tr;
        }
        return null;
      },
    );

    final routName = CustomTextFormField(
      controller: controller.routnamecontroller,
      textInputAction: TextInputAction.next,
      autofocus: false,
      hintText: 'Route Name',
      variant: TextFormFieldVariant.OutlineGray300,
      shape: TextFormFieldShape.RoundedBorder10,
      padding: TextFormFieldPadding.addressPadding,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Route Name is Required'.tr;
        }
        return null;
      },
    );

    final state = CustomTextFormField(
      controller: controller.statecontroller,
      textInputAction: TextInputAction.next,
      autofocus: false,
      hintText: 'State',
      variant: TextFormFieldVariant.OutlineGray300,
      shape: TextFormFieldShape.RoundedBorder10,
      padding: TextFormFieldPadding.addressPadding,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'State is Required'.tr;
        }
        return null;
      },
    );
    final buildingName =

    CustomTextFormField(
      controller: controller.buildingnamecontroller,
      textInputAction: TextInputAction.next,
      textInputType: TextInputType.emailAddress,
      width: MediaQuery.of(context).size.width * 0.25,
      autofocus: false,
      hintText: 'Building Name',
      variant: TextFormFieldVariant.OutlineGray300,
      shape: TextFormFieldShape.RoundedBorder10,
      padding: TextFormFieldPadding.addressPadding,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Building Name is Required'.tr;

        }
        return null;
      },
    );
    isNumeric(String s) {
      if (s == null) {
        return false;
      }
      return double.tryParse(s) != null;
    }

    final floorNumber = CustomTextFormField(
        textInputType: TextInputType.number,
        controller: controller.floornumbercontroller,
        textInputAction: TextInputAction.next,
        autofocus: false,
        hintText: 'Floor Number',
        variant: TextFormFieldVariant.OutlineGray300,
        shape: TextFormFieldShape.RoundedBorder10,
        padding: TextFormFieldPadding.addressPadding,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Floor Number is Required'.tr;
          }
          if (!isNumeric(value)) {
            return 'Only numbers are allowed'.tr;
          }
          return null;
        });

    final address = CustomTextFormField(
      controller: controller.addresscontroller,
      textInputAction: TextInputAction.next,
      autofocus: false,
      hintText: 'Address',
      variant: TextFormFieldVariant.OutlineGray300,
      shape: TextFormFieldShape.RoundedBorder10,
      padding: TextFormFieldPadding.addressPadding,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Address is Required'.tr;
        }
        return null;
      },
    );

    return Scaffold(
      appBar: CommonAppBar(controller.addressModel == null ? 'Add New Address'.tr : 'Edit Address'.tr),
      body: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(16),
          child: SingleChildScrollView(
              child: Form(
            key: controller.formKey,
            child: Wrap(runSpacing: spacing_standard_new, children: <Widget>[
              UseCurrentLocationButton(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(child: firstName),
                  const SizedBox(
                    width: spacing_standard_new,
                  ),
                  Expanded(child: lastName),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: CustomTextFormField(
                  autofocus: false,
                  controller: controller.phoneNumbercontroller,
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.number,
                  variant: TextFormFieldVariant.OutlineGray300,
                  shape: TextFormFieldShape.RoundedBorder10,
                  padding: TextFormFieldPadding.PaddingT4,
                  prefix: CodePicker(context),
                  hintText: 'Phone number'.tr,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'fill email User name please'.tr;
                    }
                    if (value.length < 8) {
                      return 'Phone number must be of 8 digits'.tr;
                    }
                    return null;
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(child: routName),
                  const SizedBox(
                    width: spacing_standard_new,
                  ),
                  Expanded(child: buildingName),
                  const SizedBox(
                    width: spacing_standard_new,
                  ),
                  Expanded(child: floorNumber),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Obx(() => Container(
                      color: Colors.white,
                      child: DropdownButtonFormField(
                        value: controller.selectedCountry,
                        items: controller.Countries.map((var country) {
                          return DropdownMenuItem(
                            value: country,
                            child: Text(country.name),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          controller.selectedCountry = newValue;
                          controller.getCities(controller.selectedCountry.id);
                        },
                        hint: Text('Select Country'.tr),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a country'.tr;
                          }
                          return null;
                        },
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Obx(() => Container(
                    color: Colors.white,
                    height: getSize(50),
                    child:
                    // CustomDropdown(
                    //   countries: controller.Cities, // Your list of countries
                    //   selectedCountry: controller.selectedCity.value,
                    //   // The currently selected country
                    //   onCountryChanged: (CountryForAddress newCountry) {
                    //     // Handle the country change
                    //     print("Selected country: ${newCountry.name}");
                    //   },
                    // )
                    !controller.loadCities.value?
                    DropdownButtonFormField(
                          value: controller.selectedCity,
                          items: controller.Cities.map((var country) {
                            return DropdownMenuItem(
                              value: country,
                              child: Text(country.name),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            controller.selectedCity = newValue;
                          },
                          hint: Text('Select City'.tr),
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a City'.tr;
                            }
                            return null;
                          },
                        ):Ui.circularIndicator(color: MainColor),
                    )),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(child: address),
                  const SizedBox(
                    width: spacing_standard_new,
                  ),
                  Expanded(child: state),
                ],
              ),
              Obx(() => controller.loading.value ? Progressor_indecator() : SaveButton()),
            ]),
          ))),
    );
  }
}
