// ignore_for_file: file_names
import 'package:flutter/material.dart';

class ResponsiveHeight extends StatelessWidget {
  final Widget screen480;
  final Widget screen576;
  final Widget screen667;
  final Widget screen771;
  final Widget screen780;
  final Widget screen800;
  final Widget screen852;
  final Widget screen900;
  final Widget screen932;
  final Widget screen1050;
  final Widget screen1200;
  final Widget screen1440;
  final Widget screen1600;
  final Widget screen2160;

  const ResponsiveHeight({
    super.key,
    required this.screen480,
    required this.screen576,
    required this.screen667,
    required this.screen771,
    required this.screen780,
    required this.screen800,
    required this.screen852,
    required this.screen900,
    required this.screen932,
    required this.screen1050,
    required this.screen1200,
    required this.screen1440,
    required this.screen1600,
    required this.screen2160,
  });

  // 480
  // 568
  // 576
  // 600
  // 648
  // 667
  // 720
  // 736
  // 768
  // 771
  // 770
  // 780
  // 792
  // 800
  // 812
  // 844
  // 852
  // 880
  // 896
  // 900
  // 924
  // 926
  // 932
  // 960
  // 1050
  // 1080
  // 1200
  // 1392
  // 1440
  // 1536
  // 1600
  // 2160

  static bool isMobileSmallVery(BuildContext context, BoxConstraints? constraints) =>
      isScreen480(context, constraints);
  static bool isMobileSmall(BuildContext context, BoxConstraints? constraints) =>
      isScreen576(context, constraints) || isScreen667(context, constraints);
  static bool isMobile(BuildContext context, BoxConstraints? constraints) =>
      isScreen771(context, constraints) ||
      isScreen780(context, constraints) ||
      isScreen800(context, constraints) ||
      isScreen852(context, constraints);
  static bool isMobileBig(BuildContext context, BoxConstraints? constraints) =>
      isScreen900(context, constraints);
  static bool isMobileBigVery(BuildContext context, BoxConstraints? constraints) =>
      isScreen932(context, constraints);
  static bool isTabletSmall(BuildContext context, BoxConstraints? constraints) =>
      isScreen1050(context, constraints);
  static bool isTablet(BuildContext context, BoxConstraints? constraints) =>
      isScreen1200(context, constraints);
  static bool isTabletBig(BuildContext context, BoxConstraints? constraints) =>
      isScreen1440(context, constraints);
  static bool isDesktopSmall(BuildContext context, BoxConstraints? constraints) =>
      isScreen1600(context, constraints);
  static bool isDesktop(BuildContext context, BoxConstraints? constraints) =>
      isScreen1440(context, constraints) || isScreen2160(context, constraints);
  static bool isDesktopBig(BuildContext context, BoxConstraints? constraints) =>
      isScreen2160(context, constraints);

  static bool isScreen480(BuildContext context, BoxConstraints? constraints) =>
      constraints == null
          ? MediaQuery.of(context).size.height <= 480
          : constraints.maxHeight <= 480;
  static bool isScreen576(BuildContext context, BoxConstraints? constraints) =>
      constraints == null
          ? MediaQuery.of(context).size.height > 480 && MediaQuery.of(context).size.height <= 576
          : constraints.maxHeight > 480 && constraints.maxHeight <= 576;

  static bool isScreen667(BuildContext context, BoxConstraints? constraints) =>
      constraints == null
          ? MediaQuery.of(context).size.height > 576 && MediaQuery.of(context).size.height <= 667
          : constraints.maxHeight > 576 && constraints.maxHeight <= 667;

  static bool isScreen771(BuildContext context, BoxConstraints? constraints) =>
      constraints == null
          ? MediaQuery.of(context).size.height > 667 && MediaQuery.of(context).size.height <= 771
          : constraints.maxHeight > 667 && constraints.maxHeight <= 771;

  static bool isScreen780(BuildContext context, BoxConstraints? constraints) =>
      constraints == null
          ? MediaQuery.of(context).size.height > 771 && MediaQuery.of(context).size.height <= 780
          : constraints.maxHeight > 771 && constraints.maxHeight <= 780;

  static bool isScreen800(BuildContext context, BoxConstraints? constraints) =>
      constraints == null
          ? MediaQuery.of(context).size.height > 780 && MediaQuery.of(context).size.height <= 800
          : constraints.maxHeight > 780 && constraints.maxHeight <= 800;

  static bool isScreen852(BuildContext context, BoxConstraints? constraints) =>
      constraints == null
          ? MediaQuery.of(context).size.height > 800 && MediaQuery.of(context).size.height <= 852
          : constraints.maxHeight > 800 && constraints.maxHeight <= 852;

  static bool isScreen900(BuildContext context, BoxConstraints? constraints) =>
      constraints == null
          ? MediaQuery.of(context).size.height > 852 && MediaQuery.of(context).size.height <= 900
          : constraints.maxHeight > 852 && constraints.maxHeight <= 900;

  static bool isScreen932(BuildContext context, BoxConstraints? constraints) =>
      constraints == null
          ? MediaQuery.of(context).size.height > 900 && MediaQuery.of(context).size.height <= 932
          : constraints.maxHeight > 900 && constraints.maxHeight <= 932;

  static bool isScreen1050(BuildContext context, BoxConstraints? constraints) =>
      constraints == null
          ? MediaQuery.of(context).size.height > 932 && MediaQuery.of(context).size.height <= 1050
          : constraints.maxHeight > 932 && constraints.maxHeight <= 1050;

  static bool isScreen1200(BuildContext context, BoxConstraints? constraints) =>
      constraints == null
          ? MediaQuery.of(context).size.height > 1050 && MediaQuery.of(context).size.height <= 1200
          : constraints.maxHeight > 1050 && constraints.maxHeight <= 1200;

  static bool isScreen1440(BuildContext context, BoxConstraints? constraints) =>
      constraints == null
          ? MediaQuery.of(context).size.height > 1200 && MediaQuery.of(context).size.height <= 1440
          : constraints.maxHeight > 1200 && constraints.maxHeight <= 1440;

  static bool isScreen1600(BuildContext context, BoxConstraints? constraints) =>
      constraints == null
          ? MediaQuery.of(context).size.height > 1440 && MediaQuery.of(context).size.height <= 1600
          : constraints.maxHeight > 1440 && constraints.maxHeight <= 1600;

  static bool isScreen2160(BuildContext context, BoxConstraints? constraints) =>
      constraints == null
          ? MediaQuery.of(context).size.height > 1600 && MediaQuery.of(context).size.height <= 2160
          : constraints.maxHeight > 1600 && constraints.maxHeight <= 2160;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (isScreen480(context, constraints)) {
          return screen480;
        } else if (isScreen576(context, constraints)) {
          return screen576;
        } else if (isScreen667(context, constraints)) {
          return screen667;
        } else if (isScreen771(context, constraints)) {
          return screen771;
        } else if (isScreen780(context, constraints)) {
          return screen780;
        } else if (isScreen800(context, constraints)) {
          return screen800;
        } else if (isScreen852(context, constraints)) {
          return screen852;
        } else if (isScreen900(context, constraints)) {
          return screen900;
        } else if (isScreen932(context, constraints)) {
          return screen932;
        } else if (isScreen1050(context, constraints)) {
          return screen1050;
        } else if (isScreen1200(context, constraints)) {
          return screen1200;
        } else if (isScreen1440(context, constraints)) {
          return screen1440;
        } else if (isScreen1600(context, constraints)) {
          return screen1600;
        } else if (isScreen2160(context, constraints)) {
          return screen2160;
        } else {
          return screen2160;
        }
      },
    );
  }
}
