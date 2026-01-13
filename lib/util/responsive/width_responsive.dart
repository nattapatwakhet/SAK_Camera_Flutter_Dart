// ignore_for_file: file_names
import 'package:flutter/material.dart';

class ResponsiveWidth extends StatelessWidget {
  final Widget screen320;
  final Widget screen344;
  final Widget screen375;
  final Widget screen390;
  final Widget screen411;
  final Widget screen448;
  final Widget screen480;
  final Widget screen540;
  final Widget screen853;
  final Widget screen1024;
  final Widget screen1152;
  final Widget screen1440;
  final Widget screen1920;
  final Widget screen3840;

  const ResponsiveWidth({
    super.key,
    required this.screen320,
    required this.screen344,
    required this.screen375,
    required this.screen390,
    required this.screen411,
    required this.screen448,
    required this.screen480,
    required this.screen540,
    required this.screen853,
    required this.screen1024,
    required this.screen1152,
    required this.screen1440,
    required this.screen1920,
    required this.screen3840,
  });

  // 320
  // 344
  // 360
  // 375
  // 390
  // 411
  // 412
  // 414
  // 428
  // 430
  // 448
  // 480
  // 540
  // 640
  // 853
  // 820
  // 800
  // 912
  // 960
  // 1024
  // 1080
  // 1152
  // 1280
  // 1366
  // 1400
  // 1440
  // 1600
  // 1680
  // 1856
  // 1920
  // 2048
  // 2560
  // 3840

  static bool isMobileSmallVery(BuildContext context, BoxConstraints? constraints) =>
      isScreen320(context, constraints);
  static bool isMobileSmall(BuildContext context, BoxConstraints? constraints) =>
      isScreen344(context, constraints) || isScreen375(context, constraints);
  static bool isMobile(BuildContext context, BoxConstraints? constraints) =>
      isScreen390(context, constraints) || isScreen411(context, constraints);
  static bool isMobileBig(BuildContext context, BoxConstraints? constraints) =>
      isScreen448(context, constraints);
  static bool isMobileBigVery(BuildContext context, BoxConstraints? constraints) =>
      isScreen480(context, constraints);
  static bool isTabletSmall(BuildContext context, BoxConstraints? constraints) =>
      isScreen540(context, constraints);
  static bool isTablet(BuildContext context, BoxConstraints? constraints) =>
      isScreen853(context, constraints);
  static bool isTabletBig(BuildContext context, BoxConstraints? constraints) =>
      isScreen1024(context, constraints);
  static bool isDesktopSmall(BuildContext context, BoxConstraints? constraints) =>
      isScreen1152(context, constraints);
  static bool isDesktop(BuildContext context, BoxConstraints? constraints) =>
      isScreen1440(context, constraints) || isScreen1920(context, constraints);
  static bool isDesktopBig(BuildContext context, BoxConstraints? constraints) =>
      isScreen3840(context, constraints);

  static bool isScreen320(BuildContext context, BoxConstraints? constraints) {
    final width = constraints?.maxWidth ?? MediaQuery.of(context).size.width;
    return width <= 320;
  }

  static bool isScreen344(BuildContext context, BoxConstraints? constraints) {
    final width = constraints?.maxWidth ?? MediaQuery.of(context).size.width;
    return width > 320 && width <= 344;
  }

  static bool isScreen375(BuildContext context, BoxConstraints? constraints) {
    final width = constraints?.maxWidth ?? MediaQuery.of(context).size.width;
    return width > 344 && width <= 375;
  }

  static bool isScreen390(BuildContext context, BoxConstraints? constraints) {
    final width = constraints?.maxWidth ?? MediaQuery.of(context).size.width;
    return width > 375 && width <= 390;
  }

  static bool isScreen411(BuildContext context, BoxConstraints? constraints) {
    final width = constraints?.maxWidth ?? MediaQuery.of(context).size.width;
    return width > 390 && width <= 414;
  }

  static bool isScreen448(BuildContext context, BoxConstraints? constraints) {
    final width = constraints?.maxWidth ?? MediaQuery.of(context).size.width;
    return width > 414 && width <= 448;
  }

  static bool isScreen480(BuildContext context, BoxConstraints? constraints) {
    final width = constraints?.maxWidth ?? MediaQuery.of(context).size.width;
    return width > 448 && width <= 480;
  }

  static bool isScreen540(BuildContext context, BoxConstraints? constraints) {
    final width = constraints?.maxWidth ?? MediaQuery.of(context).size.width;
    return width > 480 && width <= 540;
  }

  static bool isScreen853(BuildContext context, BoxConstraints? constraints) {
    final width = constraints?.maxWidth ?? MediaQuery.of(context).size.width;
    return width > 540 && width <= 853;
  }

  static bool isScreen1024(BuildContext context, BoxConstraints? constraints) {
    final width = constraints?.maxWidth ?? MediaQuery.of(context).size.width;
    return width > 853 && width <= 1024;
  }

  static bool isScreen1152(BuildContext context, BoxConstraints? constraints) {
    final width = constraints?.maxWidth ?? MediaQuery.of(context).size.width;
    return width > 1024 && width <= 1152;
  }

  static bool isScreen1440(BuildContext context, BoxConstraints? constraints) {
    final width = constraints?.maxWidth ?? MediaQuery.of(context).size.width;
    return width > 1152 && width <= 1440;
  }

  static bool isScreen1920(BuildContext context, BoxConstraints? constraints) {
    final width = constraints?.maxWidth ?? MediaQuery.of(context).size.width;
    return width > 1440 && width <= 1920;
  }

  static bool isScreen3840(BuildContext context, BoxConstraints? constraints) {
    final width = constraints?.maxWidth ?? MediaQuery.of(context).size.width;
    return width > 1920 && width <= 3840;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (isScreen320(context, constraints)) {
          return screen320;
        } else if (isScreen344(context, constraints)) {
          return screen344;
        } else if (isScreen375(context, constraints)) {
          return screen375;
        } else if (isScreen390(context, constraints)) {
          return screen390;
        } else if (isScreen411(context, constraints)) {
          return screen411;
        } else if (isScreen448(context, constraints)) {
          return screen448;
        } else if (isScreen480(context, constraints)) {
          return screen480;
        } else if (isScreen540(context, constraints)) {
          return screen540;
        } else if (isScreen853(context, constraints)) {
          return screen853;
        } else if (isScreen1024(context, constraints)) {
          return screen1024;
        } else if (isScreen1152(context, constraints)) {
          return screen1152;
        } else if (isScreen1440(context, constraints)) {
          return screen1440;
        } else if (isScreen1920(context, constraints)) {
          return screen1920;
        } else if (isScreen3840(context, constraints)) {
          return screen3840;
        } else {
          return screen3840;
        }
      },
    );
  }
}
