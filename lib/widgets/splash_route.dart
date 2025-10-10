

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/routes/app_routes.dart';
import 'package:iq_mall/screens/tabs_screen/controller/tabs_controller.dart';
import 'package:iq_mall/screens/tabs_screen/tabs_view_screen.dart';
import 'package:iq_mall/utils/ShImages.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import '../../../Product_widget/Product_widget.dart';
import '../../../main.dart';
import '../../../utils/ShColors.dart';
import '../../../widgets/ViewAllButton.dart';
import '../../../widgets/image_widget.dart';
import '../main.dart' as Firebase;
import 'applink.dart';

class SplashRouter extends StatefulWidget {
  @override
  State<SplashRouter> createState() => _SplashRouterState();
}

class _SplashRouterState extends State<SplashRouter> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    // Async app setup here
    // await Firebase.initializeApp();
    await Future.delayed(const Duration(milliseconds: 300)); // simulate init
    // await initializeApp();

    // Deep link pending?

        Future.delayed(const Duration(milliseconds: 800)).then((value) {

       WidgetsBinding.instance.addPostFrameCallback((_) {
         Get.offAllNamed(AppRoutes.tabsRoute);
       }
          // Replace with your actual widget class
         );


          // Get.lazyPut(() => TabsController(),);
          // Get.to(
          //       () => const TabsPage(),
          //
          // );
        });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
