import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MainFlushbar {
  static Flushbar<dynamic>? activeflushbar; //ต้องมีตัวแปรนี้ในคลาส

  static Future<dynamic> showFlushbar(
    BuildContext context, {
    required String title,
    required String message,
    required Color color,
    required Color textColor,
    required IconData icon,
  }) async {
    try {
      //ตรวจสอบว่ามี Flushbar ตัวเก่ากำลังแสดงอยู่หรือไม่
      if (activeflushbar != null) {
        bool? showingnow = activeflushbar!.isShowing();

        // ถ้ามันกำลังแสดงอยู่ ให้รอจนกว่าจะปิดก่อน
        if (showingnow == true) {
          await activeflushbar!.dismiss();
        }
      }

      activeflushbar = Flushbar(
        title: title,
        titleColor: textColor,
        message: message,
        messageColor: textColor,
        duration: const Duration(seconds: 3),
        backgroundColor: color,
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(10),
        flushbarPosition: FlushbarPosition.TOP,
        animationDuration: const Duration(milliseconds: 400),
        icon: Icon(icon, color: textColor),
      );

      //คืนค่ากลับ Future เพื่อให้รอ Flushbar.show เสร็จ
      if (context.mounted) {
        return await activeflushbar!.show(context);
      }
    } catch (error) {
      if (kDebugMode) print('===>>error Flushbar show/dismiss error: $error');
    }
  }
}
