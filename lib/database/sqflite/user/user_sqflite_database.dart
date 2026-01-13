import 'package:flutter/foundation.dart';
import 'package:sakcamera_getx/database/sqflite/sqflite_database.dart';
import 'package:sakcamera_getx/model/user/user_model.dart';
import 'package:sqflite/sqflite.dart';

class UserSQFLiteDatabase {
  Database? database;
  List<UserModel> model1 = [];
  UserModel model1error = UserModel(
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
    date: 'error',
  );
  String where = '';
  List whereargs = [];

  Future whereData(
    String? wherecolumnusername_2,
    String? wherecolumnuserCkTypejob,
    String? wherecolumnacguCode,
    String? wherecolumnidPersonnel,
    String? wherecolumnenforcePass,
    String? wherecolumnenforceOpenfilepass,
    String? wherecolumnstatusUser,
    String? wherecolumntitleName,
    String? wherecolumnfirstnamePsn,
    String? wherecolumnlastnamePsn,
    String? wherecolumnpstCode,
    String? wherecolumnstartworkdatePsn,
    String? wherecolumnposition,
    String? wherecolumnwpCode,
    String? wherecolumnworkplace,
    String? wherecolumnbelongId,
    String? wherecolumnbelong,
    String? wherecolumnregionId,
    String? wherecolumnregion,
    String? wherecolumncheckJobbl,
    String? wherecolumncheckJobrg,
    String? wherecolumncheckJobdm,
    String? wherecolumnpstlvCode,
    String? wherecolumntokenSetVersion,
    String? wherecolumntokenSetMessage,
    String? wherecolumnwpMbCode,
    String? wherecolumnphotoPsn,
    String? wherecolumnmbName,
    String? wherecolumnaddressPsn,
    String? wherecolumnmooPsn,
    String? wherecolumnrillagePsn,
    String? wherecolumnalleyPsn,
    String? wherecolumnstreetPsn,
    String? wherecolumndistrictPsn,
    String? wherecolumnamphoePsn,
    String? wherecolumnprovincePsn,
    String? wherecolumnzipcodePsn,
    String? wherecolumnemailPsn,
    String? wherecolumnphonePsn,
    String? wherecolumnnicknamePsn,
    String? wherecolumnpersonnelId,
    String? wherecolumndate,
  ) async {
    where = '';
    whereargs = [];
    if (wherecolumnusername_2 != null) {
      if (where.isEmpty) {
        where = '$wherecolumnusername_2 = ?';
      } else {
        where = '$where AND $wherecolumnusername_2  = ?';
      }
      whereargs.add(wherecolumnusername_2);
    }
    if (wherecolumnuserCkTypejob != null) {
      if (where.isEmpty) {
        where = '$wherecolumnuserCkTypejob = ?';
      } else {
        where = '$where AND $wherecolumnuserCkTypejob  = ?';
      }
      whereargs.add(wherecolumnuserCkTypejob);
    }
    if (wherecolumnacguCode != null) {
      if (where.isEmpty) {
        where = '$wherecolumnacguCode = ?';
      } else {
        where = '$where AND $wherecolumnacguCode  = ?';
      }
      whereargs.add(wherecolumnacguCode);
    }
    if (wherecolumnidPersonnel != null) {
      if (where.isEmpty) {
        where = '$wherecolumnidPersonnel = ?';
      } else {
        where = '$where AND $wherecolumnidPersonnel  = ?';
      }
      whereargs.add(wherecolumnidPersonnel);
    }
    if (wherecolumnenforcePass != null) {
      if (where.isEmpty) {
        where = '$wherecolumnenforcePass = ?';
      } else {
        where = '$where AND $wherecolumnenforcePass  = ?';
      }
      whereargs.add(wherecolumnenforcePass);
    }
    if (wherecolumnenforceOpenfilepass != null) {
      if (where.isEmpty) {
        where = '$wherecolumnenforceOpenfilepass = ?';
      } else {
        where = '$where AND $wherecolumnenforceOpenfilepass  = ?';
      }
      whereargs.add(wherecolumnenforceOpenfilepass);
    }
    if (wherecolumnstatusUser != null) {
      if (where.isEmpty) {
        where = '$wherecolumnstatusUser = ?';
      } else {
        where = '$where AND $wherecolumnstatusUser  = ?';
      }
      whereargs.add(wherecolumnstatusUser);
    }
    if (wherecolumnstatusUser != null) {
      if (where.isEmpty) {
        where = '$wherecolumnstatusUser = ?';
      } else {
        where = '$where AND $wherecolumnstatusUser  = ?';
      }
      whereargs.add(wherecolumnstatusUser);
    }
    if (wherecolumntitleName != null) {
      if (where.isEmpty) {
        where = '$wherecolumntitleName = ?';
      } else {
        where = '$where AND $wherecolumntitleName  = ?';
      }
      whereargs.add(wherecolumntitleName);
    }
    if (wherecolumnfirstnamePsn != null) {
      if (where.isEmpty) {
        where = '$wherecolumnfirstnamePsn = ?';
      } else {
        where = '$where AND $wherecolumnfirstnamePsn  = ?';
      }
      whereargs.add(wherecolumnfirstnamePsn);
    }
    if (wherecolumnlastnamePsn != null) {
      if (where.isEmpty) {
        where = '$wherecolumnlastnamePsn = ?';
      } else {
        where = '$where AND $wherecolumnlastnamePsn  = ?';
      }
      whereargs.add(wherecolumnlastnamePsn);
    }
    if (wherecolumnpstCode != null) {
      if (where.isEmpty) {
        where = '$wherecolumnpstCode = ?';
      } else {
        where = '$where AND $wherecolumnpstCode  = ?';
      }
      whereargs.add(wherecolumnpstCode);
    }
    if (wherecolumnstartworkdatePsn != null) {
      if (where.isEmpty) {
        where = '$wherecolumnstartworkdatePsn = ?';
      } else {
        where = '$where AND $wherecolumnstartworkdatePsn  = ?';
      }
      whereargs.add(wherecolumnstartworkdatePsn);
    }
    if (wherecolumnposition != null) {
      if (where.isEmpty) {
        where = '$wherecolumnposition = ?';
      } else {
        where = '$where AND $wherecolumnposition  = ?';
      }
      whereargs.add(wherecolumnposition);
    }
    if (wherecolumnwpCode != null) {
      if (where.isEmpty) {
        where = '$wherecolumnwpCode = ?';
      } else {
        where = '$where AND $wherecolumnwpCode  = ?';
      }
      whereargs.add(wherecolumnwpCode);
    }
    if (wherecolumnworkplace != null) {
      if (where.isEmpty) {
        where = '$wherecolumnworkplace = ?';
      } else {
        where = '$where AND $wherecolumnworkplace  = ?';
      }
      whereargs.add(wherecolumnworkplace);
    }
    if (wherecolumnbelongId != null) {
      if (where.isEmpty) {
        where = '$wherecolumnbelongId = ?';
      } else {
        where = '$where AND $wherecolumnbelongId  = ?';
      }
      whereargs.add(wherecolumnbelongId);
    }
    if (wherecolumnbelong != null) {
      if (where.isEmpty) {
        where = '$wherecolumnbelong = ?';
      } else {
        where = '$where AND $wherecolumnbelong  = ?';
      }
      whereargs.add(wherecolumnbelong);
    }
    if (wherecolumnregionId != null) {
      if (where.isEmpty) {
        where = '$wherecolumnregionId = ?';
      } else {
        where = '$where AND $wherecolumnregionId  = ?';
      }
      whereargs.add(wherecolumnregionId);
    }
    if (wherecolumnregion != null) {
      if (where.isEmpty) {
        where = '$wherecolumnregion = ?';
      } else {
        where = '$where AND $wherecolumnregion  = ?';
      }
      whereargs.add(wherecolumnregion);
    }
    if (wherecolumncheckJobbl != null) {
      if (where.isEmpty) {
        where = '$wherecolumncheckJobbl = ?';
      } else {
        where = '$where AND $wherecolumncheckJobbl  = ?';
      }
      whereargs.add(wherecolumncheckJobbl);
    }
    if (wherecolumncheckJobrg != null) {
      if (where.isEmpty) {
        where = '$wherecolumncheckJobrg = ?';
      } else {
        where = '$where AND $wherecolumncheckJobrg  = ?';
      }
      whereargs.add(wherecolumncheckJobrg);
    }
    if (wherecolumncheckJobdm != null) {
      if (where.isEmpty) {
        where = '$wherecolumncheckJobdm = ?';
      } else {
        where = '$where AND $wherecolumncheckJobdm  = ?';
      }
      whereargs.add(wherecolumncheckJobdm);
    }
    if (wherecolumnpstlvCode != null) {
      if (where.isEmpty) {
        where = '$wherecolumnpstlvCode = ?';
      } else {
        where = '$where AND $wherecolumnpstlvCode  = ?';
      }
      whereargs.add(wherecolumnpstlvCode);
    }
    if (wherecolumntokenSetVersion != null) {
      if (where.isEmpty) {
        where = '$wherecolumntokenSetVersion = ?';
      } else {
        where = '$where AND $wherecolumntokenSetVersion  = ?';
      }
      whereargs.add(wherecolumntokenSetVersion);
    }
    if (wherecolumntokenSetMessage != null) {
      if (where.isEmpty) {
        where = '$wherecolumntokenSetMessage = ?';
      } else {
        where = '$where AND $wherecolumntokenSetMessage  = ?';
      }
      whereargs.add(wherecolumntokenSetMessage);
    }
    if (wherecolumnwpMbCode != null) {
      if (where.isEmpty) {
        where = '$wherecolumnwpMbCode = ?';
      } else {
        where = '$where AND $wherecolumnwpMbCode  = ?';
      }
      whereargs.add(wherecolumnwpMbCode);
    }
    if (wherecolumnphotoPsn != null) {
      if (where.isEmpty) {
        where = '$wherecolumnphotoPsn = ?';
      } else {
        where = '$where AND $wherecolumnphotoPsn  = ?';
      }
      whereargs.add(wherecolumnphotoPsn);
    }
    if (wherecolumnmbName != null) {
      if (where.isEmpty) {
        where = '$wherecolumnmbName = ?';
      } else {
        where = '$where AND $wherecolumnmbName  = ?';
      }
      whereargs.add(wherecolumnmbName);
    }
    if (wherecolumnaddressPsn != null) {
      if (where.isEmpty) {
        where = '$wherecolumnaddressPsn = ?';
      } else {
        where = '$where AND $wherecolumnaddressPsn  = ?';
      }
      whereargs.add(wherecolumnaddressPsn);
    }
    if (wherecolumnmooPsn != null) {
      if (where.isEmpty) {
        where = '$wherecolumnmooPsn = ?';
      } else {
        where = '$where AND $wherecolumnmooPsn  = ?';
      }
      whereargs.add(wherecolumnmooPsn);
    }
    if (wherecolumnrillagePsn != null) {
      if (where.isEmpty) {
        where = '$wherecolumnrillagePsn = ?';
      } else {
        where = '$where AND $wherecolumnrillagePsn  = ?';
      }
      whereargs.add(wherecolumnrillagePsn);
    }
    if (wherecolumnalleyPsn != null) {
      if (where.isEmpty) {
        where = '$wherecolumnalleyPsn = ?';
      } else {
        where = '$where AND $wherecolumnalleyPsn  = ?';
      }
      whereargs.add(wherecolumnalleyPsn);
    }
    if (wherecolumnstreetPsn != null) {
      if (where.isEmpty) {
        where = '$wherecolumnstreetPsn = ?';
      } else {
        where = '$where AND $wherecolumnstreetPsn  = ?';
      }
      whereargs.add(wherecolumnstreetPsn);
    }
    if (wherecolumndistrictPsn != null) {
      if (where.isEmpty) {
        where = '$wherecolumndistrictPsn = ?';
      } else {
        where = '$where AND $wherecolumndistrictPsn  = ?';
      }
      whereargs.add(wherecolumndistrictPsn);
    }
    if (wherecolumnamphoePsn != null) {
      if (where.isEmpty) {
        where = '$wherecolumnamphoePsn = ?';
      } else {
        where = '$where AND $wherecolumnamphoePsn  = ?';
      }
      whereargs.add(wherecolumnamphoePsn);
    }
    if (wherecolumnprovincePsn != null) {
      if (where.isEmpty) {
        where = '$wherecolumnprovincePsn = ?';
      } else {
        where = '$where AND $wherecolumnprovincePsn  = ?';
      }
      whereargs.add(wherecolumnprovincePsn);
    }
    if (wherecolumnzipcodePsn != null) {
      if (where.isEmpty) {
        where = '$wherecolumnzipcodePsn = ?';
      } else {
        where = '$where AND $wherecolumnzipcodePsn  = ?';
      }
      whereargs.add(wherecolumnzipcodePsn);
    }
    if (wherecolumnemailPsn != null) {
      if (where.isEmpty) {
        where = '$wherecolumnemailPsn = ?';
      } else {
        where = '$where AND $wherecolumnemailPsn  = ?';
      }
      whereargs.add(wherecolumnemailPsn);
    }
    if (wherecolumnphonePsn != null) {
      if (where.isEmpty) {
        where = '$wherecolumnphonePsn = ?';
      } else {
        where = '$where AND $wherecolumnphonePsn  = ?';
      }
      whereargs.add(wherecolumnphonePsn);
    }
    if (wherecolumnnicknamePsn != null) {
      if (where.isEmpty) {
        where = '$wherecolumnnicknamePsn = ?';
      } else {
        where = '$where AND $wherecolumnnicknamePsn  = ?';
      }
      if (wherecolumnpersonnelId != null) {
        if (where.isEmpty) {
          where = '$wherecolumnpersonnelId = ?';
        } else {
          where = '$where AND $wherecolumnpersonnelId  = ?';
        }
        if (wherecolumndate != null) {
          if (where.isEmpty) {
            where = '$wherecolumndate = ?';
          } else {
            where = '$where AND $wherecolumndate  = ?';
          }
          whereargs.add(wherecolumndate);
        }
      }
    }
    if (kDebugMode) {
      print('===>> UserSQFLiteDatabase whereData where: $where');
      print('===>> UserSQFLiteDatabase whereData whereargs: $whereargs');
    }
    return true;
  }

  Future<bool> createDatabase() async {
    try {
      database = null;
      database = await SQFLiteDatabase().createDatabase().catchError((error) {
        if (kDebugMode) {
          print('error ===>> AppDatabase createDatabase: $error');
          print('error ===>> AppDatabase createDatabase return: null');
        }
        return null;
      });
      if (database != null) {
        if (kDebugMode) {
          print('===>> MarkerTimeAttendanceSQFLiteDatabase createDatabase return: true');
        }
        return true;
      } else {
        if (kDebugMode) {
          print('error ===>> MarkerTimeAttendanceSQFLiteDatabase createDatabase return: false');
        }
        return false;
      }
    } catch (error) {
      if (kDebugMode) {
        print('error ===>> MarkerTimeAttendanceSQFLiteDatabase createDatabase: $error');
        print('error ===>> MarkerTimeAttendanceSQFLiteDatabase createDatabase return: false');
      }
      return false;
    }
  }

  Future<bool> closeDatabase() async {
    try {
      await createDatabase().catchError((error) {
        if (kDebugMode) {
          print('error ===>> MarkerTimeAttendanceSQFLiteDatabase createDatabase: $error');
          print('error ===>> MarkerTimeAttendanceSQFLiteDatabase createDatabase return: false');
        }
        return false;
      });
      if (database != null) {
        await database!.close();
        if (kDebugMode) {
          print('===>> MarkerTimeAttendanceSQFLiteDatabase closeDatabase return: true');
        }
        return true;
      } else {
        if (kDebugMode) {
          print('error ===>> MarkerTimeAttendanceSQFLiteDatabase closeDatabase return: false');
        }
        return false;
      }
    } catch (error) {
      if (kDebugMode) {
        print('error ===>> MarkerTimeAttendanceSQFLiteDatabase closeDatabase un: $error');
        print('error ===>> MarkerTimeAttendanceSQFLiteDatabase closeDatabase return: false');
      }
      return false;
    }
  }

  Future<UserModel?> getData(
    String? wherecolumnusername_2,
    String? wherecolumnuserCkTypejob,
    String? wherecolumnacguCode,
    String? wherecolumnidPersonnel,
    String? wherecolumnenforcePass,
    String? wherecolumnenforceOpenfilepass,
    String? wherecolumnstatusUser,
    String? wherecolumntitleName,
    String? wherecolumnfirstnamePsn,
    String? wherecolumnlastnamePsn,
    String? wherecolumnpstCode,
    String? wherecolumnstartworkdatePsn,
    String? wherecolumnposition,
    String? wherecolumnwpCode,
    String? wherecolumnworkplace,
    String? wherecolumnbelongId,
    String? wherecolumnbelong,
    String? wherecolumnregionId,
    String? wherecolumnregion,
    String? wherecolumncheckJobbl,
    String? wherecolumncheckJobrg,
    String? wherecolumncheckJobdm,
    String? wherecolumnpstlvCode,
    String? wherecolumntokenSetVersion,
    String? wherecolumntokenSetMessage,
    String? wherecolumnwpMbCode,
    String? wherecolumnphotoPsn,
    String? wherecolumnmbName,
    String? wherecolumnaddressPsn,
    String? wherecolumnmooPsn,
    String? wherecolumnrillagePsn,
    String? wherecolumnalleyPsn,
    String? wherecolumnstreetPsn,
    String? wherecolumndistrictPsn,
    String? wherecolumnamphoePsn,
    String? wherecolumnprovincePsn,
    String? wherecolumnzipcodePsn,
    String? wherecolumnemailPsn,
    String? wherecolumnphonePsn,
    String? wherecolumnnicknamePsn,
    String? wherecolumnpersonnelId,
    String? wherecolumndate,
  ) async {
    try {
      model1 = [];
      await createDatabase().catchError((error) {
        if (kDebugMode) {
          print('error ===>> MarkerTimeAttendanceSQFLiteDatabase createDatabase: $error');
          print('error ===>> MarkerTimeAttendanceSQFLiteDatabase createDatabase return: false');
        }
        return false;
      });
      if (database != null) {
        await whereData(
          wherecolumnusername_2,
          wherecolumnuserCkTypejob,
          wherecolumnacguCode,
          wherecolumnidPersonnel,
          wherecolumnenforcePass,
          wherecolumnenforceOpenfilepass,
          wherecolumnstatusUser,
          wherecolumntitleName,
          wherecolumnfirstnamePsn,
          wherecolumnlastnamePsn,
          wherecolumnpstCode,
          wherecolumnstartworkdatePsn,
          wherecolumnposition,
          wherecolumnwpCode,
          wherecolumnworkplace,
          wherecolumnbelongId,
          wherecolumnbelong,
          wherecolumnregionId,
          wherecolumnregion,
          wherecolumncheckJobbl,
          wherecolumncheckJobrg,
          wherecolumncheckJobdm,
          wherecolumnpstlvCode,
          wherecolumntokenSetVersion,
          wherecolumntokenSetMessage,
          wherecolumnwpMbCode,
          wherecolumnphotoPsn,
          wherecolumnmbName,
          wherecolumnaddressPsn,
          wherecolumnmooPsn,
          wherecolumnrillagePsn,
          wherecolumnalleyPsn,
          wherecolumnstreetPsn,
          wherecolumndistrictPsn,
          wherecolumnamphoePsn,
          wherecolumnprovincePsn,
          wherecolumnzipcodePsn,
          wherecolumnemailPsn,
          wherecolumnphonePsn,
          wherecolumnnicknamePsn,
          wherecolumnpersonnelId,
          wherecolumndate,
        );
        List<Map<String, dynamic>> maps = await database!.query(
          table,
          columns: column,
          where: where.isEmpty ? null : where,
          whereArgs: whereargs.isEmpty ? null : whereargs,
        );
        if (kDebugMode) {
          print('===>> MarkerTimeAttendanceSQFLiteDatabase getData body: $maps');
        }
        if (maps.isNotEmpty) {
          model1 = maps.map((e) => UserModel.fromMap(e)).toList();
          UserModel model = model1.first;
          if (kDebugMode) {
            print('===>> MarkerTimeAttendanceSQFLiteDatabase getData return: $model');
          }
          return model;
        } else {
          if (kDebugMode) {
            print('===>> MarkerTimeAttendanceSQFLiteDatabase getData return: null');
          }
          return null;
        }
      } else {
        if (kDebugMode) {
          print('error ===>> MarkerTimeAttendanceSQFLiteDatabase getData return: $model1error');
        }
        return model1error;
      }
    } catch (error) {
      if (kDebugMode) {
        print('error ===>> MarkerTimeAttendanceSQFLiteDatabase getData un: $error');
        print('error ===>> MarkerTimeAttendanceSQFLiteDatabase getData return: $model1error');
      }
      return model1error;
    }
  }

  Future<List<UserModel>?> getAllData(
    String? wherecolumnusername_2,
    String? wherecolumnuserCkTypejob,
    String? wherecolumnacguCode,
    String? wherecolumnidPersonnel,
    String? wherecolumnenforcePass,
    String? wherecolumnenforceOpenfilepass,
    String? wherecolumnstatusUser,
    String? wherecolumntitleName,
    String? wherecolumnfirstnamePsn,
    String? wherecolumnlastnamePsn,
    String? wherecolumnpstCode,
    String? wherecolumnstartworkdatePsn,
    String? wherecolumnposition,
    String? wherecolumnwpCode,
    String? wherecolumnworkplace,
    String? wherecolumnbelongId,
    String? wherecolumnbelong,
    String? wherecolumnregionId,
    String? wherecolumnregion,
    String? wherecolumncheckJobbl,
    String? wherecolumncheckJobrg,
    String? wherecolumncheckJobdm,
    String? wherecolumnpstlvCode,
    String? wherecolumntokenSetVersion,
    String? wherecolumntokenSetMessage,
    String? wherecolumnwpMbCode,
    String? wherecolumnphotoPsn,
    String? wherecolumnmbName,
    String? wherecolumnaddressPsn,
    String? wherecolumnmooPsn,
    String? wherecolumnrillagePsn,
    String? wherecolumnalleyPsn,
    String? wherecolumnstreetPsn,
    String? wherecolumndistrictPsn,
    String? wherecolumnamphoePsn,
    String? wherecolumnprovincePsn,
    String? wherecolumnzipcodePsn,
    String? wherecolumnemailPsn,
    String? wherecolumnphonePsn,
    String? wherecolumnnicknamePsn,
    String? wherecolumnpersonnelId,
    String? wherecolumndate,
  ) async {
    try {
      model1 = [];
      await createDatabase().catchError((error) {
        if (kDebugMode) {
          print('error ===>> MarkerTimeAttendanceSQFLiteDatabase createDatabase: $error');
          print('error ===>> MarkerTimeAttendanceSQFLiteDatabase createDatabase return: false');
        }
        return false;
      });
      if (database != null) {
        await whereData(
          wherecolumnusername_2,
          wherecolumnuserCkTypejob,
          wherecolumnacguCode,
          wherecolumnidPersonnel,
          wherecolumnenforcePass,
          wherecolumnenforceOpenfilepass,
          wherecolumnstatusUser,
          wherecolumntitleName,
          wherecolumnfirstnamePsn,
          wherecolumnlastnamePsn,
          wherecolumnpstCode,
          wherecolumnstartworkdatePsn,
          wherecolumnposition,
          wherecolumnwpCode,
          wherecolumnworkplace,
          wherecolumnbelongId,
          wherecolumnbelong,
          wherecolumnregionId,
          wherecolumnregion,
          wherecolumncheckJobbl,
          wherecolumncheckJobrg,
          wherecolumncheckJobdm,
          wherecolumnpstlvCode,
          wherecolumntokenSetVersion,
          wherecolumntokenSetMessage,
          wherecolumnwpMbCode,
          wherecolumnphotoPsn,
          wherecolumnmbName,
          wherecolumnaddressPsn,
          wherecolumnmooPsn,
          wherecolumnrillagePsn,
          wherecolumnalleyPsn,
          wherecolumnstreetPsn,
          wherecolumndistrictPsn,
          wherecolumnamphoePsn,
          wherecolumnprovincePsn,
          wherecolumnzipcodePsn,
          wherecolumnemailPsn,
          wherecolumnphonePsn,
          wherecolumnnicknamePsn,
          wherecolumnpersonnelId,
          wherecolumndate,
        );
        List<Map<String, Object?>> maps = await database!.query(
          table,
          columns: column,
          where: where.isEmpty ? null : where,
          whereArgs: whereargs.isEmpty ? null : whereargs,
        );
        if (kDebugMode) {
          print('===>> MarkerTimeAttendanceSQFLiteDatabase getAllData body: $maps');
        }
        if (maps.isNotEmpty) {
          model1 = maps.map((e) => UserModel.fromMap(e)).toList();
          if (kDebugMode) {
            print('===>> MarkerTimeAttendanceSQFLiteDatabase getAllData return: $model1');
          }
          return model1;
        } else {
          if (kDebugMode) {
            print('===>> MarkerTimeAttendanceSQFLiteDatabase getAllData return: null');
          }
          return null;
        }
      } else {
        model1.add(model1error);
        if (kDebugMode) {
          print('error ===>> MarkerTimeAttendanceSQFLiteDatabase getAllData return: $model1');
        }
        return model1;
      }
    } catch (error) {
      model1.add(model1error);
      if (kDebugMode) {
        print('error ===>> MarkerTimeAttendanceSQFLiteDatabase getAllData un: $error');
        print('error ===>> MarkerTimeAttendanceSQFLiteDatabase getAllData return: $model1');
      }
      return model1;
    }
  }

  Future<bool> insertData(UserModel model1) async {
    try {
      await createDatabase().catchError((error) {
        if (kDebugMode) {
          print('error ===>> MarkerTimeAttendanceSQFLiteDatabase createDatabase: $error');
          print('error ===>> MarkerTimeAttendanceSQFLiteDatabase createDatabase return: false');
        }
        return false;
      });
      if (database != null) {
        await database!.insert(table, model1.toMap());
        if (kDebugMode) {
          print('===>> MarkerTimeAttendanceSQFLiteDatabase insertDatareturn: true');
        }
        return true;
      } else {
        if (kDebugMode) {
          print('error ===>> MarkerTimeAttendanceSQFLiteDatabase insertData return: false');
        }
        return false;
      }
    } catch (error) {
      if (kDebugMode) {
        print('error ===>> MarkerTimeAttendanceSQFLiteDatabase insertData un: $error');
        print('error ===>> MarkerTimeAttendanceSQFLiteDatabase insertData return: false');
      }
      return false;
    }
  }

  Future<bool> rawInsertData(List<UserModel> model1) async {
    try {
      await createDatabase().catchError((error) {
        if (kDebugMode) {
          print('error ===>> MarkerTimeAttendanceSQFLiteDatabase createDatabase: $error');
          print('error ===>> MarkerTimeAttendanceSQFLiteDatabase createDatabase return: false');
        }
        return false;
      });
      if (database != null && model1.isNotEmpty) {
        if (kDebugMode) {
          print('===>> MarkerTimeAttendanceSQFLiteDatabase rawInsertData1 send: $model1');
        }
        String columns = model1.first.toMap().keys.join(', ');
        String values = model1
            .map((model) => '(${model.toMap().values.map((value) => "'$value'").join(', ')})')
            .join(', ');
        if (kDebugMode) {
          print('===>> MarkerTimeAttendanceSQFLiteDatabase rawInsertData1 body: $values');
        }
        await database!.rawInsert('INSERT INTO $table ($columns) VALUES $values;');
        if (kDebugMode) {
          print('===>> MarkerTimeAttendanceSQFLiteDatabase rawInsertData return1: true');
        }
        return true;
      } else {
        if (kDebugMode) {
          print('error ===>> MarkerTimeAttendanceSQFLiteDatabase rawInsertData return2: false');
        }
        return false;
      }
    } catch (error) {
      if (kDebugMode) {
        print('error ===>> MarkerTimeAttendanceSQFLiteDatabase rawInsertData un: $error');
        print('error ===>> MarkerTimeAttendanceSQFLiteDatabase rawInsertData return3: false');
      }
      return false;
    }
  }

  Future<bool> updateData(
    UserModel model1,
    String? wherecolumnusername_2,
    String? wherecolumnuserCkTypejob,
    String? wherecolumnacguCode,
    String? wherecolumnidPersonnel,
    String? wherecolumnenforcePass,
    String? wherecolumnenforceOpenfilepass,
    String? wherecolumnstatusUser,
    String? wherecolumntitleName,
    String? wherecolumnfirstnamePsn,
    String? wherecolumnlastnamePsn,
    String? wherecolumnpstCode,
    String? wherecolumnstartworkdatePsn,
    String? wherecolumnposition,
    String? wherecolumnwpCode,
    String? wherecolumnworkplace,
    String? wherecolumnbelongId,
    String? wherecolumnbelong,
    String? wherecolumnregionId,
    String? wherecolumnregion,
    String? wherecolumncheckJobbl,
    String? wherecolumncheckJobrg,
    String? wherecolumncheckJobdm,
    String? wherecolumnpstlvCode,
    String? wherecolumntokenSetVersion,
    String? wherecolumntokenSetMessage,
    String? wherecolumnwpMbCode,
    String? wherecolumnphotoPsn,
    String? wherecolumnmbName,
    String? wherecolumnaddressPsn,
    String? wherecolumnmooPsn,
    String? wherecolumnrillagePsn,
    String? wherecolumnalleyPsn,
    String? wherecolumnstreetPsn,
    String? wherecolumndistrictPsn,
    String? wherecolumnamphoePsn,
    String? wherecolumnprovincePsn,
    String? wherecolumnzipcodePsn,
    String? wherecolumnemailPsn,
    String? wherecolumnphonePsn,
    String? wherecolumnnicknamePsn,
    String? wherecolumnpersonnelId,
    String? wherecolumndate,
  ) async {
    try {
      await createDatabase().catchError((error) {
        if (kDebugMode) {
          print('error ===>> MarkerTimeAttendanceSQFLiteDatabase createDatabase: $error');
          print('error ===>> MarkerTimeAttendanceSQFLiteDatabase createDatabase return: false');
        }
        return false;
      });
      if (database != null) {
        await whereData(
          wherecolumnusername_2,
          wherecolumnuserCkTypejob,
          wherecolumnacguCode,
          wherecolumnidPersonnel,
          wherecolumnenforcePass,
          wherecolumnenforceOpenfilepass,
          wherecolumnstatusUser,
          wherecolumntitleName,
          wherecolumnfirstnamePsn,
          wherecolumnlastnamePsn,
          wherecolumnpstCode,
          wherecolumnstartworkdatePsn,
          wherecolumnposition,
          wherecolumnwpCode,
          wherecolumnworkplace,
          wherecolumnbelongId,
          wherecolumnbelong,
          wherecolumnregionId,
          wherecolumnregion,
          wherecolumncheckJobbl,
          wherecolumncheckJobrg,
          wherecolumncheckJobdm,
          wherecolumnpstlvCode,
          wherecolumntokenSetVersion,
          wherecolumntokenSetMessage,
          wherecolumnwpMbCode,
          wherecolumnphotoPsn,
          wherecolumnmbName,
          wherecolumnaddressPsn,
          wherecolumnmooPsn,
          wherecolumnrillagePsn,
          wherecolumnalleyPsn,
          wherecolumnstreetPsn,
          wherecolumndistrictPsn,
          wherecolumnamphoePsn,
          wherecolumnprovincePsn,
          wherecolumnzipcodePsn,
          wherecolumnemailPsn,
          wherecolumnphonePsn,
          wherecolumnnicknamePsn,
          wherecolumnpersonnelId,
          wherecolumndate,
        );
        await database!.update(
          table,
          model1.toMap(),
          where: where.isEmpty ? null : where,
          whereArgs: whereargs.isEmpty ? null : whereargs,
        );
        if (kDebugMode) {
          print('===>> MarkerTimeAttendanceSQFLiteDatabase updateData return: true');
        }
        return true;
      } else {
        if (kDebugMode) {
          print('error ===>> MarkerTimeAttendanceSQFLiteDatabase updateData return: false');
        }
        return false;
      }
    } catch (error) {
      if (kDebugMode) {
        print('error ===>> MarkerTimeAttendanceSQFLiteDatabase updateData un: $error');
        print('error ===>> MarkerTimeAttendanceSQFLiteDatabase updateData return: false');
      }
      return false;
    }
  }

  Future<bool> deleteData(
    String? wherecolumnusername_2,
    String? wherecolumnuserCkTypejob,
    String? wherecolumnacguCode,
    String? wherecolumnidPersonnel,
    String? wherecolumnenforcePass,
    String? wherecolumnenforceOpenfilepass,
    String? wherecolumnstatusUser,
    String? wherecolumntitleName,
    String? wherecolumnfirstnamePsn,
    String? wherecolumnlastnamePsn,
    String? wherecolumnpstCode,
    String? wherecolumnstartworkdatePsn,
    String? wherecolumnposition,
    String? wherecolumnwpCode,
    String? wherecolumnworkplace,
    String? wherecolumnbelongId,
    String? wherecolumnbelong,
    String? wherecolumnregionId,
    String? wherecolumnregion,
    String? wherecolumncheckJobbl,
    String? wherecolumncheckJobrg,
    String? wherecolumncheckJobdm,
    String? wherecolumnpstlvCode,
    String? wherecolumntokenSetVersion,
    String? wherecolumntokenSetMessage,
    String? wherecolumnwpMbCode,
    String? wherecolumnphotoPsn,
    String? wherecolumnmbName,
    String? wherecolumnaddressPsn,
    String? wherecolumnmooPsn,
    String? wherecolumnrillagePsn,
    String? wherecolumnalleyPsn,
    String? wherecolumnstreetPsn,
    String? wherecolumndistrictPsn,
    String? wherecolumnamphoePsn,
    String? wherecolumnprovincePsn,
    String? wherecolumnzipcodePsn,
    String? wherecolumnemailPsn,
    String? wherecolumnphonePsn,
    String? wherecolumnnicknamePsn,
    String? wherecolumnpersonnelId,
    String? wherecolumndate,
  ) async {
    try {
      await createDatabase().catchError((error) {
        if (kDebugMode) {
          print('error ===>> MarkerTimeAttendanceSQFLiteDatabase createDatabase: $error');
          print('error ===>> MarkerTimeAttendanceSQFLiteDatabase createDatabase return: false');
        }
        return false;
      });
      if (database != null) {
        await whereData(
          wherecolumnusername_2,
          wherecolumnuserCkTypejob,
          wherecolumnacguCode,
          wherecolumnidPersonnel,
          wherecolumnenforcePass,
          wherecolumnenforceOpenfilepass,
          wherecolumnstatusUser,
          wherecolumntitleName,
          wherecolumnfirstnamePsn,
          wherecolumnlastnamePsn,
          wherecolumnpstCode,
          wherecolumnstartworkdatePsn,
          wherecolumnposition,
          wherecolumnwpCode,
          wherecolumnworkplace,
          wherecolumnbelongId,
          wherecolumnbelong,
          wherecolumnregionId,
          wherecolumnregion,
          wherecolumncheckJobbl,
          wherecolumncheckJobrg,
          wherecolumncheckJobdm,
          wherecolumnpstlvCode,
          wherecolumntokenSetVersion,
          wherecolumntokenSetMessage,
          wherecolumnwpMbCode,
          wherecolumnphotoPsn,
          wherecolumnmbName,
          wherecolumnaddressPsn,
          wherecolumnmooPsn,
          wherecolumnrillagePsn,
          wherecolumnalleyPsn,
          wherecolumnstreetPsn,
          wherecolumndistrictPsn,
          wherecolumnamphoePsn,
          wherecolumnprovincePsn,
          wherecolumnzipcodePsn,
          wherecolumnemailPsn,
          wherecolumnphonePsn,
          wherecolumnnicknamePsn,
          wherecolumnpersonnelId,
          wherecolumndate,
        );
        await database!.delete(
          table,
          where: where.isEmpty ? null : where,
          whereArgs: whereargs.isEmpty ? null : whereargs,
        );
        if (kDebugMode) {
          print('===>> MarkerTimeAttendanceSQFLiteDatabase deleteData return: true');
        }
        return true;
      } else {
        if (kDebugMode) {
          print('error ===>> MarkerTimeAttendanceSQFLiteDatabase deleteData return: false');
        }
        return false;
      }
    } catch (error) {
      if (kDebugMode) {
        print('error ===>> MarkerTimeAttendanceSQFLiteDatabase deleteData un: $error');
        print('error ===>> MarkerTimeAttendanceSQFLiteDatabase deleteData return: false');
      }
      return false;
    }
  }

  Future<bool> deleteAllData() async {
    try {
      await createDatabase().catchError((error) {
        if (kDebugMode) {
          print('error ===>> MarkerTimeAttendanceSQFLiteDatabase createDatabase: $error');
          print('error ===>> MarkerTimeAttendanceSQFLiteDatabase createDatabase return: false');
        }
        return false;
      });
      if (database != null) {
        String sql = "Delete from $table";
        await database!.rawDelete(sql);
        if (kDebugMode) {
          print('===>> MarkerTimeAttendanceSQFLiteDatabase deleteAllData return: true');
        }
        return true;
      } else {
        if (kDebugMode) {
          print('error ===>> MarkerTimeAttendanceSQFLiteDatabase deleteAllData return: false');
        }
        return false;
      }
    } catch (error) {
      if (kDebugMode) {
        print('error ===>> MarkerTimeAttendanceSQFLiteDatabase deleteAllData un: $error');
        print('error ===>> MarkerTimeAttendanceSQFLiteDatabase deleteAllData return: false');
      }
      return false;
    }
  }
}
