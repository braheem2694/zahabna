// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
// import 'package:iq_mall/routes/app_routes.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:iq_mall/screens/categories_screen/categories_screen.dart';
// import 'package:iq_mall/screens/categories_screen/controller/categories_controller.dart';
// import 'package:iq_mall/widgets/CommonWidget.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:iq_mall/models/CurrencyEx.dart';
// import 'package:flutter/material.dart';
// import 'package:iq_mall/main.dart';
// import 'package:iq_mall/utils/ShColors.dart';
// import 'package:iq_mall/utils/ShImages.dart';
// import 'package:package_info/package_info.dart';
// import 'dart:async';
// import 'package:provider/provider.dart';
// import 'dart:io';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../cores/math_utils.dart';
// import '../Cart_List_screen/Cart_List_screen.dart';
// import '../Cart_List_screen/controller/Cart_List_controller.dart';
// import '../Home_screen_fragment/Home_screen_fragment.dart';
// import '../Home_screen_fragment/controller/Home_screen_fragment_controller.dart';
// import '../Wishlist_screen/controller/Wishlist_controller.dart';
// import '../Wishlist_screen/wish_list_screen.dart';
// import '../nav_button.dart';
//
// final state = globalController.sideMenuKey.currentState;
// RxBool Updatecounter = false.obs;
// RxString ItemsCount = ''.obs;
// List settings = [];
// List settings2 = [];
// String? language = 'English';
// RxList<Widget> fragments = <Widget>[].obs;
// var homeFragment = Home_screen_fragmentscreen().obs;
//
//
// class ShHomeScreen extends StatefulWidget {
//   static String? tag = '/ShHomeScreen';
//
//   @override
//   ShHomeScreenState createState() => ShHomeScreenState();
// }
//
// class ShHomeScreenState extends State<ShHomeScreen> {
//   static ScrollController ScrollListenerCATEGORY = new ScrollController();
//   bool balanceloading = true;
//   int drawercount = 10;
//   var subscription;
//   List cartInfo = [];
//   late final PersistentTabController _controller = PersistentTabController(initialIndex: 0);
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   RxBool load = false.obs;
//   var wishlistController;
//   var cartlistController;
//   var Home_Controller;
//
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       LoadingDrawer.value = false;
//       LoadingDrawer.value = true;
//     });
//     Get.lazyPut(() => Home_screen_fragmentController());
//     Get.lazyPut(() => WishlistController());
//     Get.lazyPut(() => Cart_ListController());
//     Get.lazyPut(() => CategoriesController());
//     wishlistController = Get.find<WishlistController>();
//     cartlistController = Get.find<Cart_ListController>();
//     Home_Controller = Get.find<Home_screen_fragmentController>();
//     InitStateFucntion();
//     var categoriesFragment = CategoriesScreen().obs;
//     var wishlistFragment = Wishlistscreen().obs;
//     var CartFragment = Cart_Listscreen().obs;
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Get.lazyPut(() => WishlistController());
//       fragments.value = [
//         homeFragment.value,
//         categoriesFragment.value,
//         wishlistFragment.value,
//         CartFragment.value,
//       ];
//     });
//     super.initState();
//   }
//
//   String? version = '';
//
//   getsettings() async {
//     PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
//       version = packageInfo.version;
//     });
//   }
//
//   RxString? title;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       extendBody: true,
//       appBar: AppBar(
//         toolbarHeight: getSize(50),
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(
//             bottom: Radius.circular(30), // Change the value to your desired radius
//           ),
//         ),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.grey,
//         shadowColor: Colors.white,
//         elevation: 0.5,
//
//
//         iconTheme: const IconThemeData(color: sh_textColorPrimary),
//         centerTitle: true,
//         leading: GestureDetector(
//           onTap: () {
//             if (state?.isOpened ?? false) {
//               state?.closeSideMenu();
//             } else {
//               state?.openSideMenu();
//             }
//           },
//           child: SizedBox(
//             width: getSize(10), // Set the desired width
//             height: getSize(10), // Set the desired height
//             child: Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: SvgPicture.asset(
//                 AssetPaths.menu,
//                 fit: BoxFit.contain, // Optionally, set fit to control scaling
//               ),
//             ),
//           ),
//         ),
//         title: prefs!.getString('main_image')!.toLowerCase().endsWith('.svg')
//             ? Padding(
//               padding: getPadding(bottom: 2.0,top: 2.0),
//               child: SvgPicture.network(
//                   prefs!.getString('main_image')!,
//                   width: getSize(45),
//
//                   height: getSize(45),
//                 ),
//             )
//             : Padding(
//           padding: getPadding(bottom: 2.0,top: 2.0),
//               child: Image.network(
//                   prefs!.getString('main_image')!,
//                   width: getSize(45),
//                   height: getSize(45),
//                 ),
//             ),
//         actions: <Widget>[
//           Padding(
//             padding: getPadding(right: 8.0),
//             child: IconButton(
//               icon: SVG(AssetPaths.search_image, 27, 27, Button_color),
//               onPressed: () {
//                 Get.toNamed(AppRoutes.Search)!.then((value) {
//                   if (globalController.selectedTab.value == 2) {
//                     globalController.selectedTab.value = 0;
//                     Future.delayed(const Duration(milliseconds: 15), () {
//                       globalController.selectedTab.value = 2;
//                       Get.context!.read<Counter>().globalController.selectedTabchange(2);
//                     });
//                   } else if (globalController.selectedTab.value == 3) {
//                     globalController.selectedTab.value = 0;
//                     Get.context!.read<Counter>().globalController.selectedTabchange(0);
//                     Future.delayed(const Duration(milliseconds: 15), () {
//                       globalController.selectedTab.value = 3;
//                       Get.context!.read<Counter>().globalController.selectedTabchange(3);
//                     });
//                     cartlist = cartlist;
//                   } else {
//                     globalController.selectedTab.value = 0;
//                     Get.context!.read<Counter>().globalController.selectedTabchange(0);
//                     Future.delayed(const Duration(milliseconds: 15), () {
//                       globalController.selectedTab.value = 1;
//                       Get.context!.read<Counter>().globalController.selectedTabchange(1);
//                     });
//                     cartlist = cartlist;
//                   }
//                 });
//               },
//             ),
//           ),
//           prefs?.getString('logged_in') == 'true'
//               ? Padding(
//                   padding: getPadding(right: 8.0),
//                   child: GestureDetector(
//                       onTap: () {
//                         Get.toNamed(AppRoutes.NotificationsScreen, arguments: false);
//                       },
//                       child: InkWell(
//                         onTap: () {
//                           Get.toNamed(AppRoutes.NotificationsScreen, arguments: false)!.then(
//                             (value) => Get.context!.read<Counter>().unreadednotification(),
//                           );
//                         },
//                         radius: getSize(35),
//                         child: Stack(
//                           alignment: Alignment.center,
//                           children: <Widget>[
//                             Container(
//                                 width: getSize(30),
//                                 height: getSize(30),
//                                 child: SVG(AssetPaths.notification_image, 30, 30, Button_color)),
//                             context.watch<Counter>().unreadednotifications != 0
//                                 ? Align(
//                                     alignment: Alignment.centerRight,
//                                     child: Container(
//                                         width: getSize(30),
//                                         margin: EdgeInsets.only(
//                                             left: MediaQuery.of(context).size.height * 0.02, bottom: MediaQuery.of(context).size.height * 0.02),
//                                         padding: const EdgeInsets.all(2),
//                                         decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           color: Colors.white,
//                                           border: Border.all(width: 3, color: MainColor),
//                                         ),
//                                         child: Text(context.watch<Counter>().unreadednotifications.toString(),
//                                             style: TextStyle(color: MainColor, fontSize: 16))),
//                                   )
//                                 : const SizedBox()
//                           ],
//                         ),
//                       )),
//                 )
//               : const SizedBox(),
//         ],
//       ),
//       bottomNavigationBar: Container(
//         width: Get.width,
//         height: getSize(70),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(15.0),
//             topRight: Radius.circular(15.0),
//           ),
//           gradient: LinearGradient(
//             colors: [
//               Color(0xFFFFFFFF),
//               Color(0xFFFFFFFF),
//             ],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: MainColor.withOpacity(0.2), // Adjust opacity as needed
//               spreadRadius: 1, // Adjust spread radius as needed
//               blurRadius: 2, // Adjust blur radius as needed
//               offset: const Offset(0, 1), // Change position as needed
//             ),
//           ],
//         ),
//         padding: EdgeInsets.only(top: getVerticalSize(10.0)),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Obx(() => NavButton(
//                   onTap: () => OnBottomNavTapPress(0),
//                   label: "Home".tr,
//                   navColor: fromHex('#464b5e'),
//                   notSelectedColor: Button_color,
//                   img: globalController.selectedTab.value != 0 ? 'assets/navigation_icons/home.svg' : 'assets/navigation_icons/home_clicked.svg',
//                   isSelected: globalController.selectedTab.value == 0 ? true : false,
//                 )),
//             Obx(() => NavButton(
//                   onTap: () => OnBottomNavTapPress(1),
//                   label: "Categories".tr,
//                   navColor: fromHex('#464b5e'),
//                   notSelectedColor: Button_color,
//                   img: globalController.selectedTab.value != 1 ? 'assets/navigation_icons/categories.svg' : 'assets/navigation_icons/categories_clicked.svg',
//                   isSelected: globalController.selectedTab.value == 1 ? true : false,
//                 )),
//             Obx(() => NavButton(
//                   onTap: () => OnBottomNavTapPress(2),
//                   label: "Favorites".tr,
//                   navColor: fromHex('#464b5e'),
//                   notSelectedColor: Button_color,
//                   img: globalController.selectedTab.value != 2 ? 'assets/navigation_icons/favorite.svg' : 'assets/navigation_icons/favorite_clicked.svg',
//                   isSelected: globalController.selectedTab.value == 2 ? true : false,
//                 )),
//             Stack(
//               clipBehavior: Clip.none, // This ensures that child outside stack boundary is not clipped
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(right: 8.0), // This provides enough space for the badge
//                   child: Obx(() => NavButton(
//                         onTap: () => OnBottomNavTapPress(3),
//                         label: "Cart".tr,
//                         navColor: fromHex('#464b5e'),
//                         notSelectedColor: Button_color,
//                         img: globalController.selectedTab.value != 3 ? 'assets/navigation_icons/cart.svg' : 'assets/navigation_icons/cart_clicked.svg',
//                         isSelected: globalController.selectedTab.value == 3 ? true : false,
//                       )),
//                 ),
//                 Obx(() => Updatecounter.value || ItemsCount.value.toString() == '0' || ItemsCount.value.toString() == ''
//                     ? Container()
//                     : Positioned(
//                         top: -5.0, // Position the badge slightly above the NavButton container
//                         right: globalController.selectedTab.value == 3 ? -10.0 : -0.0, // Position the badge slightly to the right of the NavButton container
//                         child: GestureDetector(
//                           onTap: () => OnBottomNavTapPress(3),
//                           child: Container(
//                             padding: const EdgeInsets.all(6.0),
//                             decoration: BoxDecoration(
//                               color: globalController.selectedTab.value == 3 ? Button_color : MainColor,
//                               borderRadius: BorderRadius.circular(12.0),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: MainColor.withOpacity(0.2), // Adjust opacity as needed
//                                   spreadRadius: 1, // Adjust spread radius as needed
//                                   blurRadius: 2, // Adjust blur radius as needed
//                                   offset: const Offset(0, 1), // Change position as needed
//                                 ),
//                               ],
//                             ),
//                             constraints: const BoxConstraints(
//                               minWidth: 24,
//                               minHeight: 24,
//                             ),
//                             child: Center(
//                               child: Obx(() => Updatecounter.value || ItemsCount.value.toString() == '0' || ItemsCount.value.toString() == ''
//                                   ? Text('')
//                                   : Text(
//                                       ItemsCount.value.toString(),
//                                       textAlign: TextAlign.center,
//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 12.0,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     )),
//                             ),
//                           ),
//                         )))
//               ],
//             ),
//           ],
//         ),
//       ),
//       body: Obx(() => AnimatedPadding(
//             padding: EdgeInsets.only(
//               top: globalController.refreshingHomeScreen.value ? AppBar().preferredSize.height : 0,
//             ),
//             duration: Duration(milliseconds: 300),
//             child: IndexedStack(
//               index: globalController.selectedTab.value,
//               children: fragments,
//             ),
//           )),
//     );
//   }
//
//   InitStateFucntion() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Get.context!.read<Counter>().globalController.selectedTabchange(1);
//       Get.context!.read<Counter>().globalController.selectedTabchange(0);
//     });
//     setState(() {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         LoadingDrawer.value = false;
//       });
//     });
//     changeColorsAndDisplay(
//         prefs!.getString('button_color').toString(), prefs!.getString('main_color').toString(), prefs!.getString('discount_price_color').toString());
//     load.value = true;
//     Future.delayed(Duration.zero, () {
//       Get.to(() => ShHomeScreen(), routeName: '/ShHomeScreen');
//     });
//     getsettings();
//     if (prefs?.getString('currency').toString() == 'null') {
//       prefs?.setString('currency', 'Lebanese Lira');
//       prefs?.setString('idselected', country_currency_id!);
//       idselected = int.parse(prefs?.getString('idselected') ?? "");
//       prefs?.setString('sign', sign.value.toString() ?? "");
//       for (int i = 0; i < currencyExlist.length; i++) {
//         if (currencyExlist[i].from_currency == country_currency_id && currencyExlist[i].to_currency == idselected.toString()) {
//           prefs?.setString('currency_rate', currencyExlist[i].Rate);
//         }
//       }
//     } else {
//       idselected = int.parse(prefs?.getString('idselected') ?? "");
//       prefs?.setString('sign', sign.value.toString() ?? "");
//       Future.delayed(Duration.zero, () {});
//     }
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Get.context!.read<Counter>().unreadednotification();
//       LoadingDrawer.value = false;
//     });
//     setState(() {
//       Future.delayed(Duration.zero, () async {
//         drawerSize.value = Get.size.height - 200;
//         // globalController.selectedTab.value = 0;
//       });
//     });
//   }
//
//   List currencyInfo = [];
//   List categoriesInfo = [];
//
//   OnBottomNavTapPress(index) {
//     if (globalController.selectedTab.value != index) {
//       setState(() {
//         Future.delayed(Duration.zero, () {
//           globalController.selectedTab.value = index;
//         });
//       });
//     } else {
//       if (globalController.selectedTab.value == 2) {
//         Gototop(wishlistController.ScrollListenerFAVORITE);
//       } else if (globalController.selectedTab.value == 0) {
//         Gototop(Home_Controller.ScrollListenerHOME);
//       } else if (globalController.selectedTab.value == 1) {
//         Gototop(ScrollListenerCATEGORY);
//       } else if (globalController.selectedTab.value == 3) {
//         Gototop(cartlistController.ScrollListenerCART);
//       }
//     }
//   }
//
//   void OnLanguageChanged(value) {
//     if (value.contains('English')) {
//       language = 'English';
//       Get.updateLocale(const Locale('English', ''));
//       const Locale('AR', '');
//       prefs?.setString('language', 'English');
//     } else {
//       language = 'Arabic';
//       prefs?.setString('language', 'Arabic');
//       Get.updateLocale(const Locale('AR', ''));
//     }
//     language == 'English' ? Intl.defaultLocale = "English" : null;
//   }
// }
//
// Gototop(ScrollController s) {
//   try {
//     if (s.hasClients) {
//       s.animateTo(
//         1.0,
//         duration: const Duration(milliseconds: 750),
//         curve: Curves.fastLinearToSlowEaseIn,
//       );
//     }
//   } catch (ex) {}
// }
//
// class Badge extends StatelessWidget {
//   final String count;
//   final double top;
//   final double right;
//
//   Badge({required this.count, this.top = 0.0, this.right = 0.0});
//
//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       top: top,
//       right: right,
//       child: Container(
//         padding: EdgeInsets.all(6.0),
//         decoration: BoxDecoration(
//           color: Colors.red, // Badge color
//           borderRadius: BorderRadius.circular(12.0),
//         ),
//         constraints: const BoxConstraints(
//           minWidth: 24, // Minimum width of the badge
//           minHeight: 24, // Minimum height of the badge
//         ),
//         child: Center(
//           child: Text(
//             count,
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 12.0,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
