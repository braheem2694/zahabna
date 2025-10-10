import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/models/GiftCards.dart';
import 'package:iq_mall/screens/ProductDetails_screen/controller/ProductDetails_screen_controller.dart';
import 'package:iq_mall/utils/ShColors.dart';
import 'package:iq_mall/widgets/ui.dart';
import 'package:photo_view/photo_view.dart';
import '../Product_widget/Product_widget.dart';
import '../models/HomeData.dart';
import '../screens/ProductDetails_screen/widgets/better_player.dart';
import '../utils/ShImages.dart';
import 'chewie_player.dart';
import 'custom_image_view.dart';


//ignore @immutable;
class slider extends StatefulWidget {
  static String? tag = '/slider';
  final List<MoreImage>? list;
  var product;
  int index;

  slider({this.list, this.product, required this.index});

  @override
  _sliderState createState() => _sliderState();
}

class _sliderState extends State<slider> with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  SwiperController swiperController = SwiperController(); // SwiperController added

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
    swiperController = SwiperController();
    swiperController.index= widget.index;// Initialize SwiperController
  }

  TabController? tabController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        elevation: 0.0,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.cancel, color: Colors.black),
        ),
      ),
      body: Column(

        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                 color: Colors.transparent,

                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Swiper(
                    controller: swiperController, // Assign the controller to Swiper
                    itemHeight: MediaQuery.of(context).size.height * 0.6,
                    viewportFraction: 1,
                    scale: 0.95,
                    onIndexChanged: (value) {
                      setState(() {
                        currentIndex = value;
                      });
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return buildMediaContent(widget.list![index]);
                    },
                    indicatorLayout: PageIndicatorLayout.COLOR,
                    autoplayDelay: 3000,
                    itemCount: widget.list!.length,
                  ),
                ),
                Padding(
                  padding: getPadding(bottom: 40.0,right: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(15.0),

                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 3.0,bottom: 3,right: 8,left: 8),
                      child: Text(
                        '${currentIndex + 1} / ${widget.list!.length}',
                        style:  TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: getFontSize(12)),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0,
                      crossAxisCount: 4,
                    ),
                    itemCount: widget.list!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            currentIndex = index;
                            swiperController.move(index); // Update the Swiper index
                          });
                        },
                        child:!widget.list![index].file_path.toString().toLowerCase().endsWith("avif")? buildThumbnail(widget.list![index], index):
                        CustomImageView(
                          fit: BoxFit.cover,
                          color: ColorConstant.logoFirstColor,
                          image:widget.list![index].file_path!,
                        )
                        ,
                      );
                    },
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildMediaContent(MoreImage item) {
    if (isVideo(item.file_path)) {
      return
        ChewieVideoPlayer(
          initialQuality: item.file_path!,
          isMuted: false,
          videoThumb: AssetPaths.placeholder,
          videoQualities: {
            "360": item.file_path!.toString(),
            "720": item.file_path!.toString(),
          },
          isGeneral: false,
          looping: false,


        );


    } else {
      return PhotoView(
        imageProvider: CachedNetworkImageProvider(item.file_path!),
        backgroundDecoration: const BoxDecoration(color: Colors.transparent),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 2.5,
        // Allows zooming
        loadingBuilder: (context, event) {
          return const Center(child: CircularProgressIndicator());
        },
      );
    }
  }
  Widget buildThumbnail(MoreImage item, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(
            width: 1,
            color: currentIndex == index ? MainColor : Colors.grey[200]!,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child:  CachedNetworkImage(
            imageUrl:isVideo(item.file_path)
                ?AssetPaths.videoThumb: item.file_path!,
            width: double.infinity, // Ensures the image takes full width
            height: double.infinity, // Ensures the image takes full height
            fit: BoxFit.cover, // Ensures the image fills the entire container
            placeholder: (context, url) => Image.network(
              convertToThumbnailUrl(item.file_path!, isBlurred: true),
              fit: BoxFit.cover,
            ),
            errorWidget: (context, url, error) =>
                Image.asset(isVideo(item.file_path)
                    ?AssetPaths.videoThumb:AssetPaths.placeholder, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }

}
