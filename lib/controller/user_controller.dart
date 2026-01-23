import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:lottie/lottie.dart';
import 'package:sakcamera_getx/component/main_dialog_component.dart';
import 'package:sakcamera_getx/constant/main_constant.dart';
import 'package:sakcamera_getx/database/shared_preferences/shared_preferences_database.dart';
import 'package:sakcamera_getx/database/sqflite/user/user_sqflite_database.dart';
import 'package:sakcamera_getx/model/login/login_model.dart';
import 'package:sakcamera_getx/model/status_code_model.dart';
import 'package:sakcamera_getx/model/user/user_model.dart';
import 'package:sakcamera_getx/service/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class UserController extends GetxController {
  // ส่วน API
  StatusAndMessageModel? statusandmessagemodel;
  String? idpersonnel;
  // UserModel? usermodel;
  var usermodel = Rxn<UserModel>();

  late bool statusgetuser = false;
  late DateTime datetimenow = DateTime.now();
  late UserSQFLiteDatabase? userdatabase;
  late bool statusgetuserdatabase = false;
  // ส่วน API

  Future postLogin(String userid, String password) async {
    final context = Get.overlayContext ?? Get.context;
    if (context == null) {
      return UserService.model2error;
    }

    try {
      // แสดง Loading Popup
      MainDialog.dialogPopup(context, true, 'login'.tr, message: 'loging_in'.tr, statusload: true);

      await UserService().postLogIn(userid, password).then((result) async {
        if (kDebugMode) {
          print('===>> ค่า result ที่ได้จาก postLogIn: $result');
        }

        // ปิด popup load
        if (Get.isDialogOpen == true) {
          Get.back();
        }

        try {
          if (result == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              await MainDialog.dialogPopup(
                context,
                true,
                'not_loging_in'.tr,
                message: 'warning_try_login_message'.tr,
              );
            });
          } else if (result[0].toString() == 'error') {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              await MainDialog.dialogPopup(
                context,
                true,
                'not_loging_in'.tr,
                message: 'warning_try_login_message'.tr,
              );
            });
          } else {
            final String checkstatus = result[0].toString().substring(0, 10);
            if (checkstatus == '{"status":') {
              final dynamic responselogin = json.decode(result[0]);
              statusandmessagemodel = null;
              statusandmessagemodel = StatusAndMessageModel.fromMap(responselogin);
              if (statusandmessagemodel != null) {
                if (statusandmessagemodel!.status == 901) {
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    await MainDialog.dialogPopup(
                      context,
                      true,
                      'status_901_head'.tr,
                      colortext: MainConstant.primary,
                      colorbackgroundtitle: MainConstant.yellow3,
                      message: 'status_901_message'.tr,
                      image: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/qrcode-service.png',
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  });
                } else if (statusandmessagemodel!.status == 902) {
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    await MainDialog.dialogPopup(
                      context,
                      true,
                      'status_902_head'.tr,
                      colorbackgroundtitle: MainConstant.red,
                      message: statusandmessagemodel!.message,
                      heightimage: 150,
                      image: Lottie.asset('assets/lottie/datacheck.json'),
                    );
                  });
                } else if (statusandmessagemodel!.status == 903) {
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    await MainDialog.dialogPopup(
                      context,
                      true,
                      'status_903_head'.tr,
                      colorbackgroundtitle: MainConstant.red,
                      message: statusandmessagemodel!.message,
                      heightimage: 150,
                      image: Lottie.asset('assets/lottie/lostpassword1.json'),
                    );
                  });
                } else {
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    await MainDialog.dialogPopup(
                      context,
                      true,
                      'not_loging_in'.tr,
                      message: statusandmessagemodel!.message,
                      // closebutton: "ตกลง",
                    );
                  });
                }
              } else {
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  await MainDialog.dialogPopup(
                    context,
                    true,
                    'not_loging_in'.tr,
                    message: 'warning_try_login_message'.tr,
                  );
                });
              }
            } else {
              // decode JWT token จาก login success
              final dynamic parts = result[0].split('.');
              final dynamic payload = parts[1];
              final String decoded = B64urlEncRfc7515.decodeUtf8(payload);
              final dynamic response = json.decode(decoded);
              final LoginModel loginmodel = LoginModel.fromMap(response[0]);
              if (kDebugMode) {
                print('===> ${loginmodel.ID_personnel}');
              }
              final SharedPreferences sharedpreferences = await SharedPreferences.getInstance();
              sharedpreferences.setString(
                SharedPreferencesDatabase.personnelid,
                loginmodel.ID_personnel,
              );
              idpersonnel = sharedpreferences.getString(SharedPreferencesDatabase.personnelid);

              idpersonnel = loginmodel.ID_personnel;

              if (idpersonnel != null) {
                usermodel.value = await getSQFLiteUser();
              }
              if (usermodel.value == null) {
                if (kDebugMode) {
                  print('===>> error Login postLogIn error: null');
                }

                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  await MainDialog.dialogPopup(
                    context,
                    true,
                    'not_loging_in'.tr,
                    message: 'warning_try_login_message'.tr,
                  );
                });
              } else if (usermodel.value != null) {
                Get.offNamed('/camera');
              } else {
                Get.offNamed('/camera');
              }
            }
          }
        } catch (error) {
          if (kDebugMode) {
            print('===>> error UserService postLogin $error');
          }
        }
      });
    } catch (error) {
      if (kDebugMode) {
        print('===>> error postLogin: $error');
      }
    }
  }

  Future<UserModel?> getSQFLiteUser() async {
    final context = Get.overlayContext ?? Get.context;
    if (context == null) {
      return UserService.model2error;
    }

    statusgetuser = false;
    usermodel.value = null;
    datetimenow = DateTime.now();

    // String string1 = DateFormat('yyyy-MM-dd').format(datetimenow);
    userdatabase = UserSQFLiteDatabase();
    if (userdatabase != null) {
      statusgetuserdatabase = await userdatabase!.createDatabase();
      if (statusgetuserdatabase) {
        List<UserModel>? model1 = await userdatabase!.getAllData(
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          idpersonnel,
          null,
        );
        if (model1 == null) {
          return await getDataUser().catchError((error) {
            if (kDebugMode) {
              print('error ===>> TimeAttendance getMarker: $error');
            }
            statusgetuser = false;
            return UserService.model2error;
          });
        } else {
          // if (model1[0].username_2 == 'error') {
          //   await MainDialog.dialogPopup(
          //     context,
          //     true,
          //     "เข้าสู่ระบบไม่สำเร็จ",
          //     message: "กรุณาลองเข้าสู่ระบบใหม่อีกครั้ง",
          //   );
          //   statusgetuser = false;
          //   return UserService.model2error;
          // } else {
          //   usermodel.value = model1[0];
          //   return usermodel.value;
          // }
          final UserModel localuser = model1[0];

          if (localuser.username_2 == 'error') {
            await MainDialog.dialogPopup(
              context,
              true,
              "เข้าสู่ระบบไม่สำเร็จ",
              message: "กรุณาลองเข้าสู่ระบบใหม่อีกครั้ง",
            );
            statusgetuser = false;
            return UserService.model2error;
          }

          // เพิ่ม: เช็กวันของข้อมูลใน SQLite
          if (!checkdateuser(localuser.date)) {
            if (kDebugMode) {
              print('===>> user data outdated (local=${localuser.date}) → refresh from API');
            }
            return await getDataUser(); // ดึงข้อมูลล่าสุด + update SQLite
          }
          if (kDebugMode) {
            print('===>> [status] getDataUser : date is today → use local');
          }

          // ข้อมูลยังเป็นของวันนี้ ใช้ต่อได้
          usermodel.value = localuser;
          return usermodel.value;
        }
      } else {
        return await getDataUser().catchError((error) {
          if (kDebugMode) {
            print('error ===>> TimeAttendance addMarker: $error');
          }
          statusgetuser = false;
          return UserService.model2error;
        });
      }
    }
    return UserService.model2error;
  }

  Future<UserModel?> getDataUser() async {
    final context = Get.overlayContext ?? Get.context;
    if (context == null) {
      return UserService.model2error;
    }
    if (kDebugMode) {
      print("===>> เรียก getUser() แล้ว");
    }

    statusgetuser = false;
    usermodel.value = null;
    datetimenow = DateTime.now();
    String string1 = DateFormat('yyyy-MM-dd').format(datetimenow);
    await UserService()
        .getData(idpersonnel!)
        .then((value) async {
          if (value == null) {
            statusgetuser = true;
            if (kDebugMode) {
              print('===>> getUser: value is null');
            }
            await MainDialog.dialogPopup(
              context,
              true,
              "เข้าสู่ระบบไม่สำเร็จ",
              message: "กรุณาลองเข้าสู่ระบบใหม่อีกครั้ง",
            );
            return value;
          } else if (value.username_2.toString() == 'error') {
            await MainDialog.dialogPopup(
              context,
              true,
              "เข้าสู่ระบบไม่สำเร็จ",
              message: "กรุณาลองเข้าสู่ระบบใหม่อีกครั้ง",
              // closebutton: "ตกลง",
            );
            return UserService.model2error;
          } else {
            userdatabase = UserSQFLiteDatabase();
            if (userdatabase != null) {
              statusgetuserdatabase = await userdatabase!.createDatabase();
              if (statusgetuserdatabase) {
                await userdatabase!.deleteAllData();
                List<UserModel> list1 = [];
                list1.add(value);
                await userdatabase!.rawInsertData(
                  list1.map((value) {
                    return UserModel(
                      ID_personnel: value.ID_personnel,
                      username_2: value.username_2,
                      user_ck_TypeJob: value.user_ck_TypeJob,
                      AcgU_code: value.AcgU_code,
                      enforce_pass: value.enforce_pass,
                      enforce_openfilepass: value.enforce_openfilepass,
                      status_user: value.status_user,
                      title_name: value.title_name,
                      firstname_PSN: value.firstname_PSN,
                      lastname_PSN: value.lastname_PSN,
                      PST_code: value.PST_code,
                      startworkdate_PSN: value.startworkdate_PSN,
                      position: value.position,
                      WP_code: value.WP_code,
                      workplace: value.workplace,
                      belong_id: value.belong_id,
                      belong: value.belong,
                      region_id: value.region_id,
                      region: value.region,
                      check_jobBL: value.check_jobBL,
                      check_jobRG: value.check_jobRG,
                      check_jobDM: value.check_jobDM,
                      PSTLv_Code: value.PSTLv_Code,
                      token_set_version: value.token_set_version,
                      token_set_message: value.token_set_message,
                      WP_MB_Code: value.WP_MB_Code,
                      photo_PSN: value.photo_PSN,
                      MB_Name: value.MB_Name,
                      address_PSN: value.address_PSN,
                      moo_PSN: value.moo_PSN,
                      rillage_PSN: value.rillage_PSN,
                      alley_PSN: value.alley_PSN,
                      street_PSN: value.street_PSN,
                      district_PSN: value.district_PSN,
                      amphoe_PSN: value.amphoe_PSN,
                      province_PSN: value.province_PSN,
                      zipcode_PSN: value.zipcode_PSN,
                      email_PSN: value.email_PSN,
                      phone_PSN: value.phone_PSN,
                      nickname_PSN: value.nickname_PSN,
                      personnel_id: idpersonnel != null ? idpersonnel! : '',
                      date: string1,
                    );
                  }).toList(),
                );
              }
              usermodel.value = value;
            }
          }

          statusgetuser = false;
          return usermodel.value ?? UserService.model2error;
        })
        .catchError((error) {
          if (kDebugMode) {
            print('error ===>> TimeAttendanceService getMarker: $error');
          }
          statusgetuser = false;
          return UserService.model2error;
        });

    statusgetuser = false;
    return usermodel.value ?? UserService.model2error;
  }

  Future loadUserFromLocal() async {
    if (kDebugMode) {
      print('===>> [status]: loadUserFromLocal()');
    }

    if (idpersonnel == null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      idpersonnel = prefs.getString(SharedPreferencesDatabase.personnelid);
      if (kDebugMode) {
        print('===>> [status] idpersonnel from prefs : $idpersonnel');
      }
    }

    if (idpersonnel != null) {
      usermodel.value = await getSQFLiteUser();
    }
    if (kDebugMode) {
      print('===>> [status] loadUserFromLocal done, usermodel=${usermodel.value}');
    }
  }

  //เช็ควันที่บันทึกข้อมูล
  bool checkdateuser(String? storedate) {
    // return false;
    if (storedate == null) {
      return false;
    }
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return storedate == today;
  }

  Future logout() async {
    if (kDebugMode) {
      print('===>> [LOGOUT] : start');
    }

    // 1. SharedPreferences (ล้างหมด)
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (kDebugMode) {
      print('===>> [LOGOUT] : SharedPreferences clear');
    }

    // 2. SQLite (ลบทั้ง database file)
    try {
      final dbpath = await getDatabasesPath();
      final fullPath = '$dbpath/SAKCAMERA.db';

      await deleteDatabase(fullPath);

      if (kDebugMode) {
        print('===>> [LOGOUT] SQLite delete: $fullPath');
      }
    } catch (error) {
      if (kDebugMode) {
        print('===>> [LOGOUT] SQLite delete error: $error');
      }
    }

    if (kDebugMode) {
      print('===>> [LOGOUT] finish');
    }
  }
}
