import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../Home_screen_fragment/controller/Home_screen_fragment_controller.dart';

class InitializationMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (!_isAppInitialized()) {
      return const RouteSettings(name: "/tabs");
    }
    return null;
  }

  bool _isAppInitialized() {
    // Implement your logic to check if the app is fully initialized
    // For example, check if a certain service or variable is initialized
    // Return true if initialized, false otherwise
    return Home_screen_fragmentController.to.isInitialized.value;
  }
}
