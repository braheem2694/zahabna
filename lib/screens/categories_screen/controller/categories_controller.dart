import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iq_mall/models/category.dart';
import 'package:iq_mall/screens/categories_screen/models/categories_model.dart';
import 'dart:convert';
import 'package:iq_mall/main.dart';
import '../../../cores/math_utils.dart';
import '../../../models/HomeData.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/ShColors.dart';

class CategoriesController extends GetxController with GetSingleTickerProviderStateMixin, StateMixin<dynamic> {
  TextEditingController frameTwentyFourController = TextEditingController();
  var scrollController = new ScrollController();
  Rx<CategoriesModel> categoriesModelObj = CategoriesModel().obs;
  late List subcategoriesinfo;
  late RxList list;
  RxList loaded = RxList([]);
  var parent;
  List gridproductInfo = [];
  late Rx<TabController> tabController;
  int index = 0;
  List categoriesInfo = [];
  List statussubcategories = [];
  RxBool loading = true.obs;
  RxBool changingCategory = false.obs;
  int limit = 15;
  int offset = 0;
  RxBool animate = false.obs;
  RxList items = [].obs;
  RxList<String> parentSlugs = <String>[].obs;
  RxInt selectedParent = RxInt(-1);
  RxInt selectedItemId = RxInt(-1);
  RxInt selectedCategoryIndex = 0.obs;
  final RxList<Category> categories = <Category>[].obs;
  final RxInt selectedParentId = RxInt(-1);
  Rx<ScrollController> categoryScrollController = ScrollController().obs;
  late AnimationController animationController;
  late Animation<Color?> colorAnimation;
  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    colorAnimation = ColorTween(

      begin: sh_light_grey, // your grey color
      end: Colors.white,
    ).animate(animationController);


    fetchDataFromApi();
  }

  @override
  void onReady() {

    super.onReady();
  }
  void changeCategory(int newIndex) {
    selectedCategoryIndex.value = newIndex;
    animationController.forward().then((_) => animationController.reverse());
  }
    @override
  void onClose() {
      animationController.dispose();
    super.onClose();
  }






  Future<void> fetchDataFromApi() async {
    try {
      final List<Category> fetchedCategories = await getCategoriesFromApi();
      if (fetchedCategories.isNotEmpty) {
        // Set the first item to be selected by default
        selectedParentId.value = fetchedCategories.first.id!;
        parent = fetchedCategories.first;
      }
      print('Fetched categories: $fetchedCategories'); // Debug print
      categories.value = fetchedCategories;
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  void setSelectedParent(int parentId, cat,String fromKey) {

    if (selectedParentId.value == parentId) {
      var f = {
        "categories": [
          parentId.toString(),
        ],
      };
      String jsonString = jsonEncode(f);
      if(fromKey!='double_click'){
        Get.toNamed(AppRoutes.Filter_products, arguments: {
          'title': cat.categoryName,
          'id': cat.id,
          'type': jsonString,
        },
             parameters: {
            'tag': "${int.parse(cat.id.toString())}:${cat.categoryName.toString()}"
            }
        );
      }
    } else {
      changingCategory.value=true;
      selectedParentId.value = parentId;
      changingCategory.value=false;

    }
  }

  bool isSelectedParent(int parentId) {
    return selectedParentId.value == parentId;
  }

  List<Category> getRelatedParentItems() {
    print(categories);

    return categories.where((category) => category.parent == selectedParentId.value).toList();
  }

  List<Category> get parentCategories {
    return categories.where((category) => category.parent == null).toList();
  }

  Rx<Categories> CategoriesDataList = Categories().obs;

  getCategoriesFromApi() async {
    loading.value = true;
    Map<String, dynamic> response = await api.getData({
      'storeId': prefs!.getString("id") ?? "",
      'get_children': 'true',
    }, "products/get-categories");

    if (response.isNotEmpty) {
      if (response['categories'] is List) {
        CategoriesDataList = (Categories.fromJson(response)).obs;
        loading.value = false;
        return CategoriesDataList.value.categories;
      } else {
        loading.value = false;
        print('Expected a List but got something else');
        return false;
      }
    } else {
      loading.value = false;
    }
  }
}
