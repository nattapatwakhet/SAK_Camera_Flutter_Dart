import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gm;
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:sakcamera_getx/component/main_dialog_component.dart';
import 'package:sakcamera_getx/constant/main_constant.dart';
import 'package:sakcamera_getx/controller/user_controller.dart';
import 'package:sakcamera_getx/state/camera/camera_controller.dart';
import 'package:sakcamera_getx/state/camera/gallery_controller.dart';
import 'package:sakcamera_getx/state/camera/map_controller.dart';
import 'package:sakcamera_getx/util/main_util.dart';
import 'package:sakcamera_getx/util/write_focus_util.dart';

class Camera extends GetWidget<CameraPageController> {
  final usercontroller = Get.find<UserController>();
  final mapcontroller = Get.find<MapController>();
  Camera({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: MainConstant.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: MainConstant.primary,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return OrientationBuilder(
      builder: (context, orientation) {
        return MediaQuery.withClampedTextScaling(
          minScaleFactor: 1,
          maxScaleFactor: 1,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            behavior: HitTestBehavior.opaque,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: orientation == Orientation.portrait
                            ? MainConstant.primary
                            : MainConstant.transparent,
                      ),
                    ),
                    Expanded(flex: 1, child: Container(color: MainConstant.transparent)),
                  ],
                ),

                // ใช้ Obx เพื่อจับค่าจาก Controller
                SafeArea(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      controller.lastconstraints.value = constraints;

                      controller.layoutReady =
                          constraints.maxWidth > 0 && constraints.maxHeight > 0;

                      if (kDebugMode) {
                        print('=== LayoutBuilder Constraints ===');
                        print('MaxWidth: ${constraints.maxWidth}');
                        print('MaxHeight: ${constraints.maxHeight}');
                      }

                      return PopScope(
                        canPop: false, // false จะแสดง pop up เราก่อน ถ้า true จะออกเลย
                        onPopInvokedWithResult: (didPop, popResult) async {
                          final result = await MainDialog.dialogPopup(
                            context,
                            true,
                            'warning'.tr,
                            message: 'warning_close_app'.tr,
                            confirmbutton: 'ok'.tr,
                            closebutton: 'cancel'.tr,
                          );
                          if (result == true) {
                            SystemNavigator.pop(); // ออกจากแอปหรือปิดแอป
                          }
                        },
                        child: Scaffold(
                          // appBar: widgetAppBar(context),
                          backgroundColor: MainConstant.primary,
                          body: SizedBox(
                            width: MainConstant.setWidthFull(context, constraints),
                            height: MainConstant.setHeightFull(context, constraints),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  flex: 9,
                                  child: Center(
                                    child: AspectRatio(
                                      aspectRatio: 3 / 4,
                                      child: LayoutBuilder(
                                        builder: (context, box) {
                                          // box = preview จริง 100%
                                          controller.previewsize.value = Size(
                                            box.maxWidth,
                                            box.maxHeight,
                                          );

                                          return Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              // SizedBox(
                                              //   width: constraints.maxWidth,
                                              //   height: constraints.maxHeight,
                                              //   child: buildWidgetCameraPreview(
                                              //     context,
                                              //     constraints,
                                              //   ),
                                              // ),
                                              buildWidgetCameraPreview(context, box),

                                              /// ===== Shutter Effect =====
                                              Obx(() {
                                                if (!controller.shuttereffect.value) {
                                                  return const SizedBox.shrink();
                                                }

                                                return Positioned.fill(
                                                  child: Container(
                                                    color: MainConstant.black.withValues(
                                                      alpha: 0.6,
                                                    ),
                                                  ),
                                                );
                                              }),

                                              buildWidgetLogo(context, constraints),
                                              buildMiniMapGoogle(context, constraints),
                                              widgetInfoText(context, constraints),
                                              buildWidgetCameraFlashButtons(context, constraints),
                                              buildWidgetCameraSwitchButtons(context, constraints),
                                              buildWidgetCameraMarkerButtons(context, constraints),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    color: MainConstant.transparent,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        // Row(
                                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        //   children: [
                                        //     Obx(() {
                                        //       final user = usercontroller.usermodel.value;
                                        //       return Text(
                                        //         // usercontroller.usermodel.value?.ID_personnel ?? '-',
                                        //         '${user?.firstname_PSN ?? '-'} (${user?.ID_personnel ?? '-'})',
                                        //         style: TextStyle(
                                        //           color: Colors.white,
                                        //           fontSize: 16,
                                        //           fontWeight: FontWeight.bold,
                                        //         ),
                                        //       );
                                        //     }),

                                        //     ElevatedButton(
                                        //       onPressed: () async {
                                        //         await ClearUser.clearController();
                                        //         await ClearUser.clearUser();
                                        //         controller.submitLogout();
                                        //       },
                                        //       child: Text('Logout'),
                                        //     ),
                                        //   ],
                                        // ),
                                        buildGalleryButton(context, constraints),
                                        buildTakePictureButton(context, constraints),
                                        buildSettingButton(context, constraints),
                                      ],
                                    ),
                                  ),
                                ),
                                // Expanded(
                                //   flex: 1,
                                //   child: Container(color: MainConstant.red),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget widgetInfoText(BuildContext context, BoxConstraints constraints) {
    return Obx(() {
      //เช็คก่อนใช้ FutureBuilder
      if (usercontroller.usermodel.value == null) {
        return SizedBox.shrink(); // <<== ป้องกันการใช้งานก่อนถูก set
      }

      double angle;
      double? xtop;
      double? xbottom;
      double? yleft;
      double? yright;

      switch (controller.rotationangle.value) {
        case 1: // หมุนซ้าย (อุปกรณ์เอียงซ้าย)
          angle = math.pi / 2;
          xbottom = 5;
          yleft = 5;
          break;
        case 3: // หมุนขวา (อุปกรณ์เอียงขวา)
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
          angle = 0.0;
          xbottom = 5;
          yright = 5;
      }

      return Positioned(
        top: xtop,
        bottom: xbottom,
        right: yright,
        left: yleft,
        child: Transform.rotate(
          angle: angle,
          child: RepaintBoundary(
            key: controller.infotextkey,
            child: Container(
              color: MainConstant.transparent,
              width: controller.rotationangle.value == 0 || controller.rotationangle.value == 2
                  ? 220
                  : 220,
              height: controller.rotationangle.value == 0 || controller.rotationangle.value == 2
                  ? 120
                  : 220,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  StreamBuilder(
                    stream: Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now()),

                    builder: (context, timesnapshot) {
                      final datetimenow = timesnapshot.data ?? DateTime.now();
                      final textyear = (int.parse(DateFormat('y', 'th').format(datetimenow)) + 543)
                          .toString();
                      final textdate = DateFormat(
                        'EEEEที่ dd MMMM $textyear',
                        'th',
                      ).format(datetimenow);
                      final texttime = DateFormat('เวลา HH:mm:ss น.', 'th').format(datetimenow);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          MainUtil.mainText(
                            context,
                            constraints,
                            text: textdate,
                            textstyle: MainUtil.mainTextStyle(
                              context,
                              constraints,
                              fontsize: MainConstant.h12,
                              fontweight: MainConstant.boldfontweight,
                              fontcolor: MainConstant.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 3,
                                  color: MainConstant.black,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                          ),
                          MainUtil.mainText(
                            context,
                            constraints,
                            text: texttime,
                            textstyle: MainUtil.mainTextStyle(
                              context,
                              constraints,
                              fontsize: MainConstant.h12,
                              fontweight: MainConstant.boldfontweight,
                              fontcolor: MainConstant.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 3,
                                  color: MainConstant.black,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                          ),
                          MainUtil.mainText(
                            context,
                            constraints,
                            text: usercontroller.usermodel.value == null
                                ? ''
                                : usercontroller.usermodel.value!.workplace,
                            textstyle: MainUtil.mainTextStyle(
                              context,
                              constraints,
                              fontsize: MainConstant.h12,
                              fontweight: MainConstant.boldfontweight,
                              fontcolor: MainConstant.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 3,
                                  color: MainConstant.black,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                          ),
                          MainUtil.mainText(
                            context,
                            constraints,
                            text: usercontroller.usermodel.value == null
                                ? ''
                                : '${usercontroller.usermodel.value!.belong} ${usercontroller.usermodel.value!.region}',
                            textstyle: MainUtil.mainTextStyle(
                              context,
                              constraints,
                              fontsize: MainConstant.h12,
                              fontweight: MainConstant.boldfontweight,
                              fontcolor: MainConstant.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 3,
                                  color: MainConstant.black,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                          ),
                          MainUtil.mainText(
                            context,
                            constraints,
                            text: mapcontroller.currentlatlnggoogle.value != null
                                ? 'พิกัด ${mapcontroller.currentlatlnggoogle.value!.latitude.toStringAsFixed(5)}, ${mapcontroller.currentlatlnggoogle.value!.longitude.toStringAsFixed(5)}'
                                : 'ไม่พบพิกัด',
                            textstyle: MainUtil.mainTextStyle(
                              context,
                              constraints,
                              fontsize: MainConstant.h12,
                              fontweight: MainConstant.boldfontweight,
                              fontcolor: MainConstant.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 3,
                                  color: MainConstant.black,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                          ),
                          MainUtil.mainText(
                            context,
                            constraints,
                            text: '${MainConstant.nameapp} เวอร์ชัน ${MainConstant.version}',
                            textstyle: MainUtil.mainTextStyle(
                              context,
                              constraints,
                              fontsize: MainConstant.h12,
                              fontweight: MainConstant.boldfontweight,
                              fontcolor: MainConstant.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 3,
                                  color: MainConstant.black,
                                  offset: Offset(1, 1),
                                  //asdasdasda
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  //===>> AppBar <===//
  PreferredSizeWidget widgetAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(60),
      child: AppBar(
        backgroundColor: MainConstant.primary,
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                left: 15,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: MainConstant.white),
                  onPressed: () => Get.back(),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ),
              Positioned(
                bottom: 6,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'nameapp'.tr,
                    style: TextStyle(
                      fontSize: MainConstant.h24,
                      fontWeight: MainConstant.boldfontweight,
                      color: MainConstant.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  //===>> AppBar <===//

  //===>> โครง CameraPreview  <===//
  Widget buildWidgetCameraPreview(BuildContext context, BoxConstraints constraints) {
    return Obx(() {
      if (!controller.camerapermission.value) {
        return Center(
          child: Text(
            'กำลังขอสิทธิ์ใช้งานกล้อง...',
            style: TextStyle(color: MainConstant.white, fontSize: 18),
          ),
        );
      }
      if (!controller.statuscamera.value || controller.cameracontroller == null) {
        return Center(
          child: LoadingAnimationWidget.threeArchedCircle(
            color: MainConstant.white,
            size: MainConstant.setWidth(context, constraints, 50),
          ),
        );
      }

      // กล้องพร้อมแล้ว → แสดง CameraPreview
      return startCameraPreview(context, constraints);
    });
  }
  //===>> โครง CameraPreview  <===//

  //===>> CameraPreview เรียกกล้องแสดงถ้าพร้อม <===//
  Widget startCameraPreview(BuildContext context, BoxConstraints constraints) {
    final camera = controller.cameracontroller;

    if (camera == null || !controller.statuscamera.value) {
      return Center(
        child: LoadingAnimationWidget.threeArchedCircle(
          color: MainConstant.white,
          size: MainConstant.setWidth(context, constraints, 50),
        ),
      );
    }

    // constraints ตรงนี้ = preview 3/4 จริง
    final w = constraints.maxWidth;
    final h = constraints.maxHeight;

    controller.previewsize.value = Size(w, h);

    // กล้องพร้อม แสดง CameraPreview
    return Stack(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,

          // ===== TAP TO FOCUS =====
          onTapDown: (TapDownDetails details) {
            final dx = details.localPosition.dx;
            final dy = details.localPosition.dy;

            // แปลงเป็นสัดส่วน 0.0 - 1.0
            final fx = dx / w;
            final fy = dy / h;

            // บันทึกตำแหน่งไว้ให้โชว์กรอบโฟกัส
            controller.focusoffset.value = Offset(dx, dy);

            // เรียกโฟกัส
            if (fx >= 0 && fx <= 1 && fy >= 0 && fy <= 1) {
              controller.setFocusAndExposure(fx, fy);
            }

            // เริ่ม animation
            controller.focusopacity.value = 1;
            controller.focusscale.value = 1.0;

            // Step 1: Zoom out (1.0 → 1.3)
            controller.focusscale.value = 1.3;

            // Step 2: Zoom back (1.3 → 1.0)
            Future.delayed(const Duration(milliseconds: 120), () {
              controller.focusscale.value = 1.0;
            });

            // fade ออกภายใน 800ms
            Future.delayed(const Duration(milliseconds: 1500), () {
              controller.focusopacity.value = 0;

              Future.delayed(const Duration(milliseconds: 200), () {
                controller.focusoffset.value = null;
              });
            });
          },

          // ===== PINCH ZOOM =====
          onScaleStart: (details) {
            controller.basezoom = controller.zoomlevel.value;
          },

          onScaleUpdate: (details) async {
            if (details.scale == 1.0) return;

            double newzoom = controller.basezoom * details.scale;
            if (newzoom < controller.minzoom) newzoom = controller.minzoom;
            if (newzoom > controller.maxzoom) newzoom = controller.maxzoom;

            controller.zoomlevel.value = newzoom;
            await camera.setZoomLevel(newzoom);

            controller.showZoomIndicator();
          },

          // ===== DOUBLE TAP ZOOM =====
          onDoubleTap: () async {
            double newzoom = controller.zoomlevel.value + 1;
            if (newzoom > controller.maxzoom) {
              newzoom = controller.minzoom; // รีเซ็ตเป็น 1x
            }

            controller.zoomlevel.value = newzoom;
            await camera.setZoomLevel(newzoom);

            controller.showZoomIndicator();
          },

          child: CameraPreview(camera),
        ),

        // ===== ZOOM BAR =====
        buidWidgetZoomBar(context),

        // ===== FOCUS RETICLE =====
        Obx(() {
          final pos = controller.focusoffset.value;
          if (pos == null) return const SizedBox.shrink();

          const double size = 40;

          return Positioned(
            left: pos.dx - size / 2,
            top: pos.dy - size / 2,
            child: AnimatedScale(
              scale: controller.focusscale.value,
              duration: const Duration(milliseconds: 120),
              curve: Curves.easeOut,
              child: AnimatedOpacity(
                opacity: controller.focusopacity.value,
                duration: const Duration(milliseconds: 200),
                child: SizedBox(
                  width: size,
                  height: size,
                  child: CustomPaint(painter: FocusReticlePainter(color: MainConstant.white)),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
  //===>> CameraPreview เรียกกล้องแสดงถ้าพร้อม <===//

  //===>> Logo <===//
  Widget buildWidgetLogo(BuildContext context, BoxConstraints constraints) {
    return Obx(() {
      // กล้องยังโหลดไม่เสร็จไม่ต้อง render position อะไรทั้งนั้น
      if (!controller.statuscamera.value ||
          controller.cameralist.isEmpty ||
          controller.cameracontroller == null ||
          !controller.cameracontroller!.value.isInitialized) {
        return SizedBox.shrink(); // ไม่แสดงอะไร
      }

      final preview = controller.previewsize.value!;
      const double logosize = 80;

      double angle = 0;

      double? xtop;
      double? xbottom;
      double? yleft;
      double? yright;

      switch (controller.rotationangle.value) {
        case 1: // หมุนซ้าย
          angle = math.pi / 2;
          xbottom = 5;
          yright = 5;
          break;
        case 3: // หมุนขวา
          angle = -math.pi / 2;
          xtop = 5;
          yleft = 5;
          break;
        case 2: // กลับหัว
          angle = math.pi;
          xbottom = 5;
          yleft = 5;
          break;
        default: // แนวตั้ง
          angle = 0.0;
          xtop = 5;
          yright = 5;
      }

      return TweenAnimationBuilder(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        tween: Tween<double>(begin: angle, end: angle),
        builder: (context, animetionangle, child) {
          return AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: xtop,
            bottom: xbottom,
            left: yleft,
            right: yright,
            child: Transform.rotate(angle: animetionangle, child: child),
          );
        },

        child: Opacity(opacity: 0.85, child: Image.asset(MainConstant.saklogo, width: logosize)),
      );

      // final layout = controller.getLogoLayout(controller.rotationangle.value);

      // return TweenAnimationBuilder(
      //   duration: const Duration(milliseconds: 300),
      //   curve: Curves.easeInOut,
      //   tween: Tween<double>(begin: layout.angle, end: layout.angle),
      //   builder: (context, animAngle, child) {
      //     return AnimatedPositioned(
      //       duration: const Duration(milliseconds: 300),
      //       curve: Curves.easeInOut,
      //       top: layout.xtop == 0 ? null : layout.xtop,
      //       bottom: layout.xbottom == 0 ? null : layout.xbottom,
      //       left: layout.yleft == 0 ? null : layout.yleft,
      //       right: layout.yright == 0 ? null : layout.yright,
      //       child: Transform.rotate(angle: animAngle, child: child),
      //     );
      //   },
      //   child: Opacity(opacity: 0.85, child: Image.asset(MainConstant.saklogo, width: logosize)),
      // );
    });
  }
  //===>> Logo <===//

  //===>> Map <===//
  Widget buildMiniMapGoogle(BuildContext context, BoxConstraints constraints) {
    final c = Get.find<MapController>();

    return Obx(() {
      final rotationangle = c.rotationangle.value;
      final refreshmap = c.refreshmap.value;
      final currentlatlng = c.currentlatlnggoogle.value;

      double angle;
      double? xtop;
      double? xbottom;
      double? yleft;
      double? yright;

      switch (rotationangle) {
        case 1: // หมุนซ้าย
          angle = math.pi / 2;
          xtop = 0;
          yleft = 0;
          break;
        case 3: // หมุนขวา
          angle = -math.pi / 2;
          xbottom = 0;
          yright = 0;
          break;
        case 2: // กลับหัว
          angle = math.pi;
          xtop = 0;
          yright = 0;
          break;
        default: // แนวตั้ง
          angle = 0.0;
          xbottom = 0;
          yleft = 0;
      }

      return TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        tween: Tween<double>(end: angle),
        builder: (context, animetionangle, child) {
          return AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: xtop,
            bottom: xbottom,
            left: yleft,
            right: yright,
            child: Transform.rotate(angle: animetionangle, child: child),
          );
        },
        child: ClipRRect(
          borderRadius: const BorderRadius.only(topRight: Radius.circular(10)),
          child: Opacity(
            opacity: 0.9,
            child: (currentlatlng == null || refreshmap)
                ? loadingMap()
                : SizedBox(
                    width: 105,
                    height: 105,
                    child: gm.GoogleMap(
                      mapType: gm.MapType.satellite,
                      initialCameraPosition: gm.CameraPosition(target: currentlatlng, zoom: 18),
                      markers: c.googlemarker,

                      myLocationEnabled: false,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      compassEnabled: false,
                      mapToolbarEnabled: false,

                      scrollGesturesEnabled: false,
                      rotateGesturesEnabled: false,
                      tiltGesturesEnabled: false,
                      zoomGesturesEnabled: false,
                      liteModeEnabled: false,
                      minMaxZoomPreference: gm.MinMaxZoomPreference(18, 18),
                      onMapCreated: c.onGoogleMapCreated,
                    ),
                  ),
          ),
        ),
      );
    });
  }

  Widget loadingMap() {
    return Container(
      width: 105,
      height: 105,
      color: MainConstant.grey,
      child: Center(
        child: SizedBox(
          width: 25,
          height: 25,
          child: LoadingAnimationWidget.hexagonDots(color: MainConstant.white, size: 35),
        ),
      ),
    );
  }
  //===>> Map <===//

  //===>> Flash <===//
  Widget buildWidgetCameraFlashButtons(BuildContext context, BoxConstraints constraints) {
    return Obx(() {
      // กล้องยังโหลดไม่เสร็จไม่ต้อง render position อะไรทั้งนั้น
      if (!controller.statuscamera.value ||
          controller.cameralist.isEmpty ||
          controller.cameracontroller == null ||
          !controller.cameracontroller!.value.isInitialized) {
        return SizedBox.shrink(); // ไม่แสดงอะไร
      }

      double angle;

      double? xtop;
      double? xbottom;
      double? yleft;
      double? yright;

      switch (controller.rotationangle.value) {
        case 1: // หมุนซ้าย
          angle = math.pi / 2;
          xbottom = 0;
          yright = 90;
          break;
        case 3: // หมุนขวา
          angle = -math.pi / 2;
          xtop = 0;
          yleft = 90;
          break;
        case 2: // กลับหัว
          angle = math.pi;
          xbottom = 90;
          yleft = 0;
          break;
        default: // แนวตั้ง
          angle = 0.0;
          xtop = 90;
          yright = 0;
      }

      return TweenAnimationBuilder(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        tween: Tween<double>(begin: angle, end: angle),
        builder: (context, animetionangle, child) {
          return AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: xtop,
            bottom: xbottom,
            left: yleft,
            right: yright,
            child: Transform.rotate(angle: animetionangle, child: child),
          );
        },
        child: Container(
          color: MainConstant.transparent,
          child: SizedBox(
            width: 50,
            height: 50,
            child: Column(
              children: [
                if (controller.cameralist.isNotEmpty &&
                    controller.cameralist[controller.selectedcamera].lensDirection ==
                        CameraLensDirection.back)
                  ElevatedButton(
                    onPressed: () {
                      controller.takeFlash();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MainConstant.transparent,
                      shadowColor: MainConstant.transparent,
                      elevation: 0,
                      padding: EdgeInsets.all(5),
                      shape: CircleBorder(),
                    ),
                    child: Icon(
                      controller.statusflashmode.value == FlashMode.off
                          ? Icons.flash_off
                          : controller.statusflashmode.value == FlashMode.auto
                          ? Icons.flash_auto
                          : Icons.flash_on,
                      color: MainConstant.white,
                      size: 30,
                      shadows: [
                        Shadow(offset: Offset(1, 1), blurRadius: 3, color: MainConstant.black),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
  //===>> Flash <===//

  //===>> Switch <===//
  Widget buildWidgetCameraSwitchButtons(BuildContext context, BoxConstraints constraints) {
    return Obx(() {
      // กล้องยังโหลดไม่เสร็จไม่ต้อง render position อะไรทั้งนั้น
      if (!controller.statuscamera.value ||
          controller.cameralist.isEmpty ||
          controller.cameracontroller == null ||
          !controller.cameracontroller!.value.isInitialized) {
        return SizedBox.shrink(); // ไม่แสดงอะไร
      }

      // ตรวจว่าเป็นกล้องหน้า / หลัง
      final frontcamera =
          controller.cameralist[controller.selectedcamera].lensDirection ==
          CameraLensDirection.front;

      double angle;
      double? xtop;
      double? xbottom;
      double? yleft;
      double? yright;

      switch (controller.rotationangle.value) {
        case 1: // หมุนซ้าย
          angle = math.pi / 2;
          if (frontcamera) {
            // กล้องหน้า → เลื่อนขึ้นแทนตำแหน่งแฟลช
            xbottom = 0;
            yright = 90;
          } else {
            xbottom = 0;
            yright = 140;
          }
          break;

        case 3: // หมุนขวา
          angle = -math.pi / 2;
          if (frontcamera) {
            xtop = 0;
            yleft = 90;
          } else {
            xtop = 0;
            yleft = 140;
          }
          break;

        case 2: // กลับหัว
          angle = math.pi;
          if (frontcamera) {
            xbottom = 90;
            yleft = 0;
          } else {
            xbottom = 140;
            yleft = 0;
          }
          break;

        default: //แนวตั้ง
          angle = 0.0;
          if (frontcamera) {
            xtop = 90;
            yright = 0;
          } else {
            xtop = 140;
            yright = 0;
          }
      }
      return TweenAnimationBuilder(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        tween: Tween<double>(begin: angle, end: angle),
        builder: (context, animetionangle, child) {
          return AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: xtop,
            bottom: xbottom,
            left: yleft,
            right: yright,
            child: Transform.rotate(angle: animetionangle, child: child),
          );
        },
        child: Container(
          color: MainConstant.transparent,
          child: SizedBox(
            width: 50,
            height: 50,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    controller.switchCamera();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MainConstant.transparent,
                    shadowColor: MainConstant.transparent,
                    elevation: 0,
                    padding: EdgeInsets.all(5),
                    shape: CircleBorder(),
                  ),
                  child: Icon(
                    controller.cameralist.isNotEmpty
                        ? (controller.cameralist[controller.selectedcamera].lensDirection ==
                                  CameraLensDirection.front
                              ? Icons.cameraswitch_outlined
                              : Icons.cameraswitch)
                        : Icons.cameraswitch,
                    color: MainConstant.white,
                    size: 30,
                    shadows: [
                      Shadow(offset: Offset(1, 1), blurRadius: 3, color: MainConstant.black),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
  //===>> Switch <===//

  //===>> Marker <===//
  Widget buildWidgetCameraMarkerButtons(BuildContext context, BoxConstraints constraints) {
    return Obx(() {
      // กล้องยังโหลดไม่เสร็จไม่ต้อง render position อะไรทั้งนั้น
      if (!controller.statuscamera.value ||
          controller.cameralist.isEmpty ||
          controller.cameracontroller == null ||
          !controller.cameracontroller!.value.isInitialized) {
        return SizedBox.shrink(); // ไม่แสดงอะไร
      }

      // ตรวจว่าเป็นกล้องหน้า / หลัง
      final frontcamera =
          controller.cameralist[controller.selectedcamera].lensDirection ==
          CameraLensDirection.front;

      double angle;
      double? xtop;
      double? xbottom;
      double? yleft;
      double? yright;

      switch (controller.rotationangle.value) {
        case 1: // หมุนซ้าย
          angle = math.pi / 2;
          if (frontcamera) {
            xbottom = 0;
            yright = 140;
          } else {
            xbottom = 0;
            yright = 190;
          }
          break;
        case 3: // หมุนขวา
          angle = -math.pi / 2;
          if (frontcamera) {
            xtop = 0;
            yleft = 140;
          } else {
            xtop = 0;
            yleft = 190;
          }
          break;
        case 2: // กลับหัว
          angle = math.pi;
          if (frontcamera) {
            xbottom = 140;
            yleft = 0;
          } else {
            xbottom = 190;
            yleft = 0;
          }
          break;
        default: // แนวตั้ง
          angle = 0.0;
          if (frontcamera) {
            xtop = 140;
            yright = 0;
          } else {
            xtop = 190;
            yright = 0;
          }
      }

      return TweenAnimationBuilder(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        tween: Tween<double>(begin: angle, end: angle),
        builder: (context, animetionangle, child) {
          return AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: xtop,
            bottom: xbottom,
            left: yleft,
            right: yright,
            child: Transform.rotate(angle: animetionangle, child: child),
          );
        },
        child: Container(
          color: MainConstant.transparent,
          child: SizedBox(
            width: 50,
            height: 50,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await mapcontroller.refreshGoogleMap(debug: kDebugMode);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MainConstant.transparent,
                    shadowColor: MainConstant.transparent,
                    elevation: 0,
                    padding: EdgeInsets.all(5),
                    shape: CircleBorder(),
                  ),
                  child: Image.asset('assets/images/marker_icon.png', width: 30, height: 30),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
  //===>> Marker <===//

  //===>> Zoombar <===//
  Widget buidWidgetZoomBar(BuildContext context) {
    return Obx(() {
      // กล้องยังโหลดไม่เสร็จไม่ต้อง render position อะไรทั้งนั้น
      if (!controller.statuscamera.value ||
          controller.cameralist.isEmpty ||
          controller.cameracontroller == null ||
          !controller.cameracontroller!.value.isInitialized) {
        return SizedBox.shrink(); // ไม่แสดงอะไร
      }

      double angle;

      double? xtop;
      double? xbottom;
      double? yleft;
      double? yright;

      switch (controller.rotationangle.value) {
        case 1: // หมุนซ้าย
          angle = math.pi / 2;
          xbottom = 225;
          yleft = -50;
          break;
        case 3: // หมุนขวา
          angle = -math.pi / 2;
          xtop = 225;
          yright = -50;
          break;
        case 2: // กลับหัว
          angle = math.pi;
          xtop = 10;
          yright = 95;
          break;
        default: // แนวตั้ง
          angle = 0.0;
          xbottom = 10;
          yleft = 95;
      }

      return TweenAnimationBuilder(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        tween: Tween<double>(begin: angle, end: angle),
        builder: (context, animAngle, child) {
          return AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            top: xtop,
            bottom: xbottom,
            left: yleft,
            right: yright,
            child: Transform.rotate(angle: animAngle, child: child),
          );
        },

        // bottom: 10,
        // left: 75,
        // right: 75,
        child: Obx(() {
          return AnimatedOpacity(
            opacity: controller.zoomopacity.value,
            duration: Duration(milliseconds: 200),
            child: IgnorePointer(
              ignoring: controller.zoomopacity.value == 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: MainConstant.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "${controller.zoomlevel.value.toStringAsFixed(1)}x",
                        style: TextStyle(
                          color: MainConstant.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Slider ซูมเข้าออก
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 3,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                          overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                          activeTrackColor: MainConstant.white,
                          inactiveTrackColor: MainConstant.white.withValues(alpha: 0.3),
                          thumbColor: MainConstant.white,
                        ),
                        child: Slider(
                          min: controller.minzoom,
                          max: controller.maxzoom,
                          value: controller.zoomlevel.value,
                          onChanged: (value) async {
                            controller.zoomlevel.value = value;
                            await controller.cameracontroller!.setZoomLevel(value);

                            controller.showZoomIndicator();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      );
    });
  }
  //===>> Zoombar <===//

  //===>> Gallery Button <===//
  Widget buildGalleryButton(BuildContext context, BoxConstraints constraints) {
    return Obx(() {
      double angle;
      switch (controller.rotationangle.value) {
        case 1: // หมุนซ้าย
          angle = math.pi / 2;
          break;
        case 3: // หมุนขวา
          angle = -math.pi / 2;
          break;
        case 2: // กลับหัว
          angle = math.pi;
          break;
        default: // แนวตั้ง
          angle = 0.0;
      }

      return TweenAnimationBuilder<double>(
        tween: Tween(begin: angle, end: angle),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        builder: (context, animetionangle, child) {
          return Transform.rotate(angle: animetionangle, child: child);
        },
        child: SizedBox(
          width: 65,
          height: 65,
          child: ElevatedButton(
            onPressed: () {
              Get.toNamed('gallery');
            },
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.all(2),
              backgroundColor: MainConstant.white,
            ),
            child:
                // Icon(Icons.photo_library, size: 40, color: MainConstant.black),
                Obx(() {
                  final gallery = Get.find<GalleryController>();
                  final bool processingimage = controller.processingcount.value > 0;

                  // 1. ไม่มีรูปเลย + ไม่กำลังประมวลผล
                  if (gallery.assets.isEmpty && !processingimage) {
                    return Icon(Icons.photo_library, size: 40, color: MainConstant.black);
                  }

                  // 2. ไม่มีรูป + กำลังประมวลผล
                  if (gallery.assets.isEmpty && processingimage) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipOval(child: Container(width: 58, height: 58, color: MainConstant.grey)),
                        LoadingAnimationWidget.threeArchedCircle(
                          color: MainConstant.white,
                          size: 30,
                        ),
                      ],
                    );
                  }

                  // 3. มีรูปแล้ว → ใช้รูปแรก (ล่าสุด)
                  final lastasset = gallery.assets.first;

                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipOval(
                        child: AssetEntityImage(
                          lastasset,
                          width: 58,
                          height: 58,
                          fit: BoxFit.cover,
                        ),
                      ),

                      // overlay ตอนกำลัง process
                      if (processingimage)
                        Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            color: MainConstant.black.withValues(alpha: 0.4),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: LoadingAnimationWidget.threeArchedCircle(
                              color: MainConstant.white,
                              size: 30,
                            ),
                          ),
                        ),
                    ],
                  );
                }),
          ),
        ),
      );
    });
  }
  //===>> Gallery Button <===//

  //===>> TakePicture Button <===//
  Widget buildTakePictureButton(BuildContext context, BoxConstraints constraints) {
    return Obx(() {
      double angle;
      switch (controller.rotationangle.value) {
        case 1: // หมุนซ้าย
          angle = math.pi / 2;
          break;
        case 3: // หมุนขวา
          angle = -math.pi / 2;
          break;
        case 2: // กลับหัว
          angle = math.pi;
          break;
        default: // แนวตั้ง
          angle = 0.0;
      }

      return TweenAnimationBuilder<double>(
        tween: Tween(begin: angle, end: angle),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        builder: (context, animetionangle, child) {
          return Transform.rotate(angle: animetionangle, child: child);
        },
        child: SizedBox(
          width: 65,
          height: 65,
          child: ElevatedButton(
            onPressed: () async {
              controller.takePicture();

              if (kDebugMode) {
                print('===>> [status] ถ่ายรูป');
              }
            },
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.all(5),
              backgroundColor: MainConstant.white,
            ),
            child: Icon(Icons.camera_alt, size: 40, color: MainConstant.black),
          ),
        ),
      );
    });
  }
  //===>> TakePicture Button <===//

  //===>> Setting Button <===//
  Widget buildSettingButton(BuildContext context, BoxConstraints constraints) {
    return Obx(() {
      double angle;
      switch (controller.rotationangle.value) {
        case 1: // หมุนซ้าย
          angle = math.pi / 2;
          break;
        case 3: // หมุนขวา
          angle = -math.pi / 2;
          break;
        case 2: // กลับหัว
          angle = math.pi;
          break;
        default: // แนวตั้ง
          angle = 0.0;
      }

      return TweenAnimationBuilder<double>(
        tween: Tween(begin: angle, end: angle),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        builder: (context, animetionangle, child) {
          return Transform.rotate(angle: animetionangle, child: child);
        },
        child: SizedBox(
          width: 65,
          height: 65,
          child: TextButton(
            onPressed: () {

               Get.toNamed('setting');
            },
            style: TextButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.all(5),
              backgroundColor: MainConstant.transparent,
            ),
            child: Icon(Icons.settings, size: 40, color: MainConstant.white),
          ),
        ),
      );
    });
  }

  //===>> Setting Button <===//
}
