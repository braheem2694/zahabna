import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iq_mall/cores/pref_utils.dart';
import '../main.dart';
import 'language_model.dart';

class AppLocalization extends Translations {
  Map<String, Map<String, String>> _keys = {}; // Ensure it's initialized

  @override
  Map<String, Map<String, String>> get keys => _keys;

  List getLanguages() => _keys.keys.toList();

  Future<void> loadTranslations(Map<String, dynamic> value) async {
    Map<String, Map<String, String>> x = {};
    var pref = Get.put(PrefUtils());
    await pref.init();

    value["languages"].map((x) => Language.fromJson(x)).toList();

    if (!value['is_updated']) {
      (value["list"] as Map<String, dynamic>).forEach((key, val) {
        x[key] = Map.from(val).map((k, v) => MapEntry<String, String>(k, v));
      });

      setLanguages(x);
      setTranslationPref(value["date"]);
    } else {
      x = getLanguagess();
    }


    // ✅ Ensure _keys is updated before returning
    _keys = x;

    // ✅ Debug: Check if translations are loaded
    print("Translations loaded: ${_keys.isNotEmpty}");

    // ✅ Force GetX to refresh translations and UI
    Get.forceAppUpdate();
  }

  /// Ensures that translations are immediately available
  void setLanguages(Map<String, Map<String, String>> translations) {
    _keys = translations;
    Get.forceAppUpdate(); // ✅ Refresh UI with translations
  }
}

Future<bool> setTranslationPref(String? date) async {
  return await prefs!.setString('last_modified', date ?? "");
}

String? getTranslationPref() {
  return prefs?.getString('last_modified');
}

Future<bool?> setLanguages(Map<String, Map<String, String>> date) async {
  return await prefs?.setString('languages', json.encode(date));
}

Map<String, Map<String, String>> getLanguagess() {
  final String? js = prefs?.getString('languages');

  if (js == null) {
    return {};
  }
  Map<String, Map<String, String>> x = {};
  var map = json.decode(js);

  (map as Map<String, dynamic>).forEach((key, val) {
    x[key] = Map.from(val).map((k, v) => MapEntry<String, String>(k, v));
  });
  return x;
}
