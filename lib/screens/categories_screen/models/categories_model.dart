import 'package:get/get.dart';
import 'categories_item_model.dart';

class CategoriesModel {
  RxList<CategoriesItemModel> categoriesItemList =
      RxList.generate(12, (index) => CategoriesItemModel());
}
