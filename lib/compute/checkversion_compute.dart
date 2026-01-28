import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sakcamera_getx/component/main_dialog_component.dart';
import 'package:sakcamera_getx/compute/internetchecker_compute.dart';
import 'package:sakcamera_getx/constant/main_constant.dart';
import 'package:sakcamera_getx/database/shared_preferences/shared_preferences_database.dart';
import 'package:sakcamera_getx/service/app/service_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckVersion {
  static Future getVersionApp() async {
    try {
      final context = Get.context;
      if (context == null) {
        return;
      }

      SharedPreferences sharedpreferences = await SharedPreferences.getInstance();
      String? idpersonnel = sharedpreferences.getString(SharedPreferencesDatabase.personnelid);
      final bool statusinternet = await InternetChecker.to
          .checkInternetConnection()
          .timeout(Duration(seconds: 90))
          .catchError((error) {
            if (kDebugMode) {
              print('object');
            }
            return false;
          });

      if (!statusinternet) {
        if (kDebugMode) {
          print('error ===>> No Internet Connection');
        }
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          final context = Get.context;
          if (context != null) {
            await MainDialog.dialogPopup(
              context,
              true,
              'warning'.tr,
              message: 'disconnect_internet_message'.tr,
            );
          }
        });
        return null;
      }

      final result = await AppService().getVersionAppServer(idpersonnel ?? '');
      if (result == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          final context = Get.context;
          if (context != null) {
            await MainDialog.dialogPopup(context, true, 'error'.tr, message: 'error_message'.tr);
          }
        });
        return;
      } else {
        final versionappmodel = result;
        String? storeversions;
        String versions = MainConstant.version;

        if (Platform.isIOS) {
          storeversions = versionappmodel.res_CheckVersionApp_last[0].ipsv_version_IOS;
        } else if (Platform.isAndroid) {
          storeversions = versionappmodel.res_CheckVersionApp_last[0].ipsv_version_Android;
        }

        if (storeversions != null) {
          if (kDebugMode) {
            print('object');
          }

          int versions1 = int.parse(versions.substring(0, 1));
          int versions2 = int.parse(versions.substring(2, 3));
          int versions3 = int.parse(versions.substring(4, 5));
          int storeversions1 = int.parse(storeversions.substring(0, 1));
          int storeversions2 = int.parse(storeversions.substring(2, 3));
          int storeversions3 = int.parse(storeversions.substring(4, 5));

          int intversions = int.parse('$versions1$versions2$versions3');
          int intstoreversions = int.parse('$storeversions1$storeversions2$storeversions3');

          if (intstoreversions - intversions >= 2) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              await MainDialog()
                  .updateVersionDialog(
                    context,
                    'warning_checkversion'.tr,
                    '${'current_version'.tr} $versions',
                    '${'update_version'.tr}$storeversions',
                  )
                  .catchError((error) {
                    if (kDebugMode) {
                      print('error ===>> MyDialog updateVersionDialog: $error');
                    }
                  });
            });
          } else if (intstoreversions - intversions >= 1) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              await MainDialog()
                  .confirmupdateVersionDialog(
                    context,
                    'warning_checkversion'.tr,
                    '${'current_version'.tr} $versions',
                    '${'update_version'.tr}$storeversions',
                  )
                  .catchError((error) {
                    if (kDebugMode) {
                      print('error ===>> MyDialog updateVersionDialog: $error');
                    }
                  });
            });
          }
          return {
            'storeversions': storeversions,
            'intstoreversions': intstoreversions,
            'intversions': intversions,
          };
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('object');
      }
    }
  }
}
