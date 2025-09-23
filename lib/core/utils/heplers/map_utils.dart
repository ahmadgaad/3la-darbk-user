// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/style/app_color.dart';

class MapUtils {
    MapUtils._();

  static Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        )
        
    );
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

  static moveCamera(
      {required Completer<GoogleMapController> controller,
      required LatLng target,
      double zoom = 0}) async {
    if (controller.isCompleted) {
      await controller.future.then((value) async {
        await value.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: target,
          zoom: zoom,
        )));
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
      controller.future.then((value) => value.moveCamera(
            CameraUpdate.newLatLngBounds(
              bounds ??
                  LatLngBounds(
                    southwest: LatLng(sLat, sLng),
                    northeast: LatLng(nLat, nLng),
                  ),
              150,
            ),
          ));
    }
  }

  static Future<Marker> createMarker(
      {required LatLng position,
      String? title,
      int? size,
      required MarkerId markerId,
      required String image}) async {
    return Marker(
        markerId: markerId,
        position: position,
        anchor: const Offset(.5, .5),
        infoWindow: InfoWindow(title: title),
        icon: BitmapDescriptor.bytes(
            await _getBytesFromAsset(image, size ?? 100) ?? Uint8List(0)));
  }

  static Future<Uint8List?> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        ?.buffer
        .asUint8List();
  }

  static bool comparePosition(
      {required LatLng? position1, required LatLng? position2}) {
    if (position1 != null && position2 != null) {
      return position1 == position2;
    } else {
      return false;
    }
  }
   static Future<Polyline> createPolyline(
      {required PolylineId polylineId,
      required List<LatLng> points,
      Color? color}) async {
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
    await launchUrl(
      Uri.parse(googleUrl),
      mode: LaunchMode.externalApplication,
    );
  }

  static launchDirections({required LatLng fromLocation, required LatLng toLocation}) async {
    String googleUrl =
        'https://www.google.com/maps/dir/?api=1&origin=${fromLocation.latitude},${fromLocation.longitude}&destination=${toLocation.latitude},${toLocation.longitude}';
    await launchUrl(
      Uri.parse(googleUrl),
      mode: LaunchMode.externalApplication,
    );
  }
}
