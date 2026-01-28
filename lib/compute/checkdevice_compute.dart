import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class CheckDevice {
  static const MethodChannel channel = MethodChannel('com.sakcamera.check_gms');

  /// brand: huawei / samsung / etc.
  static Future<String> checkDeviceBrand() async {
    try {
      if (Platform.isAndroid) {
        final info = await DeviceInfoPlugin().androidInfo;
        return info.manufacturer.toLowerCase();
      } else if (Platform.isIOS) {
        return 'apple';
      } else {
        return 'unknown';
      }
    } catch (error) {
      if (kDebugMode) {
        print('error ===>> CheckDevice.checkDeviceBrand: $error');
      }
      return 'unknown';
    }
  }

  /// true = มี Google Mobile Services
  static Future<bool> hasGoogleMobileServices() async {
    if (!Platform.isAndroid) {
      return false;
    }

    try {
      final bool result = await channel.invokeMethod('hasGms');
      return result;
    } catch (error) {
      if (kDebugMode) {
        print('error ===>> CheckDevice.hasGoogleMobileServices: $error');
      }
      return false;
    }
  }
}
