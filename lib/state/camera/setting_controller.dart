import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sakcamera_getx/component/main_dialog_component.dart';
import 'package:sakcamera_getx/controller/user_controller.dart';

class SettingController extends GetxController {
  late UserController usercontroller;

  /// เก็บ constraint ล่าสุดของ preview
  /// สำคัญมาก ใช้คำนวณตำแหน่ง logo / map / text ตอน process รูป
  var lastconstraints = Rx<BoxConstraints?>(null);

  bool layoutready = false; // true เมื่อ layout พร้อม (ใช้ก่อน takePicture)

  RxBool switchmap = false.obs; // สลับแผนที่
  RxBool switchlicense = false.obs; // แนบลายน้ำ
  @override
  void onInit() {
    super.onInit();
    usercontroller = Get.find<UserController>();
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
