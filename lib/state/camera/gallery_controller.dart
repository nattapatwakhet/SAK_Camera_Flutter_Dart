import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryController extends GetxController {
  final assets = <AssetEntity>[].obs;
  final loading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadImages();
  }

  Future<void> loadImages() async {
    loading.value = true;

    // Desktop / Web ไม่รองรับ
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
      assets.clear();
      loading.value = false;
      return;
    }

    // Permission
    final permission = await PhotoManager.requestPermissionExtend();
    if (!permission.isAuth) {
      loading.value = false;
      return;
    }

    // sort ใหม่ก่อน (เหมือน LINE)
    final albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      onlyAll: true,
      filterOption: FilterOptionGroup(
        orders: const [OrderOption(type: OrderOptionType.createDate, asc: false)],
      ),
    );

    List<AssetEntity> list;

    // จุดสำคัญ
    if (Platform.isAndroid) {
      final sdk = int.parse(
        Platform.operatingSystemVersion.replaceAll(RegExp(r'[^0-9]'), '').substring(0, 2),
      );

      if (sdk <= 29) {
        // Android 10 หรือต่ำกว่า
        list = await albums.first.getAssetListRange(start: 0, end: 300);
      } else {
        // Android 11+
        list = await albums.first.getAssetListPaged(page: 0, size: 300);
      }
    } else {
      // iOS ใช้ได้หมด
      list = await albums.first.getAssetListRange(start: 0, end: 300);
    }

    // กรองเฉพาะ sak_
    final filtered = list.where((asset) {
      final name = asset.title ?? '';
      return name.toLowerCase().startsWith('sak_');
    }).toList();

    assets.assignAll(filtered);
    loading.value = false;
  }

  void removeAsset(AssetEntity asset) {
    assets.remove(asset);
  }

  Future<void> insertByFileName(String filename) async {
  // รอให้ system index ก่อน (จำเป็นมาก)
  await Future.delayed(const Duration(milliseconds: 300));

  final albums = await PhotoManager.getAssetPathList(
    type: RequestType.image,
    onlyAll: true,
    filterOption: FilterOptionGroup(
      orders: const [
        OrderOption(type: OrderOptionType.createDate, asc: false),
      ],
    ),
  );

  if (albums.isEmpty) return;

  final recent = await albums.first.getAssetListRange(start: 0, end: 50);

  // หา asset ที่ชื่อไฟล์ตรงกับของเรา
  final match = recent.firstWhereOrNull(
    (a) => a.title == filename,
  );

  if (match == null) return;

  // กัน insert ซ้ำ
  if (assets.isNotEmpty && assets.first.id == match.id) return;

  assets.insert(0, match);
}

}
