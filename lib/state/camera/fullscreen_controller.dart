import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sakcamera_getx/state/camera/gallery_controller.dart';

class FullscreenController extends GetxController {
  final int initialindex;
  late final RxInt currentindex;
  late final GalleryController gallery;

  final CarouselSliderController carouselcontroller = CarouselSliderController();
  final ScrollController thumbnailscroll = ScrollController();

  bool initialpageused = false;
  bool animatingfromthumb = false;

  FullscreenController(this.initialindex) {
    currentindex = initialindex.obs;
  }

  int get initialpage {
    if (initialpageused) return 0;
    initialpageused = true;
    return initialindex;
  }

  final iszoom = false.obs;
  final TransformationController transformcontroller = TransformationController();

  void onTransformChanged() {
    final scale = transformcontroller.value.getMaxScaleOnAxis();
    iszoom.value = scale > 1.01; // กัน floating error
  }

  void resetZoom() {
    transformcontroller.value = Matrix4.identity();
    iszoom.value = false;
  }

  void scrollThumbnail(int index) {
    const double itemwidth = 68; // 60 + margin
    final double target = (index * itemwidth) - (itemwidth * 1.5);

    thumbnailscroll.animateTo(
      target.clamp(0.0, thumbnailscroll.position.maxScrollExtent),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  @override
  void onInit() {
    super.onInit();
    gallery = Get.find<GalleryController>();
  }

  AssetEntity get asset => gallery.assets[currentindex.value];

  Future<bool> deleteImage() async {
    final asset = gallery.assets[currentindex.value];

    final result = await PhotoManager.editor.deleteWithIds([asset.id]);
    if (result.isNotEmpty) {
      // ลบจาก source กลาง
      gallery.assets.removeAt(currentindex.value);

      // ปรับ index
      if (currentindex.value >= gallery.assets.length && gallery.assets.isNotEmpty) {
        currentindex.value = gallery.assets.length - 1;
      }

      // ไม่มีรูปแล้ว → ปิดหน้า
      // if (gallery.assets.isEmpty) {
      //   Get.back(result: true);
      // }
      // return true;

      return gallery.assets.isEmpty; // << บอกแค่ว่าว่างแล้ว
    }
    return false;
  }
}
