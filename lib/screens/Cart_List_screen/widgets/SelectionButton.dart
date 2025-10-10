import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/models/functions.dart';
import 'package:get/get.dart';
import '../controller/Cart_List_controller.dart';



class SelectionButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Cart_ListController controller = Get.find();
    return Container(
      height: getSize(55),
      decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.grey[900]!, blurRadius: 10, spreadRadius: 0.2, offset: Offset(0, 2))], color: sh_semi_white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              controller.selectAll();
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Row(
                children: [
                  Icon(
                    controller.selectedProductIds.length == cartlist!.length ? Icons.radio_button_checked_rounded : Icons.radio_button_off,
                    color: MainColor,
                    size: 22,
                  ),
                   Text(
                    'All'.tr,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              AwesomeDialog(
                  width:  350,
                  context: context,
                  dialogType: DialogType.info,
                  body: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      SizedBox(
                        height: 170,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                          child: Column(
                            children: [
                              Text(
                                'Warning'.tr,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Center(
                                child: Text(
                                  'Are you sure you want to delete ?'.tr,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(''),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: MainColor,
                                      textStyle: const TextStyle(fontSize: 20),
                                    ),
                                    onPressed: () {
                                      if (!controller.deleting_items.value) {
                                        controller.deleting_items.value = true;
                                        Get.back();
                                        var list =
                                            <dynamic>[]; // Assuming the type of items in cartlist is dynamic. Replace <dynamic> with the actual type if known.

                                        for (var selectedId in controller.selectedProductIds) {
                                          for (var cartItem in cartlist!) {
                                            if (cartItem.product_id.toString() == selectedId.toString()) {
                                              list.add(cartItem);
                                              break; // Break out of the inner loop once a match is found to avoid unnecessary iterations
                                            }
                                          }
                                        }

                                        function.RemoveFromCart(list).then((value) {
                                          if(value){
                                            controller.selectedProductIds.clear();
                                          }
                                          controller.deleting_items.value = false;
                                          controller.GetCart();
                                        });
                                      }
                                    },
                                    child: Text(
                                      'Delete'.tr,
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  const Text(''),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: MainColor,
                                      textStyle: const TextStyle(fontSize: 20),
                                    ),
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text(
                                      'Cancel'.tr,
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  const Text(''),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )).show();
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: MainColor,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: [
                      MainColor,
                      MainColor.withOpacity(0.7),
                    ]),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${'Remove'.tr} (${controller.selectedProductIds.length})',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
