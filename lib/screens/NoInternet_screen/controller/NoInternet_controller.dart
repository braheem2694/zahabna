import 'package:get/get.dart';
import 'package:iq_mall/routes/app_routes.dart';
import 'package:iq_mall/screens/tabs_screen/tabs_view_screen.dart';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'dart:async';
import 'package:iq_mall/screens/HomeScreenPage/ShHomeScreen.dart';

class NoInternetController extends GetxController {


  @override
  void onInit() {
    // subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    //   if (result != ConnectivityResult.none) {
        Get.toNamed(AppRoutes.tabsRoute);
    //  }
    //});
    super.onInit();
  }
  bool loading = true;
  var connectivityResult;
  var subscription;



  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  Future<void> checkConnectivity() async {
    // connectivityResult = await Connectivity().checkConnectivity();
    // if (connectivityResult == ConnectivityResult.mobile ||
    //     connectivityResult == ConnectivityResult.wifi) {
    Get.toNamed(AppRoutes.tabsRoute);

      // Get.to(() => ShHomeScreen(), routeName: '/ShHomeScreen');
    // } else {
    //   toaster(Get.context!, 'No internet connection');
    // }
  }

}



