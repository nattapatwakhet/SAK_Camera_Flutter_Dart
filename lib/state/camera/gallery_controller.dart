import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sakcamera_getx/state/camera/camera_controller.dart';

class GalleryController extends GetxController {
  final assets = <AssetEntity>[].obs;
  final loading = true.obs;

  // @override
  // void onInit() {
  //   super.onInit();
  //   loadImages();
  // }

  @override
  void onReady() {
    super.onReady();
    final camera = Get.find<CameraPageController>();

    ever(camera.storagepermission, (bool granted) {
      if (granted) {
        loadImages();
      }
    });

    if (camera.storagepermission.value) {
      loadImages();
    }
  }

  // void loadImages() async {
  //   loading.value = true;

  //   // Desktop / Web ไม่รองรับ
  //   if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
  //     assets.clear();
  //     loading.value = false;
  //     return;
  //   }

  //   // Permission
  //   // final permission = await PhotoManager.requestPermissionExtend();
  //   // if (!permission.isAuth) {
  //   //   loading.value = false;
  //   //   return;
  //   // }
  //   final camera = Get.find<CameraPageController>();
  //   if (!camera.storagepermission.value) {
  //     loading.value = false;
  //     return;
  //   }

  //   // sort ใหม่ก่อน (เหมือน LINE)
  //   final albums = await PhotoManager.getAssetPathList(
  //     type: RequestType.image,
  //     onlyAll: true,
  //     filterOption: FilterOptionGroup(
  //       orders: const [OrderOption(type: OrderOptionType.createDate, asc: false)],
  //     ),
  //   );

  //   if (albums.isEmpty) {
  //     assets.clear();
  //     loading.value = false;
  //     return;
  //   }

  //   AssetPathEntity targetAlbum;

  //   if (Platform.isIOS) {
  //     // iOS: พยายามหา album SAK_Camera
  //     final matched = albums.where((a) => a.name == 'SAK_Camera').toList();

  //     if (matched.isNotEmpty) {
  //       targetAlbum = matched.first;
  //     } else {
  //       // fallback → Recents / All Photos
  //       targetAlbum = albums.first;
  //     }
  //   } else {
  //     // 🟢 Android: ใช้ All Photos
  //     targetAlbum = albums.first;
  //   }

  //   List<AssetEntity> list;

  //   // จุดสำคัญ
  //   if (Platform.isAndroid) {
  //     // final sdk = int.parse(
  //     //   Platform.operatingSystemVersion.replaceAll(RegExp(r'[^0-9]'), '').substring(0, 2),
  //     // );
  //     final sdk = (await DeviceInfoPlugin().androidInfo).version.sdkInt;

  //     if (sdk <= 29) {
  //       // Android 10 หรือต่ำกว่า
  //       list = await albums.first.getAssetListRange(start: 0, end: 300);
  //     } else {
  //       // Android 11+
  //       list = await albums.first.getAssetListPaged(page: 0, size: 300);
  //     }
  //   } else {
  //     // iOS ใช้ได้หมด
  //     list = await targetAlbum.getAssetListRange(start: 0, end: 300);
  //   }

  //   // กรองเฉพาะ sak_
  //   // final filtered = list.where((asset) {
  //   //   final name = asset.title ?? '';
  //   //   return name.toLowerCase().startsWith('sak_');
  //   // }).toList();

  //   // Android → filter sak_
  //   // iOS → ไม่ filter ชื่อ (เพราะชื่อไม่ reliable)
  //   final filtered = Platform.isAndroid
  //       ? list.where((a) {
  //           final name = a.title ?? '';
  //           return name.toLowerCase().startsWith('sak_');
  //         }).toList()
  //       : list;

  //   assets.assignAll(filtered);
  //   loading.value = false;
  // }
  Future<void> loadImages() async {
    loading.value = true;

    // Web / Desktop ไม่รองรับ
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
      assets.clear();
      loading.value = false;
      return;
    }

    final camera = Get.find<CameraPageController>();
    if (!camera.storagepermission.value) {
      loading.value = false;
      return;
    }

    final ps = await PhotoManager.requestPermissionExtend();
    if (!ps.isAuth) {
      assets.clear();
      loading.value = false;
      return;
    }

    // ดึง album ทั้งหมด
    final albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      filterOption: FilterOptionGroup(
        orders: const [OrderOption(type: OrderOptionType.createDate, asc: false)],
      ),
    );

    if (albums.isEmpty) {
      assets.clear();
      loading.value = false;
      return;
    }

    AssetPathEntity? targetAlbum;

    if (Platform.isIOS) {
      // 🔴 iOS: ใช้เฉพาะ SAK_Camera (เหมือนโค้ดเก่า)
      targetAlbum = albums.firstWhereOrNull((a) => a.name == 'SAK_Camera');

      if (targetAlbum == null) {
        // ❗ iOS ถ้าไม่เจอ album = ถือว่าไม่มีรูป
        assets.clear();
        loading.value = false;
        return;
      }
    } else {
      // 🟢 Android: ใช้ All Photos
      targetAlbum = albums.first;
    }

    List<AssetEntity> list;

    if (Platform.isAndroid) {
      final sdk = (await DeviceInfoPlugin().androidInfo).version.sdkInt;

      if (sdk <= 29) {
        list = await targetAlbum.getAssetListRange(start: 0, end: 300);
      } else {
        list = await targetAlbum.getAssetListPaged(page: 0, size: 300);
      }

      // 🟢 Android: filter sak_
      list = list.where((a) {
        final name = a.title ?? '';
        return name.toLowerCase().startsWith('sak_');
      }).toList();
    } else {
      // 🔴 iOS: เอาทั้ง album (ไม่ filter filename)
      list = await targetAlbum.getAssetListRange(start: 0, end: 300);
    }

    assets.assignAll(list);
    loading.value = false;
  }

  void removeAsset(AssetEntity asset) {
    assets.remove(asset);
  }

  Future insertByFileName(String filename) async {
    // รอให้ system index ก่อน (จำเป็นมาก)
    // await Future.delayed(const Duration(milliseconds: 300));
    for (int i = 0; i < 5; i++) {
      await Future.delayed(const Duration(milliseconds: 500));
      // reload albums + search
    }

    final albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      onlyAll: true,
      filterOption: FilterOptionGroup(
        orders: const [OrderOption(type: OrderOptionType.createDate, asc: false)],
      ),
    );

    if (albums.isEmpty) return;

    final recent = await albums.first.getAssetListRange(start: 0, end: 50);

    // หา asset ที่ชื่อไฟล์ตรงกับของเรา
    final match = recent.firstWhereOrNull((a) => a.title == filename);

    if (match == null) return;

    // กัน insert ซ้ำ
    if (assets.isNotEmpty && assets.first.id == match.id) return;

    assets.insert(0, match);
  }
}
