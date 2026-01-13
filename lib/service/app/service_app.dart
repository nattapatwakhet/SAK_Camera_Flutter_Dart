import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:sakcamera_getx/constant/main_constant.dart';
import 'package:sakcamera_getx/model/app/version_app_model.dart';
import 'package:sakcamera_getx/model/status_code_model.dart';


// import 'package:sakerp/service/line/line_service.dart';
// import 'package:sakerp/model/status_code_model.dart';

class AppService {
  dynamic dynamic1;
  String dynamic1error = 'error';
  StatusAndMessageModel? model1;
  StatusAndMessageModel model1error = StatusAndMessageModel(
    status: 0,
    message: 'error',
    dataildata: 'error',
  );
  VersionAppModel? model2;
  VersionAppModel model2error = VersionAppModel(
    res_CheckVersionApp_last: [
      VersionAppListModel(
        ipsv_version_IOS: 'error',
        ipsv_build_IOS: 'error',
        ipsv_DatetimeUpDate_IOS: 'error',
        ipsv_version_Android: 'error',
        ipsv_build_Android: 'error',
        ipsv_DatetimeUpDate_Android: 'error',
        ipsv_Detail_IOS: 'error',
        ipsv_Detail_Android: 'error',
      ),
    ],
  );

  Future<dynamic> getVersionApp(String url, {Map<String, String>? header}) async {
    try {
      if (kDebugMode) {
        log('===>> AppService getVersionApp send: $url, ${header ?? ''}');
      }
      http.Response response = await http
          .get(Uri.parse(url), headers: header)
          .timeout(
            const Duration(seconds: 90),
            onTimeout: () {
              return http.Response('error ===>> AppService getVersionApp timed out:', 408);
            },
          );
      if (kDebugMode) {
        log('===>> AppService getVersionApp status code: ${response.statusCode}');
        log('===>> AppService getVersionApp body: ${response.body}');
      }
      if (response.statusCode == 200) {
        dynamic response1 = json.decode(response.body);
        dynamic response2 = response1;
        if (kDebugMode) {
          log('===>> AppService getVersionApp decode: $response2');
        }
        if (response2.toString() == '[]' ||
            response2.toString().isEmpty ||
            response2.toString() == 'null' ||
            response2 == null) {
          if (kDebugMode) {
            log('===>> AppService getVersionApp return: null');
          }
          return null;
        } else {
          if (kDebugMode) {
            log('===>> AppService getVersionApp return: $response2');
          }
          return response2;
        }
      } else {
        if (kDebugMode) {
          log('error ===>> AppService getVersionApp return: $dynamic1error');
        }
        return dynamic1error;
      }
    } on TimeoutException catch (error) {
      if (kDebugMode) {
        log('error ===>> AppService getVersionApp timed out: $error');
        log('error ===>> AppService getVersionApp return: $dynamic1error');
      }
      return dynamic1error;
    } on SocketException catch (error) {
      if (kDebugMode) {
        log('error ===>> AppService getVersionApp socket: $error');
        log('error ===>> AppService getVersionApp return: $dynamic1error');
      }
      return dynamic1error;
    } on HttpException catch (error) {
      if (kDebugMode) {
        log('error ===>> AppService getVersionApp http: $error');
        log('error ===>> AppService getVersionApp return: $dynamic1error');
      }
      return dynamic1error;
    } catch (error) {
      if (kDebugMode) {
        log('error ===>> AppService getVersionApp un: $error');
        log('error ===>> AppService getVersionApp return: $dynamic1error');
      }
      return dynamic1error;
    }
  }

  Future<VersionAppModel?> getVersionAppServer(String string1) async {
    try {
      model2 = null;
      if (kDebugMode) {
        log('===>> AppService getVersionAppServer send: $string1');
      }
      http.Response response = await http
          .get(Uri.parse(MainConstant.apigetversionserver), headers: MainConstant.headers)
          .timeout(
            const Duration(seconds: 90),
            onTimeout: () {
              return http.Response('error ===>> AppService getVersionAppServer timed out:', 408);
            },
          );
      if (kDebugMode) {
        log('===>> AppService getVersionAppServer status code: ${response.statusCode}');
        log('===>> AppService getVersionAppServer body: ${response.body}');
      }
      if (response.statusCode == 200) {
        dynamic response1 = json.decode(response.body);
        dynamic response2 = response1;
        if (kDebugMode) {
          log('===>> AppService getVersionAppServer decode: $response2');
        }
        if (response2.toString() == '[]' ||
            response2.toString().isEmpty ||
            response2.toString() == 'null' ||
            response2 == null) {
          if (kDebugMode) {
            log('===>> AppService getVersionAppServer return: null');
          }
          return null;
        } else {
          Map<String, dynamic> json = response2;
          model2 = VersionAppModel.fromMap(json);
          if (kDebugMode) {
            log('===>> AppService getVersionAppServer return: $model2');
          }
          return model2;
        }
        // } else if (response.statusCode == 500) {
        //   await LineService()
        //       .postLine(
        //           string1, 'เซิร์ฟเวอร์ล้ม การเชื่อมต่อข้อมูลเซิร์ฟเวอร์ล้มเหลว')
        //       .then(
        //         (value) {},
        //       )
        //       .catchError(
        //     (error) {
        //       if (kDebugMode) {
        //         print(
        //           'error ===>> LineService postLine: $error',
        //         );
        //       }
        //     },
        //   );
        //   if (kDebugMode) {
        //     log(
        //       'error ===>> AppService getVersionAppServer return: $model2error',
        //     );
        //   }
        //   return model2error;
      } else {
        if (kDebugMode) {
          log('error ===>> AppService getVersionAppServer return: $model2error');
        }
        return model2error;
      }
    } on TimeoutException catch (error) {
      if (kDebugMode) {
        log('error ===>> AppService getVersionAppServer timed out: $error');

        log('error ===>> AppService getVersionAppServer return: $model2error');
      }
      return model2error;
    } on SocketException catch (error) {
      if (kDebugMode) {
        log('error ===>> AppService getVersionAppServer socket: $error');

        log('error ===>> AppService getVersionAppServer return: $model2error');
      }
      return model2error;
    } on HttpException catch (error) {
      if (kDebugMode) {
        log('error ===>> AppService getVersionAppServer http: $error');

        log('error ===>> AppService getVersionAppServer return: $model2error');
      }
      return model2error;
    } catch (error) {
      if (kDebugMode) {
        log('error ===>> AppService getVersionAppServer un: $error');

        log('error ===>> AppService getVersionAppServer return: $model2error');
      }
      return model2error;
    }
  }
}
