import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakcamera_getx/component/main_flushbar_component.dart';
import 'package:sakcamera_getx/compute/internetchecker_comepute.dart';
import 'package:sakcamera_getx/compute/checkdevice_compute.dart';
import 'package:sakcamera_getx/compute/checkversion_compute.dart';
import 'package:sakcamera_getx/constant/main_constant.dart';
import 'package:sakcamera_getx/util/main_util.dart';

class CheckVersionController extends GetxController {
  final formkey = GlobalKey<FormState>();
  final scrollcontroller = ScrollController();

  // === ตัวแปรสถานะ ===
  var loadingversion = false.obs; // กำลังโหลด?
  String? storeversions; // เวอร์ชันจากเซิร์ฟเวอร์
  int? intstoreversions; // เวอร์ชันตัวเลขจากเซิร์ฟเวอร์
  int? intversions; // เวอร์ชันตัวเลขในแอป
  String? devicebrand; // device เครื่อง

  // === ฟังก์ชันหรือ getter สำหรับข้อความ ===//
  String get versionStatusMessage {
    if (loadingversion.value) {
      return 'checking_version'.tr;
    } else if (storeversions != null && intstoreversions != null && intversions != null) {
      if (intstoreversions! > intversions!) {
        return 'checking_version_update'.tr;
      } else {
        return 'version_uptodate'.tr;
      }
    } else {
      return 'version_faild'.tr;
    }
  }

  Color get versionStatusColor {
    if (loadingversion.value) {
      return MainConstant.primary;
    } else if (storeversions != null && intstoreversions != null && intversions != null) {
      if (intstoreversions! > intversions!) {
        return MainConstant.yellow3;
      } else {
        return MainConstant.primary;
      }
    } else {
      return MainConstant.red;
    }
  }

  String get nameStore {
    if (Platform.isAndroid) {
      return (devicebrand ?? '').contains('huawei') ? 'huawei_store'.tr : 'android_store'.tr;
    } else if (Platform.isIOS) {
      return 'ios_store'.tr;
    } else {
      return 'unknown_store'.tr;
    }
  }

  // ===> ส่วนปุ่ม <=== //
  Future checkVersion([BoxConstraints? constraints]) async {
    loadingversion.value = true;

    final context = Get.context;
    if (context == null) {
      loadingversion.value = false;
      return;
    }

    final statusinternet = await InternetChecker.to.checkInternetConnection();

    if (!statusinternet) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        MainFlushbar.showFlushbar(
          context,
          title: 'warning'.tr,
          message: 'disconnect_internet_message'.tr,
          color: MainConstant.red,
          textColor: MainConstant.white,
          icon: Icons.wifi_off,
        );
      });
      loadingversion.value = false;
      return;
    }

    // ดึงข้อมูลเวอร์ชันจากเซิร์ฟเวอร์
    final result = await CheckVersion.getVersionApp();
    if (result != null) {
      storeversions = result['storeversions'];
      intstoreversions = result['intstoreversions'];
      intversions = result['intversions'];
    }
    loadingversion.value = false;
  }
  // ===> ส่วนปุ่ม <=== //
  // === ฟังก์ชันหรือ getter สำหรับข้อความ ===//

  Future openStore(BuildContext context, BoxConstraints constraints) async {
    try {
      devicebrand = await CheckDevice.checkDeviceBrand();
      String url = '';
      if (Platform.isAndroid) {
        if ((devicebrand ?? '').contains('huawei')) {
          url = MainConstant.urlhuawei; // AppGallery Store
        } else {
          url = MainConstant.urlplaystore; // Play Store
        }
      } else if (Platform.isIOS) {
        url = MainConstant.urlappstore; // App Store
      }

      if (kDebugMode) {
        print('===>> device brand: $devicebrand');
        print('===>> package: $url');
      }

      final statusinternet = await InternetChecker.to.checkInternetConnection();
      if (!statusinternet) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          MainFlushbar.showFlushbar(
            context,
            title: 'warning'.tr,
            message: 'disconnect_internet_message'.tr,
            color: MainConstant.red,
            textColor: MainConstant.white,
            icon: Icons.wifi_off,
          );
        });
        return;
      }

      final canOpen = await MainUtil.canLaunchURL(url);
      if (canOpen) {
        await MainUtil.launchURL(url);
      } else {
        if (kDebugMode) {
          print('===>> cannot launch URL: $url');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('===>> openStore error: $error');
      }
    }
  }

  // === Lifecycle === //
  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    // เรียกเช็กเวอร์ชันทันทีเมื่อหน้าแสดง
    if (Get.context != null) {
      checkVersion();
    }
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
