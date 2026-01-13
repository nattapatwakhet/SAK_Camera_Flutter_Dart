import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gm;

class MapController extends GetxController {
  final refreshmap = false.obs;
  final rotationangle = 0.obs;

  final Rxn<gm.LatLng> currentlatlnggoogle = Rxn();
  final googlemarker = <gm.Marker>{}.obs;
  final Rxn<gm.GoogleMapController> googlemapcontroller = Rxn();

  late gm.BitmapDescriptor custommarker;
  bool markerready = false;

  @override
  void onInit() {
    super.onInit();
    loadMarker();
  }

  Future setGoogleLatLng(gm.LatLng latlng, {double zoom = 18}) async {
    // โหลด marker ถ้ายังไม่พร้อม //
    if (!markerready) {
      await loadMarker();
    }
    // โหลด marker ถ้ายังไม่พร้อม //

    currentlatlnggoogle.value = latlng; // อัปเดตตำแหน่งปัจจุบัน
    setCurrentMarker(latlng); // สร้าง + ขยับ marker

    //ขยับกล้อง (ถ้า map ถูกสร้างแล้ว)//
    final g = googlemapcontroller.value;
    if (g != null) {
      g.animateCamera(gm.CameraUpdate.newLatLngZoom(latlng, zoom));
    } //ขยับกล้อง (ถ้า map ถูกสร้างแล้ว)//
  }

  void onGoogleMapCreated(gm.GoogleMapController controller) async {
    googlemapcontroller.value = controller;

    final latlng = currentlatlnggoogle.value;
    if (latlng != null) {
      await Future.delayed(const Duration(milliseconds: 300));
      controller.animateCamera(gm.CameraUpdate.newLatLngZoom(latlng, 18));
    }
  }

  void setCurrentMarker(gm.LatLng latlng) {
    if (!markerready) {
      return;
    }

    final marker = gm.Marker(
      markerId: const gm.MarkerId('current'),
      position: latlng,
      icon: custommarker,
      anchor: const Offset(0.5, 0.5),
      flat: true,
    );

    googlemarker
      ..clear()
      ..add(marker);
  }

  Future loadMarker() async {
    custommarker = await createResizedMarker(
      'assets/images/sakmarker_small.png',
      width: 65, //
    );
    markerready = true;
  }

  Future<gm.BitmapDescriptor> createResizedMarker(String assetPath, {int width = 65}) async {
    final data = await rootBundle.load(assetPath);
    final bytes = data.buffer.asUint8List();

    final codec = await ui.instantiateImageCodec(bytes, targetWidth: width);
    final frame = await codec.getNextFrame();
    final image = frame.image;

    final bytedata = await image.toByteData(format: ui.ImageByteFormat.png);
    return gm.BitmapDescriptor.fromBytes(bytedata!.buffer.asUint8List());
  }

  Future<bool> refreshGoogleMap({double? zoom, bool debug = false}) async {
    try {
      final latlng = currentlatlnggoogle.value;
      final controller = googlemapcontroller.value;

      if (latlng == null || controller == null) {
        // if (debug) {
        if (kDebugMode) {
          print(
            '===>> refreshGoogleMap cancelled '
            '(latlng: ${latlng != null}, controller: ${controller != null})',
          );
        }
        // }
        return false;
      }

      // marker ต้องพร้อม
      if (!markerready) {
        await loadMarker();
      }

      // if (debug) {
      if (kDebugMode) {
        print(
          '===>> refreshGoogleMap → '
          'lat=${latlng.latitude}, lng=${latlng.longitude}',
        );
      }
      // }

      // อัปเดต marker
      setCurrentMarker(latlng);

      // ขยับกล้อง
      if (zoom != null) {
        await controller.animateCamera(gm.CameraUpdate.newLatLngZoom(latlng, zoom));
      } else {
        await controller.animateCamera(gm.CameraUpdate.newLatLng(latlng));
      }

      return true;
    } catch (error) {
      if (kDebugMode) {
        print('===>> refreshGoogleMap error: $error');
      }
      return false;
    }
  }
}
