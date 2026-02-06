import 'dart:math';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/main.dart';
import 'package:iq_mall/models/Stores.dart';
import 'package:iq_mall/routes/app_routes.dart';
import 'package:iq_mall/screens/categories_screen/controller/categories_controller.dart';
import 'package:iq_mall/screens/tabs_screen/controller/tabs_controller.dart';
import 'dart:convert';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'package:http/http.dart' as http;
import 'package:iq_mall/cores/assets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:iq_mall/screens/HomeScreenPage/ShHomeScreen.dart';
import 'package:country_picker/country_picker.dart';

import '../../../utils/ShColors.dart';
import '../../../utils/device_data.dart';
import '../../../widgets/ui.dart';
import '../../Cart_List_screen/controller/Cart_List_controller.dart';
import '../../Home_screen_fragment/controller/Home_screen_fragment_controller.dart';
import '../../SignUp_screen/controller/SignUp_controller.dart';
import '../../Wishlist_screen/controller/Wishlist_controller.dart';
import "package:iq_mall/cores/language_model.dart";

import 'package:country_picker/src/country_parser.dart';
import 'package:country_picker/src/utils.dart';
import 'package:flutter/material.dart';

RxString country_code = '+961'.obs;

class SignInController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  String? client_token;
  var emailcontroller = TextEditingController();
  var passwordcontroller = TextEditingController();
  RxBool loggin_in = false.obs;
  RxBool thirdPartyLogin = false.obs;
  RxBool signing = false.obs;
  final formKey = GlobalKey<FormState>();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  List<String?> info = [];
  RxBool obscureText = true.obs;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  bool isUserSignedIn = false;
  GoogleSignInAccount? _currentUser;
  Map userObj = {};
  bool isIOS = false;
  var height = MediaQuery.of(Get.context!).size.height;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  Rx<Language> selectedLanguage = Language().obs;
  RxList<Language> appLanguages = <Language>[].obs;
  Language? temp;
  Locale locale = Get.put(Locale('en'));

  checkLogin() async {
    await Future.delayed(Duration(seconds: 1));
  }

  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LoadingDrawer.value = true;
    });

    prefs?.setString('seen', "true");
    // Firebase is already initialized in main.dart, no need to initialize again
    _googleSignIn.disconnect();
    FirebaseAuth.instance;
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      _currentUser = account;
      if (_currentUser != null) {}
    });
    _googleSignIn.signInSilently();
    checkLogin();

    super.onInit();
  }

  @override
  void onReady() {
    try {
      if (kDebugMode) {
        print(locale.languageCode);
      }

      temp = languages.firstWhere(
          (element) =>
              element.shortcut ==
              (prefs?.getString("locale") ?? locale.languageCode),
          orElse: () => languages[0]);
      selectedLanguage.value = temp ?? languages[0];

      for (int i = 0; i < languages.length; i++) {
        Language? temp2;
        try {
          temp2 = languages.firstWhere(
            (element) => element.shortcut == languages[i].shortcut,
          );
        } catch (_) {}
        if (temp2 != null) {
          appLanguages.add(temp2);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    super.onReady();
  }

  Future<Map<String, dynamic>> userToMap(User user) async {
    List<String> names = user.displayName?.split(' ') ?? [''];
    String firstName = names[0];
    String lastName = names.length > 1 ? names.sublist(1).join(' ') : '';
    String? idToken = await user.getIdToken();

    return {
      'federatedId': user.providerData[0].providerId == 'google.com'
          ? 'http://google.com/${user.uid}'
          : 'http://facebook.com/${user.uid}', // Adjust based on the provider
      'providerId': user.providerData[0].providerId,
      'emailVerified': user.emailVerified,
      'email': user.email,
      'firstName': firstName,
      'fullName': user.displayName,
      'lastName': lastName,
      'photoUrl': user.photoURL,
      'localId': user.uid,
      'displayName': user.displayName,
      'idToken': idToken,
      // Add other fields...
    };
  }

  var Finalidtoken;

  _handleSignIn() async {
    User? user;
    bool isSignedIn = await _googleSignIn.isSignedIn();
    if (isSignedIn) {
      user = auth.currentUser;
    } else {
      try {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        final GoogleSignInAuthentication googleAuth =
            await googleUser!.authentication;
        Finalidtoken = googleAuth.idToken;
        signing.value = true;
        final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
        signing.value = true;
        user = (await auth.signInWithCredential(credential)).user;
      } catch (e) {
        print(e);
      }
    }
    // _idtoken=googleUser?._idToken;

    return user!;
  }

  onGoogleSignIn(BuildContext context) async {
    try {
      loggin_in.value = true;
      thirdPartyLogin.value = true;
      User user = await _handleSignIn();
      var displayName = user.displayName;
      var name = displayName!.split(" ");
      var last = " ";
      for (int i = 0; i < name.length; i++) if (i != 0) last += name[i] + " ";

      socialmedialogin('google', user, "");
    } catch (e) {
      loggin_in.value = false;
      thirdPartyLogin.value = false;
    }
    // ThirdPartyLogin(context, user.email, name[0], last, 'google', user.uid, user, idToken);
  }

  Map<String, dynamic> transformFacebookResponse(Map<String, dynamic> resp) {
    List<String> names = resp['name'].split(' ');
    String firstName = names[0];
    String lastName = names.length > 1 ? names.sublist(1).join(' ') : '';

    return {
      'fullName': resp['name'],
      'firstName': firstName,
      'lastName': lastName,
      'idToken': resp['idToken'],
      // Add other transformations as needed
    };
  }

  Future<bool?> socialmedialogin(type, resp, Facebooktoken) async {
    bool success = false;
    loggin_in.value = true;
    try {
      await firebaseMessaging.getToken().then((String? token1) async {
        client_token = token1;
        prefs?.setString("token", client_token!);
        prefs?.setString("login_type", type.toString());
      }).catchError((e) {
        debugPrint("Error getting token: $e");
        prefs?.setString("token", "");
        prefs?.setString("login_type", type.toString());
      });
    } catch (e) {
      debugPrint("Error getting token: $e");
      prefs?.setString("token", "");
    }

    var data = json.encode(await getDeviceInfo());

    String jsonString = '';
    if (type == 'google') {
      Map<String, dynamic> userMap = await userToMap(resp!);
      jsonString = jsonEncode(userMap).toString();
    } else if (type != "apple") {
      Finalidtoken = Facebooktoken;
      resp['idToken'] = Finalidtoken;
    } else {
      Finalidtoken = resp;
    }

    Map<String, dynamic> pram = {
      'response': type == 'google'
          ? jsonString.toString()
          : type != 'apple'
              ? jsonEncode(transformFacebookResponse(resp))
              : "",
      'device_data': data.toString(),
      'idToken': Finalidtoken.toString(),
      if (type == "apple") 'apple_identifier': Finalidtoken,
      'type': type,
      'token': prefs!.getString("token") ?? "",
    };
    var response = await api.getData(pram, "users/login-third-party");
    if (response != null && response['token'] != null) {
      prefs?.setString("token", response['token'].toString());
    }

    if (response.isNotEmpty) {
      success = response["succeeded"];
      List? allStores = response["stores"];
      globalController.stores.clear();

      if (allStores != null) {
        globalController.stores.addAll(
            allStores.map((store) => StoreClass.userFromJson(store)).toList());
      }
      if (success) {
        prefs?.setInt('selectedaddress', 0);
        var info = response['user'];
        prefs?.setString("first_name", info['first_name'].toString());
        prefs?.setString("Profile_image", info['image'].toString());
        prefs?.setString("user_email", info['email'].toString());
        prefs?.setString("gender", info['gender'].toString());
        prefs?.setString("last_name", info['last_name'].toString());
        prefs?.setString(
            "user_name", "${info['first_name']}_${info['last_name']}");
        prefs?.setString("country_code", info['country_code'].toString());
        prefs?.setString("user_id", info['id'].toString());
        prefs?.setString("user_role", info['user_role'].toString());
        prefs?.setString("phone_number", info['phone_number_one'].toString());
        prefs?.setString(
            "login_method", info['registration_type_id'].toString());
        prefs?.setString('logged_in', 'true');

        signing.value = false;
        loggin_in.value = false;

        Get.offAllNamed(AppRoutes.tabsRoute);

        // WidgetsBinding.instance.addPostFrameCallback((_) {
        //   Get.off(ShHomeScreen(), routeName: '/ShHomeScreen');
        // });
        if (success) {
          prefs?.setString('logged_in', 'true');
        } else {
          prefs?.setString('logged_in', 'false');
        }
        return success;
      } else {
        signing.value = false;
        loggin_in.value = false;
        toaster(Get.context!, response['message']);
        prefs?.setString('logged_in', 'false');
        ;
      }
    } else {
      signing.value = false;
      loggin_in.value = false;
      prefs?.setString('logged_in', 'false');
      Ui.flutterToast(
          'Incorrect credentials'.tr, Toast.LENGTH_LONG, MainColor, whiteA700);

      // toaster(Get.context!, 'Incorrect credentials');
    }
  }

  Future<bool?> Login() async {
    bool success = false;
    loggin_in.value = true;
    try {
      await firebaseMessaging.getToken().then((String? token1) async {
        client_token = token1;
        prefs?.setString("token", client_token!);
      }).catchError((e) {
        debugPrint("Error getting token: $e");
        prefs?.setString("token", "");
      });
    } catch (e) {
      debugPrint("Error getting token: $e");
      prefs?.setString("token", "");
    }
    prefs?.setString("login_type", 'normal'.toString());

    var data = json.encode(await getDeviceInfo());
    Map<String, String> param = {
      'countryCode': country_code.value.replaceAll('+', '').toString(),
      'number': emailcontroller.text.toString(),
      'password': passwordcontroller.text.toString(),
      'recaptcha': "",
      'device_data': data,
      'token': prefs!.getString("token") ?? "",
    };
    Map<String, dynamic> response = await api.getData(param, "users/sign-in");
    if (response != null && response['token'] != null) {
      prefs?.setString("token", response['token'].toString());
    }

    try {
      if (response.isNotEmpty) {
        success = response["succeeded"];
        if (success) {
          List? allStores = response["stores"];
          globalController.stores.clear();

          if (allStores != null) {
            globalController.stores.addAll(allStores
                .map((store) => StoreClass.userFromJson(store))
                .toList());
          }

          var info = response['user'];
          prefs?.setString("first_name", info['first_name'].toString());
          prefs?.setString("Profile_image", info['image'].toString());
          prefs?.setString("user_email", info['email'].toString());
          prefs?.setString("gender", info['gender'].toString());
          prefs?.setString("last_name", info['last_name'].toString());
          prefs?.setString(
              "user_name", "${info['first_name']}_${info['last_name']}");
          prefs?.setString("country_code", info['country_code'].toString());
          prefs?.setString("user_id", info['id'].toString());
          prefs?.setString("user_role", info['user_role'].toString());
          prefs?.setString("phone_number", info['phone_number_one'].toString());
          prefs?.setString(
              "login_method", info['registration_type_id'].toString());
          prefs?.setString('logged_in', 'true');

          signing.value = false;
          loggin_in.value = false;

          LoadingDrawer.value = true;
          Future.delayed(Duration(milliseconds: 300)).then((value) {
            LoadingDrawer.value = false;
          });
          // if (Get.isRegistered<TabsController>()) {
          //   Get.delete<TabsController>();
          //
          // }
          Get.offAllNamed(AppRoutes.tabsRoute);

          // Get.offNamed(AppRoutes.tabsRoute);

          // WidgetsBinding.instance.addPostFrameCallback((_) {
          //   Get.off(ShHomeScreen(), routeName: '/ShHomeScreen');
          // });
          if (success) {
            prefs?.setString('logged_in', 'true');
          } else {
            prefs?.setString('logged_in', 'false');
          }
          signing.value = false;
          loggin_in.value = false;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            LoadingDrawer.value = false;
          });

          return success;
        } else {
          signing.value = false;
          loggin_in.value = false;
          Ui.flutterToast(response["message"].toString().tr, Toast.LENGTH_LONG,
              ColorConstant.logoFirstColor, whiteA700);

          prefs?.setString('logged_in', 'false');
        }
      } else {
        signing.value = false;
        loggin_in.value = false;
        prefs?.setString('logged_in', 'false');
        // Ui.flutterToast( 'Error occurred'.tr, Toast.LENGTH_LONG, ColorConstant.logoFirstColor, whiteA700);
      }
    } catch (e) {
      signing.value = false;
      loggin_in.value = false;
    }
  }

  Future<int?> applelogin(BuildContext context, email, first_name, last_name,
      type, password, apple_id) async {
    if (kIsWeb) {
      client_token = generateToken();
      prefs?.setString("token", client_token!);
    } else {
      try {
        await firebaseMessaging.getToken().then((String? token1) async {
          client_token = token1;
          prefs?.setString("token", client_token!);
        }).catchError((e) {
          debugPrint("Error getting token: $e");
          prefs?.setString("token", "");
        });
      } catch (e) {
        debugPrint("Error getting token: $e");
        prefs?.setString("token", "");
      }
    }
    signing.value = true;
    var url = "${con!}users/apple-login";
    final http.Response response = await http.post(
      Uri.parse(url),
      body: {
        'type': type.toString(),
        'email': email.toString(),
        'first_name': first_name.toString(),
        'last_name': last_name.toString(),
        'password': password.toString(),
        'token': prefs?.getString('token'),
        'apple_id': apple_id,
        'web': kIsWeb ? 'true' : 'false',
      },
    );
    if (response.statusCode == 200) {
      prefs?.setInt('selectedaddress', 0);

      var info = json.decode(response.body);

      try {
        prefs?.setString("first_name", info['first_name'].toString());
        prefs?.setString("Profile_image", info['image'].toString());
        prefs?.setString("user_email", info['email'].toString());
        prefs?.setString("gender", info['gender'].toString());
        prefs?.setString("last_name", info['last_name'].toString());
        prefs?.setString(
            "user_name", "${info['first_name']}_${info['last_name']}");
        prefs?.setString("country_code", info['country_code'].toString());
        prefs?.setString("user_id", info['id'].toString());
        prefs?.setString("user_role", info['user_role'].toString());
        prefs?.setString("phone_number", info['phone_number_one'].toString());
        prefs?.setString(
            "login_method", info['registration_type_id'].toString());
        prefs?.setString('logged_in', 'true');

        signing.value = true;
        await switchtoaccount();
      } catch (e) {
        print(e);
      }
      Get.offNamed(AppRoutes.tabsRoute);

      // Get.offNamed(ShHomeScreen(), routeName: '/ShHomeScreen');
    } else {
      toaster(context, "Connection error");
    }
  }
}

CodePicker(BuildContext context, {RxString? countryCode}) {
  return GestureDetector(
    onTap: () {
      showCountryPicker(
        context: context,
        exclude: <String>['KN', 'MF'],
        favorite: <String>['SE'],
        showPhoneCode: true,
        onSelect: (Country country) {
          if (countryCode != null) {
            countryCode.value = '+${country.phoneCode}';
            globalController.countryName.value = country.name;
            globalController.updateFlag(country.flagEmoji);
            print(country.flagEmoji);
          } else {
            country_code.value = '+${country.phoneCode}';
            globalController.updateFlag(country.flagEmoji);
          }
        },
        countryListTheme: CountryListThemeData(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
          ),
          inputDecoration: InputDecoration(
            labelText: 'Search',
            hintText: 'Start typing to search',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: const Color(0xFF8C98A8).withOpacity(0.2),
              ),
            ),
          ),
        ),
      );
    },
    child: Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4),
      child: Container(
        width: getHorizontalSize(90),
        height: 50,
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 2.0, right: 2),
                child: Obx(() => country_code.toString() == 'null'
                    ? const Text('')
                    : Text(
                        country_code.toString(),
                        overflow: TextOverflow.ellipsis,
                      )),
              ),
            ),
            Obx(() {
              return Text(globalController.countryFlag.value);
            }),
            const Icon(Icons.keyboard_arrow_down_sharp, size: 18),
          ],
        ),
      ),
    ),
  );
}

Future<void> switchtoaccount() async {
  var url = con! + "product/switch-to-account";
  final http.Response response = await http.post(
    Uri.parse(url),
    body: {
      'user_id': prefs?.getString('user_id'),
      'platform_id': deviceId.toString(),
    },
  );
}

String generateToken() {
  const chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random rnd = Random();

  return String.fromCharCodes(Iterable.generate(
      32, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
}
