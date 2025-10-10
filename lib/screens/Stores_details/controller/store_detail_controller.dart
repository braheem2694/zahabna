import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/multipart/form_data.dart';
import 'package:get/get_rx/get_rx.dart';
import '../../../cores/assets.dart';
import '../../../main.dart';
import '../../../models/HomeData.dart';
import '../../../models/HomeData.dart' as cat;
import '../../../models/Stores.dart';
import '../../../utils/ShColors.dart';
import '../../../widgets/ShWidget.dart';
import '../../../widgets/ui.dart';
import '../../OrderSummaryScreen/widgets/PaymentMethodsWidets/PaymentMethodsWidget.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/material/scaffold.dart';
import 'package:flutter/src/widgets/scroll_controller.dart';
import 'package:flutter/src/animation/curves.dart';
import 'package:flutter/src/material/colors.dart';

import '../../tabs_screen/models/SocialMedia.dart';
import '../models/MainSlider.dart';
import 'package:flutter/src/widgets/editable_text.dart';
import 'package:dio/dio.dart' as dio;

class StoreDetailController extends GetxController {
  RxBool loading = true.obs;
  RxBool savingWorkingTime = false.obs;
  RxBool savingImage = false.obs;
  RxDouble imageUploadPercent = 0.0.obs;

  RxBool loadMore = false.obs;
  RxBool isScroll = false.obs;
  RxInt offset = 0.obs;
  RxInt page = 1.obs;
  RxString count = "0".obs;
  RxList<Product> products= <Product>[].obs;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int previousNbOfImages = 0;
  int nbOfImages = 0;
  int countImages = 0;
  ScrollController scrollController =  ScrollController();
  late RxList<MainSlider> storeImages = <MainSlider>[].obs;
   Rx<StoreClass> store = StoreClass().obs;
  Rx<int> sliderIndex = 0.obs;
  String? workingTime;
  RxInt sectionIndex = 0.obs;
  RxBool isExpanded = true.obs;
  Map args = {};
  String tempStoreImage = '';
  RxList<cat.Category> categories = <cat.Category>[].obs;
  final myValue = ValueNotifier<bool>(false); // Initial value is false
  late RxList<SocialMedia> socialMedia = <SocialMedia>[].obs;

  late final Function(String newOpenTime, String newCloseTime) onSave;

  RxBool isOwner = false.obs;
  RxBool isEdit = false.obs;

  @override
  void onInit() {
    args = Get.arguments;
    store.value=args["store"];
    socialMedia.addAll(store.value.socials!);
    categories.addAll(store.value.categories!.where((element) => element.parent==null && element.hasProduct));
    StoreClass? temp;
    try{
     if(store.value.ownerId.toString()==  prefs!.getString("user_id")){
       isOwner.value=true;

     }

    }catch(e){
      isOwner.value=false;
    }
    storeImages.addAll(args["store"].images);

    Future.delayed(Duration(milliseconds: 600)).then((value) {
      loading.value=false;

    });
    tempStoreImage = store.value.main_image ?? '';

    // getCategoriesFromApi();

    super.onInit();
  }
  void toggleExpand(bool newValue) {
    isExpanded.value=newValue;
  }
  // getCategoriesFromApi() async {
  //   loading.value = true;
  //   Map<String, dynamic> response = await api.getData({
  //     'storeId': store.value.id,
  //     'get_children': 'true',
  //   }, "products/get-categories");
  //
  //   if (response.isNotEmpty) {
  //     if (response['succeeded'] is bool && response['succeeded'] == true) {
  //       categories =List<cat.Category>.from(response["categories"].map((x) => cat.Category.fromJson(x))).obs;
  //       loading.value = false;
  //       return categories;
  //     } else {
  //       loading.value = false;
  //       print('Expected a List but got something else');
  //       return false;
  //     }
  //   } else {
  //     loading.value = false;
  //   }
  // }
  saveWorkingTime() async {
    savingWorkingTime.value = true;

    print({
      'store_id': store.value.id,
      'token': prefs?.getString('token'),
      "data": workingTime,
    });
    Map<String, dynamic> response = await api.getData({
      'store_id': store.value.id,
      'token': prefs?.getString('token'),
      "data": workingTime,
    }, "stores/save-store-working-days");

    if (response.isNotEmpty) {
      if (response['categories'] is List) {
        categories =List<cat.Category>.from(response["categories"].map((x) => cat.Category.fromJson(x))).obs;
        savingWorkingTime.value = false;
        return categories;
      } else {
        savingWorkingTime.value = false;
        print('Expected a List but got something else');
        return false;
      }
    } else {
      savingWorkingTime.value = false;
    }
  }
  uploadImage(table_name, row_id, file_name, String? image, int type) async {
    if (image != null) {
      dio.FormData data = dio.FormData.fromMap({
        "file": await dio.MultipartFile.fromFile(
          image,
          filename: file_name.toString(),
        ).catchError((e) {}),
        "file_name": file_name,
        "token": prefs!.getString('token') ?? "",
        "table_name": table_name.toString(),
        "row_id": row_id.toString(),
        "type": type.toString()
      });

      dio.Dio dio2 = dio.Dio();

      try {
        var response = await dio2.post(
          "${con!}side/upload-images",
          data: data,
          options: dio.Options(
            headers: {
              'Accept': "application/json",
              'Authorization': 'Bearer ${prefs!.getString("token") ?? ""}',
            },
          ),
          onSendProgress: (count, total) {
              imageUploadPercent.value = count / total;
              if (imageUploadPercent.value == 1.0) {
              }
          },
        );

        if (response.statusCode == 200) {
          var responseData = response.data;

          if (responseData['succeeded'] == true) {
            var results = responseData['results'];
          } else {
            var errorMessage = responseData['message'];
            print('Error: $errorMessage');
          }
        } else {
          print('Failed with status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error while uploading: $e');
      }
    }
  }



}
