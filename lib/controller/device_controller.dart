import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';

class DeviceController extends GetxController {
  final devicebrand = false.obs;
  final manufacture = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkDeviceHuawei();
  }

  Future checkDeviceHuawei() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;

      final devicestatus = androidInfo.manufacturer.toLowerCase();

      manufacture.value = devicestatus;
      if (devicestatus == 'huawei') {
        devicebrand.value = true;
      } else {
        devicebrand.value = false;
      }
    }
  }
}
