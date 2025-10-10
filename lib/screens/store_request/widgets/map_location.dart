import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart' show Get;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import 'package:iq_mall/cores/math_utils.dart';
import 'package:iq_mall/utils/ShColors.dart';

import '../../../widgets/Ui.dart';
import '../store_request_controller.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

// for Factory
class StoreLocationPicker extends StatefulWidget {
  @override
  _StoreLocationPickerState createState() => _StoreLocationPickerState();
}

class _StoreLocationPickerState extends State<StoreLocationPicker> {
  GoogleMapController? mapController;
  StoreRequestController controller = Get.find();

  bool fetchingLocation = false;

  bool _isDraggable = false;

  @override
  void initState() {
    super.initState();
    _updateTextFields();
    Future.delayed(const Duration(milliseconds: 100)).then((value) {
      if (controller.args == null) {
        fetchUserLocation(Get.context!);
      }
    });
  }

  void fetchUserLocation(BuildContext context) async {
    final position = await getCurrentLocation(context);
    if (position != null) {
      print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
      controller.latController.text = position.latitude.toString();
      controller.lngController.text = position.longitude.toString();
      controller.markerPosition = LatLng(position.latitude, position.longitude);
      mapController?.animateCamera(CameraUpdate.newLatLng(controller.markerPosition));
      // Use lat/lng as needed
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to get location')),
      );
    }
  }

  Future<Position?> getCurrentLocation(BuildContext context) async {
    setState(() {
      fetchingLocation = true;
    });

    try {
      // Request permission if needed
      if (await Permission.location.isDenied || await Permission.location.isRestricted) {
        var result = await Permission.location.request();
        if (!result.isGranted) {
          await openAppSettings(); // Ask to enable manually
          // Delay and re-check
          await Future.delayed(const Duration(seconds: 3));
          if (!await Permission.location.isGranted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location permission is still denied.')),
            );
            setState(() => fetchingLocation = false);
            return null;
          }
        }
      }

      // Check if location services are on
      if (!await Geolocator.isLocationServiceEnabled()) {
        await Geolocator.openLocationSettings();
        await Future.delayed(const Duration(seconds: 3)); // wait a bit after settings
        if (!await Geolocator.isLocationServiceEnabled()) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location services are still disabled.')),
          );
          setState(() => fetchingLocation = false);
          return null;
        }
      }

      // Get location
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() => fetchingLocation = false);
      return position;
    } catch (e) {
      setState(() => fetchingLocation = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: $e')),
      );
      return null;
    }
  }

  void _updateTextFields() {
    controller.latController.text = controller.markerPosition.latitude.toStringAsFixed(12);
    controller.lngController.text = controller.markerPosition.longitude.toStringAsFixed(12);
  }

  void _updateMarkerFromText() {
    final double? lat = double.tryParse(controller.latController.text);
    final double? lng = double.tryParse(controller.lngController.text);
    if (lat != null && lng != null) {
      setState(() {
        controller.markerPosition = LatLng(lat, lng);
        mapController?.animateCamera(CameraUpdate.newLatLng(controller.markerPosition));
      });
    }
  }

  void _onMapTap(LatLng position) {
    if (_isDraggable) {
      setState(() {
        controller.markerPosition = position;
        _updateTextFields();
      });
    }
  }

  void _onMarkerDragEnd(LatLng newPosition) {
    if (_isDraggable) {
      setState(() {
        controller.markerPosition = newPosition;
        _updateTextFields();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Use flexible here, not a fixed height Column child
        Flexible(
          flex: 1,
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              AbsorbPointer(
                absorbing: !_isDraggable, // 👈 disables map when false
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: controller.markerPosition,
                        zoom: 15,
                      ),
                      onMapCreated: (controller) => mapController = controller,
                      markers: {
                        Marker(
                          markerId: const MarkerId("store"),
                          position: controller.markerPosition,
                          draggable: _isDraggable,
                          onDragEnd: _onMarkerDragEnd,
                        ),
                      },
                      onTap: _onMapTap,
                      scrollGesturesEnabled: _isDraggable,
                      zoomGesturesEnabled: _isDraggable,
                      rotateGesturesEnabled: _isDraggable,
                      tiltGesturesEnabled: _isDraggable,
                      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                        Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
                      },
                    ),
                    fetchingLocation ? Ui.circularIndicatorDefault(color: ColorConstant.logoFirstColorConstant, width: 50, height: 50) : const SizedBox(),
                  ],
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if (_isDraggable) {
                    // Save and exit edit mode
                    setState(() {
                      _isDraggable = false;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Location saved")),
                    );
                  } else {
                    // Enter edit mode
                    setState(() {
                      _isDraggable = true;
                    });
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      decoration: BoxDecoration(
                        color: _isDraggable ? Colors.green[400] : Colors.blue[400],
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 5,
                            offset: const Offset(-2, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(5),
                      child: Icon(_isDraggable ? Icons.save : Icons.edit_location_alt, color: Colors.white, size: getSize(30))),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              TextField(
                controller: controller.latController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Latitude',
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => _updateMarkerFromText(),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller.lngController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Longitude',
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => _updateMarkerFromText(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
