// ignore_for_file: non_constant_identifier_names, constant_identifier_names, public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/foundation.dart';

class VersionAppModel {
  //ที่เก็บข้อมูลเวอร์ชันแต่ละรายการ เช่น เวอร์ชันล่าสุด
  final List<VersionAppListModel> res_CheckVersionApp_last;
  VersionAppModel({required this.res_CheckVersionApp_last});

  VersionAppModel copyWith({List<VersionAppListModel>? res_CheckVersionApp_last}) {
    return VersionAppModel(
      res_CheckVersionApp_last: res_CheckVersionApp_last ?? this.res_CheckVersionApp_last,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'res_CheckVersionApp_last': res_CheckVersionApp_last.map((x) => x.toMap()).toList(),
    };
  }

  factory VersionAppModel.fromMap(Map<String, dynamic> map) {
    return VersionAppModel(
      res_CheckVersionApp_last: List<VersionAppListModel>.from(
        (map['res_CheckVersionApp_last'] ?? []).map<VersionAppListModel>(
          (x) => VersionAppListModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory VersionAppModel.fromJson(String source) =>
      VersionAppModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'VersionApp(res_CheckVersionApp_last: $res_CheckVersionApp_last)';

  @override
  bool operator ==(covariant VersionAppModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.res_CheckVersionApp_last, res_CheckVersionApp_last);
  }

  @override
  int get hashCode => res_CheckVersionApp_last.hashCode;
}

//===>> ข้อมูลเวอร์ชันของแอปพลิเคชัน ทั้งฝั่ง Android และ iOS
class VersionAppListModel {
  final String ipsv_version_IOS;
  final String ipsv_build_IOS;
  final String ipsv_DatetimeUpDate_IOS;
  final String ipsv_version_Android;
  final String ipsv_build_Android;
  final String ipsv_DatetimeUpDate_Android;
  final String ipsv_Detail_IOS;
  final String ipsv_Detail_Android;
  VersionAppListModel({
    required this.ipsv_version_IOS,
    required this.ipsv_build_IOS,
    required this.ipsv_DatetimeUpDate_IOS,
    required this.ipsv_version_Android,
    required this.ipsv_build_Android,
    required this.ipsv_DatetimeUpDate_Android,
    required this.ipsv_Detail_IOS,
    required this.ipsv_Detail_Android,
  });

  VersionAppListModel copyWith({
    String? ipsv_version_IOS,
    String? ipsv_build_IOS,
    String? ipsv_DatetimeUpDate_IOS,
    String? ipsv_version_Android,
    String? ipsv_build_Android,
    String? ipsv_DatetimeUpDate_Android,
    String? ipsv_Detail_IOS,
    String? ipsv_Detail_Android,
  }) {
    return VersionAppListModel(
      ipsv_version_IOS: ipsv_version_IOS ?? this.ipsv_version_IOS,
      ipsv_build_IOS: ipsv_build_IOS ?? this.ipsv_build_IOS,
      ipsv_DatetimeUpDate_IOS: ipsv_DatetimeUpDate_IOS ?? this.ipsv_DatetimeUpDate_IOS,
      ipsv_version_Android: ipsv_version_Android ?? this.ipsv_version_Android,
      ipsv_build_Android: ipsv_build_Android ?? this.ipsv_build_Android,
      ipsv_DatetimeUpDate_Android: ipsv_DatetimeUpDate_Android ?? this.ipsv_DatetimeUpDate_Android,
      ipsv_Detail_IOS: ipsv_Detail_IOS ?? this.ipsv_Detail_IOS,
      ipsv_Detail_Android: ipsv_Detail_Android ?? this.ipsv_Detail_Android,
    );
  }

  //===>> fromMap() / toMap()
  //===>> ใช้ในการแปลงข้อมูลจาก/เป็น Map<String, dynamic> (เหมาะสำหรับรับ/ส่ง JSON)
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ipsv_version_IOS': ipsv_version_IOS,
      'ipsv_build_IOS': ipsv_build_IOS,
      'ipsv_DatetimeUpDate_IOS': ipsv_DatetimeUpDate_IOS,
      'ipsv_version_Android': ipsv_version_Android,
      'ipsv_build_Android': ipsv_build_Android,
      'ipsv_DatetimeUpDate_Android': ipsv_DatetimeUpDate_Android,
      'ipsv_Detail_IOS': ipsv_Detail_IOS,
      'ipsv_Detail_Android': ipsv_Detail_Android,
    };
  }

  factory VersionAppListModel.fromMap(Map<String, dynamic> map) {
    return VersionAppListModel(
      ipsv_version_IOS: map['ipsv_version_IOS'] ?? '',
      ipsv_build_IOS: map['ipsv_build_IOS'] ?? '',
      ipsv_DatetimeUpDate_IOS: map['ipsv_DatetimeUpDate_IOS'] ?? '',
      ipsv_version_Android: map['ipsv_version_Android'] ?? '',
      ipsv_build_Android: map['ipsv_build_Android'] ?? '',
      ipsv_DatetimeUpDate_Android: map['ipsv_DatetimeUpDate_Android'] ?? '',
      ipsv_Detail_IOS: map['ipsv_Detail_IOS'] ?? '',
      ipsv_Detail_Android: map['ipsv_Detail_Android'] ?? '',
    );
  }

  //===>> fromJson() / toJson()
  //===>> ใช้แปลงจาก/เป็น String (JSON string)
  String toJson() => json.encode(toMap());

  factory VersionAppListModel.fromJson(String source) =>
      VersionAppListModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VersionAppList(ipsv_version_IOS: $ipsv_version_IOS, ipsv_build_IOS: $ipsv_build_IOS, ipsv_DatetimeUpDate_IOS: $ipsv_DatetimeUpDate_IOS, ipsv_version_Android: $ipsv_version_Android, ipsv_build_Android: $ipsv_build_Android, ipsv_DatetimeUpDate_Android: $ipsv_DatetimeUpDate_Android, ipsv_Detail_IOS: $ipsv_Detail_IOS, ipsv_Detail_Android: $ipsv_Detail_Android)';
  }

  //===>> == และ hashCode
  //===>> ใช้เปรียบเทียบ object ว่าเหมือนกันหรือไม่ (เหมาะกับ state management เช่น Bloc, Provider)
  @override
  bool operator ==(covariant VersionAppListModel other) {
    if (identical(this, other)) return true;

    return other.ipsv_version_IOS == ipsv_version_IOS &&
        other.ipsv_build_IOS == ipsv_build_IOS &&
        other.ipsv_DatetimeUpDate_IOS == ipsv_DatetimeUpDate_IOS &&
        other.ipsv_version_Android == ipsv_version_Android &&
        other.ipsv_build_Android == ipsv_build_Android &&
        other.ipsv_DatetimeUpDate_Android == ipsv_DatetimeUpDate_Android &&
        other.ipsv_Detail_IOS == ipsv_Detail_IOS &&
        other.ipsv_Detail_Android == ipsv_Detail_Android;
  }

  @override
  int get hashCode {
    return ipsv_version_IOS.hashCode ^
        ipsv_build_IOS.hashCode ^
        ipsv_DatetimeUpDate_IOS.hashCode ^
        ipsv_version_Android.hashCode ^
        ipsv_build_Android.hashCode ^
        ipsv_DatetimeUpDate_Android.hashCode ^
        ipsv_Detail_IOS.hashCode ^
        ipsv_Detail_Android.hashCode;
  }
}
