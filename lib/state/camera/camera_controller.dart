import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sakcamera_getx/component/main_dialog_component.dart';
import 'package:sakcamera_getx/compute/fix_image_orientation_compute.dart';
import 'package:sakcamera_getx/compute/mirror_image_compute.dart';
import 'package:sakcamera_getx/compute/processtask/process_image_compute.dart';
import 'package:sakcamera_getx/constant/main_constant.dart';
import 'package:sakcamera_getx/controller/device_controller.dart';
import 'package:sakcamera_getx/controller/user_controller.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CameraPageController extends GetxController with WidgetsBindingObserver {
  // ===== Layout State ===== //
  BuildContext? get context => Get.context;
  var lastconstraints = Rx<BoxConstraints?>(null); //เก็บขนาดของ layout ล่าสุด
  bool addobserver = false;
  bool initialize = false;
  // ===== Layout State ===== //

  // ===== Camera & Microphone Permission State ===== //
  RxBool camerapermission = false.obs;
  RxBool statuscamera = false.obs;
  RxBool microphonepermission = false.obs;
  // ===== Camera & Microphone Permission State ===== //

  // ===== Location Permission State ===== //
  RxBool locationpermission = false.obs;
  // ===== Location Permission State ===== //

  // ===== Storage Permission State ===== //
  RxBool storagepermission = false.obs;
  // ===== Storage Permission State ===== //

  // ===== Permission flag ===== //
  bool requestpermission = false; //ตัวแปร ควบคุม สถานะไม่ให้เรียก lifecycle
  bool statusresumed = false; //ตัวแปรสถานะ ออกยุบแอป

  bool cameradialogshowing = false; //ตัวแปร ควบคุม camera Dialog กันการเด้งซ้อน
  bool resumedfromsetting = false; //ตัวแปร status มาจากตั้งค่า
  bool denieddialogshowing = false; //ตัวแปร ควบคุม Denied Dialog กันการเด้งซ้อน
  bool settingdialogshowing =
      false; //ตัวแปร ควบคุม Setting Dialog กันการเด้งซ้อน
  // ===== Permission flag ===== //

  // ===== Sensor  State ===== //
  final rotationangle = 0.obs; //ตัวแปร sensor หมุนอัตโนมัติ
  int lastrotationangle = 0; //ตัวแปรตรวจจับการเปลี่ยนแปลงการหมุนอัตโนมัติ
  StreamSubscription? sensorsub;
  // ===== Sensor State ===== //

  // ===== Camera State ===== //
  CameraController? cameracontroller;
  List<CameraDescription> cameralist = [];
  int selectedcamera = 0; //ตัวแปรสลับกล้องหน้ากล้องหลัง

  CameraLensDirection currentlensdirection =
      CameraLensDirection.back; //ตัวแปรเก็บค่าสลับกล้อง
  bool switchcamera = false; //ตัวแปรกันกดซ้ำสลับกล้อง
  bool showpreview = false; // status กล้องตอนขอสิทธิ์

  Rx<FlashMode> statusflashmode = FlashMode.off.obs; //เพิ่มตัวแปร Flash ออโต้
  bool setautoflash = false; // ตั้งค่า Flash
  RxBool shuttereffect = false.obs; //ตัวแปรเอฟเฟคชัตเตอร์

  // focus
  var focusoffset = Rx<Offset?>(null);
  var focusscale = 1.0.obs; // scale ของกรอบโฟกัส
  var focusopacity = 0.0.obs; // ความโปร่งใส
  // focus

  // ซูม
  RxDouble zoomlevel = 1.0.obs; // ค่าซูมปัจจุบัน
  double basezoom = 1.0; // ค่าซูมก่อน pinch start

  double minzoom = 1.0;
  double maxzoom = 1.0;

  RxDouble zoomopacity = 0.0.obs;
  Timer? zoomtimer;
  // ซูม

  // ปรับแสง

  // ปรับแสง

  img.Image? imglogocache;
  // ===== Camera State ===== //

  // ===== Process State ===== //
  List<ProcessImage> taskqueue = [];
  bool processingqueue = false;

  final processimage = 0.obs;
  final processingcount = 0.obs;
  // ===== Process State ===== //

  // ===== Storage State ===== //
  final String albumname = 'SAK_Camera';
  // ===== Storage State ===== //

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
        // await openMapLocation();
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
      if (kDebugMode) {}
    }
  }
  // ===== start ===== //

  // ===== ขอสิทขั้นแรก ===== //
  Future getPermission(String permission) async {
    bool granted = false;
    try {
      final Map<String, dynamic> result = await checkPermission(
        permission,
        granted,
      );
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
        PermissionStatus storagestatusios =
            await Permission.photosAddOnly.status;

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
    return {
      'granted': granted,
      'settingsgranted': settingsgranted,
      'status': status,
    };
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
        final Map<String, dynamic> result = await checkPermission(
          permission,
          granted,
        );
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
          print(
            "===>> [status] Best Back Camera index = $selectedcamera (zoom: $maxzoom)",
          );
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
      if (cameracontroller!.description.lensDirection ==
          CameraLensDirection.front) {
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
        enableAudio:
            microphonepermission.value, // เปิด true เสียงไมค์ได้ถ้ามีสิทธิ์แล้ว
      );

      await cameracontroller!.initialize();

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

      final newindex = cameralist.indexWhere(
        (cam) => cam.lensDirection == newcameradirection,
      );

      if (newindex != -1) {
        selectedcamera = newindex;
      }
      if (kDebugMode) {
        print('===>> [status] สลับกล้อง to index $selectedcamera');
      }

      cameracontroller = CameraController(
        cameralist[selectedcamera],
        ResolutionPreset.max,
      );

      // รอ initialize ให้เสร็จก่อน
      try {
        await cameracontroller!.initialize();
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

  Future takePicture() async {
    try {
      if (cameracontroller == null || !cameracontroller!.value.isInitialized) {
        if (kDebugMode) {
          print("===>> [error] Camera not ready: $cameracontroller");
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
      final random = math.Random();
      final randomnumber = random.nextInt(90000) + 10000;
      final datetimefile =
          '${datenow.year}-${datenow.month.toString().padLeft(2, '0')}-${datenow.day.toString().padLeft(2, '0')}';
      final rawdata = datetimefile;
      final encodefile = base64UrlEncode(utf8.encode(rawdata));
      final filename = "sak_${randomnumber}_$encodefile.jpg";

      // --- copy raw ---
      final tempdir = await getTemporaryDirectory();
      final filepath = '${tempdir.path}/$filename';

      final rawfile = await File(rawimage.path).copy(filepath);
      if (kDebugMode) {
        print('===>> [status] บันทึกภาพดิบไปที่: ${rawfile.path}');
      }

      // Add to queue
      final task = ProcessImage(
        rawfilepath: rawfile.path,
        step: 0,
        rotationangle: rotationangle.value,
      );

      await addTaskToQueue(task);
    } catch (error) {
      if (kDebugMode) print("===>> [error] takePicture: $error");
    }
  }

  Future addTaskToQueue(ProcessImage task) async {
    taskqueue.add(task);
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
    try {
      if (kDebugMode) {
        print("===>> Process task: Start");
      }
      final stopwatch0 = Stopwatch()..start(); // เริ่มจับเวลา

      File file = File(task.rawfilepath);
      Uint8List imagebytes = await File(task.rawfilepath).readAsBytes();

      stopwatch0.stop(); // หยุดจับเวลา

      if (kDebugMode) {
        print(
          "===>> Process task write file to Uint8List: ${stopwatch0.elapsedMilliseconds} ms",
        );
      }

      final stopwatch1 = Stopwatch()..start(); // เริ่มจับเวลา

      // ===== Step 1: Fix orientation =====
      if (task.step <= 1) {
        imagebytes = await fixImageOrientation(imagebytes);
        task.step = 1;
        await savePendingTasksQueue();
      }

      stopwatch1.stop(); // หยุดจับเวลา

      if (kDebugMode) {
        print(
          "===>> Process task fixImageOrientation: ${stopwatch1.elapsedMilliseconds} ms",
        );
      }

      final stopwatch2 = Stopwatch()..start(); // เริ่มจับเวลา

      // ===== Step 2: Mirror ถ้าเป็นกล้องหน้า =====
      if (task.step <= 2 &&
          cameralist[selectedcamera].lensDirection ==
              CameraLensDirection.front) {
        imagebytes = await compute(mirrorImageBytes, imagebytes);
        task.step = 2;
        await savePendingTasksQueue();
      }

      stopwatch2.stop(); // หยุดจับเวลา

      if (kDebugMode) {
        print(
          "===>> Process task mirrorImageBytes: ${stopwatch2.elapsedMilliseconds} ms",
        );
      }

      final stopwatch3 = Stopwatch()..start(); // เริ่มจับเวลา

      // ===== Step 3: Save processed file =====
      img.Image? src;
      if (task.step <= 3) {
        // await file.writeAsBytes(imagebytes);
        src = img.decodeImage(imagebytes);
        task.processedfilepath = file.path;
        task.step = 3;
        await savePendingTasksQueue();
      }

      stopwatch3.stop(); // หยุดจับเวลา

      if (kDebugMode) {
        print(
          "===>> Process task writeAsBytes: ${stopwatch3.elapsedMilliseconds} ms",
        );
      }

      final stopwatch4 = Stopwatch()..start(); // เริ่มจับเวลา
      // ===== Step 4: วาดโลโก้ลงรูป (NEW) =====
      if (task.step <= 4) {
        final updatedFile = await addLogoToImage(
          src,
          task.processedfilepath!, // path รูปล่าสุด
          MainConstant.saklogo, // เปลี่ยนเป็นโลโก้จริง
          rotationangle: task.rotationangle ?? 0,
          previewWidth: lastconstraints.value!.maxWidth,
          previewHeight: lastconstraints.value!.maxHeight,
        );

        if (updatedFile != null) {
          file = updatedFile; // อัปเดต file ที่จะใช้เซฟลง album
        }

        task.step = 4;
        await savePendingTasksQueue();
      }

      stopwatch4.stop(); // หยุดจับเวลา

      if (kDebugMode) {
        print(
          "===>> Process task addLogoToImage: ${stopwatch4.elapsedMilliseconds} ms",
        );
      }

      final stopwatch5 = Stopwatch()..start(); // เริ่มจับเวลา

      // ===== Step 5: Save to Album =====
      if (task.step <= 5) {
        await saveImageToAlbum(file);
        task.step = 5;
        await savePendingTasksQueue();

        if (kDebugMode) {
          print("===>> [status] Saved to album: ${file.path}");
        }
      }

      stopwatch5.stop(); // หยุดจับเวลา

      if (kDebugMode) {
        print(
          "===>> Process task saveImageToAlbum: ${stopwatch5.elapsedMilliseconds} ms",
        );
      }
    } catch (error) {
      if (kDebugMode) print("processTask error: $error");
    }
  }

  // ฟังก์ชันสำหรับบันทึกรูปลงอัลบั้ม (ใช้ gal)
  Future saveImageToAlbum(File file) async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        final sdkInt = androidInfo.version.sdkInt;

        if (sdkInt <= 28) {
          // Android 9 หรือต่ำกว่าใช้ legacy save
          if (kDebugMode) print("===>> Android <=28, legacy save");

          final status = await Permission.storage.request();
          if (!status.isGranted) {
            if (kDebugMode) print("===>> Storage permission denied");
            return;
          }

          final folderPath = "/storage/emulated/0/Pictures/$albumname";
          final folder = Directory(folderPath);
          if (!await folder.exists()) await folder.create(recursive: true);

          final newPath =
              "$folderPath/${DateTime.now().millisecondsSinceEpoch}.jpg";
          final newFile = await file.copy(newPath);
          await ImageGallerySaverPlus.saveFile(newFile.path);

          const platform = MethodChannel('com.example.media_scan');
          await platform.invokeMethod('scanFile', {'path': newFile.path});

          if (kDebugMode) print("===>> [legacy save] > ${newFile.path}");
          return;
        } else if (sdkInt == 29 || sdkInt == 30) {
          // Android 10 ใช้ Scoped Storage
          if (kDebugMode) print("===>> Android 10, scoped storage save");

          final hasPermission = await PhotoManager.requestPermissionExtend();
          if (!hasPermission.isAuth) return;

          await PhotoManager.editor.saveImageWithPath(
            file.path,
            title: DateTime.now().millisecondsSinceEpoch.toString(),
            relativePath: "Pictures/$albumname",
          );

          if (kDebugMode) {
            print("===>> [scoped save Android 10] > ${file.path}");
          }
          return;
        } else {
          // Android 11+ → ใช้ Gal
          if (kDebugMode) print("===>> Android >=11, using Gal");

          bool hasAccess = await Gal.hasAccess(toAlbum: true);
          if (!hasAccess) await Gal.requestAccess(toAlbum: true);
          await Gal.putImage(file.path, album: albumname);

          if (kDebugMode) print("===>> [Gal save Android >=11] > ${file.path}");
          return;
        }
      }

      // iOS → ใช้ Gal
      bool hasAccess = await Gal.hasAccess(toAlbum: true);
      if (!hasAccess) await Gal.requestAccess(toAlbum: true);
      await Gal.putImage(file.path, album: albumname);

      if (kDebugMode) print("===>> [Gal save iOS] > ${file.path}");
    } on GalException catch (e) {
      if (kDebugMode) print("GalException: ${e.type.message}");
    } catch (e) {
      if (kDebugMode) print("Unknown error: $e");
    }
  }

  // === เก็บค่า logo === //
  Future preloadLogo() async {
    final data = await rootBundle.load(MainConstant.saklogo);
    final img.Image? raw = img.decodeImage(Uint8List.view(data.buffer));

    if (raw != null) {
      imglogocache = raw;
      // 400 px พอเหลือเฟือสำหรับภาพจริง
    }
  }
  // === เก็บค่า logo === //

  // === วาดโลโก้ === //
  Future<File?> addLogoToImage(
    img.Image? ts,
    String imagepath,
    String logoassetpath, {
    required int rotationangle,
    required double previewWidth,
    required double previewHeight,
  }) async {
    try {
      // โหลดรูปหลัก (แก้หมุนด้วย)
      img.Image? ori = ts;
      if (ori == null) {
        return null;
      }

      // โหลดโลโก้ที่เก็บค่าไว้
      final img.Image? logo = imglogocache;
      if (logo == null) {
        return null;
      }

      final scale = ori.width / previewWidth;

      const previewLogoWidth = 80.0;
      const marginTop = 10.0;
      const marginBottom = 5.0;
      const marginLeft = 5.0;
      const marginRight = 5.0;

      // ขนาดจริงบนรูป (คงสัดส่วนโลโก้)
      final realLogoWidth = previewLogoWidth * scale;
      final realLogoHeight = logo.height * (realLogoWidth / logo.width);

      int dx = 0;
      int dy = 0;

      switch (rotationangle) {
        case 0: // แนวตั้ง
          dx = (ori.width - realLogoWidth - (marginRight * scale)).toInt();
          dy = (marginTop * scale).toInt();
          break;

        case 1: // หมุนซ้าย
          dx = (ori.width - realLogoWidth - (marginRight * scale)).toInt();
          // dy = (ori.height - realLogoHeight - (marginBottom * scale)).toInt();
          dy = (marginTop * scale).toInt();
          break;

        case 2: // กลับหัว
          dx = (marginLeft * scale).toInt();
          dy = (ori.height - realLogoHeight - (marginBottom * scale)).toInt();
          break;

        case 3: // หมุนขวา
          dx = (marginLeft * scale).toInt();
          dy = (marginTop * scale).toInt();
          break;
      }

      // resize แบบไม่บีบ
      final resizedLogo = img.copyResize(
        logo,
        width: realLogoWidth.toInt(),
        height: realLogoHeight.toInt(),
      );

      // ใช้ Command API (image 4.5.4)
      final cmd = img.Command()
        ..image(ori)
        ..compositeImage(img.Command()..image(resizedLogo), dstX: dx, dstY: dy);

      final img.Image? result = await cmd.getImage();
      if (result == null) return null;

      // เซฟกลับ
      final updatebytes = img.encodeJpg(result);
      return await File(imagepath).writeAsBytes(updatebytes);
    } catch (e) {
      if (kDebugMode) print("addLogoToImage ERROR: $e");
      return null;
    }
  }

  Future<img.Image?> loadAndRotateImage(
    String imagepath,
    int rotationangle,
  ) async {
    try {
      final file = File(imagepath);
      if (!await file.exists()) {
        return null;
      }

      final bytes = await file.readAsBytes();
      img.Image? src = img.decodeImage(bytes);
      if (src == null) {
        return null;
      }

      switch (rotationangle) {
        case 1:
          src = img.copyRotate(src, angle: -90);
          break;
        case 3:
          src = img.copyRotate(src, angle: 90);
          break;
        case 2:
          src = img.copyRotate(src, angle: 180);
          break;
      }
      return src;
    } catch (e) {
      if (kDebugMode) print("loadAndRotateImage ERROR: $e");
      return null;
    }
  }

  Future<img.Image?> loadAndResizeLogo(String logopath) async {
    final data = await rootBundle.load(logopath);
    final img.Image? decoded = img.decodeImage(Uint8List.view(data.buffer));
    return decoded; // ไม่ต้อง resize ตรงนี้
  }

  // === วาดโลโก้ === //

  @override
  void onInit() {
    super.onInit();

    final devicecontroller = Get.find<DeviceController>();
    if (kDebugMode) {
      print(
        "===>> [status] Device brand is: ${devicecontroller.manufacture.value}",
      );
    }
  }

  // === เปิดกล้องเมื่อพร้อม === //
  @override
  void onReady() {
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
    // startApp();
    super.onReady();
  }
  // === เปิดกล้องเมื่อพร้อม === //

  // === ปิดกล้อง ===//
  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    try {
      cameracontroller?.dispose();
    } catch (_) {}
    sensorsub?.cancel();
    super.onClose();
  }
  // === ปิดกล้อง ===//

  // === จัดการ lifecycle ของแอป === //
  @override
  Future didChangeAppLifecycleState(AppLifecycleState state) async {
    if (requestpermission) {
      // ข้าม ไม่ต้องจัดการ lifecycle ตอนนี้
      if (kDebugMode) {
        print("===>> [status] skip lifecycle เพราะกำลังขอ permission");
      }
      return;
    }
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
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
              settingdialogshowing =
                  false; // reset Setting Dialog กันการเด้งซ้อน

              requestpermission =
                  false; // คืนค่าปกติ สถานะไม่ให้เรียก lifecycle

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

      // if (camerapermission.value && microphonepermission.value) {
      //   initCamera();
      //   if (kDebugMode) {
      //     print('Camera reinitialized after resume');
      //   }
      // }
    }
    super.didChangeAppLifecycleState(state);
  }
}
