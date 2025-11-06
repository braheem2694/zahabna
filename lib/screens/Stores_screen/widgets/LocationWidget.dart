import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

import '../../../cores/math_utils.dart';
import '../../../models/Stores.dart';
import '../../../utils/ShColors.dart';
import 'package:map_launcher/map_launcher.dart';

class LocationWidget extends StatefulWidget {
  final StoreClass? store;
  final double? lat;
  final double? long;

  const LocationWidget({super.key, this.store, this.lat, this.long});
  @override
  _LocationWidgetState createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  String _locationString = " unknown Store Location ";

  @override
  void initState() {
    convertLocation();
    super.initState();
  }

  convertLocation() async {
    try {
      List<Placemark> placemarks;
      if (widget.store != null) {
        placemarks = await placemarkFromCoordinates(double.parse(widget.store!.latitude.toString()), double.parse(widget.store!.longitude.toString()));
      } else {
        placemarks = await placemarkFromCoordinates(widget.lat ?? 0, widget.long ?? 0);
      }

      Placemark place = placemarks[0];

      // Update the location string with the address
      setState(() {
        _locationString = "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  launchMap() async {
    bool isGoogleMapAvailable = await MapLauncher.isMapAvailable(MapType.google) ?? false;
    bool isAppleMapAvailable = await MapLauncher.isMapAvailable(MapType.apple) ?? false;

    print("Google Maps Available: $isGoogleMapAvailable");
    print("Apple Maps Available: $isAppleMapAvailable");

    if (isGoogleMapAvailable) {
      await MapLauncher.showMarker(
        mapType: MapType.google,
        coords: Coords(double.parse(widget.store!.latitude ?? "00"), double.parse(widget.store!.longitude ?? "00")),
        title: widget.store?.store_name ?? '',
        description: widget.store?.description ?? '',
      );
    } else if (isAppleMapAvailable) {
      await MapLauncher.showMarker(
        mapType: MapType.apple,
        coords: Coords(double.parse(widget.store!.latitude ?? "00"), double.parse(widget.store!.longitude ?? "00")),
        title: widget.store?.store_name ?? '',
        description: widget.store?.description ?? '',
      );
    } else {
      print("No Map application is available.");
    }
  }

  Future<void> _getLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationString = "Location services are disabled.";
        });
        return;
      }

      // Request permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationString = "Location permissions are denied.";
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationString = "Location permissions are permanently denied, we cannot request permissions.";
        });
        return;
      }

      // Get the current position
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      // Convert the position to an address
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

      Placemark place = placemarks[0];

      // Update the location string with the address
      setState(() {
        _locationString = "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      });
    } catch (e) {
      setState(() {
        _locationString = "Failed to get location: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: launchMap,
      behavior: HitTestBehavior.translucent,
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
        child: Padding(
          padding: getPadding(left: 8.0),
          child: SizedBox(
            width: getHorizontalSize(344),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_city,
                  color: ColorConstant.logoSecondColor,
                  size: getSize(25),
                ),
                SizedBox(
                  width: 10,
                ),
                // Text("Open onMap: ".tr, style: TextStyle(fontSize: getFontSize(18), color: ColorConstant.logoSecondColor)),
                Expanded(
                  child: RichText(
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      text: TextSpan(children: [
                        TextSpan(text: _locationString.tr, style: TextStyle(fontSize: getFontSize(16), color: ColorConstant.logoFirstColor)),
                      ]),
                      textAlign: TextAlign.left),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
