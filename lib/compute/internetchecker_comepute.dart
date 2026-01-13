import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:sakcamera_getx/component/main_flushbar_component.dart';
import 'package:sakcamera_getx/constant/main_constant.dart';

class InternetChecker extends GetxService {
  static InternetChecker get to => Get.find<InternetChecker>();

  //=== เช็คอินเทอร์เน็ตแบบเรียลไทม์ ===//
  StreamSubscription<InternetStatus>? internetchecker; //ตัวแปรเช็คเน็ต
  InternetStatus? laststatus; // เก็บสถานะก่อนหน้า
  bool internetconnected = false; //สถานะการเชื่อมต่อ
  bool firstcheck = false; //เพิ่ม flag ไม่ให้แสดงครั้งแรกที่เข้า

  // ฟังก์ชันที่รันใน isolate
  Future<bool> pinghost(String host) async {
    try {
      final result = await InternetAddress.lookup(host).timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  // ฟังก์ชันสาธารณะ ใช้ได้ในทุกไฟล์
  Future<bool> checkInternetConnection({String host = 'google.com'}) async {
    try {
      final result = await InternetAddress.lookup(host).timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future startRealInternetChecker() async {
    // ตรวจครั้งแรกก่อนฟัง stream
    final firstconnected = await checkInternetConnection();
    internetconnected = firstconnected;
    laststatus = firstconnected ? InternetStatus.connected : InternetStatus.disconnected;

    // ดึง context หลัง async เสร็จ และตรวจ null ก่อนใช้งาน
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = Get.context; // ดึงใหม่หลัง async
      if (context == null) {
        return;
      }
      if (!firstconnected) {
        MainFlushbar.showFlushbar(
          context,
          title: 'warning'.tr,
          message: 'disconnect_internet_message'.tr,
          color: MainConstant.red,
          textColor: MainConstant.white,
          icon: Icons.wifi_off,
        );
      }
    });

    // ฟังการเปลี่ยนแปลงสถานะอินเทอร์เน็ต
    internetchecker ??= InternetConnection().onStatusChange.listen((InternetStatus status) async {
      final realcheck = await checkInternetConnection();
      internetconnected = realcheck;

      // ป้องกันครั้งแรก
      if (!firstcheck) {
        firstcheck = true;
        laststatus = internetconnected ? InternetStatus.connected : InternetStatus.disconnected;
        return;
      }

      final currentstatus = internetconnected
          ? InternetStatus.connected
          : InternetStatus.disconnected;
      if (currentstatus == laststatus) return;

      laststatus = status;

      // ดึง context หลัง async เสร็จ และตรวจ null ก่อนใช้งาน
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final context = Get.context;
        if (context == null) {
          return;
        }
        if (!internetconnected) {
          MainFlushbar.showFlushbar(
            context,
            title: 'warning'.tr,
            message: 'disconnect_internet_message'.tr,
            color: MainConstant.red,
            textColor: MainConstant.white,
            icon: Icons.wifi_off,
          );
        } else {
          MainFlushbar.showFlushbar(
            context,
            title: 'warning'.tr,
            message: 'connect_internet_message'.tr,
            color: MainConstant.greenn,
            textColor: MainConstant.white,
            icon: Icons.wifi,
          );
        }
      });
    });
  }

  void stopRealInternetChecker() {
    internetchecker?.cancel();
    internetchecker = null;
    MainFlushbar.activeflushbar?.dismiss();
  }

  @override
  void onClose() {
    stopRealInternetChecker();
    super.onClose();
  }
}
