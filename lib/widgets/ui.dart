import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:iq_mall/cores/assets.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import '../Product_widget/Product_widget.dart';
import '../cores/math_utils.dart';
import '../main.dart';
import '../models/HomeData.dart';
import '../utils/ShColors.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/foundation.dart' as fn; // ✅ Import compute function

import 'package:dio/dio.dart' as dio;

class Ui {
  static GetBar ErrorSnackBar({String? title = 'Error', String? message}) {
    Get.log("[$title] $message", isError: true);
    return GetBar(
      titleText: Text(title!.tr, style: Get.textTheme.titleLarge!.merge(const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
      messageText: Text(message!, style: Get.textTheme.bodySmall!.merge(const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(20),
      backgroundColor: Colors.redAccent,
      icon: const Icon(Icons.remove_circle_outline, size: 32, color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      borderRadius: 8,
      dismissDirection: DismissDirection.horizontal,
      duration: const Duration(milliseconds: 3000),
    );
  }

  static GetBar successSnackBar({String? title = 'Success', String? message}) {
    Get.log("[$title] $message", isError: false);
    return GetBar(
      titleText: Text(title!.tr, style: Get.textTheme.titleLarge!.merge(const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
      messageText: Text(message!, style: Get.textTheme.bodySmall!.merge(const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(20),
      backgroundColor: ColorConstant.logoFirstColorConstant,
      icon: const Icon(Icons.remove_circle_outline, size: 32, color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      borderRadius: 8,
      dismissDirection: DismissDirection.horizontal,
      duration: const Duration(milliseconds: 3000),
    );
  }

  static String progImages(String image, fromKey) {
    List<String> newImageList = [];

    String newImage = "";
    if (fromKey == "blur") {
      newImageList = image.split("/");
      newImageList.insert(newImageList.length - 1, "blures");
    } else if (fromKey == "thumbnails") {
      newImageList = image.split("/");
      newImageList.insert(newImageList.length - 1, "thumbnails");
    }

    for (int i = 0; i < newImageList.length; i++) {
      if (newImage != "") {
        newImage += "/${newImageList[i]}";
      } else {
        newImage += newImageList[i];
      }
    }
    return newImage;
  }

  static BoxDecoration getBoxDecoration({Color? color, double? radius, Border? border, Gradient? gradient}) {
    return BoxDecoration(
      color: color ?? Get.theme.primaryColor,
      borderRadius: BorderRadius.all(Radius.circular(radius ?? 10)),
      boxShadow: [
        BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
      ],
      border: border ?? Border.all(color: Get.theme.focusColor.withOpacity(0.05)),
      gradient: gradient,
    );
  }

  static String formatDate(DateTime dateTime) {
    // Example output: "2025-06-05"
    return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
  }

  static flutterToast(msg, toast, backgroundColor, textColor) {
    Fluttertoast.showToast(msg: msg, toastLength: toast, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 1, backgroundColor: backgroundColor, textColor: textColor, fontSize: 16.0);
  }

  // static onTapWhatsapp(Product product, String? phoneNumber) {
  //   var unescape = HtmlUnescape();
  //   String description = unescape.convert(product.description ?? '');
  //   String productUrl = "https://cms.lebanonjewelry.net/product/${product.product_id}";
  //
  //   makeWhatsappContact(
  //     phoneNumber ?? '+96171069164',
  //     text: "I want to ask about this product: ${product.product_name}\n$productUrl\n$description",
  //   );
  // }

  static void onTapWhatsapp(Product product, String? phoneNumber) {
    final unescape = HtmlUnescape();

    // --- Cleaners -------------------------------------------------------------
    String? cleanStr(dynamic v) {
      if (v == null) return null;
      final s = v.toString().trim();
      if (s.isEmpty) return null;
      final lower = s.toLowerCase();
      if (lower == 'null' || lower == 'undefined' || lower == 'nan') return null;
      return s;
    }

    final buffer = StringBuffer()..writeln("🛍️ *Product Details*");

    String? fmtInt(int? n) => n == null ? null : '$n';
    String? fmtNum(num? n, {String unit = ''}) => n == null
        ? null
        : unit.isEmpty
            ? '$n'
            : '$n $unit';
    String? fmtBool(bool? v) => v == null ? null : (v ? 'Yes' : 'No');

    // writes only if value resolves to a non-null, non-empty string (and not "null")
    void writeS(String label, dynamic v) {
      final s = cleanStr(v);
      if (s != null) buffer.writeln("• $label: $s");
    }

    void writeI(String label, int? v) {
      final s = fmtInt(v);
      if (s != null) buffer.writeln("• $label: $s");
    }

    void writeN(String label, num? v, {String unit = ''}) {
      final s = fmtNum(v, unit: unit);
      if (s != null) buffer.writeln("• $label: $s");
    }

    void writeB(String label, bool? v) {
      final s = fmtBool(v);
      if (s != null) buffer.writeln("• $label: $s");
    }

    // --- Build message --------------------------------------------------------
    final description = unescape.convert(product.description ?? '');
    final productUrl = "https://$applink/product/${product.product_id}";
    final variationsCount = product.variations?.length ?? 0;
    final fieldsCount = product.fields.length;
    final currency = cleanStr(sign) ?? '';

    // writeI("ID", product.product_id);
    writeS("Name", product.product_name);
    writeS("Section", product.product_section); // will hide "null"
    // writeI("Category ID", product.category_id);
    writeS("Description", description);

    // Price line (always shows base price; VAT/currency added only if present)
    final priceParts = StringBuffer()..write(product.product_price);
    if (product.vat != null) priceParts.write(" (VAT ${product.vat}%)");
    if (currency.isNotEmpty) priceParts.write(" $currency");
    buffer.writeln("• Price: ${priceParts.toString()}");

    writeN("After Discount", product.price_after_discount, unit: currency);
    writeS("Code", product.product_code);
    // writeS("Slug", product.slug);
    // writeI("Has Option", product.has_option);
    // writeS("In Cart (join)", product.join);
    // writeS("Quantity", product.quantity);
    writeS("Main Image", product.main_image);
    // writeI("Liked", product.is_liked);
    // writeI("Ordered Before", product.is_ordered_before);
    // writeI("Opening Qty", product.opening_qty);
    // writeI("Qty Left", product.product_qty_left);
    writeN("Weight", product.product_weight, unit: 'g');

    if (product.product_kerat != null) buffer.writeln("• Karat: ${product.product_kerat}K");

    // writeI("Boolean % Discount", product.boolean_percent_discount);
    writeI("Sales Discount", product.sales_discount);
    writeI("Free Shipping", product.free_shipping);
    // writeI("Flat Rate", product.flat_rate);
    // writeI("Multi Shipping", product.multi_shipping);
    writeN("Shipping Cost", product.shipping_cost, unit: currency);
    // writeI("Rating", product.rate);
    writeI("Reviews", product.reviews_count);
    // writeI("Orders", product.orders_count);
    // writeI("Cart Button", product.cart_btn);
    // writeI("Out of Stock", product.outOfStock);
    // writeI("Express Delivery", product.express_delivery);
    // writeI("In Cart", product.in_cart);
    // writeB("Loading", product.loading);

    // writeS("Cart ID", product.cart_id); // hides "null"
    // writeS("Removing", product.removing);
    // writeS("City ID", product.cityId); // hides "null"
    // writeS("City Name", product.cityName);
    // writeS("Options", product.options); // hides "null"
    // writeS("Variation Found", product.variationfound); // hides "null"
    // writeS("Variant ID", product.variant_id); // hides "null"
    writeS("Model", product.model);

    // Product Type (print only if something exists)
    final typeName = cleanStr(product.productTypeName);
    final typeId = product.productTypeId;
    if (typeName != null || typeId != null) {
      buffer.writeln("• Product Type: ${[if (typeName != null) typeName, if (typeId != null) "(ID: $typeId)"].join(' ')}");
    }

    writeI("Flash ID", product.r_flash_id);

    if (variationsCount > 0) buffer.writeln("• Variations Count: $variationsCount");
    if (fieldsCount > 0) buffer.writeln("• Custom Fields Count: $fieldsCount");

    // Store
    writeS("Store", product.store.name);
    writeS("Store WhatsApp", product.store.storeWhatsappNumber);
    writeS("Store Image", product.store.image);
    writeI("Store ID", product.store.id);

    buffer.writeln("🔗 *Product Link:* $productUrl");

    // --- Send (WhatsApp encoding) --------------------------------------------
    makeWhatsappContact(
      phoneNumber ?? '+96171069164',
      text: buffer.toString(),
    );
  }

  static Future<void> onTapWhatsappSupport(Product product) async {
    var unescape = HtmlUnescape();
    String description = unescape.convert(product.description ?? '');

    // Replace with your support number
    String supportNumber = '+96176600252';

    String productUrl = "https://${conVersion}product/${product.product_id}";
    String imageUrl = product.main_image.toString().replaceAll(" ", "%20");

    String message = '''
I want to ask about this product: ${product.product_name}

$description

$productUrl

Image: $imageUrl
''';

    String whatsappUrl = "https://wa.me/$supportNumber?text=${Uri.encodeComponent(message)}";

    try {
      await launchUrl(Uri.parse(whatsappUrl), mode: LaunchMode.externalApplication);
    } catch (e) {
      print("Failed to open WhatsApp: $e");
    }
  }

  static launchWhatsApp(String phoneNumber, String storeName) async {
    final link = WhatsAppUnilink(
      phoneNumber: phoneNumber,
      text: "Hey! I'm a user of $storeName",
    );
    await launch('$link');
  }

  Future<void> uploadImageInBackground(Map<String, dynamic> args) async {
    String filePath = args["file_path"];
    if (filePath.isNotEmpty) {
      File file = File(filePath);
      if (!await file.exists()) {
        return;
      }

      try {
        fn.Uint8List fileBytes = await file.readAsBytes();

        dio.FormData data = dio.FormData.fromMap({
          "file": dio.MultipartFile.fromBytes(
            fileBytes,
            filename: args["file_name"],
          ),
          "file_name": args["file_name"],
          "token": args["token"],
          "table_name": args["table_name"].toString(),
          "row_id": args["product_id"].toString(),
          "type": args["type"].toString(),
        });

        dio.Dio dio2 = dio.Dio();

        var response = await dio2.post(
          "${con!}side/upload-images",
          data: data,
          options: dio.Options(
            headers: {
              'Accept': "application/json",
              'Authorization': 'Bearer ${args["token"]}',
            },
          ),
        );

        if (response.statusCode == 200) {
          var responseData = response.data;
          if (responseData['succeeded'] == true) {
            print("✅ Image uploaded successfully: ${args["file_name"]}");
          } else {
            print('❌ Error: ${responseData["message"]}');
          }
        } else {
          print('❌ Failed with status code: ${response.statusCode}');
        }
      } catch (e) {
        print('❌ Error while uploading: $e');
      }
    }
  }

  static Widget backArrowIcon({Color iconColor = Colors.grey, String fromKey = "", void Function()? onTap}) {
    return InkWell(
      onTap: onTap ??
          () {
            Get.back();
          },
      child: Padding(
        padding: getPadding(left: 8),
        child: SizedBox(
          height: getSize(
            25,
          ),
          width: getSize(
            25,
          ),
          child: Icon(
            Icons.arrow_back_ios,
            color: iconColor,
            size: getSize(25),
          ),
        ),
      ),
    );
  }

  static String convertTo12HourFormat(String time24) {
    try {
      // Validate input format (HH:mm)
      final timeParts = time24.split(':');
      if (timeParts.length != 2) {
        throw FormatException('Invalid time format');
      }

      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);

      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
        throw FormatException('Invalid time range');
      }

      // Convert to 12-hour format
      final period = hour >= 12 ? 'PM' : 'AM';
      if (hour > 12) hour -= 12;
      if (hour == 0) hour = 12;

      return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      print('Error in convertTo12HourFormat: $e');
      return 'Invalid Time';
    }
  }

  static Widget circularIndicator({
    double height = 20,
    double width = 20,
    double strokeWidth = 3,
    double size = 20,
    Color color = ColorConstant.white,
  }) {
    return Center(
        child: SizedBox(
            height: height,
            width: width,
            child: LoadingAnimationWidget.inkDrop(
              color: color,
              size: size,
            )));
  }

  static Widget circularIndicatorDefault({
    double height = 20,
    double width = 20,
    double strokeWidth = 3,
    Color color = ColorConstant.white,
  }) {
    return Center(
        child: SizedBox(
            height: height,
            width: width,
            child: CircularProgressIndicator(
              color: color,
              strokeWidth: strokeWidth,
            )));
  }

// static Widget circularIndicatorRive({
  //   String riveFileName = 'assets/images/loader.riv',
  //   String animationName = 'Animation',
  //   BoxFit fit = BoxFit.contain,
  //   Alignment alignment = Alignment.center,
  //   double height = 100,
  //   double width = 100,
  // }) {
  //   return Center(
  //     child: SizedBox(
  //       height: height,
  //       width: width,
  //       child: RiveAnimation.asset(
  //         riveFileName,
  //         animations: [animationName],
  //         alignment: alignment,
  //         fit: fit,
  //       ),
  //     ),
  //   );
  // }
}
