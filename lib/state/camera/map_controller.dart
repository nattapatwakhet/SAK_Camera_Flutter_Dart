import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gm;
import 'package:latlong2/latlong.dart' as latlng;
import 'package:sakcamera_getx/compute/checkdevice_compute.dart';

class MapController extends GetxController {
  final refreshmap = false.obs;
  final rotationangle = 0.obs;

  final Rxn<gm.LatLng> currentlatlnggoogle = Rxn();
  final googlemarker = <gm.Marker>{}.obs;
  final Rxn<gm.GoogleMapController> googlemapcontroller = Rxn();

  late gm.BitmapDescriptor custommarker;
  bool markerready = false;

  final googlemapkey = const ValueKey('mini_map').obs;

  //Flutter map

  late fm.MapController fluttermapcontroller;
  final Rxn<latlng.LatLng> currentlatlngflutter = Rxn();
  final markersfluttermap = <fm.Marker>[].obs;
  final fluttermapkey = const ValueKey('mini_flutter_map').obs;

  int googlesession = 0; // token เพิ่มทุกครั้งที่รีเซ็ต
  final googlealive = false.obs; // map widget ยังอยู่ไหม

  final huaweibrand = false.obs; //เช็ค device huawei

  @override
  void onInit() {
    super.onInit();
    loadMarker();
    initFlutterMap();
    checkDevice();
  }

  @override
  void onClose() {
    // googlemapcontroller.value?.dispose();
    googlemapcontroller.value = null;
    super.onClose();
  }

  // void rebuildMapView(){
  //   googlemapkey.value =UniqueKey();
  //   googlemapcontroller.value= null;
  // }

  Future checkDevice() async {
    final brand = await CheckDevice.checkDeviceBrand();
    if (brand == 'huawei') {
      huaweibrand.value = true;
      if (kDebugMode) {
        print('===>> Huawei detected → force FlutterMap');
      }
    }
  }

  Future setGoogleLatLng(gm.LatLng glatlng, {double zoom = 17.5}) async {
    // โหลด marker ถ้ายังไม่พร้อม //
    if (!markerready) {
      await loadMarker();
    }
    // โหลด marker ถ้ายังไม่พร้อม //

    currentlatlnggoogle.value = glatlng; // อัปเดตตำแหน่งปัจจุบัน
    setCurrentMarker(glatlng); // สร้าง + ขยับ marker

    //  Flutter (สำคัญ)
    final f = latlng.LatLng(glatlng.latitude, glatlng.longitude);
    currentlatlngflutter.value = f;
    markersfluttermap
      ..clear()
      ..add(
        fm.Marker(
          point: f,
          width: 30,
          height: 30,
          child: Image.asset('assets/images/sakmarker_small.png'),
        ),
      );
    //ขยับกล้อง (ถ้า map ถูกสร้างแล้ว) real-time//
    final googlemapmove = googlemapcontroller.value;
    if (googlemapmove != null && googlealive.value) {
      googlemapmove.animateCamera(gm.CameraUpdate.newLatLngZoom(glatlng, zoom));
    } //ขยับกล้อง (ถ้า map ถูกสร้างแล้ว) real-time//
  }

  void onGoogleMapCreated(gm.GoogleMapController controller) async {
    final session = ++googlesession; // session ใหม่
    googlealive.value = true;
    googlemapcontroller.value = controller;

    final latlng = currentlatlnggoogle.value;
    if (latlng != null) {
      await Future.delayed(const Duration(milliseconds: 300));

      if (!googlealive.value || session != googlesession) {
        return;
      }

      controller.animateCamera(gm.CameraUpdate.newLatLngZoom(latlng, 17.5));
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
      width: 55, //
    );
    markerready = true;
  }

  Future<gm.BitmapDescriptor> createResizedMarker(String assetPath, {int width = 55}) async {
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

      if (latlng == null || controller == null || !googlealive.value) {
        if (kDebugMode) {
          print(
            '===>> refreshGoogleMap cancelled '
            '(latlng: ${latlng != null}, controller: ${controller != null})',
          );
        }

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

  void disposeGoogleMap() {
    googlesession++; // invalidate งาน async เก่าทั้งหมด
    googlealive.value = false;
    googlemapcontroller.value = null;
    googlemarker.clear();
  }

  void setFlutterLatLng(latlng.LatLng latlng, {double zoom = 17.5}) {
    currentlatlngflutter.value = latlng;

    //หมุดเลื่อนตามตำแหน่งจริง real-time
    fluttermapcontroller.move(latlng, fluttermapcontroller.camera.zoom);

    // อัปเดต marker
    markersfluttermap
      ..clear()
      ..add(
        fm.Marker(
          point: latlng,
          width: 30,
          height: 30,
          child: Image.asset('assets/images/sakmarker_small.png'),
        ),
      );
  }

  Future<bool> refreshFlutterMap({double? zoom}) async {
    final latlng = currentlatlngflutter.value;
    if (latlng == null) return false;

    try {
      fluttermapcontroller.move(latlng, zoom ?? fluttermapcontroller.camera.zoom);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('===>> refreshFlutterMap error: $e');
      }
      return false;
    }
  }

  void syncLatLngForFlutter() {
    final g = currentlatlnggoogle.value;
    if (g == null) return;

    final f = latlng.LatLng(g.latitude, g.longitude);

    currentlatlngflutter.value = f;

    markersfluttermap
      ..clear()
      ..add(
        fm.Marker(
          point: f,
          width: 30,
          height: 30,
          child: Image.asset('assets/images/sakmarker_small.png'),
        ),
      );
  }

  void initFlutterMap() {
    fluttermapcontroller = fm.MapController();
    markersfluttermap.clear();

    if (kDebugMode) {
      print('===>> initFlutterMap');
    }
  }
}
