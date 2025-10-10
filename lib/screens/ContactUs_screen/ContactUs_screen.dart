import 'package:intl/intl.dart';
import 'package:iq_mall/screens/ContactUs_screen/controller/ContactUs_controller.dart';
import 'package:iq_mall/screens/ContactUs_screen/widgets/CallRequestWidget.dart';
import 'package:iq_mall/screens/ContactUs_screen/widgets/EmailWidget.dart';
import 'package:iq_mall/screens/ContactUs_screen/widgets/WhatsAppWidget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/utils/ShConstant.dart';
import 'package:iq_mall/widgets/ShWidget.dart';
import 'package:iq_mall/widgets/CommonWidget.dart';
import 'package:get/get.dart';

import '../../cores/math_utils.dart';
import '../../main.dart';
import '../../models/HomeData.dart';
import '../../utils/ShColors.dart';
import '../Home_screen_fragment/controller/Home_screen_fragment_controller.dart';
import '../Stores_screen/widgets/LocationWidget.dart';

class ContactUsscreen extends GetView<ContactUsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar('Contact us'.tr),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            CallRequestWidget(phoneNumber: globalController.companySettings.value.phone??''),
            divider(),
            EmailWidget(respondingTimeStatement: globalController.companySettings.value.email??''),
            divider(),
            WhatsAppWidget(phoneNumber: globalController.companySettings.value.phone??''),
            divider(),
            const SizedBox(
              height: spacing_standard_new,
            ),
            Padding(
              padding: getPadding(left: 12.0, right: 12),
              child: Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: ColorConstant.black900.withOpacity(0.15),
                    blurRadius: 4.0,
                    spreadRadius: 0.0,
                    offset: const Offset(0, 3.0),
                  )
                ], color: Colors.white, borderRadius: BorderRadius.circular(5)),
                padding: getPadding(all: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: ColorConstant.logoSecondColor,
                      size: getSize(25),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      globalController.companySettings.value.address??'',
                      style: TextStyle(fontSize: getFontSize(16)),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            Obx(() {
              return Padding(
                padding: getPadding(left: 12.0, right: 12,),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: LocationWidget(lat: globalController.companySettings.value.latitude,long: globalController.companySettings.value.longitude,),
                ),
              );
            }),
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 8.0),
            //   child: Container(
            //     decoration: BoxDecoration(
            //       color: Colors.blue[200],
            //       borderRadius: BorderRadius.circular(12.0), // Add rounded corners
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.black.withOpacity(0.2), // Shadow color
            //           spreadRadius: 2, // Spread radius
            //           blurRadius: 5, // Blur radius
            //           offset: Offset(0, 3), // Offset in the x, y direction
            //         ),
            //       ],
            //     ),
            //     child: ExpansionTile(
            //       title: ListTile(
            //         leading: Icon(Icons.date_range, color: MainColor),
            //         // Icon representing a date
            //
            //         title: Row(
            //           mainAxisAlignment: MainAxisAlignment.start,
            //           crossAxisAlignment: CrossAxisAlignment.center, // Adjust crossAxisAlignment
            //           children: [
            //             Text(
            //               controller.isStoreOpen(globalController.homeDataList.value.hours!)
            //                   ? "${"Opened".tr} "
            //                   : "${"Closed".tr} ",
            //               style: TextStyle(color: MainColor, fontSize: 15),
            //             ),
            //              Text(
            //               'Store Working Hours'.tr,
            //               style: const TextStyle(color: Colors.white, fontSize: 15),
            //             ),
            //           ],
            //         ),
            //       ),
            //       initiallyExpanded: true,
            //       children: [
            //         Obx(() => Material(
            //             elevation: 20.0, // Set the elevation value
            //             borderRadius: BorderRadius.circular(12.0), // Add rounded corners
            //             child: Padding(
            //               padding: const EdgeInsets.only(top: 12.0),
            //               child: Container(
            //                 decoration: const BoxDecoration(
            //                   color: Colors.white,
            //                 ),
            //                 height: 600,
            //                 child: GridView.builder(
            //                   physics: const NeverScrollableScrollPhysics(),
            //                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //                     crossAxisCount: 2, // Two items per row
            //                     crossAxisSpacing: 8.0,
            //                     mainAxisSpacing: 8.0,
            //                     childAspectRatio: 12 / 8,
            //                   ),
            //                   itemCount: globalController.homeDataList.value.hours!.length,
            //                   itemBuilder: (context, index) {
            //                     final hour = globalController.homeDataList.value.hours![index];
            //                     return Card(
            //                       color: Colors.red[200],
            //                       elevation: 10.0,
            //                       shape: RoundedRectangleBorder(
            //                         borderRadius: BorderRadius.circular(16.0),
            //                       ),
            //                       child: Padding(
            //                         padding: const EdgeInsets.all(8.0), // Adjust padding here
            //                         child: Column(
            //                           mainAxisAlignment: MainAxisAlignment.center, // Vertically center content
            //                           children: [
            //                             Text(
            //                               hour.day,
            //                               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19.0, color: Colors.white),
            //                             ),
            //                             const SizedBox(height: 8.0),
            //                             Text(
            //                               DateFormat('h:mm a').format(
            //                                 DateFormat('hh:mm:ss').parse(hour.openTime),
            //                               ),
            //                               style: const TextStyle(
            //                                 color: Colors.white,
            //                                 fontSize: 16,
            //                               ),
            //                             ),
            //                             const SizedBox(height: 3.0),
            //                             Text(
            //                               DateFormat('h:mm a').format(
            //                                 DateFormat('hh:mm:ss').parse(hour.closeTime),
            //                               ),
            //                               style: const TextStyle(
            //                                 color: Colors.white,
            //                                 fontSize: 16,
            //                               ),
            //                             ),
            //                           ],
            //                         ),
            //                       ),
            //                     );
            //                   },
            //                 ),
            //               ),
            //             ))),
            //       ],
            //     ),
            //   ),
            // ),
            // Obx(() => controller.loading.value
            //     ? SizedBox(
            //         height: 200,
            //         child: GoogleMap(
            //           mapType: MapType.hybrid,
            //           zoomControlsEnabled: true,
            //           zoomGesturesEnabled: true,
            //           initialCameraPosition: CameraPosition(
            //             target: LatLng(double.parse(prefs!.getString('latitude').toString()), double.parse(prefs!.getString('longitude').toString())),
            //             zoom: 15,
            //           ),
            //           onMapCreated: (GoogleMapController controller2) {
            //             controller.mapController?.animateCamera(CameraUpdate.newCameraPosition(
            //               CameraPosition(
            //                 target:
            //                     LatLng(double.parse(prefs!.getString('latitude').toString()), double.parse(prefs!.getString('longitude').toString())),
            //                 zoom: 15,
            //               ),
            //             ));
            //           },
            //           markers: controller.markers.map((Marker marker) {
            //             return marker.copyWith(
            //               draggableParam: false,
            //             );
            //           }).toSet(),
            //         ),
            //       )
            //     : Container()),
          ],
        ),
      ),
    );
  }
}
