import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakcamera_getx/component/main_dialog_component.dart';
import 'package:sakcamera_getx/compute/checkdevice_compute.dart';
import 'package:sakcamera_getx/controller/user_controller.dart';
import 'package:sakcamera_getx/database/shared_preferences/shared_preferences_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingController extends GetxController {
  late UserController usercontroller;

  /// เก็บ constraint ล่าสุดของ preview
  /// สำคัญมาก ใช้คำนวณตำแหน่ง logo / map / text ตอน process รูป
  var lastconstraints = Rx<BoxConstraints?>(null);

  bool layoutready = false; // true เมื่อ layout พร้อม (ใช้ก่อน takePicture)

  RxBool switchmap = false.obs; // สลับแผนที่
  RxBool switchwatermark = false.obs; // แนบลายน้ำ

  RxBool switchingmap = false.obs; // กันกดสวิตแมพรัว

  final huaweibrand = false.obs; //เช็ค device huawei

  RxBool statusgms = true.obs;  //เช็ค สถานะ gms


  @override
  void onInit() {
    super.onInit();
    usercontroller = Get.find<UserController>();
    loadSetting();
    checkDevice();
  }

  Future checkDevice() async {
    final brand = await CheckDevice.checkDeviceBrand();

    // === ไม่ใช่ Huawei → ปล่อยผ่านทั้งหมด ===
    if (brand != 'huawei') {
      return;
    }

    if (brand == 'huawei') {
      final hasgms = await CheckDevice.hasGoogleMobileServices();

      huaweibrand.value = true;
      statusgms.value = hasgms;

      if (!hasgms) {
        // Huawei ไม่มี GMS → บังคับ FlutterMap
        switchmap.value = false;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(SharedPreferencesDatabase.switchmap, false);
        if (kDebugMode) {
          print('===>> Huawei (no GMS) → force FlutterMap');
        }
      } else {
        if (kDebugMode) {
          print('===>> Huawei (with GMS) → Google Map allowed');
        }
      }
    }
  }

  void loadSetting() async {
    final prefs = await SharedPreferences.getInstance();

    switchmap.value = prefs.getBool(SharedPreferencesDatabase.switchmap) ?? true;

    switchwatermark.value = prefs.getBool(SharedPreferencesDatabase.switchwatermark) ?? false;
  }

  Future submitLogout(BuildContext context) async {
    final result = await MainDialog.dialogPopup(
      context,
      true,
      'warning'.tr,
      message: 'warning_close_app'.tr,
      confirmbutton: 'ok'.tr,
      closebutton: 'cancel'.tr,
    );

    if (result == true) {
      await usercontroller.logout(); //ลบข้อมูลทุกอย่างก่อน

      Get.offAllNamed('/login');
    }
  }
}
