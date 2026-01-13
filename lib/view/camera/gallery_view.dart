import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:sakcamera_getx/constant/main_constant.dart';
import 'package:sakcamera_getx/state/camera/camera_controller.dart';
import 'package:sakcamera_getx/state/camera/fullscreen_controller.dart';
import 'package:sakcamera_getx/state/camera/gallery_controller.dart';
import 'package:sakcamera_getx/util/main_util.dart';
import 'package:sakcamera_getx/view/camera/fullscreen_view.dart';

class Gallery extends GetWidget<GalleryController> {
  const Gallery({super.key});

  @override
  Widget build(BuildContext context) {
    final cameracontroller = Get.find<CameraPageController>();
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            title: MainUtil.mainText(
              context,
              constraints,
              text: 'คลังรูปภาพ',
              textstyle: MainUtil.mainTextStyle(
                context,
                constraints,

                fontsize: MainConstant.h22,
                fontweight: MainConstant.boldfontweight,
                fontcolor: MainConstant.primary,
              ),
            ),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return Obx(() {
                if (controller.loading.value) {
                  return Center(
                    child: LoadingAnimationWidget.threeArchedCircle(
                      color: MainConstant.primary,
                      size: MainConstant.setWidth(context, constraints, 50),
                    ),
                  );
                }

                if (controller.assets.isEmpty) {
                  return Center(
                    child: MainUtil.mainText(
                      context,
                      constraints,
                      text: 'ไม่มีรูปภาพที่จะแสดง',
                      textstyle: MainUtil.mainTextStyle(
                        context,
                        constraints,
                        fontsize: MainConstant.h16,
                        fontcolor: MainConstant.primary,
                      ),
                    ),
                    // Text('ไม่มีรูปภาพที่จะแสดง',)
                  );
                }

                return Column(
                  children: [
                    // ===== PROCESS BAR =====
                    Obx(() {
                      final count = cameracontroller.processingcount.value;

                      if (count <= 0) {
                        return const SizedBox.shrink();
                      }

                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        color: MainConstant.primary,
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: LoadingAnimationWidget.hexagonDots(
                                color: MainConstant.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'กำลังประมวลผล $count ภาพ',
                              style: TextStyle(fontSize: 16, color: MainConstant.white),
                            ),
                          ],
                        ),
                      );
                    }),

                    // ===== GRID =====
                    Expanded(
                      child: GridView.builder(
                        padding: EdgeInsets.zero,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 1,
                        ),
                        itemCount: controller.assets.length,
                        itemBuilder: (_, index) {
                          final asset = controller.assets[index];

                          return GestureDetector(
                            onTap: () async {
                              final deleteimg = await Get.to<bool>(
                                () => const Fullscreen(),
                                binding: BindingsBuilder(() {
                                  Get.put(FullscreenController(index));
                                }),
                              );

                              if (deleteimg == true) {
                                controller.removeAsset(asset);
                              }
                            },
                            child: AssetEntityImage(asset, fit: BoxFit.cover),
                          );
                        },
                      ),
                    ),
                  ],
                );
              });
            },
          ),
        );
      },
    );
  }
}
