import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../cores/language_model.dart';
import '../../main.dart';
import '../../utils/ShColors.dart';
import '../../utils/ShImages.dart';
import '../../widgets/CommonWidget.dart';
import '../Home_screen_fragment/Home_screen_fragment.dart';
class LanguageListWidget extends StatefulWidget {
  @override
  _LanguageListWidgetState createState() => _LanguageListWidgetState();
}

class _LanguageListWidgetState extends State<LanguageListWidget> {

  // If you have any stateful variables you can declare them here
  // final LanguageController _languageController = Get.put(LanguageController());
  var selectedLanguage = (languages.isNotEmpty) ? languages[0].obs : Language().obs;

  void changeLanguage(Language newLang) {
    selectedLanguage.value = newLang;
    // Here you can call OnLanguageChanged function to perform any action when language is changed.
    // OnLanguageChanged(newLang.shortcut);
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: ColorConstant.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Languages'.tr),
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Padding(
            padding: EdgeInsets.all(15.0), // You can adjust the padding value
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
        )
        ,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 28.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 18.0, top: 15),
              child: Row(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 14.0),
                      child: SVG(AssetPaths.language, 27, 27, MainColor)
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Languages'.tr,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),


            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 20),
              child: Container(
                height: 40,width: 100,
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(color: Colors.grey, width: 1.0),
                  color: Colors.transparent,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Language>(
                    value: selectedLanguage.value,
                    items: languages.map((Language lang) {
                      return DropdownMenuItem<Language>(
                        value: lang,
                        child: Text(lang.languageName!, style: TextStyle(fontSize: 16.0)),
                      );
                    }).toList(),
                    onChanged: (Language? newLang) {
                      if (newLang != null) {
                        String langCode = newLang.shortcut!;
                        prefs?.setString('language', langCode);
                        Get.updateLocale(Locale(langCode));

                        if (langCode == 'EN') {
                          Intl.defaultLocale = 'en_US';
                        } else {
                          Intl.defaultLocale = langCode.toLowerCase();
                        }
                        selectedLanguage.value = newLang;
                        Get.forceAppUpdate();
                        print("Current Locale: ${Get.locale}");
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
