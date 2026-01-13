import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakcamera_getx/component/main_flushbar_component.dart';
import 'package:sakcamera_getx/compute/internetchecker_comepute.dart';
import 'package:sakcamera_getx/constant/main_constant.dart';
import 'package:sakcamera_getx/controller/user_controller.dart';

class LoginController extends GetxController {
  final userCtrl = Get.find<UserController>(); // โหลด UserController ที่ผูกไว้

  //============================================
  //== SECTION: ตัวแปรและ state หลัก
  //============================================
  final formkey = GlobalKey<FormState>(); //ผูกกับ Form() เพื่อใช้ตรวจสอบ validate
  final scrollcontroller = ScrollController(); //ควบคุมการเลื่อนในหน้า Login

  final TextEditingController userid = TextEditingController(text: 'sak@'); //ตัวแปรชื่อผู้ใช้
  final TextEditingController password = TextEditingController(); //ตัวแปรรหัสผ่าน

  // ค่าที่ต้องสังเกตด้วย Obx
  var uservalidation = false.obs;
  var passwordvalidation = false.obs;
  var showpassword = true.obs;
  var isloading = false.obs;

  var checkpopupstatus = false.obs; //เก็บสถานะ popup แบบ observable (Obx() ใช้ได้)
  var lastconstraints = Rx<BoxConstraints?>(null); //เก็บขนาดของ layout ล่าสุด

  //============================================
  //== SECTION: ตัวแปรและ state หลัก
  //============================================

  void changeValidationUser(String value) {
    uservalidation.value = value.isEmpty;
  }

  void changeValidationPassword(String value) {
    passwordvalidation.value = value.isEmpty;
  }

  void switchEye() {
    showpassword.value = !showpassword.value;
  }

  //=== เช็ค Validation ตอนกดปุ่มก่อนไปหา API ===//
  Future submitCheckLogin(BoxConstraints constraints) async {
    try {
      // ตรวจสอบว่ามีการสร้างฟอร์มแล้วหรือยัง
      if (formkey.currentState != null) {
        // เรียก validate() เพื่อเช็คทุกช่องในฟอร์ม
        bool checkvalidation = formkey.currentState!.validate();

        if (checkvalidation) {
          // ผ่านการตรวจสอบทั้งหมด
          uservalidation.value = false;
          passwordvalidation.value = false;

          if (kDebugMode) {
            print('Username: ${userid.text}');
            print('Password: ${password.text}');
          }

          //เช็คสถานะอินเทอร์เน็ตก่อนเรียก API
          final context = Get.context;
          if (context == null) {
            return;
          }

          // final hasInternet = InternetCheckerService.to.internetconnected;
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

          //มีเน็ตเรียก API ต่อ

          //🔥 เรียก UserController ที่ถูกต้อง
          await userCtrl.postLogin(userid.text, password.text);
        } else {
          uservalidation.value = userid.text.isEmpty;
          passwordvalidation.value = password.text.isEmpty;
        }
      }
    } catch (error) {
      if (kDebugMode) print('error ===>> Class(LoginController){submitCheckLogin}: $error');
    }
  }
  //=== เช็ค Validation ตอนกดปุ่มก่อนไปหา API ===//

  //============================================
  //== SECTION: Lifecycle
  //============================================
  @override
  void onInit() async {
    super.onInit();
    safeRun(() async {
      await InternetChecker.to.startRealInternetChecker(); // เรียก stream เช็กเน็ต
    }, tag: 'LoginController (InternetChecker)');
  }

  @override
  void onClose() {
    super.onClose();
    InternetChecker.to.stopRealInternetChecker();
    scrollcontroller.dispose();
    userid.dispose();
    password.dispose();
  }

  Future<T?> safeRun<T>(Future<T> Function() task, {String? tag}) async {
    if (isClosed) return null; // Controller ถูกปิด ไม่ต้องทำอะไร
    try {
      if (!isClosed) {
        final result = await task();
        return result;
      }
    } catch (error, stack) {
      if (kDebugMode) {
        print('error ===>> ${tag ?? "safeRun"}: $error $stack');
      }
    }
    return null;
  }
}
