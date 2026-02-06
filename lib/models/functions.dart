import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'package:iq_mall/main.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Product_widget/Product_widget.dart';
import '../screens/Home_screen_fragment/controller/Home_screen_fragment_controller.dart';
import '../utils/ShColors.dart';
import 'HomeData.dart';

class function {
  static Future<bool?> setFavorite(Product product, reload,bool isLiked) async {
    if (reload) recheck.value = true;
    bool success = false;
    Map<String, dynamic> response = await api.getData({
      'storeId': globalController.currentStoreId,
      'product_id': product.product_id,
      'token': prefs!.getString("token") ?? "",
      'is_liked': isLiked,
    }, "products/set-favorite");

    if (response.isNotEmpty) {
      success = response["succeeded"];

      // Get.lazyPut(() => WishlistController());
      // var wishlistController = Get.find<WishlistController>();
      // wishlistController.GetFavorite();
      if (success) {
        if (product.is_liked == 0) {
          product.is_liked = 1;
          for (var productSample in globalController.homeDataList.value.products!) {
            if (productSample.product_price == product.product_id) {
              productSample.is_liked = 1;
            }
          }
          for (var productSample in globalController.homeDataList.value.flashProducts!) {
            if (productSample.product_price == product.product_id) {
              productSample.is_liked = 1;
            }
          }
        } else {
          for (var productSample in globalController.homeDataList.value.products!) {
            if (productSample.product_price == product.product_id) {
              productSample.is_liked = 0;
            }
          }
          for (var productSample in globalController.homeDataList.value.flashProducts!) {
            if (productSample.product_price == product.product_id) {
              productSample.is_liked = 0;
            }
          }
          product!.is_liked = 0;
        }
        recheck.value = false;
        return success;
      } else {
        toaster(Get.context!, response["message"]);
      }
    } else {
      toaster(Get.context!, 'Failed');
    }
    return null;
  }

  static List currencyExInfo = [];

  static Future<List<XFile>?> multiImagePicker() async {
    final ImagePicker _picker = ImagePicker();
    List<XFile>? _selectedImages;
    try {
      final List<XFile>? images = await _picker.pickMultiImage();

      if (images != null) {
          _selectedImages = images;
      }
    } catch (e) {
      print("Image picker error: $e");
    }
    return _selectedImages;
  }
  static Future<XFile?> SingleImagePicker(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    XFile? _selectedImage;

    try {
      // On iOS, image_picker handles permission requests automatically
      // Just call pickImage and it will show the system permission dialog
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      
      if (image != null) {
        _selectedImage = image;
      }
    } catch (e) {
      print("Image picker error: $e");
      
      // Check if it's a permission error
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains('permission') || 
          errorStr.contains('denied') || 
          errorStr.contains('authorized')) {
        
        // Check current permission status
        PermissionStatus cameraStatus = await Permission.camera.status;
        PermissionStatus photosStatus = await Permission.photos.status;
        
        final relevantStatus = source == ImageSource.camera ? cameraStatus : photosStatus;
        
        if (relevantStatus.isPermanentlyDenied || relevantStatus.isDenied) {
          // Show dialog to open settings
          final shouldOpenSettings = await Get.dialog<bool>(
            AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Icon(
                    source == ImageSource.camera ? Icons.camera_alt : Icons.photo_library,
                    color: Colors.orange,
                  ),
                  SizedBox(width: 8),
                  Text('Permission Required'.tr),
                ],
              ),
              content: Text(
                source == ImageSource.camera
                    ? 'Camera access is required to take photos. Please enable it in Settings.'.tr
                    : 'Photo library access is required. Please enable it in Settings.'.tr,
                style: TextStyle(fontSize: 15),
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(result: false),
                  child: Text('Cancel'.tr, style: TextStyle(color: Colors.grey)),
                ),
                TextButton(
                  onPressed: () => Get.back(result: true),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.orange.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Open Settings'.tr,
                    style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );

          if (shouldOpenSettings == true) {
            await openAppSettings();
          }
        } else {
          // Permission can still be requested
          toaster(
            Get.context!,
            source == ImageSource.camera
                ? 'Camera permission is required to take photos'.tr
                : 'Photo library permission is required'.tr,
          );
        }
      } else {
        toaster(Get.context!, 'Failed to pick image'.tr);
      }
    }

    return _selectedImage;
  }
  // static Future<MultiImagePickerController?> multiImagePicker(bool mode, int count) async {
  //
  //
  //   final controller = MultiImagePickerController(
  //     maxImages: count,
  //
  //     images: <ImageFile>[], // array of pre/default selected images
  //     picker: (bool allowMultiple) async {
  //       return await pickImagesUsingImagePicker(allowMultiple);
  //     },
  //   );
  //
  //   // Check if the list is not empty and create a File object from the path
  //   return controller;
  // }
  static  Future<List<ImageFile>> pickImagesUsingImagePicker(bool allowMultiple) async {
    final picker = ImagePicker();
    final List<XFile> xFiles;
    if (allowMultiple) {
      xFiles = await picker.pickMultiImage(maxWidth: 1080, maxHeight: 1080);
    } else {
      xFiles = [];
      final xFile = await picker.pickImage(
          source: ImageSource.gallery, maxHeight: 1080, maxWidth: 1080);
      if (xFile != null) {
        xFiles.add(xFile);
      }
    }
    if (xFiles.isNotEmpty) {
      return xFiles.map<ImageFile>((e) => convertXFileToImageFile(e)).toList();
    }
    return [];
  }

  static RemoveFromCart(products) async {
    bool success = false;
    List<Map<String, dynamic>> productsList = [];

    for (var product in products) {
      Map<String, dynamic> productMap = {
        'product_id': int.parse(product.product_id.toString()),
        'variant_id': product.variant_id != 'null' ? int.parse(product.variant_id) : null,
      };
      productsList.add(productMap);
    }
    var data2 = json.encode(productsList);
    print(data2.toString());
    Map<String, dynamic> data = {
      'token': prefs!.getString("token") ?? "",
      'products': data2.toString(),
    };

    final sessionId = prefs!.getString("session_id");
    if (sessionId != null && sessionId.isNotEmpty && prefs!.getString("token") == null) {
      data['session_id'] = sessionId;
    }
    Map<String, dynamic> response = await api.getData(data, "cart/remove-from-cart");

    if (response.isNotEmpty) {
      success = response["succeeded"];
    }
    if (success) {
    } else {}

    return success;
  }
}

class MediaPicker {
  static final ImagePicker _picker = ImagePicker();

  /// Function to pick both images and videos
  static Future<XFile?> pickVideos() async {
     XFile? video;
    try {


      // Pick multiple videos (manually select multiple one by one)
          video = await _picker.pickVideo(source: ImageSource.gallery,);

    } catch (e) {
      print("Media picker error: $e");
    }

    return video;
  }
}
