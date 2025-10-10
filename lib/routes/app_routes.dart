import 'package:get/get.dart';
import 'package:iq_mall/screens/Account_screen/Account_screen.dart';
import 'package:iq_mall/screens/Account_screen/binding/Account_binding.dart';
import 'package:iq_mall/screens/Add_new_address_screen/Add_new_address_screen.dart';
import 'package:iq_mall/screens/Add_new_address_screen/binding/Add_new_address_screen_binding.dart';
import 'package:iq_mall/screens/BrandsScreen_screen/binding/BrandsScreen_binding.dart';
import 'package:iq_mall/screens/ContactUs_screen/ContactUs_screen.dart';
import 'package:iq_mall/screens/ContactUs_screen/binding/ContactUs_binding.dart';
import 'package:iq_mall/screens/EmailScreen_screen/EmailScreen_screen.dart';
import 'package:iq_mall/screens/EmailScreen_screen/binding/EmailScreen_binding.dart';
import 'package:iq_mall/screens/Forget_password_screen/Forget_Password_screen.dart';
import 'package:iq_mall/screens/Forget_password_screen/binding/Forget_Password_binding.dart';
import 'package:iq_mall/screens/Forget_password_verification_screen/Forget_password_verification_screen.dart';
import 'package:iq_mall/screens/Forget_password_verification_screen/binding/Forget_password_verification_binding.dart';
import 'package:iq_mall/screens/Home_screen_fragment/binding/Home_screen_fragment_binding.dart';
import 'package:iq_mall/screens/Languages/binding/Languages.dart';
import 'package:iq_mall/screens/NoInternet_screen/NoInternet_screen.dart';
import 'package:iq_mall/screens/NoInternet_screen/binding/NoInternet_binding.dart';
import 'package:iq_mall/screens/OffersScreen_screen/OffersScreen_screen.dart';
import 'package:iq_mall/screens/OffersScreen_screen/binding/OffersScreen_binding.dart';
import 'package:iq_mall/screens/OrderSummaryScreen/OrderSummaryScreen.dart';
import 'package:iq_mall/screens/OrderSummaryScreen/binding/OrderSummaryScreen_binding.dart';
import 'package:iq_mall/screens/Order_Details/binding/Order_Details_binding.dart';
import 'package:iq_mall/screens/Orders_list_screen/Orders_list_screen.dart';
import 'package:iq_mall/screens/Orders_list_screen/binding/Orders_list_binding.dart';
import 'package:iq_mall/screens/Phone_verification_screen/Phone_verification_screen.dart';
import 'package:iq_mall/screens/Phone_verification_screen/binding/Phone_verification_binding.dart';
import 'package:iq_mall/screens/ProductDetails_screen/ProductDetails_screen.dart';
import 'package:iq_mall/screens/ProductDetails_screen/binding/ProductDetails_screen_binding.dart';
import 'package:iq_mall/screens/ReportsAndBugs_screen/TermsAndConditions_screen.dart';
import 'package:iq_mall/screens/ReportsAndBugs_screen/binding/ReportsAndBugs_binding.dart';
import 'package:iq_mall/screens/Search_screen/Search_screen.dart';
import 'package:iq_mall/screens/HomeScreenPage/ShHomeScreen.dart';
import 'package:iq_mall/screens/SignIn_screen/SignIn_screen.dart';
import 'package:iq_mall/screens/SignIn_screen/binding/SignIn_binding.dart';
import 'package:iq_mall/screens/SignUp_screen/SignUp_screen.dart';
import 'package:iq_mall/screens/SignUp_screen/binding/SignUp_binding.dart';
import 'package:iq_mall/screens/Stores_details/binding/Store_detail_binding.dart';
import 'package:iq_mall/screens/TermsAndConditions_screen/TermsAndConditions_screen.dart';
import 'package:iq_mall/screens/TermsAndConditions_screen/binding/TermsAndConditions_binding.dart';
import 'package:iq_mall/screens/Update_Profile_screen/update_profile.dart';
import 'package:iq_mall/screens/bill_screen/bill_screen.dart';
import 'package:iq_mall/screens/bill_screen/binding/bill_binding.dart';
import 'package:iq_mall/screens/change_phone_number_screen/binding/change_phone_number_screen_binding.dart';
import 'package:iq_mall/screens/change_phone_number_screen/change_phone_number_screen.dart';
import 'package:iq_mall/screens/notifications_screen/binding/notification_binding.dart';
import 'package:iq_mall/screens/notifications_screen/notifications_screen.dart';
import 'package:iq_mall/screens/transactions/bindings/transactions_binding.dart';
import 'package:iq_mall/screens/transactions/transactions_view.dart';
import 'package:iq_mall/widgets/slider.dart';
import '../screens/Address_manager_screen/Address_manager_screen.dart';
import '../screens/Address_manager_screen/binding/Address_manager_binding.dart';
import '../screens/BrandsScreen_screen/BrandsScreen.dart';
import '../screens/Cart_List_screen/Cart_List_screen.dart';
import '../screens/Cart_List_screen/controller/Cart_List_controller.dart';
import '../screens/Change_password_screen/binding/Forget_Password_binding.dart';
import '../screens/Change_password_screen/change_password.dart';
import '../screens/Filter_Products_screen/Filter_Products_screen.dart';
import '../screens/Filter_Products_screen/binding/Filter_Products_binding.dart';
import '../screens/Filter_Products_screen/controller/Filter_Products_controller.dart';
import '../screens/GiftCardDetailScreen/GiftCardDetail_screen.dart';
import '../screens/GiftCardDetailScreen/binding/GiftCardDetailScreen.dart';
import '../screens/HomeScreenPage/binding/Home_screen_fragment_binding.dart';
import '../screens/Home_screen_fragment/Home_screen_fragment.dart';
import '../screens/Languages/Languages.dart';
import '../screens/Order_Details/Order_Details_screen.dart';
import '../screens/ProductDetails_screen/controller/ProductDetails_screen_controller.dart';
import '../screens/Search_screen/binding/Search_binding.dart';
import '../screens/Stores_details/Stores_details_screen.dart';
import '../screens/Stores_screen/Stores_screen.dart';
import '../screens/Stores_screen/binding/Stores_screen.dart';
import '../screens/Stores_screen/binding/my_store_binding.dart';
import '../screens/Stores_screen/controller/Stores_screen_controller.dart';
import '../screens/Stores_screen/widgets/my_store_widget.dart';
import '../screens/Update_Profile_screen/binding/update_profile_binding.dart';
import '../screens/View_all_Products_screen/View_all_Products_screen.dart';
import '../screens/View_all_Products_screen/binding/View_all_Products_binding.dart';
import '../screens/settings_screen/binding/settings_binding.dart';
import '../screens/settings_screen/settings_screen.dart';
import '../screens/tabs_screen/binding/tabs_binding.dart';
import '../screens/tabs_screen/tabs_view_screen.dart';
import '../screens/wallet_screen/binding/wallet_screen.dart';
import '../screens/wallet_screen/wallet_screen.dart';
import '../screens/store_request/store_request_view.dart';
import '../screens/store_request/store_request_controller.dart';
import '../screens/store_requests/store_requests_view.dart';
import '../screens/store_requests/store_requests_controller.dart';
import '../screens/store_requests/binding/store_requests_binding.dart';

class AppRoutes {
  static const String AccountsScreen = '/Account';
  static const String BrandScreen = '/brandsscreen';
  static const String ShhomeScreen = '/ShHomeScreen';
  static const String SliderScreen = '/slider';
  static const String TermsAndConditionsScreen = '/termsandconditions';
  static const String reports = '/reports';
  static const String BillScreen = '/Bill';
  static const String NotificationsScreen = '/NotificationsScreen';
  static const String wallet = '/wallet';
  static const String ContactusScreen = '/ContactUs';
  static const String SignIn = '/SignIn';
  static const String SignUp = '/SignUp';
  static const String EmailScreen = '/EmailScreenscreen';
  static const String NoInternet = '/NoInternet';
  static const String offersScreen = '/OffersScreen';
  static const String myProductsScreen = '/myProductsScreen';
  static const String Productdetails_screen = '/product/:tag';
  static const String SplashScreen = '/SplashScreen';
  static const String Add_new_address = '/Add_new_address';
  static const String OrderSummary = '/OrderSummaryScreen';
  static const String changephonenumberscreen = '/change_phone_number_screen';
  static const String ForgetPasswordscreen = '/Forget_Password_screen';
  static const String Changepasswordscreen = '/Changepasswordscreen';
  static const String Forgetpasswordverificationscreen = '/Forgetpasswordverificationscreen';
  static const String Orderslistscreen = '/Orders_list_screen';
  static const String Phoneverificationscreen = '/Phoneverificationscreen';
  static const String OrderSummarySc = '/OrderSummaryScreen';
  static const String WalkThrought = '/WalkThroughtscreen';
  static const String Search = '/Search';
  static const String Filter_products = '/View_All_Productsscreen';
  static const String cartScreen = '/cart_screen';
  static const String OrderDetails = '/OrderDetailsscreen';
  static const String GiftCard = '/GiftCard';
  static const String Home_screen_fragment = '/Home_screen_fragmentscreen';
  static const String Stores = '/Storesscreen';
  static const String AddressesManager = '/AddressManager';
  static const String MyProfile = '/MyProfile';
  static const String View_All_Products = '/View_All_Products';
  static const String Language = '/languages';
  static const String settings = '/settings';
  static const String tabsRoute = '/tabs';
  static const String mainRoute = '/';
  static const String myStore = '/mStore';
  static const String soreDetails = '/store_details';
  static const String storeRequest = '/store-request';
  static const String storeRequests = '/store-requests';
  static const String transactionsScreen = '/transactions';

  static final routes = [
    GetPage(
      name: AppRoutes.Stores,
      page: () => Storesscreen(),
      binding: BindingsBuilder(() {
        final tag = Get.arguments?['tag'] ?? "main";
        if (!Get.isRegistered<StoreController>(tag: tag)) {
          Get.lazyPut(() => StoreController(), tag: tag);
        }
      }),
      preventDuplicates: false,
    ),

    GetPage(
      name: Productdetails_screen,
      page: () => ProductDetails_screen(),
      binding: BindingsBuilder(() {
        final tag = Get.parameters['tag'] ?? 'default';
        if (!Get.isRegistered<ProductDetails_screenController>(tag: tag)) {
          Get.lazyPut(() => ProductDetails_screenController(), tag: tag);
        }
      }),
    ),

    GetPage(
      name: Filter_products,
      page: () => Filter_Productsscreen(),
      binding: BindingsBuilder(() {
        final tag = Get.parameters['tag'];
        Get.lazyPut(() => Filter_ProductsController(), tag: tag ?? 'default');
      }),
      preventDuplicates: false,
    ),

    GetPage(
      name: cartScreen,
      page: () => Cart_Listscreen(),
      binding: BindingsBuilder(() {
        final tag = Get.parameters['tag'];
        Get.lazyPut(() => Cart_ListController(), tag: tag ?? 'default');
      }),
      preventDuplicates: false,
    ),

    GetPage(
      name: tabsRoute,
      page: () => TabsPage(),
      bindings: [
        TabsBinding(),
      ],
    ),
    GetPage(
      name: soreDetails,
      page: () => StoreDetails(),
      bindings: [
        StoreDetailBinding(),
      ],
    ),
    GetPage(
      name: myStore,
      page: () => MyStoreScreen(),
      bindings: [
        MyStoresBinding(),
      ],
    ),

    GetPage(
      name: GiftCard,
      page: () => GiftCardDetailScreen(),
      binding: GiftCardDetailScreenBinding(),
    ),
    GetPage(
      name: wallet,
      page: () => wallet_screen(),
      binding: wallet_screenBinding(),
    ),
    GetPage(
      name: Language,
      page: () => LanguageListWidget(),
      binding: LanguagesBinding(),
    ),
    GetPage(
      name: settings,
      page: () => SettingsScreen(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: MyProfile,
      page: () => update_profile_screen(),
      binding: update_profile_screen_Binding(),
    ),
    GetPage(
      name: Changepasswordscreen,
      page: () => Change_password_screen(),
      binding: Change_password_screen_Binding(),
    ),
    GetPage(
      name: AddressesManager,
      page: () => AddressManager(),
      binding: Address_managerBinding(),
    ),

    // GetPage(
    //   name: AppRoutes.Stores,
    //   page: () => Storesscreen(),
    //   binding: BindingsBuilder(() {
    //     final tag = Get.arguments?['tag'] ?? "main"; // Default to "main" if no argument is passed
    //     if (!Get.isRegistered<StoreController>(tag: tag)) {
    //       Get.lazyPut(() => StoreController(), tag: tag);
    //     }
    //   }),
    //   preventDuplicates: false,
    // ),

    GetPage(
      name: Home_screen_fragment,
      page: () => Home_screen_fragmentscreen(),
      binding: Home_screen_fragmentBinding(),
    ),
    GetPage(
      name: OrderDetails,
      page: () => OrderDetailsscreen(),
      binding: Order_DetailsBinding(),
    ),
    GetPage(
      name: View_All_Products,
      page: () => View_all_Productsscreen(),
      binding: View_all_ProductsBinding(),
    ),
    // GetPage(
    //   name: Productdetails_screen,
    //   page: () =>  ProductDetails_screen(),
    //   binding: BindingsBuilder(() {
    //     final tag = Get.arguments['tag'];
    //     if (tag != null) {
    //       Get.lazyPut(() => ProductDetails_screenController(), tag: tag);
    //     }
    //   }),
    //   preventDuplicates: false,
    //
    // ),

    // GetPage(
    //   name: Filter_products,
    //   page: () => Filter_Productsscreen(),
    //   binding: BindingsBuilder(() {
    //     final tag = Get.parameters['tag'];
    //     if (tag != null) {
    //       Get.lazyPut(() => Filter_ProductsController(), tag: tag);
    //     }
    //   }),
    //   preventDuplicates: false,
    //
    // ),
    // GetPage(
    //   name: cartScreen,
    //   page: () => Cart_Listscreen(),
    //   binding: BindingsBuilder(() {
    //     final tag = Get.parameters['tag'];
    //     if (tag != null) {
    //       Get.lazyPut(() => Cart_ListController(), tag: tag);
    //     }
    //   }),
    //   preventDuplicates: false,
    //   transition: Transition.cupertino,
    //
    //
    // ),

    GetPage(
      name: Search,
      page: () => Searchscreen(),
      binding: SearchBinding(),
    ),
    // GetPage(
    //   name: WalkThrought,
    //   page: () => WalkThroughtscreen(),
    //   binding: WalkThroughtBinding(),
    // ),
    GetPage(
      name: OrderSummarySc,
      page: () => OrderSummaryScreen(),
      binding: OrderSummaryScreenBinding(),
    ),
    GetPage(
      name: Phoneverificationscreen,
      page: () => Phone_verificationscreen(),
      binding: Phone_verificationBinding(),
    ),
    GetPage(
      name: Orderslistscreen,
      page: () => Orders_list_screen(),
      binding: Orders_list_Binding(),
    ),
    GetPage(
      name: Forgetpasswordverificationscreen,
      page: () => Forget_password_verificationscreen(),
      binding: Forget_password_verificationBinding(),
    ),
    GetPage(
      name: ForgetPasswordscreen,
      page: () => Forget_Password_screen(),
      binding: Forget_Password_Binding(),
    ),
    GetPage(
      name: changephonenumberscreen,
      page: () => change_phone_number_screen(),
      binding: change_phone_number_screenBinding(),
    ),
    GetPage(
      name: OrderSummary,
      page: () => OrderSummaryScreen(),
      binding: OrderSummaryScreenBinding(),
    ),
    GetPage(
      name: Add_new_address,
      page: () => Add_new_address_screen(),
      binding: Add_new_address_screenBinding(),
    ),
    // GetPage(
    //   name: SplashScreen,
    //   page: () => Splash_Screen(),
    //   binding: Splash_ScreenBinding(),
    // ),
    // GetPage(
    //   name: Productdetails_screen,
    //   page: () => ProductDetails_screen(),
    //   binding: ProductDetails_screen_Binding(),
    // ),

    // GetPage(
    //   name: myProductsScreen,
    //   page: () => MyProductsScreen(),
    //   binding: MyProductsBinding(),
    // ),
    GetPage(
      name: offersScreen,
      page: () => OffersScreen(),
      binding: OffersScreenBinding(),
    ),
    GetPage(
      name: NoInternet,
      page: () => NoInternetScreen(),
      binding: NoInternetBinding(),
    ),
    GetPage(
      name: EmailScreen,
      page: () => EmailScreenscreen(),
      binding: EmailScreenBinding(),
    ),
    GetPage(
      name: SignUp,
      page: () => SignUpScreen(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: SignIn,
      page: () => SignInScreen(),
      binding: SignInBinding(),
    ),
    GetPage(
      name: reports,
      page: () => ReportsAndBugsscreen(),
      binding: ReportsAndBugsBinding(),
    ),
    // GetPage(
    //   name: ShProductDetailScreen + '/:id',
    //   page: () => ShProductDetail(),
    //   // binding: ShProductDetailBinding(),
    // ),
    GetPage(
      name: ContactusScreen,
      page: () => ContactUsscreen(),
      binding: ContactUsBinding(),
    ),
    GetPage(
      name: AccountsScreen,
      page: () => Accountsscreen(),
      binding: AccountBinding(),
    ),
    GetPage(
      name: NotificationsScreen,
      page: () => notificationsscreen(),
      binding: NotificationsBinding(),
    ),
    // GetPage(
    //   name: BrandScreen,
    //   page: () => Brandsscreen(),
    //   binding: BrandsBinding(),
    // ),
    // GetPage(
    //   name: ShViewAllProductScreen + '/:id',
    //   page: () => ShViewAllProductScreen(),
    // //  binding: ShViewAllProductScreenBinding(),
    // ),
    // GetPage(
    //   name: ShSplashScreen,
    //   page: () => ShSplashScreen(),
    //  // binding: ShSplashScreenBinding(),
    // ),
    //  GetPage(
    //    name: ShhomeScreen,
    //    page: () => ShHomeScreen(),
    //    binding: HomeMainFragment(),
    //  ),
    GetPage(
      name: '/brandsscreen', // Ensure this matches the route you're navigating to
      page: () => BrandsScreen(),
      binding: BrandsScreenBinding(),
    ),

    // GetPage(
    //   name: ShCartScreen,
    //   page: () => ShCartScreen(),
    //  // binding: ShCartScreenBinding(),
    // ),
    // GetPage(
    //   name: ShWalkThroughScreen,
    //   page: () => ShWalkThroughScreen(),
    // //  binding: ShWalkThroughScreenBinding(),
    // ),
    //  GetPage(
    //    name: ShSearchScreen,
    //    page: () => ShSearchScreen(),
    // //   binding: ShSearchScreenBinding(),
    //  ),
    //  GetPage(
    //    name: ShSettingsScreen,
    //    page: () => ShSettingsScreen(),
    //   // binding: ShSettingsScreenBinding(),
    //  ),

    // GetPage(
    //   name: SliderScreen,
    //   page: () => slider(index: 0,),
    //   //  binding: SliderBinding(),
    // ),
    GetPage(
      name: TermsAndConditionsScreen,
      page: () => TermsAndConditionsscreen(),
      binding: TermsAndConditionsBinding(),
    ),

    GetPage(
      name: BillScreen,
      page: () => Billsscreen(),
      binding: BillBinding(),
    ),

    GetPage(
      name: storeRequest,
      page: () => StoreRequestView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => StoreRequestController());
      }),
    ),
    GetPage(
      name: storeRequests,
      page: () => const StoreRequestsView(),
      binding: StoreRequestsBinding(),
    ),
    GetPage(
      name: transactionsScreen,
      page: () => const TransactionsView(),
      binding: TransActionsBinding(),
    ),
  ];
}
