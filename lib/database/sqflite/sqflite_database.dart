import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sakcamera_getx/constant/main_constant.dart';
import 'package:sakcamera_getx/model/user/user_model.dart' as user;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQFLiteDatabase {
  Database? database;
  Future<bool> tableExist(Database db, String tablename) async {
    if (kDebugMode) {
      print('===>> SQFLiteDatabase tableExist send: $db, $tablename');
    }
    List<Map<String, Object?>> result = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='$tablename'",
    );
    return result.isNotEmpty;
  }

  Future<bool> columnExist(Database db, String tablename, String columnname) async {
    if (kDebugMode) {
      print('===>> SQFLiteDatabase columnExist send: $db, $tablename, $columnname');
    }
    List<Map<String, Object?>> result = await db.rawQuery("PRAGMA table_info($tablename)");
    for (Map<String, dynamic> column in result) {
      if (column['name'] == columnname) {
        return true;
      }
    }
    return false;
  }

  Future checkAddColumn(Database db, String tablename, List<String> columntable) async {
    if (kDebugMode) {
      print('===>> SQFLiteDatabase checkAddColumn send: $db, $tablename, $columntable');
    }
    if (columntable.isNotEmpty) {
      for (String name in columntable) {
        if (!await columnExist(db, tablename, name)) {
          await db.execute("ALTER TABLE $tablename ADD COLUMN $name TEXT");
          if (kDebugMode) {
            print(
              '===>> SQFLiteDatabase checkAddColumn Database Table $tablename Add Column: $name',
            );
          }
        }
      }
    }
  }

  Future checkColumn(Database db) async {
    if (kDebugMode) {
      print('===>> SQFLiteDatabase checkColumn send: $db');
    }

    if (!await tableExist(db, user.table)) {
      await db.execute(user.createtable);
      if (kDebugMode) {
        print('===>> SQFLiteDatabase checkColumn Create Database Table ${user.table}');
      }
    } else {
      await checkAddColumn(db, user.table, user.column);
    }
  }

  Future<Database?> createDatabase() async {
    try {
      database = null;
      String databasepath = await getDatabasesPath();
      String path = join(databasepath, MainConstant.databasename);
      if (!await Directory(dirname(path)).exists()) {
        await Directory(dirname(path)).create(recursive: true);
      }
      database = await openDatabase(
        path,
        version: MainConstant.databaseversion,
        onCreate: (db, version) async {
          if (kDebugMode) {
            print('===>> SQFLiteDatabase createDatabase Database Create Version: $version');
          }
          await checkColumn(db).catchError((error) {
            if (kDebugMode) {
              print('error ===>> SQFLiteDatabase checkColumn: $error');
            }
          });
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (kDebugMode) {
            print('===>> SQFLiteDatabase createDatabase Database Upgrade Old Version: $oldVersion');
            print('===>> SQFLiteDatabase createDatabase Database Upgrade New Version: $newVersion');
          }
          await checkColumn(db).catchError((error) {
            if (kDebugMode) {
              print('error ===>> SQFLiteDatabase checkColumn: $error');
            }
          });
        },
        onOpen: (db) async {
          if (kDebugMode) {
            print(
              '===>> SQFLiteDatabase createDatabase Database Open Version: ${await db.getVersion()}',
            );
          }
          await checkColumn(db).catchError((error) {
            if (kDebugMode) {
              print('error ===>> SQFLiteDatabase checkColumn: $error');
            }
          });
        },
      );
      if (kDebugMode) {
        print('===>> SQFLiteDatabase createDatabase return: $database');
      }
      return database;
    } catch (error) {
      if (kDebugMode) {
        print('error ===>> SQFLiteDatabase createDatabase un: $error');

        print('error ===>> SQFLiteDatabase createDatabase return: null');
      }
      return null;
    }
  }

  Future<bool> closeDatabase() async {
    try {
      database = null;
      database = await createDatabase().catchError((error) {
        if (kDebugMode) {
          print('error ===>> SQFLiteDatabase createDatabase: $error');

          print('error ===>> SQFLiteDatabase createDatabase return: null');
        }
        return null;
      });
      if (database != null) {
        await database!.close();
        if (kDebugMode) {
          print('===>> SQFLiteDatabase createDatabase return: true');
        }
        return true;
      } else {
        if (kDebugMode) {
          print('error ===>> SQFLiteDatabase closeDatabase return: false');
        }
        return false;
      }
    } catch (error) {
      if (kDebugMode) {
        print('error ===>> SQFLiteDatabase closeDatabase un: $error');

        print('error ===>> SQFLiteDatabase closeDatabase return: false');
      }
      return false;
    }
  }
}
