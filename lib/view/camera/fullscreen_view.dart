import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:sakcamera_getx/constant/main_constant.dart';
import 'package:sakcamera_getx/state/camera/fullscreen_controller.dart';
import 'package:sakcamera_getx/state/camera/gallery_controller.dart';

class Fullscreen extends GetWidget<FullscreenController> {
  const Fullscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gallery = Get.find<GalleryController>();

    return PopScope(
      canPop: false, // เราคุมการ pop เอง
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return; // ถูก pop ไปแล้ว ไม่ทำซ้ำ
        }

        // ดัก system back / gesture back
        Get.back(result: controller.haschange.value);
      },
      child: Scaffold(
        backgroundColor: MainConstant.black,
        body: Obx(() {
          if (gallery.assets.isEmpty) {
            return const SizedBox.shrink();
          }

          return Column(
            children: [
              // ===== รูปใหญ่ =====
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CarouselSlider.builder(
                      carouselController: controller.carouselcontroller,
                      itemCount: gallery.assets.length,
                      options: CarouselOptions(
                        initialPage: controller.initialpage,
                        // initialPage: controller.currentindex.value,
                        enableInfiniteScroll: false,
                        viewportFraction: 1,
                        height: double.infinity,
                        onPageChanged: (index, _) {
                          if (controller.animatingfromthumb) {
                            // slide ที่เกิดจาก thumbnail → ข้าม
                            controller.animatingfromthumb = false;
                            return;
                          }

                          controller.currentindex.value = index;
                          controller.scrollThumbnail(index);
                        },
                      ),
                      itemBuilder: (_, index, __) {
                        final asset = gallery.assets[index];
                        return Center(
                          child: InteractiveViewer(
                            transformationController: controller.transformcontroller,
                            onInteractionEnd: (_) => controller.onTransformChanged(),
                            onInteractionUpdate: (_) => controller.onTransformChanged(),
                            child: AssetEntityImage(asset, isOriginal: true, fit: BoxFit.contain),
                          ),
                        );
                      },
                    ),

                    // ===== ลูกศรซ้าย =====
                    Obx(() {
                      if (controller.currentindex.value == 0
                      // || controller.iszoom.value
                      ) {
                        return const SizedBox.shrink();
                      }
                      return Positioned(
                        left: 10,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_ios, color: MainConstant.white, size: 30),
                          onPressed: () {
                            controller.resetZoom(); //reset zoom ก่อนเลื่อน
                            controller.carouselcontroller.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                      );
                    }),

                    // ===== ลูกศรขวา =====
                    Obx(() {
                      if (controller.currentindex.value >= gallery.assets.length - 1
                      // || controller.iszoom.value
                      ) {
                        return const SizedBox.shrink();
                      }
                      return Positioned(
                        right: 10,
                        child: IconButton(
                          icon: Icon(Icons.arrow_forward_ios, color: MainConstant.white, size: 30),
                          onPressed: () {
                            controller.resetZoom(); // reset zoom ก่อนเลื่อน
                            controller.carouselcontroller.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),

              // ===== แถบ preview ด้านล่าง =====
              SizedBox(
                height: 80,
                child: ListView.builder(
                  controller: controller.thumbnailscroll,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  itemCount: gallery.assets.length,
                  itemBuilder: (context, index) {
                    final asset = gallery.assets[index];
                    // final bool active = controller.currentindex.value == index;

                    return GestureDetector(
                      onTap: () {
                        // controller.carouselcontroller.jumpToPage(index);
                        controller.animatingfromthumb = true;

                        controller.carouselcontroller.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                        );

                        controller.currentindex.value = index;
                        controller.scrollThumbnail(index);
                      },
                      child: Obx(() {
                        final bool active = controller.currentindex.value == index;
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: active ? MainConstant.white : MainConstant.transparent,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: AssetEntityImage(
                              asset,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),
              ),

              // ===== control bar (ย้อนกลับ + ลบ) =====
              SafeArea(
                top: false,
                child: Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  color: MainConstant.black.withValues(alpha: 0.85),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // ปุ่มย้อนกลับ
                      IconButton(
                        icon: Image.asset(
                          'assets/images/back.png',
                          width: 25,
                          height: 25,
                          color: MainConstant.white,
                        ),
                        onPressed: () {
                          Get.back(result: controller.haschange.value);
                        },
                      ),

                      // ปุ่มลบ
                      IconButton(
                        icon: Image.asset(
                          'assets/images/bin_1.png',
                          width: 25,
                          height: 25,
                          color: MainConstant.white, // ถ้าเป็น PNG ขาว/โปร่ง จะ tint ได้
                        ),
                        onPressed: () async {
                          await controller.deleteImage();

                          // ถ้าลบแล้วไม่มีรูป → ออกจากหน้า
                          if (gallery.assets.isEmpty) {
                            Get.back(result: true);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
