// =====================================================
// IMPORTS
// =====================================================

// Dart core
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:math' as math;
import 'dart:ui' as ui;

// Flutter
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

// Camera & Media
import 'package:camera/camera.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;

// Permissions & Storage
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:gal/gal.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path_provider/path_provider.dart';

// Device / Sensor / Location
import 'package:device_info_plus/device_info_plus.dart';
import 'package:sakcamera_getx/compute/processimage/prepare_logo.dart';
import 'package:sakcamera_getx/state/camera/setting_controller.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:geolocator/geolocator.dart';

// Map
import 'package:google_maps_flutter/google_maps_flutter.dart' as gm;

// State / GetX / App modules
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project specific
import 'package:sakcamera_getx/component/main_dialog_component.dart';
import 'package:sakcamera_getx/compute/processimage/image_process_compute.dart';
import 'package:sakcamera_getx/compute/processtask/process_image_compute.dart';
import 'package:sakcamera_getx/constant/main_constant.dart';
import 'package:sakcamera_getx/controller/device_controller.dart';
import 'package:sakcamera_getx/controller/user_controller.dart';
import 'package:sakcamera_getx/model/camera/imageprocess.dart';
import 'package:sakcamera_getx/state/camera/gallery_controller.dart';
import 'package:sakcamera_getx/state/camera/map_controller.dart';

class CameraPageController extends GetxController with WidgetsBindingObserver {
  // ===== Layout State ===== //
  /// เก็บ constraint ล่าสุดของ preview
  /// สำคัญมาก ใช้คำนวณตำแหน่ง logo / map / text ตอน process รูป
  var lastconstraints = Rx<BoxConstraints?>(null);

  /// context กลางของหน้า camera (ใช้เรียก dialog / navigator)
  BuildContext? get context => Get.context;

  /// ป้องกัน add WidgetsBindingObserver ซ้ำ
  bool addobserver = false;

  /// ป้องกัน init ซ้ำตอน onReady
  bool initialize = false;

  /// controller ที่เกี่ยวข้องกับหน้า camera
  late final UserController usercontroller;
  late final MapController mapcontroller;
  late final GalleryController gallerycontroller;
  // ===== Layout State ===== //

  // ===== Permission State ===== //
  // ===== Camera & Microphone Permission State ===== //
  RxBool camerapermission = false.obs; // สิทธิ์กล้อง
  RxBool statuscamera = false.obs; // สถานะกล้องพร้อมใช้งาน (initialize แล้ว)
  RxBool microphonepermission = false.obs; // สิทธิ์ไมโครโฟน (ใช้กับ video / audio)
  // ===== Camera & Microphone Permission State ===== //

  // ===== Location Permission State ===== //
  RxBool locationpermission = false.obs; // สิทธิ์ตำแหน่ง (ใช้กับ Google Map)
  // ===== Location Permission State ===== //

  // ===== Storage Permission State ===== //
  RxBool storagepermission = false.obs; // สิทธิ์เก็บข้อมูล / gallery
  // ===== Storage Permission State ===== //
  // ===== Permission State ===== //

  // ===== Permission flag ===== //
  bool requestpermission = false; // ใช้กัน lifecycle ทำงานระหว่างขอ permission
  bool statusresumed = false; // ใช้เช็คว่า resume จาก background แล้วหรือยัง (ตอนยุบแอป)

  bool cameradialogshowing = false; // ป้องกัน dialog ขอ permission เด้งซ้อน
  bool resumedfromsetting = false; // ใช้รู้ว่ากลับมาจากหน้า settings
  bool denieddialogshowing = false; // ป้องกัน dialog denied เด้งซ้อน
  bool settingdialogshowing = false; // ป้องกัน dialog setting เด้งซ้อน
  // ===== Permission flag ===== //

  // ===== process flag ===== //
  bool layoutready = false; // true เมื่อ layout พร้อม (ใช้ก่อน takePicture)
  // ===== process flag ===== //

  // ===== Sensor  State ===== //
  final rotationangle = 0.obs; //ตัวแปร sensor หมุนอัตโนมัติ ค่า rotation ปัจจุบัน (0,1,2,3)
  int lastrotationangle = 0; // เก็บ rotation ล่าสุด เพื่อกัน set ซ้ำ
  StreamSubscription? sensorsub; // subscription ของ sensor
  // ===== Sensor State ===== //

  // ===== Camera State ===== //
  CameraController? cameracontroller; // controller หลักของกล้อง
  List<CameraDescription> cameralist = []; // รายชื่อกล้องในเครื่อง
  int selectedcamera = 0; // index กล้องที่ใช้อยู่ (หน้า / หลัง)
  Rx<Size?> previewsize = Rx<Size?>(null); // ขนาด preview ที่ได้จาก camera
  CameraLensDirection currentlensdirection =
      CameraLensDirection.back; // lens ปัจจุบัน (front / back)
  bool switchcamera = false; //ตัวแปรกันกดซ้ำสลับกล้อง
  bool showpreview = false; // แสดง preview หรือไม่ (หลังขอ permission)

  // flash & Shutter
  Rx<FlashMode> statusflashmode = FlashMode.off.obs; // สถานะแฟลช (off / auto / torch)
  bool setautoflash = false; // flag ใช้กับ flash auto
  RxBool shuttereffect = false.obs; // เอฟเฟคชัตเตอร์ (flash ขาว)

  // focus
  var focusoffset = Rx<Offset?>(null); // ตำแหน่ง tap focus
  var focusscale = 1.0.obs; // scale animation ของกรอบ focus
  var focusopacity = 0.0.obs; // ความโปร่งใสของกรอบ focus
  // focus

  // zoom
  RxDouble zoomlevel = 1.0.obs; // ระดับ zoom ปัจจุบัน
  double basezoom = 1.0; // zoom ก่อน pinch start

  double minzoom = 1.0; // ค่า zoom ต่ำสุด
  double maxzoom = 1.0; // สูงสุดจาก hardware

  RxDouble zoomopacity = 0.0.obs; // ใช้แสดง indicator zoom
  Timer? zoomtimer; // เวลาแสดง zoom
  // zoom

  // ปรับแสง

  // ปรับแสง

  // ===== camera resource cache ===== //
  img.Image? imglogocache; // cache logo แบบ decode แล้ว (ลดเวลา process)
  Uint8List? googlemapsnapshot; // cache google map snapshot
  Uint8List? fluttermapsnapshot; // cache flutter map snapshot

  Uint8List? mapbytes; // cache map snapshot bytes
  final GlobalKey infotextkey = GlobalKey(); // key สำหรับ capture widget text overlay
  final GlobalKey fluttermapsnapshotkey = GlobalKey(); // key สำหรับ capture widget flutter map
  // ===== camera resource cache ===== //
  // ===== Camera State ===== //

  // ===== Process State ===== //
  List<ProcessImage> taskqueue = []; // คิวงาน process รูป
  bool processingqueue = false; // true เมื่อกำลัง process queue

  final processingcount = 0.obs; // จำนวนงานที่กำลัง process

  //== เก็บค่าตำแหน่ง logo เพื่อไปวาด ==//
  double logouiwidth = 80; // ความกว้าง logo บน UI
  double logolanscapeuiwidth = 60; // ความกว้าง logo บน UI
  //== เก็บค่าตำแหน่ง logo เพื่อไปวาด ==//
  //== เก็บค่าตำแหน่ง map เพื่อไปวาด ==//
  double mapuiwidth = 105; // ความกว้าง map บน UI
  double maplanscapeuiwidth = 85; // ความกว้าง map บน UI
  //== เก็บค่าตำแหน่ง map เพื่อไปวาด ==//
  // ===== Process State ===== //

  // ===== Storage State ===== //
  final String albumname = 'SAK_Camera'; // ชื่ออัลบั้มที่ใช้บันทึกรูป
  // ===== Storage State ===== //

  late Rx<File?> lastfile = Rx<File?>(null);

  PreparedOverlay? preparelogo;
  PreparedOverlay? preparemap;

  PreparedOverlay? preparelanscapelogo;
  PreparedOverlay? preparelanscapemap;

  PreparedOverlay? preparetext;

  PreparedOverlay? emptybase;

  // ===== Function State ===== //
  @override
  void onInit() {
    super.onInit();

    final devicecontroller = Get.find<DeviceController>();

    usercontroller = Get.find<UserController>();
    mapcontroller = Get.put(MapController());
    gallerycontroller = Get.put(GalleryController());

    if (kDebugMode) {
      print("===>> [status] Device brand is: ${devicecontroller.manufacture.value}");
    }
  }

  @override
  void onReady() async {
    super.onReady();
    if (!addobserver) {
      WidgetsBinding.instance.addObserver(this);
      addobserver = true;
    }
    // โหลด User ใหม่ทุกครั้งที่เข้าหน้ากล้อง
    final usercontroller = Get.find<UserController>();
    usercontroller.loadUserFromLocal();
    if (!initialize) {
      initialize = true;
      startApp();
    }
  }

  // === จัดการ lifecycle ของแอป === //
  @override
  Future didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (requestpermission) {
      // ข้าม ไม่ต้องจัดการ lifecycle ตอนนี้
      if (kDebugMode) {
        print("===>> [status] skip lifecycle เพราะกำลังขอ permission");
      }
      return;
    }
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      try {
        if (!requestpermission) {
          statusresumed = false;

          //หยุดกล้องขณะยุบแอปพลิเคชัน
          if (cameracontroller != null) {
            await cameracontroller!.pausePreview();
            if (kDebugMode) {
              print('===>> [status] Camera pausePreview สถานะ: ยุบแอปพลิเคชัน');
              print('===>> [status] Camera (state: $state)');
            }

            statuscamera.value = false;
          }
        }
      } catch (error) {
        if (kDebugMode) {
          print('===>> [error] state AppLifecycleState.paused: $error');
        }
      }
    } else if (state == AppLifecycleState.resumed && !statusresumed) {
      try {
        if (!requestpermission) {
          if (resumedfromsetting) {
            resumedfromsetting = false; // reset flag
            bool camerapermission = await Permission.camera.isGranted;
            bool microphonepermission = await Permission.microphone.isGranted;

            if (camerapermission || microphonepermission) {
              cameradialogshowing = false; // reset camera Dialog กันการเด้งซ้อน
              denieddialogshowing = false; // reset Denied Dialog กันการเด้งซ้อน
              settingdialogshowing = false; // reset Setting Dialog กันการเด้งซ้อน

              requestpermission = false; // คืนค่าปกติ สถานะไม่ให้เรียก lifecycle

              await startApp(statusprocess: true);
            }
          }

          if (!statuscamera.value) {
            // เปิดกล้องใหม่
            await openCamera();

            //setflash
            await setFlashCamera();
          }

          if (kDebugMode) {
            print('===>> [status] เรียก camera AppLifecycleState');
          }

          statusresumed = true;
        } else {
          if (resumedfromsetting) {
            resumedfromsetting = false;
          }
        }
      } catch (error) {
        if (kDebugMode) {
          print('===>> [error] state AppLifecycleState.resumed: $error');
        }
      }
    }
  }

  @override
  void onClose() {
    super.onClose();
    WidgetsBinding.instance.removeObserver(this);
    try {
      cameracontroller?.dispose();
    } catch (_) {}
    sensorsub?.cancel();
  }

  // ===== start ===== //
  Future startApp({statusprocess = false}) async {
    try {
      requestpermission = true; //เริ่มการขอ permission แล้ว

      //===>> ขออนุญาตสิทธิ์กล้อง && ไมโครโฟน
      camerapermission.value = await getPermission('camera');
      microphonepermission.value = await getPermission('microphone');
      if (camerapermission.value && microphonepermission.value) {
        await openCamera();
      }
      //===>> ขออนุญาตสิทธิ์กล้อง && ไมโครโฟน

      //===>> ขออนุญาตสิทธิ์ตำแหน่งที่ตั้ง
      locationpermission.value = await getPermission('location');
      if (locationpermission.value) {
        await openMapLocation();
        // mapcontroller.setGoogleLatLng(
        //   gm.LatLng(17.62263, 100.08710), // สำนักงานใหญ่
        // );
      }
      //===>> ขออนุญาตสิทธิ์ตำแหน่งที่ตั้ง

      //===>> ขออนุญาตสิทธิ์ที่เก็บข้อมูล
      storagepermission.value = await getPermission('storage');
      if (kDebugMode) {
        print('===>> Go getPermissionstorage: $storagepermission');
      }
      if (storagepermission.value) {
        // await openStorageGallery();
        // await updateLastImage(); // อัปเดทภาพล่าสุด
      }
      //===>> ขออนุญาตสิทธิ์ที่เก็บข้อมูล

      requestpermission = false; //การขอ permission จบแล้ว
      rotation();
    } catch (error) {
      if (kDebugMode) {
        print('===>> [error] Fun');
      }
    }
  }
  // ===== start ===== //

  // ===== ขอสิทขั้นแรก ===== //
  Future getPermission(String permission) async {
    bool granted = false;
    try {
      final Map<String, dynamic> result = await checkPermission(permission, granted);
      granted = result['granted'] ?? false;
      // ===== ถ้ามีสิทธิ์อยู่แล้ว ===== //
      if (granted == true) {
        return granted;
      }

      if (!Platform.isIOS) {
        String title = '';
        String message = '';
        if (permission == 'camera') {
          title = 'peramission_camera'.tr;
          message = 'peramission_camera_message'.tr;
        } else if (permission == 'microphone') {
          title = 'peramission_microphone'.tr;
          message = 'peramission_microphone_message'.tr;
        } else if (permission == 'location') {
          title = 'peramission_location'.tr;
          message = 'peramission_location_message'.tr;
        } else if (permission == 'storage') {
          title = 'peramission_storage'.tr;
          message = 'peramission_storage_message'.tr;
        }

        // ===== popup แรก =====
        dynamic resultdialog;
        if (context == null) {
          return false;
        }
        resultdialog = await MainDialog.dialogPopup(
          context!,
          true,
          title,
          message: message,
          confirmbutton: 'ok'.tr,
          closebutton: 'cancel'.tr,
          valueconfirmbutton: true,
          valueclosebutton: false,
          outback: true,
          back: true,
        );

        if (resultdialog == true) {
          await requeatPermission(permission);
        }
        // ยังไม่ได้สิทธิ์เรียก popup ของเรา
        return await showPermissionDialog(permission);
      } else {
        await requeatPermission(permission);
        return await showPermissionDialog(permission);
      }
    } catch (error) {
      if (kDebugMode) {
        print('error ===>> Camera getPermissionCamera: $error');
      }
      return false; // กลับค่า false กรณี error
    }
  }
  // ===== ขอสิทขั้นแรก ===== //

  // ===== ขอสิทขั้นสอง ===== //
  Future<Map<String, dynamic>> checkPermission(
    String permission,
    bool granted, {
    bool settingsgranted = false,
    PermissionStatus? status,
  }) async {
    if (permission == 'camera') {
      status = await Permission.camera.status;
      if (status.isGranted) {
        granted = true;
        settingsgranted = true;
        camerapermission.value = true;
      }
    } else if (permission == 'microphone') {
      status = await Permission.microphone.status;
      if (status.isGranted) {
        granted = true;
        settingsgranted = true;
        microphonepermission.value = true;
      }
    } else if (permission == 'location') {
      status = await Permission.location.status;
      if (status.isGranted) {
        granted = true;
        settingsgranted = true;
        locationpermission.value = true;
      }
    } else if (permission == 'storage') {
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        final sdkInt = androidInfo.version.sdkInt;
        if (sdkInt >= 33) {
          // Android 13+ เช็คทั้ง photos และ storage
          PermissionStatus photostatus = await Permission.photos.status;
          PermissionStatus storagestatus = await Permission.storage.status;

          if (photostatus.isGranted || storagestatus.isGranted) {
            settingsgranted = true;
            granted = true;
            if (photostatus.isGranted) {
              status = photostatus;
              storagepermission.value = true;
            } else if (storagestatus.isGranted) {
              status = photostatus;
              storagepermission.value = true;
            }
          }
        } else {
          // Android ต่ำกว่า 13 ใช้ storage
          PermissionStatus storagestatus = await Permission.storage.status;

          if (storagestatus.isGranted) {
            settingsgranted = true;
            granted = true;
            status = storagestatus;
            storagepermission.value = true;
          }
        }
      } else if (Platform.isIOS) {
        PermissionStatus photostatusios = await Permission.photos.status;
        PermissionStatus storagestatusios = await Permission.photosAddOnly.status;

        // ผ่านถ้าอย่างใดอย่างหนึ่งอนุญาต
        if (photostatusios.isGranted || storagestatusios.isGranted) {
          settingsgranted = true;
          granted = true;
          if (photostatusios.isGranted) {
            status = photostatusios;
            storagepermission.value = true;
          } else if (storagestatusios.isGranted) {
            status = photostatusios;
            storagepermission.value = true;
          }
        }
      }
    }
    // ส่งค่ากลับเสมอ
    return {'granted': granted, 'settingsgranted': settingsgranted, 'status': status};
  }
  // ===== ขอสิทขั้นสอง ===== //

  // ===== ฟังก์ชันเรียกสิทธิ์ ===== //
  Future<PermissionStatus> requeatPermission(String permission) async {
    PermissionStatus status = PermissionStatus.denied;
    if (permission == 'camera') {
      status = await Permission.camera.request();
    } else if (permission == 'microphone') {
      status = await Permission.microphone.request();
    } else if (permission == 'location') {
      status = await Permission.location.request();
    } else if (permission == 'storage') {
      await PhotoManager.requestPermissionExtend();
      if (Platform.isAndroid) {
        final androidinfo = await DeviceInfoPlugin().androidInfo;
        final sdkint = androidinfo.version.sdkInt;
        if (sdkint >= 33) {
          PermissionStatus photostatus = await Permission.photos.request();
          PermissionStatus storagestatus = await Permission.storage.request();

          if (photostatus.isGranted || storagestatus.isGranted) {
            status = photostatus;
          }
        } else {
          status = await Permission.storage.request();
        }
      } else if (Platform.isIOS) {
        status = await Permission.photos.request();
      }
    }
    return status;
  }
  // ===== ฟังก์ชันเรียกสิทธิ์ ===== //

  // ===== ฟังก์ชันแสดง Pop-Up กรณีไม่อนุญาตสิทธิ์หรือยังไม่ได้สิทธิ์ ===== //
  Future showPermissionDialog(String permission) async {
    if (cameradialogshowing) {
      return false;
    }
    bool granted = false;
    PermissionStatus status;
    try {
      while (!granted) {
        //กรณีไม่ได้สิทธิ์ checkPermission อีกที
        final Map<String, dynamic> result = await checkPermission(permission, granted);
        granted = result['granted'] ?? false;
        status = result['status'] ?? PermissionStatus.denied;
        if (permission == 'storage') {
          if (kDebugMode) {
            print('===>> $granted และ $status');
          }
        }
        if (status.isGranted) {
          granted = true;
          break;
        } else {}

        if (!resumedfromsetting) {
          await showDeniedDialog(permission);
          await showDialogSetting(permission);
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('error ===>> Camera showCameraDialog: $error');
      }
    } finally {
      cameradialogshowing = false;
    }
    return granted;
  }
  // ===== ฟังก์ชันแสดง Pop-Up กรณีไม่อนุญาตสิทธิ์หรือยังไม่ได้สิทธิ์ ===== //

  // ===== Pop-Up แจ้งเตือนกรณีไม่อนุญาตสิทธิ์ ===== //
  Future showDeniedDialog(String permission) async {
    if (denieddialogshowing) {
      return; // ป้องกันการเด้งซ้อน
    }
    denieddialogshowing = true;
    String title = '';
    String message = '';

    if (permission == 'camera') {
      title = 'denied_peramission_camera'.tr;
      message = 'denied_peramission_camera_message'.tr;
    } else if (permission == 'microphone') {
      title = 'denied_peramission_microphone'.tr;
      message = 'denied_peramission_microphone_message'.tr;
    } else if (permission == 'location') {
      title = 'denied_peramission_location'.tr;
      message = 'denied_peramission_location_message'.tr;
    }
    if (context == null) {
      return;
    }
    await MainDialog.dialogPopup(
      context!,
      true,
      title,
      message: message,
      confirmbutton: 'ok'.tr,
      valueconfirmbutton: true,
      valueclosebutton: false,
      outback: true,
      back: true,
    );
    denieddialogshowing = false; // ปิด dialog แล้วรีเซ็ต
  }
  // ===== Pop-Up แจ้งเตือนกรณีไม่อนุญาตสิทธิ์ ===== //

  // ===== ฟังก์ชันขออนุญาตกล้องไปตั้งค่า ===== //
  Future showDialogSetting(String permission) async {
    settingdialogshowing = true;
    String title = '';
    String message = '';
    if (permission == 'camera') {
      title = 'denied_peramission_camera'.tr;
      message = 'setting_peramission_camera_message'.tr;
    } else if (permission == 'microphone') {
      title = 'denied_peramission_microphone'.tr;
      message = 'setting_peramission_microphone_message'.tr;
    } else if (permission == 'location') {
      title = 'denied_peramission_location'.tr;
      message = 'setting_peramission_location_message'.tr;
    }

    if (context == null) {
      return;
    }
    dynamic settingsresult = await MainDialog.dialogPopup(
      context!,
      true,
      title,
      message: message,
      confirmbutton: 'go_setting'.tr,
      closebutton: 'cancel'.tr,
      valueconfirmbutton: true,
      valueclosebutton: false,
    );
    settingdialogshowing = false;
    if (settingsresult == false) {
    } else {
      resumedfromsetting = true;
      await openAppSettings();
    }
  }
  // ===== ฟังก์ชันขออนุญาตกล้องไปตั้งค่า ===== //

  Future openMapLocation() async {
    try {
      // เช็ค Location service //
      final serviceenabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceenabled) {
        if (kDebugMode) {
          print('===>> Location service disabled');
        }
        return;
      }
      // เช็ค Location service //

      // เช็ค + ขอ permission //
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        if (kDebugMode) {
          print('===>> Location permission denied forever');
        }
        return;
      }
      // เช็ค + ขอ permission //

      // ดึงตำแหน่งจริงจาก GPS //
      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      if (kDebugMode) {
        print('===>> Current location: ${position.latitude}, ${position.longitude}');
      }
      // ดึงตำแหน่งจริงจาก GPS //

      // ส่งพิกัดให้ MapController //
      mapcontroller.setGoogleLatLng(gm.LatLng(position.latitude, position.longitude));
      // ส่งพิกัดให้ MapController //

      googlemapsnapshot ??= await captureGoogleMapBytes();
    } catch (error) {
      if (kDebugMode) {
        print('===>> [error] openMapLocation: $error');
      }
    }
  }

  // ===== โหลดและเปิดกล้อง ===== //
  Future openCamera() async {
    try {
      showpreview = false; // status กล้องตอนขอสิทธิ์

      if (cameracontroller != null) {
        await cameracontroller!.dispose();
      }

      cameralist = await availableCameras();

      if (cameralist.isEmpty) {
        if (kDebugMode) {
          print('===>>[status] ไม่พบ camera ในเครื่อง');
        }
        return;
      }

      // เลือกกล้องหลังที่ดีที่สุด
      // await selectBestBackCamera();

      final int backcamera = cameralist.indexWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
      );
      if (backcamera != -1) {
        selectedcamera = backcamera;
      } else {
        selectedcamera = 0;
      }

      cameracontroller = CameraController(
        cameralist[selectedcamera],
        ResolutionPreset.max,
        imageFormatGroup: ImageFormatGroup.jpeg,
        enableAudio: microphonepermission.value, // เปิด true เสียงไมค์ได้ถ้ามีสิทธิ์แล้ว
      );

      await cameracontroller!.initialize();

      // === iOS กันหมุนเอง ===
      if (Platform.isIOS) {
        await cameracontroller!.lockCaptureOrientation(DeviceOrientation.portraitUp);
      }

      //setflash
      await setFlashCamera();

      // โหลดค่าซูม (สำคัญที่สุด)
      await initZoom();

      //เก็บค่า logo
      await preloadLogo();

      if (cameracontroller!.value.isInitialized) {
        showpreview = true;
        currentlensdirection = cameracontroller!.description.lensDirection;
        statuscamera.value = true;
      } else {
        if (kDebugMode) {
          print("===>> camera initialize failed");
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print("===>> [error] openCamera: $error");
      }
    }
  }
  // ===== โหลดและเปิดกล้อง ===== //

  // ===== สลับกล้อง ===== //
  Future switchCamera() async {
    // ป้องกันกดซ้ำ
    if (switchcamera) {
      return;
    }
    switchcamera = true;

    try {
      if (cameralist.isEmpty) {
        return;
      }
      statuscamera.value = false;

      if (cameracontroller != null) {
        await cameracontroller!.dispose();
        cameracontroller = null;
      }

      final newcameradirection =
          cameralist[selectedcamera].lensDirection == CameraLensDirection.front
          ? CameraLensDirection.back
          : CameraLensDirection.front;

      final newindex = cameralist.indexWhere((cam) => cam.lensDirection == newcameradirection);

      if (newindex != -1) {
        selectedcamera = newindex;
      }
      if (kDebugMode) {
        print('===>> [status] สลับกล้อง to index $selectedcamera');
      }

      cameracontroller = CameraController(cameralist[selectedcamera], ResolutionPreset.max);

      // รอ initialize ให้เสร็จก่อน
      try {
        await cameracontroller!.initialize();

        // === iOS กันหมุนเอง ===
        if (Platform.isIOS) {
          await cameracontroller!.lockCaptureOrientation(DeviceOrientation.portraitUp);
        }
      } catch (error) {
        if (kDebugMode) {
          print('===>>[error] CameraController initialize failed: $error');
        }
        return; // กล้องใช้ไม่ได้ ก็หยุดเลย
      }

      //setflash
      await setFlashCamera();

      await initZoom();

      statuscamera.value = true;
    } catch (error) {
      if (kDebugMode) {
        print('===>> [error] switchCamera: $error');
      }
    } finally {
      // ปิดการล็อก ตอนทำงานเสร็จจริงเท่านั้น
      switchcamera = false;
    }
  }
  // ===== สลับกล้อง ===== //

  // ===== เลือกกล้อง ===== //
  Future selectBestBackCamera() async {
    try {
      if (cameralist.isEmpty) {
        return;
      }

      final backcamera = cameralist
          .where((c) => c.lensDirection == CameraLensDirection.back)
          .toList();

      if (backcamera.isEmpty) {
        selectedcamera = 0;
        return;
      }

      double maxzoom = -1;
      CameraDescription? bestcamera;

      for (final camera in backcamera) {
        final status = CameraController(
          camera,
          ResolutionPreset.max,
          imageFormatGroup: ImageFormatGroup.jpeg,
        );
        await status.initialize();

        final zoomlevel = await status.getMaxZoomLevel();
        if (zoomlevel > maxzoom) {
          maxzoom = zoomlevel;
          bestcamera = camera;
        }
        await status.dispose();
      }
      // ถ้าเจอกล้องหลังที่ดีที่สุด
      if (bestcamera != null) {
        selectedcamera = cameralist.indexOf(bestcamera);
        if (kDebugMode) {
          print("===>> [status] Best Back Camera index = $selectedcamera (zoom: $maxzoom)");
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print("===>> [error] selectBestBackCamera error: $error");
      }
    }
  }
  // ===== เลือกกล้อง ===== //

  // ===== เซ็ทแฟลชกล้อง ===== //
  Future setFlashCamera() async {
    try {
      if (cameracontroller == null) {
        return;
      }
      // กล้องหน้าปิดแฟลชทันที
      if (cameracontroller!.description.lensDirection == CameraLensDirection.front) {
        statusflashmode.value = FlashMode.off;
        if (kDebugMode) {
          print('===>> [status] มีการสลับเป็นกล้องหน้า: $statusflashmode');
        }
        return;
      }

      // กล้องหลังตั้งค่าตามที่เลือก
      try {
        await cameracontroller!.setFlashMode(statusflashmode.value);
      } catch (_) {
        statusflashmode.value = FlashMode.off;
      }
    } catch (error) {
      if (kDebugMode) {
        print('===>> [error] setFlashCamera: $error');
      }
    }
  }
  // ===== เซ็ทแฟลชกล้อง ===== //

  // ===== ฟังก์ชันคำนวนหมุนองศาหน้าจอ ===== //
  void rotation() {
    try {
      sensorsub = accelerometerEventStream().listen((AccelerometerEvent event) {
        final x = event.x;
        final y = event.y;

        int newrotationangle;

        if (y > 7) {
          newrotationangle = 0; // แนวตั้ง (ถือมือถือปกติ)
        } else if (y < -7) {
          newrotationangle = 2; // กลับหัว
        } else if (x > 7) {
          newrotationangle = 1; // แนวนอนซ้าย (หมุนไปทางซ้าย)
        } else if (x < -7) {
          newrotationangle = 3; // แนวนอนขวา (หมุนไปทางขวา)
        } else {
          return; // ไม่เปลี่ยนถ้าไม่ชัดเจนพอ
        }

        if (newrotationangle != lastrotationangle) {
          lastrotationangle = newrotationangle;
          rotationangle.value = newrotationangle;

          // sync ไป mini map
          mapcontroller.rotationangle.value = newrotationangle;

          debugPrint('===>> rotationangle เปลี่ยนเป็น $newrotationangle');
          if (newrotationangle == 0) debugPrint('===>> แนวตั้ง');
          if (newrotationangle == 1) debugPrint('===>> หมุนซ้าย');
          if (newrotationangle == 2) debugPrint('===>> กลับหัว');
          if (newrotationangle == 3) debugPrint('===>> หมุนขวา');
        }
      });
    } catch (error) {
      if (kDebugMode) {
        print('error ===>> Camera rotation: $error');
      }
    }
  }
  // ===== ฟังก์ชันคำนวนหมุนองศาหน้าจอ ===== //

  // ===== โฟกัส ===== //
  Future setFocusAndExposure(double x, double y) async {
    try {
      // ปลดล็อกก่อน
      await cameracontroller?.setExposureMode(ExposureMode.auto);

      await cameracontroller?.setFocusPoint(Offset(x, y));
      await cameracontroller?.setExposurePoint(Offset(x, y));

      // ไม่ให้ปรับแสงตามตำแหน่ง -> ล็อกไว้
      await cameracontroller?.setExposureMode(ExposureMode.locked);
    } catch (e) {
      if (kDebugMode) print("focus error: $e");
    }
  }
  // ===== โฟกัส ===== //

  // ===== สลับแฟลช ===== //
  Future takeFlash() async {
    try {
      if (cameracontroller == null) {
        return;
      }

      if (statusflashmode.value == FlashMode.off) {
        statusflashmode.value = FlashMode.auto;
      } else if (statusflashmode.value == FlashMode.auto) {
        statusflashmode.value = FlashMode.torch;
      } else {
        statusflashmode.value = FlashMode.off;
      }

      if (cameracontroller!.value.isInitialized) {
        await cameracontroller!.setFlashMode(statusflashmode.value);
      }
      if (kDebugMode) {
        print('===>> [status] สลับแฟลช Switch To : $statusflashmode');
      }
    } catch (error) {
      if (kDebugMode) {
        print('===>> [error] takeFlash: $error');
      }
    }
  }
  // ===== สลับแฟลช ===== //

  // ===== ซูม ===== //
  Future initZoom() async {
    minzoom = await cameracontroller!.getMinZoomLevel();
    maxzoom = await cameracontroller!.getMaxZoomLevel();

    zoomlevel.value = minzoom;
    basezoom = minzoom;
    if (kDebugMode) {
      print("===>> minZoom=$minzoom, maxZoom=$maxzoom");
    }
  }

  void showZoomIndicator() {
    zoomopacity.value = 1.0;

    zoomtimer?.cancel();

    zoomtimer = Timer(const Duration(seconds: 1), () {
      zoomopacity.value = 0.0;
    });
  }
  // ===== ซูม ===== //

  // ===== ปรับแสง ===== //

  // ===== ปรับแสง ===== //

  // ===== ถ่ายภาพ ===== //
  Future takePicture() async {
    if (!layoutready) {
      if (kDebugMode) {
        print('===>> takePicture blocked: layout not ready');
      }
      return;
    }
    try {
      if (cameracontroller == null || !cameracontroller!.value.isInitialized) {
        if (kDebugMode) {
          print("===>> [error] Camera not ready: $cameracontroller");
        }
        return;
      }

      if (lastconstraints.value == null) return;

      final cw = lastconstraints.value!.maxWidth;
      final ch = lastconstraints.value!.maxHeight;

      if (cw <= 0 || ch <= 0) {
        if (kDebugMode) {
          print('===>> invalid constraint: $cw x $ch');
        }
        return;
      }

      // เปิดเอฟเฟค
      shuttereffect.value = true;

      // ปิดหลัง 100ms
      Future.delayed(const Duration(milliseconds: 100), () {
        shuttereffect.value = false;
      });

      if (statusflashmode.value == FlashMode.auto) {
        setautoflash = true;
      }

      // ปลด exposure ก่อนถ่าย
      await cameracontroller?.setExposureMode(ExposureMode.auto);

      try {
        if (setautoflash) {
          await cameracontroller!.setFlashMode(FlashMode.torch);
          await Future.delayed(const Duration(milliseconds: 200));
        } else {
          await cameracontroller!.setFlashMode(statusflashmode.value);
        }
      } catch (error) {
        if (kDebugMode) print('error ===>> setFlashMode: $error');
      }

      // --- take raw image ---
      final rawimage = await cameracontroller!.takePicture();

      if (setautoflash) {
        try {
          await cameracontroller!.setFlashMode(FlashMode.off);
        } catch (_) {}
      }

      // --- create file name ---
      final datenow = DateTime.now();
      final random = Random();
      final randomnumber = random.nextInt(90000) + 10000;
      final datetimefile =
          '${datenow.year}-${datenow.month.toString().padLeft(2, '0')}-${datenow.day.toString().padLeft(2, '0')}';
      final rawdata = datetimefile;
      final encodefile = base64UrlEncode(utf8.encode(rawdata));
      final filename = "sak_${randomnumber}_$encodefile.jpg";

      // --- copy raw ---
      final tempdir = await getTemporaryDirectory();
      final filepath = '${tempdir.path}/$filename';

      final rawfileimage = await File(rawimage.path).copy(filepath);
      if (kDebugMode) {
        print('===>> [status] บันทึกภาพดิบไปที่: ${rawfileimage.path}');
      }

      // ===== FIX ORIENTATION (Front camera landscape) =====
      // try {
      //   final bytes = await rawfileimage.readAsBytes();
      //   final img.Image? decoded = img.decodeImage(bytes);

      //   if (decoded != null) {
      //     img.Image fixed = decoded;

      //     final isFront = cameralist[selectedcamera].lensDirection == CameraLensDirection.front;

      //     if (isFront) {
      //       switch (rotationangle.value) {
      //         case 1: // landscape left
      //           fixed = img.copyRotate(decoded, angle: -90);
      //           break;
      //         case 3: // landscape right
      //           fixed = img.copyRotate(decoded, angle: 90);
      //           break;
      //         case 2: // upside down
      //           fixed = img.copyRotate(decoded, angle: 180);
      //           break;
      //         default:
      //           break;
      //       }
      //     }

      //     final fixedBytes = img.encodeJpg(fixed, quality: 95);
      //     await rawfileimage.writeAsBytes(fixedBytes, flush: true);

      //     if (kDebugMode) {
      //       print('===>> [fix] orientation applied (${rotationangle.value})');
      //     }
      //   }
      // } catch (e) {
      //   if (kDebugMode) {
      //     print('===>> [error] fix orientation: $e');
      //   }
      // }

      // --- capture map snapshot ---

      // mapsnapshot ??= await captureGoogleMapBytes();
      // final Uint8List? mapbytes = mapsnapshot;

      Uint8List? mapbytes;

      if (Get.find<SettingController>().switchmap.value) {
        // Google Map
        googlemapsnapshot ??= await captureGoogleMapBytes();
        mapbytes = googlemapsnapshot;
      } else {
        // Flutter Map
        fluttermapsnapshot ??= await captureFlutterMapBytes();
        mapbytes = fluttermapsnapshot;
      }

      // final Uint8List? mapbytes = await captureGoogleMapBytes();

      // normalize map → PNG (กัน isolate พัง)
      // Uint8List? safemapbytes;

      // if (mapsnapshotcache != null) {
      //   if (mapsnapshotcache!.isNotEmpty) {
      //     final img.Image? decoded = img.decodeImage(mapsnapshotcache!);
      //     if (decoded != null) {
      //       safemapbytes = Uint8List.fromList(img.encodePng(decoded));
      //     }
      //   }
      // }

      final textoverlaybytes = await captureText(infotextkey);

      // Add to queue
      final taskimage = ProcessImage(
        rawfilepath: rawfileimage.path,
        filename: filename,
        step: 0,
        rotationangle: rotationangle.value,
        mapbytes: mapbytes,
        textoverlaybytes: textoverlaybytes,
      );

      await addTaskToQueue(taskimage);
    } catch (error) {
      if (kDebugMode) {
        print("===>> [error] takePicture: $error");
      }
    }
  }
  // ===== ถ่ายภาพ ===== //

  // === ถ่ายภาพ Google Map === //
  Future<Uint8List?> captureGoogleMapBytes() async {
    try {
      final controller = mapcontroller.googlemapcontroller.value;
      if (controller == null) {
        return null;
      }

      // รอ map render นิ่งจริง (กันภาพเทา)
      // await Future.delayed(const Duration(milliseconds: 300));

      final bytesmap = await controller.takeSnapshot();
      if (bytesmap == null || bytesmap.isEmpty) {
        return null;
      }

      if (kDebugMode) {
        print('===>> GoogleMap snapshot captured: ${bytesmap.length}');
      }

      return bytesmap;
    } catch (error) {
      if (kDebugMode) {
        print('===>> [error] captureGoogleMapBytes error: $error');
      }
      return null;
    }
  }
  // === ถ่ายภาพ Google Map === //

  // === ถ่ายภาพ Flutter Map === //
  Future<Uint8List?> captureFlutterMapBytes() async {
    try {
      final context = fluttermapsnapshotkey.currentContext;
      if (context == null) return null;

      final boundary = context.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;

      // รอ frame นิ่ง (สำคัญมาก)
      await Future.delayed(const Duration(milliseconds: 120));

      final ui.Image image = await boundary.toImage(pixelRatio: ui.window.devicePixelRatio);

      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) return null;

      final bytes = byteData.buffer.asUint8List();

      if (kDebugMode) {
        print('===>> FlutterMap snapshot captured: ${bytes.length}');
      }

      return bytes;
    } catch (error) {
      if (kDebugMode) {
        print('===>> [error] captureFlutterMapBytes: $error');
      }
      return null;
    }
  }
  // === ถ่ายภาพ Flutter Map === //

  // === ถ่ายภาพ text === //
  Future<Uint8List> captureText(GlobalKey key) async {
    await Future.delayed(const Duration(milliseconds: 16));

    final boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;

    final image = await boundary.toImage(pixelRatio: 3); // คม
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }
  // === ถ่ายภาพ text === //

  Future addTaskToQueue(ProcessImage task) async {
    taskqueue.add(task);
    processingcount.value++;
    await savePendingTasksQueue();

    if (!processingqueue) {
      processQueue();
    }
  }

  Future savePendingTasksQueue() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = taskqueue.map((e) => e.toJson()).toList();
    await prefs.setString('pendingTasksQueue', jsonEncode(jsonList));
  }

  Future loadPendingTasksQueue() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString('pendingTasksQueue');
    if (str != null) {
      final list = jsonDecode(str) as List;
      taskqueue = list.map((e) => ProcessImage.fromJson(e)).toList();

      if (taskqueue.isNotEmpty && !processingqueue) {
        processQueue();
      }
    }
  }

  Future processQueue() async {
    if (processingqueue) return;
    processingqueue = true;

    try {
      while (taskqueue.isNotEmpty) {
        final task = taskqueue.first;

        await processTask(task);

        taskqueue.removeAt(0);
        await savePendingTasksQueue();
      }
    } finally {
      processingqueue = false;
    }
  }

  Future processTask(ProcessImage task) async {
    if (kDebugMode) {
      print("===>> Process task: Start");
    }
    // ป้องกันแคส
    if (lastconstraints.value == null) {
      if (kDebugMode) {
        print("===>> skip processTask: lastconstraints is null");
      }
      return;
    }

    try {
      final stopwatch1 = Stopwatch()..start(); // เริ่มจับเวลา

      final previewwidth = lastconstraints.value!.maxWidth;
      final previewheight = lastconstraints.value!.maxHeight;

      if (previewwidth <= 0 || previewheight <= 0) {
        if (kDebugMode) {
          print('===>> invalid preview size: $previewwidth x $previewheight');
        }
        return;
      }

      File file = File(task.rawfilepath);

      Uint8List bytes = await file.readAsBytes();

      final bool camerafront =
          cameralist[selectedcamera].lensDirection == CameraLensDirection.front;

      final int angle = convertRotation(task.rotationangle ?? 0, camerafront: camerafront);

      final logo = imglogocache;
      if (logo == null) {
        if (kDebugMode) print('===>> logo cache null, skip overlay');
        // จะ return หรือทำต่อแบบไม่วาดโลโก้ก็ได้
        return;
      }

      // ============================
      // STEP 1 : หมุนรูปตามที่ถ่ายแนวตั้ง/แนวนอน (main isolate เท่านั้น)
      // ============================
      if (task.step <= 1) {
        bytes = await FlutterImageCompress.compressWithList(
          bytes,
          rotate: angle,
          quality: 85,
          keepExif: false,
        );

        stopwatch1.stop();
        if (kDebugMode) {
          print("===>> Process FlutterImageCompress: ${stopwatch1.elapsedMilliseconds} ms");
        }

        // bytes = downscaleBeforeIsolate(bytes, maxSide: 2300);

        task.step = 1;
        await savePendingTasksQueue();
      }

      // ============================
      // STEP 3 : isolate (image package only)
      // ============================

      if (task.textoverlaybytes == null) {
        task.step = 2;
        await savePendingTasksQueue();
        return;
      }

      final stopwatch2 = Stopwatch()..start(); // เริ่มจับเวลา

      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final imagepreviewwidth = frame.image.width;
      final imagepreviewheight = frame.image.height;

      if (rotationangle.value == 0 || rotationangle.value == 2) {
        preparelogo ??= prepareLogoForImage(
          logo: logo,
          previewW: previewwidth,
          imageW: imagepreviewwidth,
          imageH: imagepreviewheight,
        );

        if (preparemap == null) {
          if (task.mapbytes != null) {
            final mapimage = img.decodeImage(task.mapbytes!);
            if (mapimage != null) {
              preparemap = prepareMapForImage(
                map: mapimage,
                previewW: previewwidth,
                imageW: imagepreviewwidth,
                imageH: imagepreviewheight,
                mapUiWidth: mapuiwidth, // 105
              );
            }
          }
        }
      } else {
        preparelanscapelogo ??= prepareLogoForImage(
          logo: logo,
          previewW: previewwidth,
          imageW: imagepreviewwidth,
          imageH: imagepreviewheight,
        );

        if (preparelanscapemap == null) {
          if (task.mapbytes != null) {
            final mapimage = img.decodeImage(task.mapbytes!);
            if (mapimage != null) {
              preparelanscapemap = prepareMapForImage(
                map: mapimage,
                previewW: previewwidth,
                imageW: imagepreviewwidth,
                imageH: imagepreviewheight,
                mapUiWidth: mapuiwidth, // 105
              );
            }
          }
        }
      }

      if (task.textoverlaybytes != null) {
        final textimage = img.decodeImage(task.textoverlaybytes!);
        if (textimage != null) {
          preparetext = prepareTextForImage(
            text: textimage,
            previewW: previewwidth,
            imageW: imagepreviewwidth,
            imageH: imagepreviewheight,
          );
        }
      }

      stopwatch2.stop();
      if (kDebugMode) {
        print("===>> Process xy: ${stopwatch2.elapsedMilliseconds} ms");
      }

      // if (emptybase == null) {
      //   final img.Image? base = img.decodeImage(bytes);
      //   if (base == null) return;

      //   final img.Image empty = img.Image(width: base.width, height: base.height);

      //   img.fill(empty, color: img.ColorRgba8(0, 0, 0, 0));

      //   void draw(PreparedOverlay? overlay, img.Image? empty) {
      //     if (overlay == null) {
      //       return;
      //     }

      //     final x = overlay.x.clamp(0, empty!.width - overlay.image.width);
      //     final y = overlay.y.clamp(0, empty.height - overlay.image.height);

      //     img.compositeImage(empty, overlay.image, dstX: x, dstY: y, blend: img.BlendMode.alpha);
      //   }

      //   if (preparelogo != null) {
      //     draw(preparelogo, empty);
      //   }
      //   if (preparemap != null) {
      //     draw(preparemap, empty);
      //   }

      //   emptybase = PreparedOverlay(image: empty, x: 0, y: 0);
      // }

      final stopwatch3 = Stopwatch()..start(); // เริ่มจับเวลา

      if (task.step <= 2) {
        bytes = await compute(
          processImageIsolate,
          ImageProcessPayload(
            bytes: bytes,
            maxside: 2300,
            logo: rotationangle.value == 0 || rotationangle.value == 2
                ? preparelogo
                : preparelanscapelogo,
            map: rotationangle.value == 0 || rotationangle.value == 2
                ? preparemap
                : preparelanscapemap,
            text: preparetext,
            emptybase: emptybase,
          ),
        );

        await file.writeAsBytes(bytes);

        stopwatch3.stop();
        if (kDebugMode) {
          print("===>> Process processImageIsolate: ${stopwatch3.elapsedMilliseconds} ms");
        }
        task.step = 2;
        await savePendingTasksQueue();
      }

      // ============================
      // STEP 4 : Save Album
      // ============================

      final stopwatch5 = Stopwatch()..start(); // เริ่มจับเวลา

      if (task.step <= 3) {
        // lastfile.value = file;
        await saveImageToAlbum(file, task.filename);

        // แจ้ง gallery ให้ insert ล่าสุด
        await gallerycontroller.insertLatestImageSafe();

        stopwatch5.stop();
        if (kDebugMode) {
          print("===>> Process saveImageToAlbum: ${stopwatch5.elapsedMilliseconds} ms");
        }

        task.step = 3;
        await savePendingTasksQueue();
      }

      // ลบ raw file
      try {
        final raw = File(task.rawfilepath);
        if (await raw.exists()) await raw.delete();
      } catch (_) {}
    } catch (error) {
      if (kDebugMode) {
        print('===>> error processTask: $error');
      }
    } finally {
      processingcount.value--;
    }
  }

  int convertRotation(int angle, {required bool camerafront}) {
    if (camerafront) {
      switch (angle) {
        case 1:
          return 90; // ซ้าย
        case 3:
          return -90; // ขวา
        case 2:
          return 180; // กลับหัว
        default:
          return 0; // ปกติ
      }
    } else {
      switch (angle) {
        case 1:
          return -90; // ซ้าย
        case 3:
          return 90; // ขวา
        case 2:
          return 180; // กลับหัว
        default:
          return 0; // ปกติ
      }
    }
  }

  // === ฟังก์ชันสำหรับบันทึกรูปลงอัลบั้ม (ใช้ gal + photo manager) === //
  Future saveImageToAlbum(File file, String filename) async {
    try {
      if (Platform.isAndroid) {
        final androidinfo = await DeviceInfoPlugin().androidInfo;
        final sdkint = androidinfo.version.sdkInt;

        if (sdkint <= 28) {
          // Android 9 หรือต่ำกว่าใช้ legacy save
          if (kDebugMode) print("===>> Android <=28, legacy save");

          final status = await Permission.storage.request();
          if (!status.isGranted) {
            if (kDebugMode) print("===>> Storage permission denied");
            return;
          }

          final folderpath = "/storage/emulated/0/Pictures/$albumname";
          final folder = Directory(folderpath);
          if (!await folder.exists()) await folder.create(recursive: true);

          final originalname = file.path.split("/").last;
          final newpath = "$folderpath/$originalname";
          final newfile = await file.copy(newpath);
          await ImageGallerySaverPlus.saveFile(newfile.path);

          const platform = MethodChannel("com.sakcamera.media_scan");
          await platform.invokeMethod("scanFile", {"path": newfile.path});

          if (kDebugMode) print("===>> [legacy save] > ${newfile.path}");
          return;
        } else if (sdkint == 29 || sdkint == 30) {
          final originalname = file.path.split("/").last;
          // Android 10 ใช้ Scoped Storage
          if (kDebugMode) print("===>> Android 10, scoped storage save");

          final haspermission = await PhotoManager.requestPermissionExtend();
          if (!haspermission.isAuth) return;

          await PhotoManager.editor.saveImageWithPath(
            file.path,
            title: originalname,
            relativePath: "Pictures/$albumname",
          );

          if (kDebugMode) {
            print("===>> [scoped save Android 10] > ${file.path}");
          }
          return;
        } else {
          // Android 11+ → ใช้ Gal
          if (kDebugMode) print("===>> Android >=11, using Gal");

          bool hasaccessapk = await Gal.hasAccess(toAlbum: true);
          if (!hasaccessapk) await Gal.requestAccess(toAlbum: true);
          await Gal.putImage(file.path, album: albumname);

          if (kDebugMode) print("===>> [Gal save Android >=11] > ${file.path}");
          return;
        }
      }

      // iOS → ใช้ Gal
      bool hasaccessios = await Gal.hasAccess(toAlbum: true);
      if (!hasaccessios) await Gal.requestAccess(toAlbum: true);
      await Gal.putImage(file.path, album: albumname);

      if (kDebugMode) print("===>> [Gal save iOS] > ${file.path}");
    } on GalException catch (e) {
      if (kDebugMode) print("GalException: ${e.type.message}");
    } catch (e) {
      if (kDebugMode) print("Unknown error: $e");
    }
  }
  // === ฟังก์ชันสำหรับบันทึกรูปลงอัลบั้ม (ใช้ gal + photo manager) === //

  Future submitLogout() async {
    try {
      final result = await MainDialog.dialogPopup(
        context!,
        true,
        'warning'.tr,
        message: 'warning_close_app'.tr,
        confirmbutton: 'ok'.tr,
        closebutton: 'cancel'.tr,
      );

      if (result == true) {
        Get.offAllNamed('/login');
      }
    } catch (error) {
      if (kDebugMode) {
        print('===>> error Logout submitLogout: $error');
      }
    }
  }

  //===>> ฟังก์ชันส่วนของวันเดือนปีภาษาไทย
  Map<String, String> formatThaiDateTime(DateTime now) {
    const weekdays = [
      '',
      'วันจันทร์',
      'วันอังคาร',
      'วันพุธ',
      'วันพฤหัสบดี',
      'วันศุกร์',
      'วันเสาร์',
      'วันอาทิตย์',
    ];
    const months = [
      '',
      'มกราคม',
      'กุมภาพันธ์',
      'มีนาคม',
      'เมษายน',
      'พฤษภาคม',
      'มิถุนายน',
      'กรกฎาคม',
      'สิงหาคม',
      'กันยายน',
      'ตุลาคม',
      'พฤศจิกายน',
      'ธันวาคม',
    ];

    final buddhistyear = now.year + 543;
    final weekday = weekdays[now.weekday];
    final month = months[now.month];

    final formatdate = "$weekday ที่ ${now.day} $month พ.ศ. $buddhistyear";
    final formattime =
        "เวลา ${now.hour.toString().padLeft(2, '0')}:"
        "${now.minute.toString().padLeft(2, '0')}:"
        "${now.second.toString().padLeft(2, '0')} น.";
    return {'date': formatdate, 'time': formattime};
  }
  //===>> ฟังก์ชันส่วนของวันเดือนปีภาษาไทย

  // === เก็บค่า logo === //
  Future preloadLogo() async {
    if (imglogocache != null) {
      return;
    }

    final data = await rootBundle.load(MainConstant.saklogo);
    final bytes = data.buffer.asUint8List();

    final decode = img.decodeImage(bytes);
    if (decode == null) {
      if (kDebugMode) print('===>> [error] preloadLogo: decode logo failed');
      return;
    }

    imglogocache = decode;
  }
  // === เก็บค่า logo === //

  MarginDrawImg getLogoLayout(int rotation) {
    switch (rotation) {
      case 1: // หมุนซ้าย
        return MarginDrawImg(
          name: 'logo_left',
          xtop: 0,
          xbottom: 5,
          yleft: 0,
          yright: 5,
          angle: math.pi / 2,
        );

      case 3: // หมุนขวา
        return MarginDrawImg(
          name: 'logo_right',
          xtop: 5,
          xbottom: 0,
          yleft: 5,
          yright: 0,
          angle: -math.pi / 2,
        );

      case 2: // กลับหัว
        return MarginDrawImg(
          name: 'logo_upsidedown',
          xtop: 0,
          xbottom: 5,
          yleft: 5,
          yright: 0,
          angle: math.pi,
        );

      default: // แนวตั้ง
        return MarginDrawImg(
          name: 'logo_portrait',
          xtop: 5,
          xbottom: 0,
          yleft: 0,
          yright: 5,
          angle: 0,
        );
    }
  }

  MarginDrawImg getMapLayout(int rotation) {
    switch (rotation) {
      case 1: // หมุนซ้าย
        return MarginDrawImg(
          name: 'map_left',
          xtop: 0,
          xbottom: 0,
          yleft: 0,
          yright: 0,
          angle: math.pi / 2,
        );

      case 3: // หมุนขวา
        return MarginDrawImg(
          name: 'map_right',
          xtop: 0,
          xbottom: 0,
          yleft: 0,
          yright: 0,
          angle: -math.pi / 2,
        );

      case 2: // กลับหัว
        return MarginDrawImg(
          name: 'map_upsideDown',
          xtop: 0,
          xbottom: 0,
          yleft: 0,
          yright: 0,
          angle: math.pi,
        );

      default: // แนวตั้ง
        return MarginDrawImg(
          name: 'map_portrait',
          xtop: 0,
          xbottom: 0,
          yleft: 0,
          yright: 0,
          angle: 0,
        );
    }
  }

  MarginDrawImg getTextLayout(int rotation) {
    double angle = 0;
    double xtop = 0;
    double xbottom = 0;
    double yleft = 0;
    double yright = 0;

    switch (rotation) {
      case 1: // หมุนซ้าย
        angle = math.pi / 2;
        xbottom = 5;
        yleft = 5;
        break;

      case 3: // หมุนขวา
        angle = -math.pi / 2;
        xtop = 5;
        yright = 5;
        break;

      case 2: // กลับหัว
        angle = math.pi;
        xtop = 5;
        yleft = 5;
        break;

      default: // แนวตั้ง
        angle = 0;
        xbottom = 5;
        yright = 5;
    }

    return MarginDrawImg(
      name: 'text',
      xtop: xtop,
      xbottom: xbottom,
      yleft: yleft,
      yright: yright,
      angle: angle,
    );
  }

  MarginDrawImg getLogoLayoutForImage() {
    return MarginDrawImg(name: 'image', xtop: 5, xbottom: 0, yleft: 0, yright: 5, angle: 0);
  }

  // === ตำแหน่ง logo === //
  PreparedOverlay prepareLogoForImage({
    required img.Image logo,
    required double previewW,
    required int imageW,
    required int imageH,
  }) {
    // final imagescale = imageW / previewW;

    final bool portrait = rotationangle.value == 0 || rotationangle.value == 2;

    final imagescale = portrait
        ? imageW / previewW
        : imageH / previewW; // หรือ previewH (ที่ถูกต้องกว่า)

    // final double reallogowidth = logouiwidth * imagescale;
    // final double reallogoheight = logo.height * (reallogowidth / logo.width);

    double reallogowidth;
    double reallogoheight;

    if (rotationangle.value == 0 || rotationangle.value == 2) {
      reallogowidth = logouiwidth * imagescale;
    } else {
      reallogowidth = logolanscapeuiwidth * imagescale;
    }

    reallogoheight = logo.height * (reallogowidth / logo.width);

    int safe(int v) => v < 1 ? 1 : v;

    final img.Image resize = img.copyResize(
      logo,
      width: safe(reallogowidth.round()),
      height: safe(reallogoheight.round()),
    );

    final layout = getLogoLayoutForImage();

    int x = 0;
    int y = 0;

    if (layout.yleft > 0) {
      x = (layout.yleft * imagescale).round();
    } else if (layout.yright > 0) {
      x = (imageW - resize.width - (layout.yright * imagescale)).round();
    }

    if (layout.xtop > 0) {
      y = (layout.xtop * imagescale).round();
    } else if (layout.xbottom > 0) {
      y = (imageH - resize.height - (layout.xbottom * imagescale)).round();
    }

    x = x.clamp(0, imageW - resize.width);
    y = y.clamp(0, imageH - resize.height);

    return PreparedOverlay(image: resize, x: x, y: y);
  }
  // === ตำแหน่ง logo === //

  // === ตำแหน่ง map === //
  PreparedOverlay prepareMapForImage({
    required img.Image map,
    required double previewW,
    required int imageW,
    required int imageH,
    required double mapUiWidth, // เช่น 105
  }) {
    final imagescale = imageW / previewW;

    // final double realMapWidth = mapUiWidth * imagescale;
    // final double realMapHeight = map.height * (realMapWidth / map.width);

    double realmapwidth;
    double realmapheight;

    if (rotationangle.value == 0 || rotationangle.value == 2) {
      realmapwidth = mapuiwidth * imagescale;
    } else {
      realmapwidth = maplanscapeuiwidth * imagescale;
    }

    realmapheight = map.height * (realmapwidth / map.width);

    int safe(int v) => v < 1 ? 1 : v;

    img.Image resize = img.copyResize(
      map,
      width: safe(realmapwidth.round()),
      height: safe(realmapheight.round()),
    );

    //ทำมุมขวาบน
    final int radius = (10 * imagescale).round(); // UI 10px
    resize = roundTopRightCorner(resize, radius: radius);

    // ตำแหน่งเดิมของคุณ: ซ้ายล่าง
    int x = 0;
    int y = imageH - resize.height;

    // กันหลุดขอบ
    x = x.clamp(0, imageW - resize.width);
    y = y.clamp(0, imageH - resize.height);

    return PreparedOverlay(image: resize, x: x, y: y);
  }
  // === ตำแหน่ง map === //

  //ฟังก์ชันวาดโค้งมุมแผนที่
  img.Image roundTopRightCorner(img.Image src, {int radius = 16}) {
    final w = src.width;
    final h = src.height;

    // clamp radius ไม่ให้เกินขนาดภาพ
    final int safeRadius = radius.clamp(0, min(w, h)).toInt();
    if (safeRadius == 0) return src;

    for (int y = 0; y < safeRadius; y++) {
      for (int x = w - safeRadius; x < w; x++) {
        final dx = x - (w - safeRadius);
        final dy = safeRadius - y;
        if (dx * dx + dy * dy > safeRadius * safeRadius) {
          src.setPixelRgba(x, y, 0, 0, 0, 0);
        }
      }
    }
    return src;
  }
  //ฟังก์ชันวาดโค้งมุมแผนที่

  PreparedOverlay prepareTextForImage({
    required img.Image text,
    required double previewW,
    required int imageW,
    required int imageH,
  }) {
    // scale ตามภาพจริง (logic เดิมของคุณ)
    const double textscalewidth = 0.9;

    final bool landscape = imageW > imageH;
    final double orientationscale = landscape ? 0.8 : 1.0;

    final double textscale = (imageW / 1080) * orientationscale;

    int safe(int v) => v < 1 ? 1 : v;

    final img.Image resize = img.copyResize(
      text,
      width: safe((text.width * textscale * textscalewidth).round()),
      height: safe((text.height * textscale * textscalewidth).round()),
    );

    // margin แบบเดิม
    final int marginRight = (12 * textscale).round();
    final int marginBottom = (12 * textscale).round();

    // ตำแหน่งขวาล่าง
    int x = imageW - resize.width - marginRight;
    int y = imageH - resize.height - marginBottom;

    // กันหลุดขอบ
    x = x.clamp(0, imageW - resize.width);
    y = y.clamp(0, imageH - resize.height);

    return PreparedOverlay(image: resize, x: x, y: y);
  }
}
