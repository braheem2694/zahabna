import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:iq_mall/screens/HomeScreenPage/ShHomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:iq_mall/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import '../../../models/HomeData.dart';

class ContactUsController extends GetxController {
  var firstNamecontroller = TextEditingController();
  Set<Marker> markers = {};
  GoogleMapController? mapController;
  Rxn<BitmapDescriptor>? _markerIcon = Rxn();
  RxBool load=false.obs;

  @override
  void onInit() {
    loadMarkerIconAndInitialize();
    super.onInit();
  }


  String getCurrentDay() {
    final now = DateTime.now();
    final formatter = DateFormat('EEEE');
    return formatter.format(now);
  }

  bool isStoreOpen(List<Hour> hours) {
    final currentDay = getCurrentDay();
    final currentTime = DateFormat('HH:mm:ss').format(DateTime.now());

  try {
    final matchingDay = hours.firstWhere(
          (hour) => hour.day == currentDay,
    );
    if (matchingDay != null) {
      final openTime = DateFormat('HH:mm:ss').parse(matchingDay.openTime!);
      final closeTime = DateFormat('HH:mm:ss').parse(matchingDay.closeTime!);
      final currentDateTime = DateFormat('HH:mm:ss').parse(currentTime);

      if (currentDateTime.isAfter(openTime) && currentDateTime.isBefore(closeTime)) {
        return true; // Store is open
      }
    }
  }catch(e){

  }



    return false; // Store is closed
  }




  Future<void> loadMarkerIconAndInitialize() async {
    // Download the image from the network
    final File fetchedFile = await DefaultCacheManager().getSingleFile(
      prefs!.getString('main_image')!,
    );

    // Create a marker icon from the downloaded image
    final markerIcon = await BitmapDescriptor.fromBytes(
      await fetchedFile.readAsBytes(),
    );

      _markerIcon?.value = markerIcon;

    // Initialize the markers after the marker icon has been loaded
    initializeMarkers();
  }

  void initializeMarkers() {
    LatLng latLng = LatLng(
      double.parse(prefs!.getString('latitude').toString()),
      double.parse(prefs!.getString('longitude').toString()),
    );

    markers.clear();
    final newMarker = Marker(
      markerId: MarkerId(latLng.toString()),
      position: latLng,
      icon: _markerIcon?.value ?? BitmapDescriptor.defaultMarker, // Use default marker if _markerIcon is null
      draggable: true,
      onDragEnd: (LatLng newPosition) {
        // Handle drag end if needed
      },
    );
    markers.add(newMarker);

    firstNamecontroller.text = prefs?.getString('phone_number') ?? "";
    load.value=true;
    update();
    refresh();
  }

  removeSharedPreferences() async {
    prefs?.clear();
  }



  RxBool loading = true.obs;
}
