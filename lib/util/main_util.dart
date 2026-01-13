
import 'package:flutter/material.dart';
import 'package:sakcamera_getx/constant/main_constant.dart';
import 'package:url_launcher/url_launcher.dart';


class MainUtil {
  // route
  // static Map<String, WidgetBuilder> map = {
  //   '/privacy': (BuildContext context) => Privacy(),
  //   '/home': (BuildContext context) => Home(),
  // };

  //ไปหน้า store
  static Future<bool> canLaunchURL(String url) async {
    return await canLaunchUrl(Uri.parse(url));
    // return false;
  }

  //ของเก่า
  static TextStyle mainTextStyle(
    BuildContext context,
    BoxConstraints? constraints, {
    Color? fontcolor,
    String? fontfamily,
    double? fontsize,
    FontWeight? fontweight,
    List<Shadow>? shadows,
  }) => TextStyle(
    color: fontcolor ?? MainConstant.white,
    fontFamily: fontfamily ?? MainConstant.sukhumvit,
    fontWeight: fontweight ?? MainConstant.normalfontweight,
    fontSize: fontsize ?? MainConstant.h14,
    shadows: shadows,
  );

  static Text mainText(
    BuildContext context,
    BoxConstraints? constraints, {
    String? text,
    TextSpan? textSpan,
    TextStyle? textstyle,
    TextOverflow? overflow = TextOverflow.ellipsis,
    bool softwrap = false,
  }) {
    if (textSpan != null) {
      return Text.rich(textSpan, overflow: overflow, softWrap: softwrap);
    } else {
      return Text(text ?? '', style: textstyle, overflow: overflow, softWrap: softwrap);
    }
  }

  static Future launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'ไม่สามารถเปิดลิงก์ได้: $url';
    }
  }
}
