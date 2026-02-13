import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'package:iq_mall/widgets/ui.dart';
import 'package:iq_mall/routes/app_routes.dart';
import 'cores/assets.dart';
import 'main.dart';
import 'package:dio/dio.dart' as dio;

class API extends GetxService {
  // Flag to prevent multiple logout dialogs
  static bool _isHandlingUnauthorized = false;

  /// Handle 401 Unauthorized response - redirect to login
  Future<void> _handleUnauthorized() async {
    // Prevent multiple simultaneous logout operations
    if (_isHandlingUnauthorized) return;
    _isHandlingUnauthorized = true;

    try {
      // Clear user session
      await prefs?.remove('token');
      await prefs?.remove('user_id');
      await prefs?.remove('user');

      // Show message to user
      Ui.flutterToast(
        'Session expired. Please login again.'.tr,
        Toast.LENGTH_LONG,
        MainColor,
        whiteA700,
      );

      // Navigate to login screen and clear all routes
      Get.offAllNamed(AppRoutes.SignIn);
    } finally {
      // Reset flag after a delay to prevent rapid re-triggers
      Future.delayed(const Duration(seconds: 2), () {
        _isHandlingUnauthorized = false;
      });
    }
  }

  Future<Map<String, dynamic>> getDataaa(Map<String, dynamic> param, String url,
      [bool isMaster = false]) async {
    Map<String, dynamic> resultData = <String, dynamic>{};

    //param.addAll(isWeb);

    String? path = con!;

    if (isMaster) {
      path = conVersion;
    }

    try {
      final dio2 = Dio();

      final response = await dio2.post('$path$url',
          data: dio.FormData.fromMap(param),
          cancelToken: globalController.cancelToken.value,
          options: Options(
            responseType: ResponseType.json,
            headers: {
              'Authorization': 'Bearer ${prefs?.getString("token") ?? ""}',
            },
          ));

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
      } else {}
    } on DioException catch (error) {
      // Handle 401 Unauthorized
      if (error.response?.statusCode == 401) {
        await _handleUnauthorized();
        return resultData;
      }
      // print('Error occurred: $error');
    } catch (error) {
      // print('Error occurred: $error');
    }

    return resultData;
  }

  Future<Map<String, dynamic>> getData(Map<String, dynamic> param, String url,
      [bool isMaster = false]) async {
    Map<String, dynamic> resultData = <String, dynamic>{};

    //param.addAll(isWeb);
    String? path = con!;

    if (isMaster) {
      path = conVersion;
    }

    try {
      final dio2 = Dio();
      print('🌐 API Request: $path$url');

      final response = await dio2.post('$path$url',
          data: dio.FormData.fromMap(param),
          cancelToken: globalController.cancelToken.value,
          options: Options(
            responseType: ResponseType.json,
            headers: {
              'Authorization': 'Bearer ${prefs?.getString("token") ?? ""}',
            },
          ));

      print('✅ API Response [$url]: Status ${response.statusCode}');

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
            Ui.flutterToast(
                translatedText, Toast.LENGTH_LONG, MainColor, whiteA700);
          }
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
      } else {
        print('⚠️ API Non-200 Response [$url]: Status ${response.statusCode}');
      }
    } on DioException catch (error) {
      print('❌ DioException [$url]: Status ${error.response?.statusCode}');
      print('❌ DioException Message: ${error.message}');
      print('❌ DioException Response: ${error.response?.data}');

      // Handle 401 Unauthorized
      if (error.response?.statusCode == 401) {
        print('🔒 401 Unauthorized detected! Redirecting to login...');
        await _handleUnauthorized();
        return resultData;
      }
      // Ui.flutterToast('Error occurred', Toast.LENGTH_LONG, MainColor, whiteA700);
    } catch (error) {
      print('❌ General Error [$url]: $error');
      // Ui.flutterToast('Error occurred', Toast.LENGTH_LONG, MainColor, whiteA700);
    }

    return resultData;
  }

  Future<Map<String, dynamic>> getDataGet(
      Map<String, dynamic> param, String url,
      [bool isMaster = false]) async {
    Map<String, dynamic> resultData = <String, dynamic>{};

    String? path = con!;

    if (isMaster) {
      path = conVersion;
    }

    try {
      final dio2 = Dio();
      print('🌐 API Request [GET]: $path$url');
      print('🌐 API Params: $param');

      final response = await dio2.get('$path$url',
          queryParameters: param,
          cancelToken: globalController.cancelToken.value,
          options: Options(
            responseType: ResponseType.json,
            headers: {
              'Authorization': 'Bearer ${prefs?.getString("token") ?? ""}',
            },
          ));

      print('✅ API Response [GET][$url]: Status ${response.statusCode}');

      if (response.statusCode == 200) {
        try {
          resultData = response.data as Map<String, dynamic>;
        } catch (e) {
          print(e);
        }
      } else {
        print(
            '⚠️ API Non-200 Response [GET][$url]: Status ${response.statusCode}');
      }
    } on DioException catch (error) {
      print('❌ DioException [GET][$url]: Status ${error.response?.statusCode}');
      print('❌ DioException Message: ${error.message}');
      print('❌ DioException Response: ${error.response?.data}');

      if (error.response?.statusCode == 401) {
        print('🔒 401 Unauthorized detected! Redirecting to login...');
        await _handleUnauthorized();
        return resultData;
      }
    } catch (error) {
      print('❌ General Error [GET][$url]: $error');
    }

    return resultData;
  }
}
