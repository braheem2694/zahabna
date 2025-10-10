import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iq_mall/screens/Address_manager_screen/controller/Address_manager_controller.dart';
import '../../../main.dart';
import '../../../models/Address.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/ShColors.dart';
import '../../../utils/ShConstant.dart';
import '../../../utils/ShImages.dart';
import '../../../widgets/ShWidget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressListView extends StatefulWidget {
  @override
  _AddressListViewState createState() => _AddressListViewState();
}

class _AddressListViewState extends State<AddressListView> {
  Address_managerController controller = Get.find();

  @override
  void initState() {
    super.initState();
    controller = Get.find();
  }

  @override
  Widget build(BuildContext context) {
    Address_managerController controller = Get.find();
    return Padding(
      padding: const EdgeInsets.only(bottom: 58.0),
      child: Obx(() => ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(top: spacing_standard_new, bottom: spacing_standard_new),
            itemBuilder: (item, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                child: InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5, // Spread radius
                          blurRadius: 7, // Blur radius
                          offset: const Offset(0, 2), // Offset in (x,y)
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(spacing_standard_new),
                    margin: const EdgeInsets.only(
                      right: spacing_standard_new,
                      left: spacing_standard_new,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Radio(
                            value: index,
                            groupValue: prefs!.getInt('selectedaddress'),
                            onChanged: (value) {
                              setState(() {
                                index2.value = index;
                                prefs!.setInt('selectedaddress', index);
                                Get.context?.read<Counter>().incrementIndex(index2.value);
                              });
                            },
                            activeColor: Colors.blue),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                            text(addresseslist[index].first_name + " " + addresseslist[index].last_name,
                                textColor: sh_textColorPrimary, fontFamily: fontMedium, fontSize: textSizeLargeMedium),
                            text(addresseslist[index].phone_number, textColor: sh_textColorPrimary, fontSize: textSizeMedium),
                            text(addresseslist[index].address + ' ' +addresseslist[index].country_name+" , "+ addresseslist[index].city_name),
                            text(addresseslist[index].route_name + " "+addresseslist[index].building_name + " "+addresseslist[index].floor_number + " ",
                                textColor: sh_textColorPrimary, fontFamily: fontMedium, fontSize: textSizeLargeMedium),
                            Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.toNamed(AppRoutes.Add_new_address,
                                              arguments: {'edit': true, 'navigation': 'notnormal', 'addressModel': addresseslist[index]})!
                                          .then((value) {
                                        controller.GetAddresses();
                                        prefs!.setInt('selectedaddress', 0);
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Image.asset(AssetPaths.edit,height: 15,width: 15,),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 3.0),
                                          child: Text('Edit', style: TextStyle(color: Colors.blue)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Delete Address'),
                                            content: const Text('Are you sure you want to delete this address?'),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text(
                                                  'Cancel',
                                                  style: TextStyle(color: Colors.blue),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                                onPressed: () {
                                                  controller.DeleteAddress(index).then((value) {
                                                    addresseslist.removeAt(index);
                                                    prefs!.setInt('selectedaddress', 0);
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 12.0),
                                      child: Row(
                                        children: [
                                          Image.asset(AssetPaths.delete,height: 15,width: 15,),
                                          const Text('Delete', style: TextStyle(color: Colors.red)),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            shrinkWrap: true,
            itemCount: addresseslist.value.length,
          )),
    );
  }
}
