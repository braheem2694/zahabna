import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/link.dart';
import '../../../Product_widget/Product_widget.dart';
import '../../../cores/math_utils.dart';
import '../../../main.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/ShColors.dart';
import '../../../utils/ShConstant.dart';
import '../../../utils/ShImages.dart';
import '../../../widgets/ShWidget.dart';
import '../../../widgets/CommonFunctions.dart';
import '../../../widgets/LikeButton.dart';
import '../controller/Search_controller.dart';
import 'package:get/get.dart';

//ignore: must_be_immutable
class SearchListItem extends StatelessWidget {
  var SearchController = Get.find<Searchcontroller>();

  SearchListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // determines the number of items in a row
          childAspectRatio: getHorizontalSize(180) / getVerticalSize(310),
          mainAxisSpacing: 5.0, // vertical spacing
          crossAxisSpacing: 5.0, // ho rizontal spacing
        ),
        itemCount: SearchController.SearchList?.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return ProductWidget(
            product: SearchController.SearchList![index],
          );
        },
      );
    });
  }
}
