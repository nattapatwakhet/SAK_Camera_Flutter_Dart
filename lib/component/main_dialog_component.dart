import 'package:get/get.dart';
import 'package:animations/animations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sakcamera_getx/constant/main_constant.dart';
import 'package:sakcamera_getx/util/main_util.dart';

class MainDialog {
  // ฟังก์ชันหลักสำหรับแสดง Dialog
  static Future<dynamic> dialogPopup(
    BuildContext context,
    bool admin,
    String title, {
    Color? colorbackgroundtitle,
    Color? colortext,
    String? message,
    Color? colormessage,
    dynamic data,
    String confirmbutton = 'ตกลง',
    Color? colorconfirmbutton,
    dynamic valueconfirmbutton = true,
    String? closebutton,
    Color? colorclosebutton,
    dynamic valueclosebutton = false,
    bool outback = true,
    bool back = true,
    bool statusload = false,
    List? otherbutton,
    Widget? image,
    double? heightimage,
  }) async {
    try {
      bool statusallowbutton = true;

      // ฟังก์ชันปิด popup
      void onReturn(BuildContext context, bool bool1, dynamic dynamic1) {
        try {
          if (bool1 && statusallowbutton) {
            statusallowbutton = false;
            Future.delayed(const Duration(milliseconds: 200), () {
              if (Get.isDialogOpen == true) {
                Get.back(result: dynamic1 ?? false);
              }
            });
          }
        } catch (error) {
          if (kDebugMode) {
            print('error ===>> MainDialog onReturn: $error');
          }
        }
      }

      Future<bool> onWillPop() async => back;

      Widget widgetButtonDialog(BuildContext context, dynamic value, String text, {Color? color}) {
        return ElevatedButton(
          onPressed: () => onReturn(context, true, value),
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? MainConstant.primary,
            foregroundColor: MainConstant.white,
            elevation: 10,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          ),
          child: Text(text),
        );
      }

      // ปิด popup เก่าก่อนถ้ามี (ป้องกันซ้อน)
      if (Get.isDialogOpen == true) {
        Get.back();
        await Future.delayed(const Duration(milliseconds: 150));
      }

      // ใช้ Get.dialog + FadeScaleTransition
      dynamic dynamic1 = await Get.dialog(
        PageTransitionSwitcher(
          duration: const Duration(milliseconds: 300),
          reverse: false,
          transitionBuilder: (child, animation, secondaryAnimation) {
            return FadeScaleTransition(animation: animation, child: child);
          },
          child: PopScope(
            canPop: back, // ใช้แทน onWillPop
            onPopInvokedWithResult: (didPop, result) async {
              if (!didPop) {
                // เมื่อผู้ใช้พยายามย้อนกลับแต่ระบบยังไม่ pop
                final result = await onWillPop();
                if (result == false) return;
                Get.back(); //
              }
            },
            child: Scaffold(
              backgroundColor: MainConstant.transparent,
              body: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Dialog(
                        insetPadding: const EdgeInsets.all(5),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Container(
                              constraints: BoxConstraints(
                                minHeight:
                                    (MainConstant.setHeight(context, constraints, 150)).isFinite
                                    ? MainConstant.setHeight(context, constraints, 150)
                                    : 150,
                                maxWidth:
                                    (MainConstant.setWidth(context, constraints, 375)).isFinite
                                    ? MainConstant.setWidth(context, constraints, 375)
                                    : 375,
                                minWidth:
                                    (MainConstant.setWidth(context, constraints, 200)).isFinite
                                    ? MainConstant.setWidth(context, constraints, 200)
                                    : 200,
                              ),

                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // ===>> ส่วนหัวข้อ <<===
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: colorbackgroundtitle ?? MainConstant.primary,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                      ),
                                    ),
                                    child: Text(
                                      title,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: MainConstant.boldfontweight,
                                        fontSize: MainConstant.h16,
                                        color: colortext ?? MainConstant.white,
                                      ),
                                    ),
                                  ),
                                  // ===>> ส่วนรูปภาพ <<===
                                  Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    child: Column(
                                      children: [
                                        if (image != null)
                                          SizedBox(height: heightimage ?? 150, child: image),
                                      ],
                                    ),
                                  ),
                                  // ===>> ส่วนข้อความและปุ่ม <<===
                                  Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 5,
                                      horizontal: 15,
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        // Loading Animation
                                        if (statusload)
                                          Container(
                                            margin: const EdgeInsets.only(bottom: 40),
                                            child: LoadingAnimationWidget.discreteCircle(
                                              color: MainConstant.primary,
                                              secondRingColor: MainConstant.orange,
                                              thirdRingColor: MainConstant.yellow3,
                                              size: 40,
                                            ),
                                          ),
                                        // ข้อความ
                                        if (message != null)
                                          Container(
                                            margin: const EdgeInsets.only(bottom: 25),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  constraints: BoxConstraints(
                                                    maxWidth: MainConstant.setWidth(
                                                      context,
                                                      constraints,
                                                      250,
                                                    ),
                                                  ),
                                                  child: MainUtil.mainText(
                                                    context,
                                                    constraints,
                                                    text: message,
                                                    textstyle: TextStyle(
                                                      fontSize: MainConstant.h16,
                                                      color: colormessage ?? MainConstant.black,
                                                    ),
                                                    overflow: null,
                                                    softwrap: true,
                                                  ),
                                                ),
                                                if (statusload)
                                                  Container(
                                                    margin: const EdgeInsets.only(left: 5),
                                                    child: LoadingAnimationWidget.staggeredDotsWave(
                                                      color: MainConstant.primary,
                                                      size: 16,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        // ปุ่ม
                                        if (!statusload)
                                          Container(
                                            margin: const EdgeInsets.only(bottom: 5),
                                            child: StreamBuilder(
                                              stream: statusallowbutton
                                                  ? Stream.periodic(
                                                      const Duration(milliseconds: 250),
                                                    )
                                                  : null,
                                              builder: (context, snapshot) {
                                                return Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    if (closebutton != null)
                                                      widgetButtonDialog(
                                                        context,
                                                        valueclosebutton,
                                                        closebutton,
                                                        color: statusallowbutton
                                                            ? (colorclosebutton ?? MainConstant.red)
                                                            : MainConstant.grey,
                                                      ),
                                                    if (otherbutton != null)
                                                      ...otherbutton.asMap().entries.map((entry) {
                                                        final Map<dynamic, dynamic> data =
                                                            entry.value as Map;
                                                        return widgetButtonDialog(
                                                          context,
                                                          data['value'] ?? valueclosebutton,
                                                          data['title'] ?? '',
                                                          color: data['color'],
                                                        );
                                                      }),
                                                    Container(
                                                      margin: const EdgeInsets.only(left: 20),
                                                      child: widgetButtonDialog(
                                                        context,
                                                        valueconfirmbutton,
                                                        confirmbutton,
                                                        color:
                                                            colorconfirmbutton ??
                                                            MainConstant.primary,
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        barrierDismissible: outback,
        barrierColor: Colors.black.withValues(alpha: 0.5),
      );

      return dynamic1;
    } catch (error) {
      if (admin) {
        if (kDebugMode) {
          print('error ===>> MainDialog dialog: $error');
        }
      }
      return null;
    }
  }

  //component set ค่า
  Future<dynamic> dialogPopupError(
    BuildContext context,
    BoxConstraints constraints,
    bool admin,
  ) async {
    try {
      return await dialogPopup(context, admin, MainConstant.errortitle);
    } catch (error) {
      if (admin) {
        if (kDebugMode) {
          print('error ===>> MainDialog dialogPopupError: $error');
        }
      }
      return null;
    }
  }

  // แสดง dialog สำหรับอัปเดตเวอร์ชันแอป (บังคับ)
  Future<dynamic> updateVersionDialog(
    BuildContext context,
    String title,
    String currentVersion,
    String newVersion,
  ) async {
    await dialogPopup(
      context,
      true,
      title,
      message: "$currentVersion\n$newVersion",
      confirmbutton: "อัปเดต",
      valueconfirmbutton: true,
      outback: false,
      back: false,
    );
  }

  // แสดง dialog ยืนยันการอัปเดตเวอร์ชัน
  Future<dynamic> confirmupdateVersionDialog(
    BuildContext context,
    String title,
    String currentVersion,
    String newVersion,
  ) async {
    return await dialogPopup(
      context,
      false,
      title,
      message: "$currentVersion\n$newVersion",
      confirmbutton: "อัปเดต",
      valueconfirmbutton: true,
      closebutton: "ภายหลัง",
      valueclosebutton: false,
      outback: true,
    );
  }
}
