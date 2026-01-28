import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:sakcamera_getx/component/main_dialog_component.dart';
import 'package:sakcamera_getx/component/main_form_component.dart';
import 'package:sakcamera_getx/compute/setting_reset_compute.dart';
import 'package:sakcamera_getx/constant/main_constant.dart';
import 'package:sakcamera_getx/controller/user_controller.dart';
import 'package:sakcamera_getx/database/shared_preferences/shared_preferences_database.dart';
import 'package:sakcamera_getx/state/camera/camera_controller.dart';
import 'package:sakcamera_getx/state/camera/map_controller.dart';
import 'package:sakcamera_getx/state/camera/setting_controller.dart';
import 'package:sakcamera_getx/util/main_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting extends GetWidget<SettingController> {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: MainConstant.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: MainConstant.black,
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

                SafeArea(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      controller.lastconstraints.value = constraints;

                      controller.layoutready =
                          constraints.maxWidth > 0 && constraints.maxHeight > 0;

                      if (kDebugMode) {
                        print('=== LayoutBuilder Constraints ===');
                        print('MaxWidth: ${constraints.maxWidth}');
                        print('MaxHeight: ${constraints.maxHeight}');
                      }

                      return PopScope(
                        canPop: true, // false จะแสดง pop up เราก่อน ถ้า true จะออกเลย
                        // onPopInvokedWithResult: (didPop, result) async {
                        //   final result = await MainDialog.dialogPopup(
                        //     context,
                        //     true,
                        //     'warning'.tr,
                        //     message: 'warning_close_app'.tr,
                        //     confirmbutton: 'ok'.tr,
                        //     closebutton: 'cancel'.tr,
                        //   );
                        //   if (result == true) {
                        //     SystemNavigator.pop(); // ออกจากแอปหรือปิดแอป
                        //   }
                        // },
                        child: Scaffold(
                          appBar: widgetAppBar(context),
                          backgroundColor: MainConstant.grey3,
                          body: SizedBox(
                            width: MainConstant.setWidthFull(context, constraints),
                            height: MainConstant.setHeightFull(context, constraints),
                            child: Stack(
                              children: [
                                // Positioned.fill(
                                //   child: Image.asset(MainConstant.bgsetting, fit: BoxFit.fill),
                                // ),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: MainConstant.setHeight(context, constraints, 30),
                                        bottom: MainConstant.setHeight(context, constraints, 10),
                                        left: MainConstant.setWidth(context, constraints, 10),
                                        right: MainConstant.setWidth(context, constraints, 10),
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          MainConstant.setWidth(context, constraints, 36),
                                        ),
                                        color: MainConstant.white,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: MainConstant.setWidth(context, constraints, 20),
                                        vertical: MainConstant.setHeight(context, constraints, 20),
                                      ),
                                      child: Column(
                                        children: [
                                          // Container(
                                          //   padding: EdgeInsets.symmetric(
                                          //     // horizontal: 5,
                                          //     vertical: MainConstant.setHeight(
                                          //       context,
                                          //       constraints,
                                          //       5,
                                          //     ),
                                          //   ),
                                          //   decoration: BoxDecoration(
                                          //     color: MainConstant.white,
                                          //     borderRadius: BorderRadius.circular(
                                          //       MainConstant.setWidth(context, constraints, 36),
                                          //     ),
                                          //   ),
                                          //   alignment: Alignment.center,

                                          //   child: MainUtil.mainText(
                                          //     context,
                                          //     constraints,
                                          //     text: 'แอปพลิเคชัน',

                                          //     textstyle: MainUtil.mainTextStyle(
                                          //       context,
                                          //       constraints,
                                          //       fontsize: MainConstant.h22,
                                          //       fontweight: MainConstant.boldfontweight,
                                          //       fontcolor: MainConstant.primary,
                                          //     ),
                                          //   ),
                                          // ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              vertical: MainConstant.setWidth(
                                                context,
                                                constraints,
                                                10,
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              color: MainConstant.white,
                                              borderRadius: BorderRadius.circular(
                                                MainConstant.setWidth(context, constraints, 36),
                                              ),
                                            ),

                                            child: Column(
                                              children: [
                                                Obx(() {
                                                  return Container(
                                                    margin: EdgeInsets.only(
                                                      top: MainConstant.setHeight(
                                                        context,
                                                        constraints,
                                                        10,
                                                      ),
                                                      left: MainConstant.setWidth(
                                                        context,
                                                        constraints,
                                                        20,
                                                      ),
                                                      right: MainConstant.setWidth(
                                                        context,
                                                        constraints,
                                                        20,
                                                      ),
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: MainConstant.transparent,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets.only(
                                                            right: MainConstant.setWidth(
                                                              context,
                                                              constraints,
                                                              10,
                                                            ),
                                                          ),
                                                          child: MainUtil.mainText(
                                                            context,
                                                            constraints,
                                                            text: 'switch_map'.tr,
                                                            textstyle: MainUtil.mainTextStyle(
                                                              context,
                                                              constraints,
                                                              fontsize: MainConstant.h16,
                                                              fontweight:
                                                                  MainConstant.normalfontweight,
                                                              fontcolor: MainConstant.primary,
                                                            ),
                                                          ),
                                                        ),
                                                        FlutterSwitch(
                                                          width: MainConstant.setWidth(
                                                            context,
                                                            constraints,
                                                            70,
                                                          ),
                                                          height: MainConstant.setHeight(
                                                            context,
                                                            constraints,
                                                            25,
                                                          ),
                                                          // toggleSize: 30.0,
                                                          // borderRadius: 30.0,
                                                          value: controller.switchmap.value,
                                                          showOnOff: true,
                                                          activeText: 'on'.tr,
                                                          inactiveText: 'off'.tr,
                                                          valueFontSize: MainConstant.h14,
                                                          activeColor: MainConstant.primary,
                                                          activeToggleColor: MainConstant.white,
                                                          inactiveColor: MainConstant.grey,
                                                          activeTextColor: MainConstant.white,
                                                          inactiveTextColor: MainConstant.white,
                                                          onToggle: (value) async {
                                                            if (controller.switchingmap.value) {
                                                              return;
                                                            }

                                                            controller.switchingmap.value = true;

                                                            try {
                                                              controller.switchmap.value = value;

                                                              if (kDebugMode) {
                                                                print(
                                                                  "===>> Switch is: ${value ? "ON" : "OFF"}",
                                                                );
                                                              }

                                                              final sharepreferences =
                                                                  await SharedPreferences.getInstance();
                                                              await sharepreferences.setBool(
                                                                SharedPreferencesDatabase.switchmap,
                                                                value,
                                                              ); // true = Google Map, false = Flutter Map
                                                              if (kDebugMode) {
                                                                print(
                                                                  "===>> Switch is: ${value ? "ON (Google Map)" : "OFF (Flutter Map)"}",
                                                                );
                                                              }

                                                              // เคลียร์ cache ก่อนทุกครั้งที่สลับ
                                                              final cameracontroller =
                                                                  Get.find<CameraPageController>();
                                                              cameracontroller.clearMapCache();

                                                              final mapcontroller =
                                                                  Get.find<MapController>();

                                                              mapcontroller.disposeGoogleMap();

                                                              if (!value) {
                                                                // สลับมา FlutterMap
                                                                mapcontroller.initFlutterMap();
                                                                mapcontroller
                                                                    .syncLatLngForFlutter(); // sync ตำแหน่ง
                                                              }
                                                              mapcontroller.refreshmap.value = true;
                                                              await Future.delayed(
                                                                const Duration(milliseconds: 50),
                                                              );
                                                              mapcontroller.refreshmap.value =
                                                                  false;
                                                            } finally {
                                                              controller.switchingmap.value = false;
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }),
                                                Obx(() {
                                                  return Container(
                                                    margin: EdgeInsets.only(
                                                      top: MainConstant.setHeight(
                                                        context,
                                                        constraints,
                                                        10,
                                                      ),
                                                      left: MainConstant.setWidth(
                                                        context,
                                                        constraints,
                                                        20,
                                                      ),
                                                      right: MainConstant.setWidth(
                                                        context,
                                                        constraints,
                                                        20,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          decoration: BoxDecoration(
                                                            color: MainConstant.transparent,
                                                          ),
                                                          child: MainUtil.mainText(
                                                            context,
                                                            constraints,
                                                            text: 'switch_watermark'.tr,
                                                            textstyle: MainUtil.mainTextStyle(
                                                              context,
                                                              constraints,
                                                              fontsize: MainConstant.h16,
                                                              fontweight:
                                                                  MainConstant.normalfontweight,
                                                              fontcolor: MainConstant.primary,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          decoration: BoxDecoration(
                                                            color: MainConstant.transparent,
                                                          ),
                                                          margin: EdgeInsets.only(
                                                            left: MainConstant.setWidth(
                                                              context,
                                                              constraints,
                                                              10,
                                                            ),
                                                          ),
                                                          child: FlutterSwitch(
                                                            width: MainConstant.setWidth(
                                                              context,
                                                              constraints,
                                                              70,
                                                            ),
                                                            height: MainConstant.setHeight(
                                                              context,
                                                              constraints,
                                                              25,
                                                            ),
                                                            // toggleSize: 30.0,
                                                            // borderRadius: 30.0,
                                                            value: controller.switchwatermark.value,
                                                            showOnOff: true,
                                                            activeText: 'on'.tr,
                                                            inactiveText: 'off'.tr,
                                                            valueFontSize: MainConstant.h14,
                                                            activeColor: MainConstant.primary,
                                                            activeToggleColor: MainConstant.white,
                                                            inactiveColor: MainConstant.grey,
                                                            activeTextColor: MainConstant.white,
                                                            inactiveTextColor: MainConstant.white,
                                                            onToggle: (value) async {
                                                              controller.switchwatermark.value =
                                                                  value;
                                                              if (kDebugMode) {
                                                                print(
                                                                  "===>> Switch is: ${value ? "ON" : "OFF"}",
                                                                );
                                                              }

                                                              final prefs =
                                                                  await SharedPreferences.getInstance();
                                                              await prefs.setBool(
                                                                SharedPreferencesDatabase
                                                                    .switchwatermark,
                                                                value,
                                                              ); // true = แปะลายน้ำ
                                                              final cameracontroller =
                                                                  Get.find<CameraPageController>();

                                                              if (!value) {
                                                                cameracontroller.preparewatermark =
                                                                    null; // ล้าง overlay
                                                                cameracontroller.watermarkCache =
                                                                    null; // (optional) ล้าง image cache
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }),

                                                widgetButtonCheckVersions(context, constraints),
                                                widgetButtonResetSetting(context, constraints),
                                                widgetButtonLogout(context, constraints),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                Container(
                                  width: MainConstant.setWidthFull(context, constraints),
                                  height: MainConstant.setHeight(context, constraints, 20),
                                  decoration: BoxDecoration(
                                    color: MainConstant.primary,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(
                                        MainConstant.setWidth(context, constraints, 36),
                                      ),
                                      bottomRight: Radius.circular(
                                        MainConstant.setWidth(context, constraints, 36),
                                      ),
                                    ),
                                  ),
                                ),
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

  Container widgetButtonLogout(BuildContext context, BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(top: MainConstant.setWidth(context, constraints, 10)),
      decoration: BoxDecoration(color: MainConstant.transparent),
      child: MainComponet.mainButton(
        context,
        constraints,
        margin: EdgeInsets.only(
          top: MainConstant.setHeight(context, constraints, 0),
          bottom: MainConstant.setHeight(context, constraints, 0),
        ),
        width: MainConstant.setWidth(context, constraints, 350),
        height: MainConstant.setHeight(context, constraints, 40),
        onPressed: () async {
          // ออกจากระบบไปหน้า login
          controller.submitLogout(context);
        },
        backgroundcolor: MainConstant.primary,
        foregroundcolor: MainConstant.white,

        // ===> ส่วน text ในปุ่ม <=== //
        child: MainUtil.mainText(
          context,
          constraints,
          text: 'logout'.tr,
          textstyle: MainUtil.mainTextStyle(
            context,
            constraints,
            fontsize: MainConstant.h18,
            fontweight: MainConstant.boldfontweight,
            fontcolor: MainConstant.white,
          ),
        ),
      ),
    );
  }

  Container widgetButtonResetSetting(BuildContext context, BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(top: MainConstant.setWidth(context, constraints, 10)),
      decoration: BoxDecoration(color: MainConstant.transparent),
      child: MainComponet.mainButton(
        context,
        constraints,
        margin: EdgeInsets.only(
          top: MainConstant.setHeight(context, constraints, 0),
          bottom: MainConstant.setHeight(context, constraints, 0),
        ),
        width: MainConstant.setWidth(context, constraints, 350),
        height: MainConstant.setHeight(context, constraints, 40),
        onPressed: () async {
          final confirm = await MainDialog.dialogPopup(
            context,
            true,
            'รีเซ็ตข้อมูล',
            message:
                'ระบบจะล้างข้อมูลเดิมและดึงข้อมูลใหม่จากเซิร์ฟเวอร์\nต้องการดำเนินการต่อหรือไม่',
            confirmbutton: 'ตกลง',
            closebutton: 'ยกเลิก',
          );

          if (confirm == true) {
            final usercontroller = Get.find<UserController>();

            await SettingReset.resetToDefault(
              usercontroller: usercontroller,
              settingcontroller: controller,
              huaweibrand: controller.huaweibrand.value,
              statusgms: controller.statusgms.value,
            );

            if (kDebugMode) {
              print('===>> User triggered reset & refresh');
            }

            await MainDialog.dialogPopup(
              context,
              true,
              'สำเร็จ',
              message: 'รีเซ็ตข้อมูลเรียบร้อยแล้ว',
            );
          }
        },
        backgroundcolor: MainConstant.primary,
        foregroundcolor: MainConstant.white,

        // ===> ส่วน text ในปุ่ม <=== //
        child: MainUtil.mainText(
          context,
          constraints,
          text: 'clear_setting'.tr,
          textstyle: MainUtil.mainTextStyle(
            context,
            constraints,
            fontsize: MainConstant.h18,
            fontweight: MainConstant.boldfontweight,
            fontcolor: MainConstant.white,
          ),
        ),
      ),
    );
  }

  Container widgetButtonCheckVersions(BuildContext context, BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(top: MainConstant.setWidth(context, constraints, 35)),
      decoration: BoxDecoration(color: MainConstant.transparent),
      child: MainComponet.mainButton(
        context,
        constraints,
        margin: EdgeInsets.only(
          top: MainConstant.setHeight(context, constraints, 0),
          bottom: MainConstant.setHeight(context, constraints, 0),
        ),
        width: MainConstant.setWidth(context, constraints, 350),
        height: MainConstant.setHeight(context, constraints, 40),
        onPressed: () async {
          //ไปหน้า check version
          Get.toNamed('version');
        },
        backgroundcolor: MainConstant.primary,
        foregroundcolor: MainConstant.white,

        // ===> ส่วน text ในปุ่ม <=== //
        child: MainUtil.mainText(
          context,
          constraints,
          text: 'name_version'.tr,
          textstyle: MainUtil.mainTextStyle(
            context,
            constraints,
            fontsize: MainConstant.h18,
            fontweight: MainConstant.boldfontweight,
            fontcolor: MainConstant.white,
          ),
        ),
      ),
    );
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
                  onPressed: () => Navigator.pop(context),
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
                    'setting'.tr,
                    style: TextStyle(
                      fontSize: MainConstant.h18,
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
}
