import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/models/HomeData.dart';
import 'package:iq_mall/widgets/ui.dart';
import '../Product_widget/Product_widget.dart';
import '../main.dart';
import '../screens/Cart_List_screen/controller/Cart_List_controller.dart';
import '../utils/ShImages.dart';
import 'ShWidget.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'custom_image_view.dart';

class AddToCartButton extends StatefulWidget {
  Product product;

  AddToCartButton({
    required this.product,
  });

  @override
  _AddToCartButtonState createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isAdded = false;
  String _apiStatus = 'Adding'; // New state variable

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.decelerate, // Applying the curve here
      ),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Future.delayed(Duration(milliseconds: 200), () {
            if (mounted) {
              setState(() {
                _controller.reverse();
              });
            }
          });
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<bool?> AddToCart(product, quantity) async {
    bool success = false;

    // Set the initial API call status to 'adding'
    setState(() {
      _apiStatus = 'adding';
    });

    Map<String, dynamic> data = {
      'token': prefs!.getString("token") ?? "",
      'product_id': product.product_id,
      'qty': quantity,
      'variant_id': '',
    };

    final sessionId = prefs!.getString("session_id");
    if (sessionId != null && sessionId.isNotEmpty) {
      data['session_id'] = sessionId;
    }

    // Make the API call
    Map<String, dynamic> response = await api.getData(data, "cart/add-to-cart");

    if (response.isNotEmpty) {
      success = response["succeeded"];
      if (success) {
        // Handle success
        String? session_id = prefs!.getString("session_id");
        if (session_id == null || session_id.isEmpty) {
          session_id = response["session_id"];
          if (session_id != null) {
            await prefs!.setString("session_id", session_id);
          }
        }
        Get.context!.read<Counter>().calculateTotal(0.0);
        Cart_ListController Cartcontroller = Get.find();
        Cartcontroller.GetCart();
        Ui.flutterToast(response["message"].toString().tr, Toast.LENGTH_LONG, MainColor, whiteA700);

        // toaster(Get.context!, response["message"]);
        if (mounted) {
          setState(() {
            _apiStatus = 'added';
          });
        }
        await Future.delayed(Duration(milliseconds: 700));
      } else {
        // Handle failure
        await Future.delayed(Duration(milliseconds: 700));
        Ui.flutterToast(response["message"].toString().tr, Toast.LENGTH_LONG, MainColor, whiteA700);
        // Wait for 2 seconds
        // toaster(Get.context!, response["message"]);

        // Update the UI for failure
        if (mounted) {
          setState(() {
            _apiStatus = 'failed';
          });
        }
      }
    } else {
      // Handle empty response
      Ui.flutterToast('Error Occurs'.tr, Toast.LENGTH_LONG, MainColor, whiteA700);

      toaster(Get.context!, 'Error Occurs');

      // Update the UI for failure
      if (mounted) {
        setState(() {
          _apiStatus = 'failed';
        });
      }
    }

    return success;
  }

  void _addToCart() {
    ProductWidgetController productWidgetController = Get.find(tag: widget.product.product_id.toString());
    productWidgetController.borderWidth.value = 2.0;
    setState(() {
      _isAdded = true;
    });
    ;
    _controller.forward();
    vibrationMethod();
    setState(() {
      widget.product.loading = true;
    });

    AddToCart(widget.product, '1').then((value) {
      // Introduce a delay here
      Future.delayed(const Duration(milliseconds: 700), () {
        if (mounted) {
          setState(() {
            widget.product.loading = false;
            _controller.reverse(); // Reverse the animation for closing
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return prefs!.getString('show_add_to_cart').toString() == '1' && widget.product.has_option == 0 && prefs!.getString('cart_btn') == '1' && widget.product.cart_btn == 1
        ? GestureDetector(
            onTap: _addToCart,
            child: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Button_color,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CustomImageView(
                    svgPath: AssetPaths.addToCart,
                    width: getSize(20),
                    height: getSize(20),
                    // imagePath: AssetPaths.FacebookImage,
                  ),
                  // Icon(
                  //   Icons.add,
                  //   color: Colors.white,
                  //   size: getSize(15),
                  // ),
                  SizeTransition(
                    sizeFactor: _animation,
                    axis: Axis.horizontal,
                    axisAlignment: -1,
                    child: Text(
                      _apiStatus,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container();
  }
}
