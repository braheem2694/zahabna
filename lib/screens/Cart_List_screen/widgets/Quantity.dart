import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:iq_mall/cores/math_utils.dart';
import '../../../cores/assets.dart';
import '../../../main.dart';
import '../../../models/HomeData.dart';
import '../../../utils/ShColors.dart';
import '../../../utils/ShConstant.dart';
import '../../../widgets/CommonWidget.dart';
import '../../../widgets/ShWidget.dart';
import '../../../widgets/ui.dart';
import '../controller/Cart_List_controller.dart';
import 'package:iq_mall/models/functions.dart';
import 'package:flutter/services.dart';

class CartItemWidget extends StatefulWidget {
  final int index;

  CartItemWidget({required this.index});

  @override
  _CartItemWidgetState createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  Cart_ListController controller = Get.find();


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: getPadding(bottom: spacing_standard,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            child: Container(
              width: getSize(28),
              height: getSize(28),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: MainColor,
                border: Border.all(
                  width: 1,
                  color: MainColor,
                ),
              ),
              child: Icon(
                Icons.remove,
                color: Colors.white,
                size: getSize(18),
              ),
            ),
            onTap: () {
              setState(() {
                cartlist![widget.index].loading = true;
              });
              if (int.parse(cartlist![widget.index].quantity.toString()) > 1) {
                cartlist![widget.index].loading = true;
                controller.AddToCart(cartlist![widget.index], '-1', "").then((value) {
                  setState(() {
                    calculateTotalWithoutDelivery();
                    // Get.context!.read<Counter>().calculateTotal(0.0);

                    globalController.refreshProductPrice(true);
                    setState(() {
                      cartlist![widget.index].loading = false;
                    });
                    globalController.refreshProductPrice(false);
                  });
                });
              } else {
                AwesomeDialog(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width < 1000 ? 350 : 600,
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

                                          if (controller.selectedProductIds.contains(cartlist![widget.index].product_id)) {
                                            controller.selectedProductIds.remove(cartlist![widget.index].product_id);
                                          }
                                          cartlist![widget.index].removing = '1';
                                          cartlist![widget.index].in_cart = 0;
                                          Get.back();
                                          List<Product> list = [];
                                          list.add(cartlist![widget.index]);
                                          function.RemoveFromCart(list).then((value) {
                                            cartlist![widget.index].removing = '0';

                                            controller.GetCart().then((value) => controller.deleting_items.value = false);
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
                    )).show().then((value) {
                  setState(() {
                    cartlist![widget.index].loading = false;
                  });
                  globalController.refreshProductPrice(false);
                });
              }
            },
          ),
          Obx(() =>
          cartlist![widget.index].loading == true
              ? Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: getHorizontalSize(35),
              height: 20,
              child: Center(
                child: Progressor_indecator(),
              ),
            ),
          )
              : GestureDetector(
            onTap: () {
              TextEditingController amount = new TextEditingController();
              RxBool loading = false.obs;
              controller.awesomeOpened.value = true;
              // _showBottomSheet(context);
              AwesomeDialog(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width < 1000 ? 350 : 600,
                  context: context,
                  dialogType: DialogType.info,
                  body: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        height: getSize(220),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                          child: Column(
                            children: [
                              Text(
                                'Enter Quantity'.tr,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Focus(
                                onFocusChange: (hasFocus) {
                                  if (hasFocus) {
                                    amount.selection = TextSelection(baseOffset: 0, extentOffset: amount.text.length);
                                  }
                                },
                                child: TextFormField(
                                  autofocus: true,
                                  textAlignVertical: TextAlignVertical.center,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                                  ],
                                  keyboardType: TextInputType.number,
                                  controller: amount = TextEditingController(
                                    text: cartlist!.value[widget.index].quantity,
                                  ),
                                  enabled: true,
                                  textCapitalization: TextCapitalization.words,
                                  style: const TextStyle(color: sh_textColorPrimary, fontSize: textSizeMedium),
                                  decoration: InputDecoration(
                                      prefixText: "",
                                      filled: true,
                                      fillColor: sh_editText_background,
                                      focusColor: sh_editText_background_active,
                                      hintText: 'Please input amount'.tr,
                                      hintStyle: const TextStyle(color: sh_textColorSecondary, fontSize: textSizeMedium),
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: MainColor, width: 0.5)),
                                      enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, style: BorderStyle.none, width: 0))),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: 20,
                                  child: Obx(() => Text(controller.errorResponse.value,style:  TextStyle(color: Colors.red,fontSize: getFontSize(15)),)),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(''),
                                  GestureDetector(onTap: () {
                                    if (amount.text.toString() != '' && amount.text.toString() != '0') {
                                      loading.value = true;
                                      final RegExp regexp = RegExp(r'^0+(?=.)');
                                      amount.text = double.parse(amount.text).toInt().toString();

                                      if (int.parse(cartlist!.value[widget.index].product_qty_left.toString()) > int.parse(cartlist!.value[widget.index].quantity!)) {
                                        var temp = (int.parse(amount.text) - int.parse(cartlist!.value[widget.index].quantity!));
                                        controller.AddToCart(cartlist!.value[widget.index], temp, "alert").then((value) =>
                                        {
                                          controller.GetCart(),
                                          calculateTotalWithoutDelivery(),
                                          Get.context!.read<Counter>().calculateTotal(0.0),
                                          cartlist!.value[widget.index].loading = false,
                                          Get.back(),
                                          loading.value = false,
                                        });
                                      } else {
                                        cartlist!.value[widget.index].loading = false;
                                        toaster(Get.context!, 'Maximum Quantity Reached'.tr);
                                      }
                                    } else {
                                      Get.showSnackbar(Ui.ErrorSnackBar(
                                        message: "Quantity cant be empty or 0",
                                        title: 'Alert',
                                      ));
                                      amount.selection = TextSelection.fromPosition(TextPosition(offset: amount.text.length));
                                    }
                                  }, child: Obx(
                                        () {
                                      return loading.value == false
                                          ? const Icon(
                                        Icons.check_box,
                                        color: Colors.green,
                                        size: 50,
                                      )
                                          : Ui.circularIndicator(color: ColorConstant.logoFirstColor);
                                    },
                                  )),
                                  const Text('')
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )).show().then((value) => controller.awesomeOpened.value = false);
            },
            child: Container(
              color: Colors.transparent,
              width: getHorizontalSize(35),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: Center(
                  child: Text(cartlist!.value[widget.index].quantity!, style: const TextStyle(fontSize: 12.0)),
                ),
              ),
            ),
          )),
          InkWell(
            child: Container(
              width: getSize(28),
              height: getSize(28),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: MainColor,
                border: Border.all(
                  width: 1,
                  color: MainColor,
                ),
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: getSize(18),
              ),
            ),
            onTap: () {
              setState(() {
                cartlist![widget.index].loading = true;
              });
              if (int.parse(cartlist![widget.index].product_qty_left.toString()) > int.parse(cartlist![widget.index].quantity!)) {
                controller.AddToCart(cartlist![widget.index], '1', "").then((value) {
                  setState(() {
                    calculateTotalWithoutDelivery();
                    globalController.refreshProductPrice(true);

                    // Get.context!.read<Counter>().calculateTotal(0.0);
                    cartlist![widget.index].loading = false;
                  });
                  globalController.refreshProductPrice(false);
                });
              } else {
                cartlist![widget.index].loading = false;
                toaster(Get.context!, 'Maximum Quantity Reached'.tr);
              }
            },
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    TextEditingController amount = new TextEditingController();
    RxBool loading = false.obs;

    Get.bottomSheet(
      Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: getSize(220),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
              child: Column(
                children: [
                  Text(
                    'Enter Quantity'.tr,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Focus(
                    onFocusChange: (hasFocus) {
                      if (hasFocus) {
                        amount.selection = TextSelection(baseOffset: 0, extentOffset: amount.text.length);
                      }
                    },
                    child: TextFormField(
                      autofocus: true,
                      textAlignVertical: TextAlignVertical.center,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                      ],
                      keyboardType: TextInputType.number,
                      controller: amount = TextEditingController(
                        text: cartlist!.value[widget.index].quantity,
                      ),
                      enabled: true,
                      textCapitalization: TextCapitalization.words,
                      style: const TextStyle(color: sh_textColorPrimary, fontSize: textSizeMedium),
                      decoration: InputDecoration(
                          prefixText: "",
                          filled: true,
                          fillColor: sh_editText_background,
                          focusColor: sh_editText_background_active,
                          hintText: 'Please input amount'.tr,
                          hintStyle: const TextStyle(color: sh_textColorSecondary, fontSize: textSizeMedium),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: MainColor, width: 0.5)),
                          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, style: BorderStyle.none, width: 0))),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(''),
                      GestureDetector(onTap: () {
                        if (amount.text.toString() != '' && amount.text.toString() != '0') {
                          loading.value = true;
                          final RegExp regexp = RegExp(r'^0+(?=.)');
                          amount.text = double.parse(amount.text).toInt().toString();

                          if (int.parse(cartlist!.value[widget.index].product_qty_left.toString()) > int.parse(cartlist!.value[widget.index].quantity!)) {
                            var temp = (int.parse(amount.text) - int.parse(cartlist!.value[widget.index].quantity!));
                            controller.AddToCart(cartlist!.value[widget.index], temp, "alert").then((value) =>
                            {
                              controller.GetCart(),
                              calculateTotalWithoutDelivery(),
                              Get.context!.read<Counter>().calculateTotal(0.0),
                              cartlist!.value[widget.index].loading = false,
                              Get.back(),
                              loading.value = false,
                            });
                          } else {
                            cartlist!.value[widget.index].loading = false;
                            toaster(Get.context!, 'Maximum Quantity Reached'.tr);
                          }
                        } else {
                          Get.showSnackbar(Ui.ErrorSnackBar(
                            message: "Quantity cant be empty or 0",
                            title: 'Alert',
                          ));
                          amount.selection = TextSelection.fromPosition(TextPosition(offset: amount.text.length));
                        }
                      }, child: Obx(
                            () {
                          return loading.value == false
                              ? const Icon(
                            Icons.check_box,
                            color: Colors.green,
                            size: 50,
                          )
                              : Ui.circularIndicator(color: ColorConstant.logoFirstColor);
                        },
                      )),
                      const Text('')
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      isDismissible: true,
      enableDrag: true,
      ignoreSafeArea: true,

      backgroundColor: Colors.white,

      isScrollControlled: true, // Set this to true to make the sheet full-screen.
    );
  }
}
