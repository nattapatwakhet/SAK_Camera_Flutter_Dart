import 'package:get/get.dart';
import 'package:sakcamera_getx/constant/main_constant.dart';

class TranslationService extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'th': {
      //===>> Section Login <===//
      'name_project': 'ระบบบริหารจัดการภายในองค์กร',
      'name_company': 'บริษัท ศักดิ์สยามลิสซิ่ง จำกัด (มหาชน)',
      'login': 'เข้าสู่ระบบ',
      'username': 'ชื่อผู้ใช้',
      'username_required': '*กรุณากรอกข้อมูล ชื่อผู้ใช้',
      'password': 'รหัสผ่าน',
      'password_required': '*กรุณากรอกรหัสผ่าน',
      'forget_password': 'ลืมรหัสผ่าน',
      'logout': 'ออกจากระบบ',
      'privacy_policy': 'เงื่อนไขและนโยบายความเป็นส่วนตัว',
      'dev_by': 'พัฒนาโดย : ฝ่ายพัฒนาระบบส่งเสริมปฏิบัติการ (version ${MainConstant.version})',

      'loging_in': 'กำลังเข้าสู่ระบบ',
      'not_loging_in': 'เข้าสู่ระบบไม่สำเร็จ',
      'warning_try_login_message': 'กรุณาลองเข้าสู่ระบบใหม่อีกครั้ง',

      'status_901_head': 'สิทธิ์การเข้าใช้ระบบของท่าน\nยังไม่ได้เปิดใช้งาน',
      'status_901_message': 'กรุณาติดต่อเจ้าหน้าที่\n ไลน์ ID: @214bbyek',
      'status_902_head': 'ชื่อผู้ใช้ของท่านไม่ถูกต้อง',
      'status_903_head': 'รหัสผ่านของท่านไม่ถูกต้อง',
      //===>> Section Login <===//

      //===>> Section Internet <===//
      'connect_internet_message': 'เชื่อมต่ออินเทอร์เน็ตแล้ว',
      'disconnect_internet_message': 'ไม่มีการเชื่อมต่ออินเทอร์เน็ต',
      //===>> Section Internet <===//

      //===>> Section Checkversion <===//
      'name_version': 'ตรวจสอบเวอร์ชัน',
      'warning_checkversion': 'กรุณาอัปเดตเวอร์ชัน',
      'current_version': 'เวอร์ชันปัจจุบันของคุณคือ',
      'update_version': 'อัปเดตเวอร์ชันใหม่คือ',
      'checking_version': 'กำลังตรวจสอบเวอร์ชัน...',
      'checking_version_update': 'มีเวอร์ชันใหม่ กรุณาอัปเดต',
      'version_uptodate': 'เวอร์ชันของคุณเป็นเวอร์ชันล่าสุด',
      'version_faild': 'ไม่สามารถตรวจสอบเวอร์ชันได้',
      'error': 'เกิดข้อผิดพลาด',
      'error_message': 'ไม่สามารถตรวจสอบเวอร์ชันได้ กรุณาลองใหม่',

      'android_store': 'เปิด Play Store',
      'ios_store': 'เปิด App Store',
      'huawei_store': 'เปิด AppGallery',

      'setting': 'ตั้งค่า',
      'clear_setting': 'รีเซ็ตข้อมูล',

      //===>> Section Checkversion <===//

      //===>> Section ขอสิทธิ์ <===//
      'peramission_camera': 'อนุญาตให้เข้าถึงกล้อง',
      'peramission_camera_message': 'กรุณาเปิดอนุญาตสิทธิ์กล้องเพื่อใช้งานคุณสมบัตินี้',
      'peramission_microphone': 'อนุญาตให้เข้าถึงไมโครโฟน',
      'peramission_microphone_message': 'กรุณาเปิดอนุญาตสิทธิ์ไมโครโฟนเพื่อใช้งานคุณสมบัตินี้',
      'peramission_location': 'อนุญาตให้เข้าถึงตำแหน่งที่ตั้ง',
      'peramission_location_message': 'กรุณาเปิดอนุญาตสิทธิ์ตำแหน่งที่ตั้งเพื่อใช้งานคุณสมบัตินี้',
      'peramission_storage': 'อนุญาตให้เข้าถึงที่จัดเก็บข้อมูล',
      'peramission_storage_message': 'กรุณาเปิดอนุญาตสิทธิ์ที่จัดเก็บข้อมูลเพื่อใช้งานคุณสมบัตินี้',
      //===>> Section ขอสิทธิ์ <===//

      //===>> Section ปฏิเสธขอสิทธิ์ <===//
      'denied_peramission_camera': 'การขออนุญาตสิทธิ์กล้องถูกปฏิเสธ',
      'denied_peramission_camera_message': 'กรุณาเปิดอนุญาตสิทธิ์กล้องเพื่อใช้งานคุณสมบัตินี้',
      'denied_peramission_microphone': 'การขออนุญาตสิทธิ์ไมโครโฟนถูกปฏิเสธ',
      'denied_peramission_microphone_message': 'กรุณาไปที่การตั้งค่าเพื่ออนุญาตการเข้าถึงไมโครโฟน',
      'denied_peramission_location': 'การขออนุญาตสิทธิ์ตำแหน่งที่ตั้งถูกปฏิเสธ',
      'denied_peramission_location_message':
          'กรุณาเปิดอนุญาตสิทธิ์ตำแหน่งที่ตั้งเพื่อใช้งานคุณสมบัตินี้',
      'denied_peramission_storage': 'การขออนุญาตสิทธิ์พื้นที่จัดเก็บข้อมูลถูกปฏิเสธ',
      'denied_peramission_storage_message':
          'กรุณาเปิดอนุญาตสิทธิ์ที่จัดเก็บข้อมูลเพื่อใช้งานคุณสมบัตินี้',
      //===>> Section ปฏิเสธขอสิทธิ์ <===//

      //===>> Section ปฏิเสธขอสิทธิ์ไปตั้งค่า <===//
      'setting_peramission_camera_message': 'กรุณาไปที่การตั้งค่าเพื่อเปิดสิทธิ์ใช้งานกล้อง',
      'setting_peramission_microphone_message': 'กรุณาไปที่การตั้งค่าเพื่ออนุญาตการเข้าถึงไมโครโฟน',
      'setting_peramission_location_message':
          'กรุณาไปที่การตั้งค่าเพื่ออนุญาตการเข้าถึงตำแหน่งที่ตั้ง',
      'setting_peramission_storage_message':
          'กรุณาไปที่การตั้งค่าเพื่ออนุญาตการเข้าถึงพื้นที่จัดเก็บข้อมูล',
      //===>> Section ปฏิเสธขอสิทธิ์ไปตั้งค่า <===//

      //===>> Section switch <===//
      'switch_map': 'เปิดใช้งาน Google Map:',
      'switch_watermark': 'ลายน้ำ:',
      //===>> Section switch <===//

      //===>> Section Warning <===//
      'warning': 'แจ้งเตือน',
      'warning_close_app': 'ต้องการปิดแอปหรือไม่',
      //===>> Section Warning <===//

      //===>> Section Button <===//
      'ok': 'ตกลง',
      'cancel': 'ยกเลิก',
      'go_setting': 'ไปที่ตั้งค่า',
      //===>> Section Button <===//

      //===>> Section ปิด/เปิด <===//
      'on': 'เปิด',
      'off': 'ปิด',
      //===>> Section ปิด/เปิด <===//
    },
    'en': {
      //===>> Section Login <===//
      'name_project': 'Management Information System',
      'name_company': 'SAKSIAM LEASING PUBLIC COMPANY LIMITED',
      'login': 'Login',
      'username': 'Username',
      'password': 'Password',
      'password_required': '*Please enter your password',
      'forget_password': 'Forgot your password?',
      'privacy_policy': 'Terms and Privacy Policy',
      'logout': 'Logout',
      'dev_by': 'Developed by: System Development Department.(version ${MainConstant.version})',

      'loging_in': 'Loging in',
      'not_loging_in': 'Login failed',
      'warning_try_login_message': 'Please try to log in again',

      'status_901_head': 'Your system access has not been activated yet',
      'status_901_message': 'Please contact support\n LINE ID: @214bbyek',
      'status_902_head': 'Your username is incorrect',
      'status_903_head': 'Your password is incorrect',
      //===>> Section Login <===//

      //===>> Section Internet <===//
      'connect_internet_message': 'Internet connected',
      'disconnect_internet_message': 'No internet connection',
      //===>> Section Internet <===//

      //===>> Section Checkversion <===//
      'name_version': 'Check version',
      'warning_checkversion': 'Please update version',
      'current_version': 'Your current version is',
      'update_version': 'The new version update is',
      'checking_version': 'Checking version…',
      'checking_version_update': 'A new version is available. Please update.',
      'version_uptodate': 'Your version is up to date.',
      'version_faild': 'Unable to check version.',
      'error': 'An error occurred.',
      'error_message': 'Unable to check version. Please try again.',

      'android_store': 'Go to Play Store',
      'ios_store': 'Go to App Store',
      'huawei_store': 'Go to AppGallery',

      'setting': 'Setting',
      'clear_setting': 'Reset Data',
      //===>> Section Checkversion <===//

      //===>> Section ขอสิทธิ์ <===//
      'peramission_camera': 'Allow access camera.',
      'peramission_camera_message': 'Please allow camera access to use this feature.',
      'peramission_microphone': 'Allow access microphone.',
      'peramission_microphone_message': 'Please allow microphone access to use this feature.',
      'peramission_location': 'Allow access location.',
      'peramission_location_message': 'Please allow location access to use this feature.',
      'peramission_storage': 'Allow access to storage.',
      'peramission_storage_message': 'Please allow storage access to use this feature.',
      //===>> Section ขอสิทธิ์ <===//

      //===>> Section ปฏิเสธขอสิทธิ์ <===//
      'denied_peramission_camera': 'Camera access denied.',
      'denied_peramission_camera_message': 'Please allow camera access to use this feature.',
      'denied_peramission_microphone': 'Microphone access denied.',
      'denied_peramission_microphone_message':
          'Please allow microphone access to use this feature.',
      'denied_peramission_location': 'Location access denied.',
      'denied_peramission_location_message': 'Please allow location access to use this feature.',
      'denied_peramission_storage': 'Storage access denied.',
      'denied_peramission_storage_message': 'Please allow storage access to use this feature.',
      //===>> Section ปฏิเสธขอสิทธิ์ <===//

      //===>> Section ปฏิเสธขอสิทธิ์ไปตั้งค่า <===//
      'setting_peramission_camera_message': 'Please go to settings to allow camera access.',
      'setting_peramission_microphone_message': 'Please go to settings to allow microphone access.',
      'setting_peramission_location_message': 'Please go to settings to allow location access.',
      'setting_peramission_storage_message': 'Please go to settings to allow storage access.',
      //===>> Section ปฏิเสธขอสิทธิ์ไปตั้งค่า <===//

      //===>> Section switch <===//
      'switch_map': 'Open Google Map:',
      'switch_watermark': 'Water Mark:',
      //===>> Section switch <===//

      //===>> Section Warning <===//
      'warning': 'Warning',
      'warning_close_app': 'Want to close the app?',

      //===>> Section Warning <===//

      //===>> Section Button <===//
      'ok': 'OK',
      'cancel': 'Cancel',
      'go_setting': 'Go to settings',
      //===>> Section Button <===//

      //===>> Section ปิด/เปิด <===//
      'on': 'On',
      'off': 'Off',
      //===>> Section ปิด/เปิด <===//
    },
  };
}
