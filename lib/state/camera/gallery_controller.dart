import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sakcamera_getx/state/camera/camera_controller.dart';

class GalleryController extends GetxController {
  final assets = <AssetEntity>[].obs;
  final loading = true.obs;
  final Rx<AssetEntity?> lastasset = Rx<AssetEntity?>(null);

  static const String albumname = 'SAK_Camera';

  @override
  void onReady() {
    super.onReady();
    final camera = Get.find<CameraPageController>();

    ever(camera.storagepermission, (bool granted) {
      if (granted) loadImages();
    });

    if (camera.storagepermission.value) {
      loadImages();
    }
  }

  // =====================================================
  // LOAD IMAGES (รองรับ Android 8–16 + iOS)
  // =====================================================
  Future loadImages() async {
    loading.value = true;

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

    AssetPathEntity? targetalbum;

    if (Platform.isIOS) {
      // iOS → strict album
      targetalbum = albums.firstWhereOrNull((a) => a.name == albumname);
      if (targetalbum == null) {
        assets.clear();
        loading.value = false;
        return;
      }
    }
    if (Platform.isAndroid) {
      targetalbum = albums.firstWhereOrNull((a) => a.name.toLowerCase() == albumname.toLowerCase());

      // ไม่ fallback
      if (targetalbum == null) {
        assets.clear();
        lastasset.value = null;
        loading.value = false;
        return;
      }
    }

    final sdk = Platform.isAndroid ? (await DeviceInfoPlugin().androidInfo).version.sdkInt : 0;

    final List<AssetEntity> list = Platform.isAndroid
        ? (sdk <= 29
              ? await targetalbum!.getAssetListRange(start: 0, end: 300)
              : await targetalbum!.getAssetListPaged(page: 0, size: 300))
        : await targetalbum!.getAssetListRange(start: 0, end: 300);

    // Android ห้าม filter ด้วย filename
    assets.assignAll(list);

    if (assets.isNotEmpty) {
      lastasset.value = assets.first;
    }

    loading.value = false;
  }

  // void removeAsset(AssetEntity asset) {
  //   assets.remove(asset);
  // }
  void removeAsset(AssetEntity asset) {
    assets.removeWhere((a) => a.id == asset.id);

    if (assets.isEmpty) {
      lastasset.value = null;
    } else {
      lastasset.value = assets.first;
    }

    assets.refresh();
  }

  // =====================================================
  // INSERT BY FILENAME (ใช้ตอน save ใหม่)
  // =====================================================
  Future insertLatestImageSafe() async {
    final ps = await PhotoManager.requestPermissionExtend();
    if (!ps.isAuth) return;

    // รอ MediaStore index
    await Future.delayed(const Duration(milliseconds: 800));

    final albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      filterOption: FilterOptionGroup(
        orders: const [OrderOption(type: OrderOptionType.createDate, asc: false)],
      ),
    );

    if (albums.isEmpty) return;

    AssetPathEntity? target = albums.firstWhereOrNull(
      (a) => a.name.toLowerCase() == albumname.toLowerCase(),
    );

    if (target == null) return;

    final recent = await target.getAssetListPaged(page: 0, size: 1);
    if (recent.isEmpty) return;

    final asset = recent.first;

    // update state
    assets.insert(0, asset);
    lastasset.value = asset;
    assets.refresh();
  }
}
