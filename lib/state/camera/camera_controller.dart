import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:math' as math;

import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:gal/gal.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gm;
import 'package:image/image.dart' as img;
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sakcamera_getx/component/main_dialog_component.dart';
import 'package:sakcamera_getx/compute/image/image_process_compute.dart';
import 'package:sakcamera_getx/compute/processtask/process_image_compute.dart';
import 'package:sakcamera_getx/constant/main_constant.dart';
import 'package:sakcamera_getx/controller/device_controller.dart';
import 'package:sakcamera_getx/controller/user_controller.dart';
import 'package:sakcamera_getx/model/camera/imageprocess.dart';
import 'package:sakcamera_getx/state/camera/gallery_controller.dart';
import 'package:sakcamera_getx/state/camera/map_controller.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CameraPageController extends GetxController with WidgetsBindingObserver {
  // ===== Layout State ===== //
  BuildContext? get context => Get.context;
  var lastconstraints = Rx<BoxConstraints?>(null); //เก็บขนาดของ layout ล่าสุด
  bool addobserver = false;
  bool initialize = false;
  late final UserController usercontroller;
  late final MapController mapcontroller;
  late final GalleryController gallerycontroller;
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
  bool settingdialogshowing = false; //ตัวแปร ควบคุม Setting Dialog กันการเด้งซ้อน
  // ===== Permission flag ===== //

  // ===== process flag ===== //
  bool layoutReady = false;
  // ===== process flag ===== //

  // ===== Sensor  State ===== //
  final rotationangle = 0.obs; //ตัวแปร sensor หมุนอัตโนมัติ
  int lastrotationangle = 0; //ตัวแปรตรวจจับการเปลี่ยนแปลงการหมุนอัตโนมัติ
  StreamSubscription? sensorsub;
  // ===== Sensor State ===== //

  // ===== Camera State ===== //
  CameraController? cameracontroller;
  List<CameraDescription> cameralist = [];
  int selectedcamera = 0; //ตัวแปรสลับกล้องหน้ากล้องหลัง
  Rx<Size?> previewsize = Rx<Size?>(null); // เก็บขนาดสัดส่วนกล้อง

  CameraLensDirection currentlensdirection = CameraLensDirection.back; //ตัวแปรเก็บค่าสลับกล้อง
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
  Uint8List? mapbytes;
  final GlobalKey infotextkey = GlobalKey();
  // ===== Camera State ===== //

  // ===== Process State ===== //
  List<ProcessImage> taskqueue = [];
  bool processingqueue = false;

  final processingcount = 0.obs;
  // final processingcount = 0.obs;

  Uint8List? logobytescache; // เก็บโลโก้
  Uint8List? mapsnapshotbytes; // เก็บภาพแผนที่ (GoogleMap)

  //== เก็บค่าตำแหน่ง logo เพื่อไปวาด ==//
  double logouiwidth = 80;
  //== เก็บค่าตำแหน่ง logo เพื่อไปวาด ==//

  //== เก็บค่าตำแหน่ง logo เพื่อไปวาด ==//
  double mapuiwidth = 110;
  //== เก็บค่าตำแหน่ง logo เพื่อไปวาด ==//

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
      if (kDebugMode) {}
    }
  }
  // ===== start ===== //

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
    } catch (e) {
      if (kDebugMode) {
        print('===>> openMapLocation error: $e');
      }
    }
  }

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
    if (!layoutReady) {
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

      final rawfile = await File(rawimage.path).copy(filepath);
      if (kDebugMode) {
        print('===>> [status] บันทึกภาพดิบไปที่: ${rawfile.path}');
      }

      // --- capture map snapshot ---
      final mapsnapshotbytes = await captureGoogleMapBytes();

      // normalize map → PNG (กัน isolate พัง)
      Uint8List? safemapbytes;

      if (mapsnapshotbytes != null && mapsnapshotbytes.isNotEmpty) {
        final img.Image? decoded = img.decodeImage(mapsnapshotbytes);
        if (decoded != null) {
          safemapbytes = Uint8List.fromList(img.encodePng(decoded));
        }
      }

      final textoverlaybytes = await captureText(infotextkey);

      // Add to queue
      final task = ProcessImage(
        rawfilepath: rawfile.path,
        filename: filename,
        step: 0,
        rotationangle: rotationangle.value,
        mapbytes: safemapbytes,
        textoverlaybytes: textoverlaybytes,
      );

      await addTaskToQueue(task);
    } catch (error) {
      if (kDebugMode) print("===>> [error] takePicture: $error");
    }
  }

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
      final stopwatch0 = Stopwatch()..start(); // เริ่มจับเวลา

      final pw = lastconstraints.value!.maxWidth;
      final ph = lastconstraints.value!.maxHeight;

      if (pw <= 0 || ph <= 0) {
        if (kDebugMode) {
          print('===>> invalid preview size: $pw x $ph');
        }
        return;
      }

      File file = File(task.rawfilepath);
      Uint8List bytes = await file.readAsBytes();

      final int angle = convertRotation(task.rotationangle ?? 0);
      final bool camerafront =
          cameralist[selectedcamera].lensDirection == CameraLensDirection.front;

      if (logobytescache == null) {
        await preloadLogo(); // กันพลาด
      }

      final Uint8List logobytes = logobytescache!;

      // ============================
      // STEP 1 : compress + rotate (main isolate เท่านั้น)
      // ============================
      if (task.step <= 1) {
        bytes = await FlutterImageCompress.compressWithList(
          bytes,
          rotate: camerafront ? 0 : angle, //กล้องหน้าไม่ rotate ที่นี่
          quality: 92,
          keepExif: false,
        );

        await file.writeAsBytes(bytes, flush: true);

        task.step = 1;
        await savePendingTasksQueue();
      }

      // ============================
      // STEP 2 : isolate (image package only)

      // if (task.textoverlaybytes == null) {
      //   if (kDebugMode) {
      //     print('===>> skip process: textoverlaybytes is null');
      //   }
      //   return;
      // }
      if (task.textoverlaybytes == null) {
        task.step = 2;
        await savePendingTasksQueue();
        return;
      }

      final logolayout = getLogoLayoutForImage();
      final maplayout = getMapLayout(task.rotationangle ?? 0);
      final textlayout = getTextLayout(task.rotationangle ?? 0);

      if (task.step <= 2) {
        bytes = await compute(
          processImageIsolate,
          ImageProcessPayload(
            bytes: bytes,
            camerafront: camerafront,
            previewwidth: pw,
            previewheight: ph,
            logobytes: logobytes,
            mapbytes: task.mapbytes,
            rotationangle: task.rotationangle ?? 0,

            textOverlayBytes: task.textoverlaybytes!,

            //logo
            logouiwidth: logouiwidth,
            logouitop: logolayout.xtop,
            logouibottom: logolayout.xbottom,
            logouileft: logolayout.yleft,
            logouiright: logolayout.yright,
            logouiangle: logolayout.angle,

            //map
            mapuiwidth: mapuiwidth,
            mapuitop: maplayout.xtop,
            mapuibottom: maplayout.xbottom,
            mapuileft: maplayout.yleft,
            mapuiright: maplayout.yright,
            mapuiangle: maplayout.angle,

            // text
            textuitop: textlayout.xtop,
            textuibottom: textlayout.xbottom,
            textuileft: textlayout.yleft,
            textuiright: textlayout.yright,
            // textuiangle: textlayout.angle,
          ),
        );

        await file.writeAsBytes(bytes, flush: true);

        task.step = 2;
        await savePendingTasksQueue();
      }

      stopwatch0.stop();
      if (kDebugMode) {
        print("===>> Process task image: ${stopwatch0.elapsedMilliseconds} ms");
      }

      // ============================
      // STEP 5 : Save Album
      // ============================

      if (task.step <= 3) {
        await saveImageToAlbum(file, task.filename);

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

  int convertRotation(int angle) {
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

  // ฟังก์ชันสำหรับบันทึกรูปลงอัลบั้ม (ใช้ gal)
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

          final gallery = Get.find<GalleryController>();
          await gallery.insertByFileName(filename);

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

          final gallery = Get.find<GalleryController>();
          await gallery.insertByFileName(filename);

          if (kDebugMode) print("===>> [Gal save Android >=11] > ${file.path}");
          return;
        }
      }

      // iOS → ใช้ Gal
      bool hasaccessios = await Gal.hasAccess(toAlbum: true);
      if (!hasaccessios) await Gal.requestAccess(toAlbum: true);
      await Gal.putImage(file.path, album: albumname);

      final gallery = Get.find<GalleryController>();
      await gallery.insertByFileName(filename);

      if (kDebugMode) print("===>> [Gal save iOS] > ${file.path}");
    } on GalException catch (e) {
      if (kDebugMode) print("GalException: ${e.type.message}");
    } catch (e) {
      if (kDebugMode) print("Unknown error: $e");
    }
  }

  // === เก็บค่า logo === //
  Future preloadLogo() async {
    if (logobytescache != null) {
      return;
    }

    final data = await rootBundle.load(MainConstant.saklogo);
    logobytescache = data.buffer.asUint8List();
  }
  // === เก็บค่า logo === //

  // === เก็บค่า Map === //
  Future<Uint8List?> captureGoogleMapBytes() async {
    try {
      final controller = mapcontroller.googlemapcontroller.value;
      if (controller == null) return null;

      // รอ map render นิ่งจริง (กันภาพเทา)
      await Future.delayed(const Duration(milliseconds: 300));

      final bytes = await controller.takeSnapshot();
      if (bytes == null || bytes.isEmpty) return null;

      if (kDebugMode) {
        print('===>> GoogleMap snapshot captured: ${bytes.length}');
      }

      return bytes;
    } catch (e) {
      if (kDebugMode) {
        print('===>> captureGoogleMapBytes error: $e');
      }
      return null;
    }
  }
  // === เก็บค่า Map === //

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

  Future<Uint8List> captureText(GlobalKey key) async {
    await Future.delayed(const Duration(milliseconds: 16));

    final boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;

    final image = await boundary.toImage(pixelRatio: 3); // คม
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

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

  // === เปิดกล้องเมื่อพร้อม === //
  @override
  void onReady() async {
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
