import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/screens/Home_screen_fragment/controller/Home_screen_fragment_controller.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../main.dart';

class main_swiper extends StatefulWidget {
  const main_swiper({Key? key}) : super(key: key);

  @override
  _main_swiperState createState() => _main_swiperState();
}

class _main_swiperState extends State<main_swiper> {
  RxBool addsloading = true.obs;
  List onlineaddsInfo = [];

  List SingleproductInfo = [];

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }


  final PageController _pageController = PageController(
    initialPage: 0,
  );
  RxInt _currentPage = 0.obs;

  @override
  void initState() {
    print(globalController.homeDataList.value.gridElements!);
    super.initState();
    Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      return mounted
          ? setState(() {
              if (_currentPage < globalController.homeDataList.value.gridElements!.length) {
                _currentPage++;
              } else {
                _currentPage.value = 0;
              }
              _pageController.animateToPage(
                _currentPage.value,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeIn,
              );
            })
          : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
          aspectRatio: 2.0,
          enlargeCenterPage: true,
          enlargeStrategy: CenterPageEnlargeStrategy.height,
        ),
        items: globalController.homeDataList.value.gridElements!
            .map((item) => GestureDetector(
                  onTap: () {
                    // if (item.ad_type.toString() == '1') {
                    //   getsingleproduct(item.product_id.toString()).then((value) {
                    //     Get.toNamed(AppRoutes.Productdetails_screen, arguments: {'product': searchlist[0], 'from_cart': false});
                    //   });
                    // } else if (item.ad_type.toString() == '2') {
                    //   Get.toNamed(AppRoutes.View_All_Products, arguments: {
                    //     'title': item.category_name.toString(),
                    //     'id': item.category_id.toString(),
                    //     'type': 'null',
                    //   });
                    // } else if (item.ad_type.toString() == '3') {
                    //   _launchURL(item.url.toString());
                    // } else {
                    //   toaster(context, 'Sorry an error occurred try again later or contact us');
                    // }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 10.0, right: 10),
                    child: Material(
                      // Wrap the Container with Material
                      elevation: 4, // Adjust the elevation to control the shadow intensity
                      shadowColor: Colors.grey, // Define the shadow color
                      borderRadius: BorderRadius.circular(5.0),
                      child: SizedBox(
                        width: 1000.0,
                        height: 450,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                          child: Image.network(
                            item.main_image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
