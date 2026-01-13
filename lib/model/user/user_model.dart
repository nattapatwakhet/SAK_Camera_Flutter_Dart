// ignore_for_file: non_constant_identifier_names, constant_identifier_names, public_member_api_docs, sort_constructors_first
import 'dart:convert';

const String table = 'user';
const String column_username_2 = 'username_2';
const String column_user_ck_TypeJob = 'user_ck_TypeJob';
const String column_AcgU_code = 'AcgU_code';
const String column_ID_personnel = 'ID_personnel';
const String column_enforce_pass = 'enforce_pass';
const String column_enforce_openfilepass = 'enforce_openfilepass';
const String column_status_user = 'status_user';
const String column_title_name = 'title_name';
const String column_firstname_PSN = 'firstname_PSN';
const String column_lastname_PSN = 'lastname_PSN';
const String column_PST_code = 'PST_code';
const String column_startworkdate_PSN = 'startworkdate_PSN';
const String column_position = 'position';
const String column_WP_code = 'WP_code';
const String column_workplace = 'workplace';
const String column_belong_id = 'belong_id';
const String column_belong = 'belong';
const String column_region_id = 'region_id';
const String column_region = 'region';
const String column_check_jobBL = 'check_jobBL';
const String column_check_jobRG = 'check_jobRG';
const String column_check_jobDM = 'check_jobDM';
const String column_PSTLv_Code = 'PSTLv_Code';
const String column_token_set_version = 'token_set_version';
const String column_token_set_message = 'token_set_message';
const String column_WP_MB_Code = 'WP_MB_Code';
const String column_photo_PSN = 'photo_PSN';
const String column_MB_Name = 'MB_Name';
const String column_address_PSN = 'address_PSN';
const String column_moo_PSN = 'moo_PSN';
const String column_rillage_PSN = 'rillage_PSN';
const String column_alley_PSN = 'alley_PSN';
const String column_street_PSN = 'street_PSN';
const String column_district_PSN = 'district_PSN';
const String column_amphoe_PSN = 'amphoe_PSN';
const String column_province_PSN = 'province_PSN';
const String column_zipcode_PSN = 'zipcode_PSN';
const String column_email_PSN = 'email_PSN';
const String column_phone_PSN = 'phone_PSN';
const String column_nickname_PSN = 'nickname_PSN';
const String column_personnel_id = 'personnel_id';
const String column_date = 'date';
String createtable =
    "CREATE TABLE $table ("
    "$column_username_2 TEXT,"
    "$column_user_ck_TypeJob TEXT,"
    "$column_AcgU_code TEXT,"
    "$column_ID_personnel TEXT,"
    "$column_enforce_pass TEXT,"
    "$column_enforce_openfilepass TEXT,"
    "$column_status_user TEXT"
    ",$column_title_name TEXT,"
    "$column_firstname_PSN TEXT,"
    "$column_lastname_PSN TEXT,"
    "$column_PST_code TEXT,"
    "$column_startworkdate_PSN TEXT,"
    "$column_position TEXT,"
    "$column_WP_code TEXT,"
    "$column_workplace TEXT,"
    "$column_belong_id TEXT,"
    "$column_belong TEXT,"
    "$column_region_id TEXT,"
    "$column_region TEXT,"
    "$column_check_jobBL TEXT,"
    "$column_check_jobRG TEXT,"
    "$column_check_jobDM TEXT,"
    "$column_PSTLv_Code TEXT,"
    "$column_token_set_version TEXT,"
    "$column_token_set_message TEXT,"
    "$column_WP_MB_Code TEXT,"
    "$column_photo_PSN TEXT,"
    "$column_MB_Name TEXT,"
    "$column_address_PSN TEXT,"
    "$column_moo_PSN TEXT,"
    "$column_rillage_PSN TEXT,"
    "$column_alley_PSN TEXT,"
    "$column_street_PSN TEXT,"
    "$column_district_PSN TEXT,"
    "$column_amphoe_PSN TEXT,"
    "$column_province_PSN TEXT,"
    "$column_zipcode_PSN TEXT,"
    "$column_email_PSN TEXT,"
    "$column_phone_PSN TEXT,"
    "$column_nickname_PSN TEXT"
    ",$column_personnel_id TEXT,"
    "$column_date TEXT"
    ")";
List<String> column = [
  column_username_2,
  column_user_ck_TypeJob,
  column_AcgU_code,
  column_ID_personnel, //รหัสพนักงาน
  column_enforce_pass,
  column_enforce_openfilepass,
  column_status_user, // สถานะของพนักงาน
  column_title_name, // คำนำหน้าชื่อ
  column_firstname_PSN, // ชื่อ
  column_lastname_PSN, // นามสกุล
  column_PST_code, // รหัสตำแหน่ง
  column_startworkdate_PSN, // วันที่เริ่มงาน
  column_position, // ชื่อตำแหน่ง
  column_WP_code, // รหัสชื่อฝ่าย
  column_workplace, // สาขา
  column_belong_id, // รหัสพิ้นที่สังกัด (ฝ่าย-เขต)
  column_belong, // ชื่อเขตพิ้นที่สังกัด (ฝ่าย-เขต)
  column_region_id, // รหัสภาค
  column_region, // เลขภาค1-5, 6 เป็น ส.ใหญ่
  column_check_jobBL,
  column_check_jobRG,
  column_check_jobDM,
  column_PSTLv_Code, // ระดับของตำแหน่ง
  column_token_set_version,
  column_token_set_message,
  column_WP_MB_Code,
  column_photo_PSN,
  column_MB_Name,
  column_address_PSN,
  column_moo_PSN,
  column_rillage_PSN,
  column_alley_PSN,
  column_street_PSN,
  column_district_PSN,
  column_amphoe_PSN,
  column_province_PSN,
  column_zipcode_PSN,
  column_email_PSN,
  column_phone_PSN,
  column_nickname_PSN,
  column_personnel_id, // รหัสพนักงาน
  column_date, // วันที่บันทึกข้อมูล
];

class UserModel {
  final String username_2;
  final String user_ck_TypeJob;
  final String AcgU_code;
  final String ID_personnel;
  final String enforce_pass;
  final String enforce_openfilepass;
  final String status_user;
  final String title_name;
  final String firstname_PSN;
  final String lastname_PSN;
  final String PST_code;
  final String startworkdate_PSN;
  final String position;
  final String WP_code;
  final String workplace;
  final String belong_id;
  final String belong;
  final String region_id;
  final String region;
  final String check_jobBL;
  final String check_jobRG;
  final String check_jobDM;
  final String PSTLv_Code;
  final String token_set_version;
  final String token_set_message;
  final String WP_MB_Code;
  final String photo_PSN;
  final String MB_Name;
  final String address_PSN;
  final String moo_PSN;
  final String rillage_PSN;
  final String alley_PSN;
  final String street_PSN;
  final String district_PSN;
  final String amphoe_PSN;
  final String province_PSN;
  final String zipcode_PSN;
  final String email_PSN;
  final String phone_PSN;
  final String nickname_PSN;
  final String personnel_id;
  final String date;
  UserModel({
    required this.username_2,
    required this.user_ck_TypeJob,
    required this.AcgU_code,
    required this.ID_personnel,
    required this.enforce_pass,
    required this.enforce_openfilepass,
    required this.status_user,
    required this.title_name,
    required this.firstname_PSN,
    required this.lastname_PSN,
    required this.PST_code,
    required this.startworkdate_PSN,
    required this.position,
    required this.WP_code,
    required this.workplace,
    required this.belong_id,
    required this.belong,
    required this.region_id,
    required this.region,
    required this.check_jobBL,
    required this.check_jobRG,
    required this.check_jobDM,
    required this.PSTLv_Code,
    required this.token_set_version,
    required this.token_set_message,
    required this.WP_MB_Code,
    required this.photo_PSN,
    required this.MB_Name,
    required this.address_PSN,
    required this.moo_PSN,
    required this.rillage_PSN,
    required this.alley_PSN,
    required this.street_PSN,
    required this.district_PSN,
    required this.amphoe_PSN,
    required this.province_PSN,
    required this.zipcode_PSN,
    required this.email_PSN,
    required this.phone_PSN,
    required this.nickname_PSN,
    required this.personnel_id,
    required this.date,
  });

  UserModel copyWith({
    String? username_2,
    String? user_ck_TypeJob,
    String? AcgU_code,
    String? ID_personnel,
    String? enforce_pass,
    String? enforce_openfilepass,
    String? status_user,
    String? title_name,
    String? firstname_PSN,
    String? lastname_PSN,
    String? PST_code,
    String? startworkdate_PSN,
    String? position,
    String? WP_code,
    String? workplace,
    String? belong_id,
    String? belong,
    String? region_id,
    String? region,
    String? check_jobBL,
    String? check_jobRG,
    String? check_jobDM,
    String? PSTLv_Code,
    String? token_set_version,
    String? token_set_message,
    String? WP_MB_Code,
    String? photo_PSN,
    String? MB_Name,
    String? address_PSN,
    String? moo_PSN,
    String? rillage_PSN,
    String? alley_PSN,
    String? street_PSN,
    String? district_PSN,
    String? amphoe_PSN,
    String? province_PSN,
    String? zipcode_PSN,
    String? email_PSN,
    String? phone_PSN,
    String? nickname_PSN,
    String? personnel_id,
    String? date,
  }) {
    return UserModel(
      username_2: username_2 ?? this.username_2,
      user_ck_TypeJob: user_ck_TypeJob ?? this.user_ck_TypeJob,
      AcgU_code: AcgU_code ?? this.AcgU_code,
      ID_personnel: ID_personnel ?? this.ID_personnel,
      enforce_pass: enforce_pass ?? this.enforce_pass,
      enforce_openfilepass: enforce_openfilepass ?? this.enforce_openfilepass,
      status_user: status_user ?? this.status_user,
      title_name: title_name ?? this.title_name,
      firstname_PSN: firstname_PSN ?? this.firstname_PSN,
      lastname_PSN: lastname_PSN ?? this.lastname_PSN,
      PST_code: PST_code ?? this.PST_code,
      startworkdate_PSN: startworkdate_PSN ?? this.startworkdate_PSN,
      position: position ?? this.position,
      WP_code: WP_code ?? this.WP_code,
      workplace: workplace ?? this.workplace,
      belong_id: belong_id ?? this.belong_id,
      belong: belong ?? this.belong,
      region_id: region_id ?? this.region_id,
      region: region ?? this.region,
      check_jobBL: check_jobBL ?? this.check_jobBL,
      check_jobRG: check_jobRG ?? this.check_jobRG,
      check_jobDM: check_jobDM ?? this.check_jobDM,
      PSTLv_Code: PSTLv_Code ?? this.PSTLv_Code,
      token_set_version: token_set_version ?? this.token_set_version,
      token_set_message: token_set_message ?? this.token_set_message,
      WP_MB_Code: WP_MB_Code ?? this.WP_MB_Code,
      photo_PSN: photo_PSN ?? this.photo_PSN,
      MB_Name: MB_Name ?? this.MB_Name,
      address_PSN: address_PSN ?? this.address_PSN,
      moo_PSN: moo_PSN ?? this.moo_PSN,
      rillage_PSN: rillage_PSN ?? this.rillage_PSN,
      alley_PSN: alley_PSN ?? this.alley_PSN,
      street_PSN: street_PSN ?? this.street_PSN,
      district_PSN: district_PSN ?? this.district_PSN,
      amphoe_PSN: amphoe_PSN ?? this.amphoe_PSN,
      province_PSN: province_PSN ?? this.province_PSN,
      zipcode_PSN: zipcode_PSN ?? this.zipcode_PSN,
      email_PSN: email_PSN ?? this.email_PSN,
      phone_PSN: phone_PSN ?? this.phone_PSN,
      nickname_PSN: nickname_PSN ?? this.nickname_PSN,
      personnel_id: personnel_id ?? this.personnel_id,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username_2': username_2,
      'user_ck_TypeJob': user_ck_TypeJob,
      'AcgU_code': AcgU_code,
      'ID_personnel': ID_personnel,
      'enforce_pass': enforce_pass,
      'enforce_openfilepass': enforce_openfilepass,
      'status_user': status_user,
      'title_name': title_name,
      'firstname_PSN': firstname_PSN,
      'lastname_PSN': lastname_PSN,
      'PST_code': PST_code,
      'startworkdate_PSN': startworkdate_PSN,
      'position': position,
      'WP_code': WP_code,
      'workplace': workplace,
      'belong_id': belong_id,
      'belong': belong,
      'region_id': region_id,
      'region': region,
      'check_jobBL': check_jobBL,
      'check_jobRG': check_jobRG,
      'check_jobDM': check_jobDM,
      'PSTLv_Code': PSTLv_Code,
      'token_set_version': token_set_version,
      'token_set_message': token_set_message,
      'WP_MB_Code': WP_MB_Code,
      'photo_PSN': photo_PSN,
      'MB_Name': MB_Name,
      'address_PSN': address_PSN,
      'moo_PSN': moo_PSN,
      'rillage_PSN': rillage_PSN,
      'alley_PSN': alley_PSN,
      'street_PSN': street_PSN,
      'district_PSN': district_PSN,
      'amphoe_PSN': amphoe_PSN,
      'province_PSN': province_PSN,
      'zipcode_PSN': zipcode_PSN,
      'email_PSN': email_PSN,
      'phone_PSN': phone_PSN,
      'nickname_PSN': nickname_PSN,
      'personnel_id': personnel_id,
      'date': date,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      username_2: map['username_2'] ?? '',
      user_ck_TypeJob: map['user_ck_TypeJob'] ?? '',
      AcgU_code: map['AcgU_code'] ?? '',
      ID_personnel: map['ID_personnel'] ?? '',
      enforce_pass: map['enforce_pass'] ?? '',
      enforce_openfilepass: map['enforce_openfilepass'] ?? '',
      status_user: map['status_user'] ?? '',
      title_name: map['title_name'] ?? '',
      firstname_PSN: map['firstname_PSN'] ?? '',
      lastname_PSN: map['lastname_PSN'] ?? '',
      PST_code: map['PST_code'] ?? '',
      startworkdate_PSN: map['startworkdate_PSN'] ?? '',
      position: map['position'] ?? '',
      WP_code: map['WP_code'] ?? '',
      workplace: map['workplace'] ?? '',
      belong_id: map['belong_id'] ?? '',
      belong: map['belong'] ?? '',
      region_id: map['region_id'] ?? '',
      region: map['region'] ?? '',
      check_jobBL: map['check_jobBL'] ?? '',
      check_jobRG: map['check_jobRG'] ?? '',
      check_jobDM: map['check_jobDM'] ?? '',
      PSTLv_Code: map['PSTLv_Code'] ?? '',
      token_set_version: map['token_set_version'] ?? '',
      token_set_message: map['token_set_message'] ?? '',
      WP_MB_Code: map['WP_MB_Code'] ?? '',
      photo_PSN: map['photo_PSN'] ?? '',
      MB_Name: map['MB_Name'] ?? '',
      address_PSN: map['address_PSN'] ?? '',
      moo_PSN: map['moo_PSN'] ?? '',
      rillage_PSN: map['rillage_PSN'] ?? '',
      alley_PSN: map['alley_PSN'] ?? '',
      street_PSN: map['street_PSN'] ?? '',
      district_PSN: map['district_PSN'] ?? '',
      amphoe_PSN: map['amphoe_PSN'] ?? '',
      province_PSN: map['province_PSN'] ?? '',
      zipcode_PSN: map['zipcode_PSN'] ?? '',
      email_PSN: map['email_PSN'] ?? '',
      phone_PSN: map['phone_PSN'] ?? '',
      nickname_PSN: map['nickname_PSN'] ?? '',
      personnel_id: map['personnel_id'] ?? '',
      date: map['date'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(username_2: $username_2, user_ck_TypeJob: $user_ck_TypeJob, AcgU_code: $AcgU_code, ID_personnel: $ID_personnel, enforce_pass: $enforce_pass, enforce_openfilepass: $enforce_openfilepass, status_user: $status_user, title_name: $title_name, firstname_PSN: $firstname_PSN, lastname_PSN: $lastname_PSN, PST_code: $PST_code, startworkdate_PSN: $startworkdate_PSN, position: $position, WP_code: $WP_code, workplace: $workplace, belong_id: $belong_id, belong: $belong, region_id: $region_id, region: $region, check_jobBL: $check_jobBL, check_jobRG: $check_jobRG, check_jobDM: $check_jobDM, PSTLv_Code: $PSTLv_Code, token_set_version: $token_set_version, token_set_message: $token_set_message, WP_MB_Code: $WP_MB_Code, photo_PSN: $photo_PSN, MB_Name: $MB_Name, address_PSN: $address_PSN, moo_PSN: $moo_PSN, rillage_PSN: $rillage_PSN, alley_PSN: $alley_PSN, street_PSN: $street_PSN, district_PSN: $district_PSN, amphoe_PSN: $amphoe_PSN, province_PSN: $province_PSN, zipcode_PSN: $zipcode_PSN, email_PSN: $email_PSN, phone_PSN: $phone_PSN, nickname_PSN: $nickname_PSN , personnel_id: $personnel_id, date: $date)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.username_2 == username_2 &&
        other.user_ck_TypeJob == user_ck_TypeJob &&
        other.AcgU_code == AcgU_code &&
        other.ID_personnel == ID_personnel &&
        other.enforce_pass == enforce_pass &&
        other.enforce_openfilepass == enforce_openfilepass &&
        other.status_user == status_user &&
        other.title_name == title_name &&
        other.firstname_PSN == firstname_PSN &&
        other.lastname_PSN == lastname_PSN &&
        other.PST_code == PST_code &&
        other.startworkdate_PSN == startworkdate_PSN &&
        other.position == position &&
        other.WP_code == WP_code &&
        other.workplace == workplace &&
        other.belong_id == belong_id &&
        other.belong == belong &&
        other.region_id == region_id &&
        other.region == region &&
        other.check_jobBL == check_jobBL &&
        other.check_jobRG == check_jobRG &&
        other.check_jobDM == check_jobDM &&
        other.PSTLv_Code == PSTLv_Code &&
        other.token_set_version == token_set_version &&
        other.token_set_message == token_set_message &&
        other.WP_MB_Code == WP_MB_Code &&
        other.photo_PSN == photo_PSN &&
        other.MB_Name == MB_Name &&
        other.address_PSN == address_PSN &&
        other.moo_PSN == moo_PSN &&
        other.rillage_PSN == rillage_PSN &&
        other.alley_PSN == alley_PSN &&
        other.street_PSN == street_PSN &&
        other.district_PSN == district_PSN &&
        other.amphoe_PSN == amphoe_PSN &&
        other.province_PSN == province_PSN &&
        other.zipcode_PSN == zipcode_PSN &&
        other.email_PSN == email_PSN &&
        other.phone_PSN == phone_PSN &&
        other.nickname_PSN == nickname_PSN &&
        other.personnel_id == personnel_id &&
        other.date == date;
  }

  @override
  int get hashCode {
    return username_2.hashCode ^
        user_ck_TypeJob.hashCode ^
        AcgU_code.hashCode ^
        ID_personnel.hashCode ^
        enforce_pass.hashCode ^
        enforce_openfilepass.hashCode ^
        status_user.hashCode ^
        title_name.hashCode ^
        firstname_PSN.hashCode ^
        lastname_PSN.hashCode ^
        PST_code.hashCode ^
        startworkdate_PSN.hashCode ^
        position.hashCode ^
        WP_code.hashCode ^
        workplace.hashCode ^
        belong_id.hashCode ^
        belong.hashCode ^
        region_id.hashCode ^
        region.hashCode ^
        check_jobBL.hashCode ^
        check_jobRG.hashCode ^
        check_jobDM.hashCode ^
        PSTLv_Code.hashCode ^
        token_set_version.hashCode ^
        token_set_message.hashCode ^
        WP_MB_Code.hashCode ^
        photo_PSN.hashCode ^
        MB_Name.hashCode ^
        address_PSN.hashCode ^
        moo_PSN.hashCode ^
        rillage_PSN.hashCode ^
        alley_PSN.hashCode ^
        street_PSN.hashCode ^
        district_PSN.hashCode ^
        amphoe_PSN.hashCode ^
        province_PSN.hashCode ^
        zipcode_PSN.hashCode ^
        email_PSN.hashCode ^
        phone_PSN.hashCode ^
        nickname_PSN.hashCode ^
        personnel_id.hashCode ^
        date.hashCode;
  }
}
