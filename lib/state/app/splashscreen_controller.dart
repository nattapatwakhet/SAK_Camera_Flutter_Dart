import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakcamera_getx/database/shared_preferences/shared_preferences_database.dart';
import 'package:sakcamera_getx/routes/sakcamera_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenController extends GetxController {
  var lastconstraints = Rx<BoxConstraints?>(null); //เก็บขนาดของ layout ล่าสุด
  final RxDouble progress = 0.0.obs; // เก็บค่าเปอร์เซ็นต์ (0.0 - 100.0)

  Future animateProgress(double target) async {
    while (progress.value < target) {
      progress.value += 1;
      await Future.delayed(const Duration(milliseconds: 10));
    }
    progress.value = target;
  }

  Future simulateLoading() async {
    const totalsteps = 2;
    int currentstep = 0;

    // STEP 1: โหลด shared pref
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    currentstep++;
    final target1 = (currentstep / totalsteps) * 100.0;
    await animateProgress(target1);

    // STEP 2: เช็ค userresult
    final String? userresult = prefs.getString(SharedPreferencesDatabase.personnelid);
    if (kDebugMode) {
      print('===>> Splash userresult: $userresult');
    }
    currentstep++;
    final target2 = (currentstep / totalsteps) * 100.0;
    await animateProgress(target2);

    // รอให้ frame ปัจจุบันเสร็จก่อนค่อยเปลี่ยนหน้า
    if (!isClosed) {
      if (userresult == null || userresult.isEmpty) {
        Get.offAllNamed(Routes.login);
      } else {
        Get.offAllNamed(Routes.camera);
      }
    }

    // if (!isClosed) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) async {
    //     final SharedPreferences prefs = await SharedPreferences.getInstance();
    //     final String? userresult = prefs.getString(SharedPreferencesDatabase.personnelid);
    //   });
    // }
  }

  @override
  void onInit() {
    super.onInit();
    simulateLoading();
  }
}
