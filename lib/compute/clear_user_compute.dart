// camera_util.dart หรือ main_util.dart
import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:sakcamera_getx/database/sqflite/user/user_sqflite_database.dart';
import 'package:sakcamera_getx/model/user/user_model.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ClearUser {
  //===>> กล้องและแผนที่ <<===//
  static CameraController? cameracontroller;
  // static GoogleMapController? mapcontroller;

  //===>> ตัวจัดการเวลาและตำแหน่ง <<===//
  // static StreamSubscription? positionstream;
  // static Timer? focusreset;

  //===>> สถานะและข้อมูล <<===//
  // static bool admin = true;
  // static LatLng? currentlatlng;
  // static Set<Marker> markers = {};
  // static bool ismapready = false;
  // static bool fixmapmove = false;

  //===>> ข้อมูลผู้ใช้ <<===//
  static UserModel? usermodel;

  //===>> หยุดและรีเซ็ตค่าทุกอย่าง
  static Future clearController() async {
    try {
      //===>> หยุดกล้อง
      if (cameracontroller != null) {
        await cameracontroller!.pausePreview().catchError((error) {
          if (kDebugMode) print('error ===>> stop clearController: $error');
        });
        cameracontroller = null;
      }

      //===>> ปิด GoogleMapController
      // if (mapcontroller != null) {
      //   try {
      //     mapcontroller!.dispose();
      //     if (kDebugMode) print('===>> GoogleMapController disposed');
      //   } catch (error) {
      //     if (kDebugMode) print('error ===>> disposing mapcontroller: $error');
      //   }
      //   mapcontroller = null;
      // }

      //===>> ยกเลิกการ subscribe และ timer
      // await positionstream?.cancel();
      // focusreset?.cancel();
      // positionstream = null;
      // focusreset = null;

      //===>> เคลียร์ตัวแปรแผนที่/กล้อง
      // currentlatlng = null;
      // markers.clear();
      // ismapready = false;
      // fixmapmove = false;

      if (kDebugMode) print('===>> App Stop Camera & Map.');
    } catch (error) {
      if (kDebugMode) {
        print('error ===>> ClearUtil clearController : $error');
      }
    }
  }

  static Future clearUser() async {
    try {
      // เคลียร์ SQLite
      final userdatabase = UserSQFLiteDatabase();
      await userdatabase.createDatabase();
      await userdatabase.deleteAllData();

      // เคลียร์ SharedPreferences personnelid
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // หรือใช้ SharedPreferencesDatabase.personnelid
    } catch (error) {
      if (kDebugMode) {
        print('error ===>> ClearUtil clearUser : $error');
      }
    }
  }
}
