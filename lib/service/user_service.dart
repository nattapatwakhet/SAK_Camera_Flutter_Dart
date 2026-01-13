import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:sakcamera_getx/constant/main_constant.dart';
import 'package:sakcamera_getx/model/status_code_model.dart';
import 'package:sakcamera_getx/model/user/user_model.dart';


class UserService {
  http.Response? response;

  StatusAndMessageModel? model1;
  StatusAndMessageModel model1error = StatusAndMessageModel(
    status: 0,
    message: 'error',
    dataildata: 'error',
  );
  List<UserModel> model2 = [];
  static UserModel model2error = UserModel(
    username_2: 'error',
    user_ck_TypeJob: 'error',
    AcgU_code: 'error',
    ID_personnel: 'error',
    enforce_pass: 'error',
    enforce_openfilepass: 'error',
    status_user: 'error',
    title_name: 'error',
    firstname_PSN: 'error',
    lastname_PSN: 'error',
    PST_code: 'error',
    startworkdate_PSN: 'error',
    position: 'error',
    WP_code: 'error',
    workplace: 'error',
    belong_id: 'error',
    belong: 'error',
    region_id: 'error',
    region: 'error',
    check_jobBL: 'error',
    check_jobRG: 'error',
    check_jobDM: 'error',
    PSTLv_Code: 'error',
    token_set_version: 'error',
    token_set_message: 'error',
    WP_MB_Code: 'error',
    photo_PSN: 'error',
    MB_Name: 'error',
    address_PSN: 'error',
    moo_PSN: 'error',
    rillage_PSN: 'error',
    alley_PSN: 'error',
    street_PSN: 'error',
    district_PSN: 'error',
    amphoe_PSN: 'error',
    province_PSN: 'error',
    zipcode_PSN: 'error',
    email_PSN: 'error',
    phone_PSN: 'error',
    nickname_PSN: 'error',
     personnel_id: 'error',
     date: 'error'
  );
  List model3 = [];
  List model3error = [];

  Future<List?> postLogIn(String user, String password) async {
    model3 = [];
    try {
      if (kDebugMode) {
        log('===>> UserService postLogIn send: $user, $password');
      }
      String body = json.encode({"username_form": user, "password_form": password});
      if (kDebugMode) {
        log('===>> UserService postLogIn body: $body');
      }
      try {
        http.Response response = await http
            .post(Uri.parse(MainConstant.apigetlogin), headers: MainConstant.headers, body: body)
            .timeout(
              const Duration(seconds: 90),
              onTimeout: () {
                return http.Response('error ===>> UserService postLogIn timed out:', 408);
              },
            );
        if (kDebugMode) {
          log('===>> UserService postLogIn status code: ${response.statusCode}');
          log('===>> UserService postLogIn body: ${response.body}');
        }
        if (response.statusCode == 200) {
          dynamic response1 = response.body;
          dynamic response2 = response1;
          if (response2.toString() == '[]' ||
              response2.toString().isEmpty ||
              response2.toString() == 'null' ||
              response2.toString() == '' ||
              response2.toString() == 'clear' ||
              response2 == null) {
            if (kDebugMode) {
              log('===>> UserService postLogIn return: null');
            }
            return null;
          } else {
            model3.add(response2);
            if (kDebugMode) {
              log('===>> UserService postLogIn return: $model3');
            }

            return model3;
          }
        } else {
          if (kDebugMode) {
            log('===>> UserService postLogIn return: null');
          }
          return null;
        }
      } catch (error) {
        if (kDebugMode) {
          log('error ===>> UserService postLogIn timed out: $error');
          log('===>> UserService postLogIn return: null');
        }
        return null;
      }
    } on TimeoutException catch (error) {
      if (kDebugMode) {
        log('error ===>> UserService postLogIn timed out: $error');
        log('===>> UserService postLogIn return: null');
      }
      return null;
    } on SocketException catch (error) {
      if (kDebugMode) {
        log('error ===>> UserService postLogIn socket: $error');
        log('===>> UserService postLogIn return: null');
      }
      return null;
    } on HttpException catch (error) {
      if (kDebugMode) {
        log('error ===>> UserService postLogIn http: $error');
        log('===>> UserService postLogIn return: null');
      }
      return null;
    } catch (error) {
      if (kDebugMode) {
        log('error ===>> UserService postLogIn un: $error');
        log('===>> UserService postLogIn return: null');
      }
      return null;
    }
  }

  Future<UserModel?> getData(String idpersonnel) async {
    model2 = [];
    try {
      if (kDebugMode) {
        log('===>> UserService getData: $idpersonnel');
      }
      Uint8List byte1 = utf8.encode(idpersonnel);
      String base641 = base64.encode(byte1);
      if (kDebugMode) {
        log('===>> UserService getData encode: $base641');
      }
      String string1 = '${MainConstant.apigetuser}?idper=$base641';
      if (kDebugMode) {
        log('===>> UserService getData encode: $base641');
      }
      try {
        http.Response response = await http
            .get(Uri.parse(string1), headers: MainConstant.headers)
            .timeout(
              const Duration(seconds: 90),
              onTimeout: () {
                return http.Response('error ===>> UserService getData timed out:', 408);
              },
            );
        if (kDebugMode) {
          log('===>> UserService getData status code: ${response.statusCode}');
          log('===>> UserService getData body: ${response.body}');
        }
        if (response.statusCode == 200) {
          dynamic response1 = json.decode(response.body);
          dynamic response2 = json.decode(response1);
          if (kDebugMode) {
            log('===>> UserService getData decode: $response2');
          }
          if (response2.toString() == '[]' ||
              response2.toString().isEmpty ||
              response2.toString() == 'null' ||
              response2.toString() == '' ||
              response2.toString() == 'clear' ||
              response2 == null) {
            if (kDebugMode) {
              log('===>> UserService getData return: null');
            }
            return null;
          } else {
            Iterable<dynamic> jsonlength = response2;
            for (var item in jsonlength) {
              UserModel model = UserModel.fromMap(item);
              model2.add(model);
            }
            if (kDebugMode) {
              log('===>> UserService getData return: $model2');
            }
            return model2[0];
          }
        } else {
          model2.add(model2error);
          if (kDebugMode) {
            log('===>> UserService getData return: $model2');
          }
          return model2[0];
        }
      } catch (error) {
        if (kDebugMode) {
          log('error ===>> UserService postLogIn timed out: $error');
          log('===>> UserService postLogIn return: $model2');
        }
        return model2[0];
      }
    } on TimeoutException catch (error) {
      if (kDebugMode) {
        log('error ===>> UserService getData timed out: $error');
      }
      model2.add(model2error);
      if (kDebugMode) {
        log('===>> UserService getData return: $model2');
      }
      return model2[0];
    } on SocketException catch (error) {
      if (kDebugMode) {
        log('error ===>> UserService getData socket: $error');
      }
      model2.add(model2error);
      if (kDebugMode) {
        log('===>> UserService getData return: $model2');
      }
      return model2[0];
    } on HttpException catch (error) {
      if (kDebugMode) {
        log('error ===>> UserService getData http: $error');
      }
      model2.add(model2error);
      if (kDebugMode) {
        log('===>> UserService getData return: $model2');
      }
      return model2[0];
    } catch (error) {
      if (kDebugMode) {
        log('error ===>> UserService getData un: $error');
      }
      model2.add(model2error);
      if (kDebugMode) {
        log('===>> UserService getData return: $model2');
      }
      return model2[0];
    }
  }
}
