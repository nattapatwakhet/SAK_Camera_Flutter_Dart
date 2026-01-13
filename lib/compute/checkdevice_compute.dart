import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class CheckDevice {
  static Future checkDeviceBrand() async {
    try {
      if (Platform.isAndroid) {
        final info = await DeviceInfoPlugin().androidInfo;
        return info.brand.toLowerCase();
      } else if (Platform.isIOS) {
        return 'apple';
      } else {
        return "unknown";
      }
    } catch (error) {
      if (kDebugMode) {
        print('error ===>> CheckDevice.checkDeviceBrand: $error');
      }
    }
  }
}
