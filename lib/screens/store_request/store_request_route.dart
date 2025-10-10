import 'package:get/get.dart';
import 'store_request_binding.dart';
import 'store_request_view.dart';

class StoreRequestRoute {
  static final route = GetPage(
    name: '/store-request',
    page: () => StoreRequestView(),
    binding: StoreRequestBinding(),
  );
} 