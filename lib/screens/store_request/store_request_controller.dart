import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../main.dart';
import '../../models/store_request.dart';
import '../../widgets/ui.dart';
import '../../cores/assets.dart';
import '../SignIn_screen/controller/SignIn_controller.dart';

class StoreRequestController extends GetxController {
  // Form fields
  final TextEditingController subscriberNameController = TextEditingController();
  final TextEditingController motherNameController = TextEditingController();
  final TextEditingController storeNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController regionController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController recordNumber = TextEditingController();
  final TextEditingController branchCountController = TextEditingController();
  final TextEditingController birthDay = TextEditingController();
  final TextEditingController subscriptionMonthsController = TextEditingController(text: "3");
  final agreedToTerms = false.obs;
  LatLng markerPosition = const LatLng(33.8886, 35.4955); // Beirut
  GoogleMapController? mapController;
  RxString termsConditions = ''.obs;

  final TextEditingController latController = TextEditingController();
  final TextEditingController lngController = TextEditingController();
  // File uploads
  final idImage = Rxn<String>();
  final id2Image = Rxn<String>();
  final selfieImage = Rxn<String>();
  final storeImage = Rxn<String>();
  final logoImage = Rxn<String>();

  RxBool editing = false.obs;

  // Form key
  final formKey = GlobalKey<FormState>();

  // Amount calculation
  int get totalAmount {
    final int branchCount = int.tryParse(branchCountController.text) ?? 1;
    const int months = 3;
    return branchCount * months * 30;
  }

  StoreRequest? args;
  // Example: $30 per branch per month

  final RxBool isUploading = false.obs;
  final RxBool sendingRequest = false.obs;
  final RxBool deletingRequest = false.obs;
  final RxInt uploadProgress = 0.obs;
  final RxInt totalImages = 0.obs;

  Future<void> updateRequestForm() async {
    if (args == null) return; // only for existing requests

    final token = prefs!.getString("token") ?? "";
    sendingRequest.value = true;

    final Map<String, dynamic> formData = {
      'token': token,
      "id": args?.id,
      'row_id': args!.id, // adjust if your StoreRequest uses another id field
      'name': subscriberNameController.text,
      'mother_name': motherNameController.text,
      'store_name': storeNameController.text,
      'phone_number': "${country_code.value.toString().replaceAll('+', '')}${phoneNumberController.text}",
      'country': globalController.countryName.value,
      'address': addressController.text,
      'region': regionController.text,
      'email': emailController.text,
      'record_no': recordNumber.text,
      'place': regionController.text,
      'birth_date': birthDay.text,
      'latitude': latController.text,
      'longitude': lngController.text,
      'terms_conditions': termsConditions.value != "" ? termsConditions.value : globalController.homeDataList.value.requestTerms,
      'branch_count': branchCountController.text,
      'subscription_count': subscriptionMonthsController.text,
    };

    try {
      // If your backend updates on the same endpoint, you can keep "create-store-request" and include row_id.
      // Otherwise, point to your real update endpoint:
      final response = await api.getData(formData, "stores/update-store-request");

      sendingRequest.value = false;

      if ((response['success'] ?? false) == true) {
        Ui.flutterToast("Changes saved".tr, Toast.LENGTH_LONG, Colors.green, Colors.white);

        // Optionally refresh local args with current edits
        args = StoreRequest(
          id: args!.id,
          subscriberName: subscriberNameController.text,
          motherName: motherNameController.text,
          storeName: storeNameController.text,
          phoneNumber: "${country_code.value.toString().replaceAll('+', '')}${phoneNumberController.text}",
          country: globalController.countryName.value,
          region: regionController.text,
          address: addressController.text,
          birthDay: birthDay.text,
          createdAt: args!.createdAt,
          hasTransaction: args!.hasTransaction,
          endDate: args!.endDate,
          email: args!.email,
          startDate: args!.startDate,
          registerDate: args!.registerDate,
          status: args!.status,
          recordNumber: recordNumber.text != "" ? double.tryParse(recordNumber.text) ?? 0.0 : 0.0,
          branchCount: int.tryParse(branchCountController.text) ?? 1,
          subscriptionMonths: int.tryParse(subscriptionMonthsController.text) ?? 1,
          agreedToTerms: agreedToTerms.value,
          userTermsANdConditions: termsConditions.value != "" ? termsConditions.value : globalController.homeDataList.value.requestTerms ?? '',
          latitude: double.tryParse(latController.text),
          longitude: double.tryParse(lngController.text),
          images: args!.images, // keep existing image list
        );

        // Upload any newly selected images (if any)
        await uploadImageInBackground({
          'row_id': args!.id,
          'table_name': 'stores_request', // use the table name your backend returns/uses
          'token': token,
        });

        editing.value = false; // exit edit mode
      } else {
        Ui.flutterToast(response['message'] ?? "Update failed".tr, Toast.LENGTH_LONG, Colors.red, Colors.white);
      }
    } catch (e) {
      sendingRequest.value = false;
      Ui.flutterToast("Update error".tr, Toast.LENGTH_LONG, Colors.red, Colors.white);
    }
  }

  Future<bool> deleteStoreById(String id) async {
    final String token = prefs!.getString("token") ?? "";
    if (token.isEmpty) {
      return false;
    }

    try {
      deletingRequest.value = true;
      final Map<String, dynamic> response = await api.getData(
        {
          'token': token,
          'id': id,
        },
        "stores/delete-store-request",
      );

      if (response['success'] == true) {
        deletingRequest.value = false;
        args!.status = "Deleted";

        Get.back();
        Get.back(result: args);
        Ui.flutterToast(response["message"].toString().tr, Toast.LENGTH_SHORT, Colors.black45, Colors.white);

        return true;
      } else {
        deletingRequest.value = false;

        Ui.flutterToast(response["message"].toString().tr, Toast.LENGTH_SHORT, Colors.black45, Colors.white);

        return false;
      }
    } catch (e) {
      deletingRequest.value = false;

      return false;
    }
  }
  // ===== Helpers (put inside StoreRequestController) =====

  String? _existingPathForType(int type) {
    if (args == null) return null;
    try {
      return args!.images.firstWhere((img) => img.type == type).filePath;
    } catch (_) {
      return null;
    }
  }

  bool _isRemote(String s) {
    final l = s.toLowerCase();
    return l.startsWith('http://') || l.startsWith('https://');
  }

  String _basename(String s) {
    final q = s.split('?').first; // strip query
    final h = q.split('#').first; // strip fragment
    return h.split('/').last; // last path segment
  }

  /// Return true iff this Rx value should be uploaded for the given type
  bool _shouldUpload(Rxn<String> rx, int type) {
    final v = rx.value;
    if (v == null || v.trim().isEmpty) return false;

    // If the selected value is a remote URL, we assume it's the existing server image
    // (i.e., user didn't change it). Don't upload.
    if (_isRemote(v)) {
      // extra safety: if args image is different remote URL, you can still treat as unchanged,
      // since user didn't pick a local file.
      return false;
    }

    // Local file path selected by user → candidate for upload.
    final existing = _existingPathForType(type);
    if (existing == null || existing.trim().isEmpty) return true;

    // If existing is remote, compare by filename to avoid re-uploading the same file name.
    // (Server may keep same name; adjust if your backend uses unique names)
    final newName = _basename(v).toLowerCase();
    final oldName = _basename(existing).toLowerCase();
    return newName != oldName;
  }

  /// Convenience to count how many uploads are pending
  int _countPendingUploads() {
    int c = 0;
    if (_shouldUpload(idImage, 201)) c++;
    if (_shouldUpload(id2Image, 202)) c++;
    if (_shouldUpload(selfieImage, 205)) c++;
    if (_shouldUpload(storeImage, 203)) c++;
    if (_shouldUpload(logoImage, 206)) c++;
    return c;
  }

  Future<void> uploadImageInBackground(Map<String, dynamic> argsMap) async {
    if (isUploading.value) return;
    sendingRequest.value = false;

    // Compute only the changed/new images
    totalImages.value = _countPendingUploads();
    if (totalImages.value == 0) {
      // nothing to upload
      return;
    }

    isUploading.value = true;
    uploadProgress.value = 0;

    try {
      final String table = argsMap['table_name'].toString();
      final String rowId = argsMap['row_id'].toString();

      // ID front (201)
      if (_shouldUpload(idImage, 201)) {
        final path = idImage.value!;
        await uploadImage(table, rowId, _basename(path), path, 201);
        uploadProgress.value++;
      }

      // ID back (202)
      if (_shouldUpload(id2Image, 202)) {
        final path = id2Image.value!;
        await uploadImage(table, rowId, _basename(path), path, 202);
        uploadProgress.value++;
      }

      // Selfie (205)
      if (_shouldUpload(selfieImage, 205)) {
        final path = selfieImage.value!;
        await uploadImage(table, rowId, _basename(path), path, 205);
        uploadProgress.value++;
      }

      // Store (203)
      if (_shouldUpload(storeImage, 203)) {
        final path = storeImage.value!;
        await uploadImage(table, rowId, _basename(path), path, 203);
        uploadProgress.value++;
      }

      // Logo (206)
      if (_shouldUpload(logoImage, 206)) {
        final path = logoImage.value!;
        await uploadImage(table, rowId, _basename(path), path, 206);
        uploadProgress.value++;
      }

      // Optionally: success toast/snackbar here
    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        'Failed to upload some images. Please try again.'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
        duration: const Duration(seconds: 3),
      );
    } finally {
      isUploading.value = false;
      uploadProgress.value = 0;
      totalImages.value = 0;
    }
  }

  Future<void> uploadImage(String tableName, String rowId, String fileName, String filePath, int type) async {
    final token = prefs!.getString("token") ?? "";

    try {
      dio.FormData data = dio.FormData.fromMap({
        "file": await dio.MultipartFile.fromFile(
          filePath,
          filename: fileName,
        ).catchError((e) {}),
        "file_name": fileName,
        "token": token,
        "table_name": tableName,
        "row_id": rowId,
        "type": type.toString()
      });

      dio.Dio dio2 = dio.Dio();

      var response = await dio2.post(
        "${con}side/upload-images",
        data: data,
        options: dio.Options(
          headers: {
            'Accept': "application/json",
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        var responseData = response.data;
        // if (responseData['succeeded'] != true) {
        //   throw Exception(responseData['message'] ?? 'Upload failed');
        // }
      } else {
        throw Exception('Upload failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
  // Put near your other helpers/fields in StoreRequestController

  bool _hasExistingImageType(int type) {
    if (args == null) return false;
    return args!.images.any((img) => img.type == type && (img.filePath).toString().isNotEmpty);
  }

  void submitRequest() {
    if (isUploading.value) return; // Prevent multiple submissions while uploading

    List<String> validationErrors = [];

    // Check form fields
    if (formKey.currentState?.validate() != true) {
      validationErrors.add('Please fill all required fields'.tr);
    }

    // Check images
    if (idImage.value == null && id2Image.value == null) {
      validationErrors.add('Please upload both ID/Passport images'.tr);
    }

    if (selfieImage.value == null) {
      validationErrors.add('Please upload a selfie image'.tr);
    }

    if (storeImage.value == null) {
      validationErrors.add('Please upload a store image'.tr);
    }

    // Check terms
    if (!agreedToTerms.value) {
      validationErrors.add('Please accept the terms and conditions'.tr);
    }

    // If there are any validation errors, show them in a single snackbar
    if (validationErrors.isNotEmpty) {
      Get.snackbar(
        'Required Fields'.tr,
        validationErrors.join('\n'),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
        duration: Duration(seconds: 5),
      );
      return;
    }

    // Submit the form first, then upload images
    submitRequestForm();
  }

  void fillFromStoreRequest(StoreRequest request) {
    subscriberNameController.text = request.subscriberName;
    motherNameController.text = request.motherName;
    storeNameController.text = request.storeName;
    addressController.text = request.address;
    birthDay.text = request.birthDay ?? '';
    recordNumber.text = request.recordNumber.toString();
    phoneNumberController.text = normalizePhoneNumber(request.phoneNumber);

    countryController.text = request.country;

    regionController.text = request.region;
    branchCountController.text = request.branchCount.toString();
    subscriptionMonthsController.text = request.subscriptionMonths.toString();
    agreedToTerms.value = request.userTermsANdConditions != "" ? true : false;
    termsConditions.value = request.userTermsANdConditions != "" ? request.userTermsANdConditions : globalController.homeDataList.value.requestTerms ?? '';

    if (request.status.toLowerCase() == "deleted") {
      Ui.flutterToast("This request is deleted".tr, Toast.LENGTH_SHORT, Colors.red, Colors.white);
    }

    // Clear all image observables
    idImage.value = null;
    id2Image.value = null;
    selfieImage.value = null;
    storeImage.value = null;
    logoImage.value = null;
    int idCounter = 0;
    latController.text = request.latitude.toString();
    lngController.text = request.longitude.toString();
    markerPosition = LatLng(request.latitude ?? 33.8886, request.longitude ?? 35.4955);
    mapController?.animateCamera(CameraUpdate.newLatLng(markerPosition));

    // Assign images by type
    for (final img in request.images) {
      switch (img.type) {
        case 201: // First ID/Passport image
          idImage.value = img.filePath;
          break;
        case 202:
          if (idCounter == 0) {
            idImage.value = img.filePath;
            idCounter++;
          } else if (idCounter == 1) {
            id2Image.value = img.filePath;
            idCounter++;
          }
          // Second ID/Passport image
          id2Image.value = img.filePath;
          break;
        case 205: // Selfie image
          selfieImage.value = img.filePath;
          break;
        case 203: // Store image
          storeImage.value = img.filePath;
          break;
        case 206: // Logo image
          logoImage.value = img.filePath;
          break;
      }
    }
  }

  Future<void> submitRequestForm() async {
    final token = prefs!.getString("token") ?? "";
    sendingRequest.value = true;
    final Map<String, dynamic> formData = {
      'token': token,
      'name': subscriberNameController.text,
      'mother_name': motherNameController.text,
      'store_name': storeNameController.text,
      'phone_number': "${country_code.value.toString().replaceAll('+', '')}${phoneNumberController.text}",
      'country': globalController.countryName.value,
      'address': addressController.text,
      'region': regionController.text,
      'email': regionController.text,
      'place': regionController.text,
      'latitude': latController.text,
      'longitude': lngController.text,
      'terms_conditions': termsConditions != "" ? termsConditions : globalController.homeDataList.value.requestTerms,
      'branch_count': branchCountController.text,
      'subscription_count': subscriptionMonthsController.text,
    };

    if (formKey.currentState?.validate() != true) {
      Ui.flutterToast("Please fill all required fields".tr, Toast.LENGTH_SHORT, Colors.red, Colors.white);
      return;
    }

    try {
      final response = await api.getData(formData, "stores/create-store-request");
      sendingRequest.value = false;

      if ((response['success'] ?? false) == true) {
        // Upload images after successful form submission
        await uploadImageInBackground({
          'row_id': response['row_id'],
          'table_name': response['table_name'],
          'token': token,
        });

        Ui.flutterToast("Subscription submitted successfully".tr, Toast.LENGTH_LONG, Colors.green, Colors.white);
        Get.back();
      } else {
        Ui.flutterToast(response['message'] ?? "Submission failed".tr, Toast.LENGTH_LONG, Colors.red, Colors.white);
      }
    } catch (e) {
      Ui.flutterToast("Request error".tr, Toast.LENGTH_LONG, Colors.red, Colors.white);
    }
  }

  @override
  void onInit() {
    super.onInit();
    args = Get.arguments;
    if (args != null) {
      fillFromStoreRequest(args!);
    }
  }
}

String normalizePhoneNumber(String rawPhone) {
  // Remove all non-digit characters
  String cleaned = rawPhone.replaceAll(RegExp(r'\D'), '');

  // Remove leading country code if present (up to 4 digits)
  // Assumes local numbers start after the first 8 or 9 digits
  // You can adapt this logic to your format rules
  if (cleaned.startsWith('961')) {
    cleaned = cleaned.substring(3); // Remove "961"
  } else if (cleaned.startsWith('1')) {
    cleaned = cleaned.substring(1); // Remove "1"
  } else if (cleaned.length > 8 && cleaned.length <= 12) {
    cleaned = cleaned.substring(cleaned.length - 8); // Keep last 8 digits
  }

  return cleaned;
}

// Usage:
