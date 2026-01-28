import 'package:flutter/foundation.dart';
import 'package:sakcamera_getx/database/sqflite/user/user_sqflite_database.dart';
import 'package:sakcamera_getx/state/camera/setting_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sakcamera_getx/controller/user_controller.dart';
import 'package:sakcamera_getx/database/shared_preferences/shared_preferences_database.dart';

class SettingReset {
  /// ===============================
  /// RESET EVERYTHING (ตามที่ขอ)
  /// ===============================
  static Future resetToDefault({
    required UserController usercontroller,
    required SettingController settingcontroller,
    required bool huaweibrand,
    required bool statusgms,
  }) async {
    await refreshUserData(usercontroller);
    // await resetPersonnelid(userController);
    await resetswitchsetting(
      settingController: settingcontroller,
      huaweibrand: huaweibrand,
      statusgms: statusgms,
    );

    if (kDebugMode) {
      print('===>> ResetAppCompute.resetAll DONE');
    }
  }

  // -------------------------------
  // 1. Reset SQLite
  // -------------------------------
  static Future refreshUserData(UserController userController) async {
    // 1. ล้าง SQLite
    final db = UserSQFLiteDatabase();
    await db.deleteAllData();

    // 2. ดึง API ใหม่ (ใช้ personnel_id เดิม)
    if (userController.idpersonnel != null) {
      await userController.getDataUser();
    }

    if (kDebugMode) {
      print('===>> Refresh user data from API completed');
    }
  }

  // -------------------------------
  // 2. Reset personal_id + โหลดใหม่
  // -------------------------------
  // static Future resetPersonnelid(UserController userController) async {
  //   final prefs = await SharedPreferences.getInstance();

  //   // ลบตัวตน
  //   await prefs.remove(SharedPreferencesDatabase.personnelid);

  //   // เคลียร์ state
  //   userController.idpersonnel = null;
  //   userController.usermodel.value = null;

  //   if (kDebugMode) {
  //     print('===>> Reset personnel_id completed (logout state)');
  //   }
  // }

  // -------------------------------
  // 3. Reset switch → ค่า default แอป
  // -------------------------------
  static Future resetswitchsetting({
    required SettingController settingController,
    required bool huaweibrand,
    required bool statusgms,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // ค่าเริ่มต้นของแอป
    bool defaultmap = true;
    bool defaultwatermark = false;

    // Huawei + ไม่มี GMS
    if (huaweibrand && !statusgms) {
      defaultmap = false;
    }

    // 1. save prefs
    await prefs.setBool(SharedPreferencesDatabase.switchmap, defaultmap);
    await prefs.setBool(SharedPreferencesDatabase.switchwatermark, defaultwatermark);

    // 2. update GetX state
    settingController.switchmap.value = defaultmap;
    settingController.switchwatermark.value = defaultwatermark;

    if (kDebugMode) {
      print('===>> Reset switch (map=$defaultmap, watermark=$defaultwatermark)');
    }
  }
}
