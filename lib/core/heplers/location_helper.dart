import 'dart:async';
import 'dart:developer' as dev;
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/style/app_color.dart';

class LocationHelper {
  LocationHelper._();

  /// Get the current location of the device.
  static Future<Position> getCurrentPosition() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        dev.log('❌ Location services are disabled.');
        await Geolocator.requestPermission();
      }

      // Check permission
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        dev.log('❌ Location permissions permanently denied.');
        await openAppSettings();
      }

      if (permission == LocationPermission.denied) {
        dev.log('❌ Location permissions denied by user.');
      }

      // Get current position
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 0,
        ),
      );
    } catch (e) {
      dev.log("⚠️ Error getting location: $e");
      rethrow;
    }
  }

  ///  Get Address from LatLng;
  static Future<String> getAddressFromLatLng(LatLng position) async {
    await setLocaleIdentifier("ar");
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    Placemark place = placemarks[0];
    dev.log(
      "\x1B[32m Current Address [administrativeArea]: ${place.administrativeArea}",
    );
    dev.log(
      "\x1B[32m Current Address [subAdministrativeArea]: ${place.subAdministrativeArea}",
    );
    dev.log("\x1B[32m Current Address [locality]: ${place.locality}");
    dev.log("\x1B[32m Current Address [subLocality]: ${place.subLocality}");
    dev.log("\x1B[32m Current Address [thoroughfare]: ${place.thoroughfare}");
    dev.log(
      "\x1B[32m Current Address [subThoroughfare]: ${place.subThoroughfare}",
    );
    dev.log("\x1B[32m Current Address [country]: ${place.country}");
    dev.log("\x1B[32m Current Address [name]: ${place.name}");
    dev.log("\x1B[32m Current Address [street]: ${place.street}");
    dev.log(
      "\x1B[32m Current Address [isoCountryCode]: ${place.isoCountryCode}",
    );
    dev.log("\x1B[32m Current Address [postalCode]: ${place.postalCode}");

    final String address =
        '${_addressJoin(place.street)}${_addressJoin(place.locality)}${_addressJoin(place.administrativeArea)}${_addressJoin(place.postalCode)} ${place.country ?? ""}';
    return address;
  }

  static String _addressJoin(String? v) {
    final bool valid = v != null && v.isNotEmpty;
    return "${v ?? ""}${valid ? ", " : ""}";
  }

  static double calculateDistance({
    required LatLng fromLocation,
    required LatLng toLocation,
  }) {
    final double lat1 = fromLocation.latitude;
    final double lon1 = fromLocation.longitude;
    final double lat2 = toLocation.latitude;
    final double lon2 = toLocation.longitude;
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000;
  }

  static Future<void> moveCamera({
    required Completer<GoogleMapController> controller,
    required LatLng target,
    double zoom = 0,
  }) async {
    if (controller.isCompleted) {
      await controller.future.then((value) async {
        await value.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: target, zoom: zoom),
          ),
        );
      });
    }
  }

  static cameraMoveBounds({
    required LatLng fromLocation,
    required LatLng toLocation,
    LatLngBounds? bounds,
    required Completer<GoogleMapController> controller,
  }) async {
    var latFrom = fromLocation.latitude;
    var lngFrom = fromLocation.longitude;
    var latTo = toLocation.latitude;
    var lngTo = toLocation.longitude;
    double sLat, sLng, nLat, nLng;

    if (latFrom <= latTo) {
      sLat = latFrom;
      nLat = latTo;
    } else {
      sLat = latTo;
      nLat = latFrom;
    }

    if (lngFrom <= lngTo) {
      sLng = lngFrom;
      nLng = lngTo;
    } else {
      sLng = lngTo;
      nLng = lngFrom;
    }
    if (controller.isCompleted) {
      controller.future.then(
        (value) => value.moveCamera(
          CameraUpdate.newLatLngBounds(
            bounds ??
                LatLngBounds(
                  southwest: LatLng(sLat, sLng),
                  northeast: LatLng(nLat, nLng),
                ),
            150,
          ),
        ),
      );
    }
  }

  static Future<Marker> createMarker({
    required LatLng position,
    String? title,
    int? size,
    required MarkerId markerId,
    required String image,
  }) async {
    return Marker(
      markerId: markerId,
      position: position,
      anchor: const Offset(.5, .5),
      infoWindow: InfoWindow(title: title),
      icon: BitmapDescriptor.bytes(
        await _getBytesFromAsset(image, size ?? 100) ?? Uint8List(0),
      ),
    );
  }

  static Future<Uint8List?> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(
      format: ui.ImageByteFormat.png,
    ))?.buffer.asUint8List();
  }

  static bool comparePosition({
    required LatLng? position1,
    required LatLng? position2,
  }) {
    if (position1 != null && position2 != null) {
      return position1 == position2;
    } else {
      return false;
    }
  }

  static Future<Polyline> createPolyline({
    required PolylineId polylineId,
    required List<LatLng> points,
    Color? color,
  }) async {
    final Polyline polyline = Polyline(
      polylineId: polylineId,
      consumeTapEvents: true,
      color: color ?? AppColors.primary,
      width: 2,
      points: points,
    );
    return polyline;
  }

  static launchLocation(LatLng location) async {
    String googleUrl =
        'http://maps.google.com/maps?q=${location.latitude},${location.longitude}';
    await launchUrl(Uri.parse(googleUrl), mode: LaunchMode.externalApplication);
  }

  static launchDirections({
    required LatLng fromLocation,
    required LatLng toLocation,
  }) async {
    String googleUrl =
        'https://www.google.com/maps/dir/?api=1&origin=${fromLocation.latitude},${fromLocation.longitude}&destination=${toLocation.latitude},${toLocation.longitude}';
    await launchUrl(Uri.parse(googleUrl), mode: LaunchMode.externalApplication);
  }
}
