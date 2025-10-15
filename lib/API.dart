import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'package:iq_mall/widgets/ui.dart';
import 'cores/assets.dart';
import 'main.dart';
import 'package:dio/dio.dart' as dio;

class API extends GetxService {
  Future<Map<String, dynamic>> getDataaa(Map<String, dynamic> param, String url, [bool isMaster = false]) async {
    Map<String, dynamic> resultData = <String, dynamic>{};

    //param.addAll(isWeb);
    
    String? path = con!;

    if (isMaster) {
      path = conVersion;
    }

    try {
      final dio2 = Dio();

      final response = await dio2.post('$path$url', data: dio.FormData.fromMap(param), cancelToken: globalController.cancelToken.value, options: Options(responseType: ResponseType.json));

      if (response.statusCode == 200) {
        try {
          resultData = json.decode(response.data);
        } catch (e) {
          print(e);
        }
        if (kDebugMode) {}

        try {
          if (resultData['logged_out'] != null && resultData['logged_out']) {
            final temp = prefs!.getString('token');
            // globalController.updateUserState(false, url, param: param, token: prefs!.getString('token') ?? 'null');
          }
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
      } else {
        if (kDebugMode) {
          print(response.statusCode);
          print('url is: $url');
        }
      }
    } catch (error) {
      // print('Error occurred: $error');
    }

    return resultData;
  }

  Future<Map<String, dynamic>> getData(Map<String, dynamic> param, String url, [bool isMaster = false]) async {
    Map<String, dynamic> resultData = <String, dynamic>{};

    //param.addAll(isWeb);
    String? path = con!;

    if (isMaster) {
      path = conVersion;
    }

    try {
      final dio2 = Dio();
      print('$path$url');

      final response = await dio2.post('$path$url', data: dio.FormData.fromMap(param), cancelToken: globalController.cancelToken.value, options: Options(responseType: ResponseType.json));

      if (response.statusCode == 200) {
        try {
          resultData = response.data as Map<String, dynamic>;
        } catch (e) {
          print(e);
        }
        if (kDebugMode) {}

        try {
          if (resultData['logged_out'] != null && resultData['logged_out']) {
            final temp = prefs!.getString('token');
            String translatedText = 'user_not_found'.tr;
            Ui.flutterToast(translatedText, Toast.LENGTH_LONG, MainColor, whiteA700);

          }
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
      } else {

      }
    } catch (error) {
      print('Error occurred: $error');
      // Ui.flutterToast('Error occurred', Toast.LENGTH_LONG, MainColor, whiteA700);
    }

    return resultData;
  }


}
