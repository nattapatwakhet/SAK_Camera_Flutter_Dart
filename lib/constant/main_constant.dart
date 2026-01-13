import 'package:flutter/material.dart';
import 'package:sakcamera_getx/util/responsive/height_responsive.dart';
import 'package:sakcamera_getx/util/responsive/width_responsive.dart';

class MainConstant {
  // app
  static DateTime datetime = DateTime.now();
  static String nameapp = 'SAK Camera';
  static String version = '2.0.0';
  static String nameversion = '20';
  static String nameapplestore = 'com.saksiamleasing.sakcamera';
  static String nameplaystorepackage = 'com.saksiamleasing.sakcamera';
  static String namewebpackage = 'com.saksiamleasing.sakcamera';
  static String nameappstore = 'sak-camera';
  static String appleid = '6745921708';
  static String huaweiid = 'C114211697';
  static String namesystem = 'ระบบบริหารจัดการภายในองค์กร';
  static String namecompany = 'บริษัท ศักดิ์สยามลิสซิ่ง จำกัด (มหาชน)';
  static int databaseversion = 1;
  static String databasename = 'SAKCAMERA.db';
  static String idpersonnel = '999999';
  static String keysakcamera = '246992cd733ad20fcac4f5999d58d977';

  static String urlplaystore =
      'https://play.google.com/store/apps/details?id=$nameplaystorepackage';
  static String urlappstore = 'https://apps.apple.com/th/app/$nameappstore/$appleid';
  static String urlhuawei = 'https://appgallery.huawei.com/app/$huaweiid';
  //admin
  static bool admin = false;

  // key
  // map
  static String allgoogleapikey = '';
  static String androidgoogleapikey = '';
  static String iosgoogleapikey = '';
  static String mapandroidgoogleapikey = '';
  static String mapiosgoogleapikey = '';
  // firebase
  static String messagingcloudfirebaseapikey = '';
  // chatgpt
  // static String openaichatgptapikey =
  //     '';
  // line
  // static String devlinekey = '';

  // server
  // app
  static String hoot = 'apimb.sakerp.org';
  static String hoottest = 'test01.sakerp.org'; //ตัวทดสอบ
  static String cookie = 'ci_session=dndk8sp9arvc4eglcrdsrssb1i4r8123';
  static String contentype = 'application/json';
  static String keyapi = 'ab13a9850982d247fe65d61fda0f6159';
  static var headers = {
    'x-api-key': keyapi,
    'Content-Type': contentype,
    'Cookie': cookie,
    'User-Agent': 'Mobile', //
  };

  // api
  //
  static String apipostresetpassword = 'https://$hoot/api/login/newpassword'; //
  static String apigetlogin = 'https://$hoot/api/login'; //
  //
  static String apigetuser = 'https://$hoot/api/login/detailsper'; //
  // flutter
  static String hootflutter = 'https://api.pub.dev/';
  // line
  // static String hootlinenotification = 'https://notify-api.line.me/api/notify';
  //policy web
  static String webpolicy = 'https://saksiam.com/privacy-policy-sakcamera';
  // version
  static String apigetversionserver = 'https://$hoot/api/sakcamera/appversion';
  // apple
  static String apigetversionapple = 'itunes.apple.com/lookup';
  // route
  static String routecamera = '/camera'; //
  static String routelogin = '/login'; //
  static String routereset = '/resetpassword'; //

  // คำ error
  static String errortitle = 'ส่งข้อมูลไม่สำเร็จ';

  // color
  static Color primary = const Color(0xFF243865);
  static Color primary1 = const Color(0xff3761AB);
  static Color primary2 = const Color(0xFF243865);
  static Color primary3 = const Color(0xD316479E);
  static Color primarylow = const Color.fromARGB(187, 22, 72, 158);
  static Color primarylow1 = const Color.fromARGB(133, 22, 72, 158);
  static Color backgroundcolor = const Color(0xFF000000);
  static Color black = const Color(0xFF000000);

  //
  static Color red = const Color(0xFFF44336);
  static Color green = const Color.fromARGB(255, 9, 255, 58);
  static Color greenn = Colors.green;
  static Color green1 = const Color(0xFF6AC047);
  static Color green2 = const Color(0xFF327E14);
  static Color green3 = const Color(0xFF6AC047);
  static Color green4 = const Color.fromRGBO(146, 218, 118, 1);
  static Color green5 = const Color(0xFF70e000);
  static Color green6 = const Color.fromARGB(255, 179, 252, 42);
  static Color green7 = const Color(0xFF9ef01a);
  static Color green8 = const Color(0xFF9ef01a);
  static Color greenlight = Colors.green;
  static Color greenlow = const Color.fromARGB(59, 45, 224, 125);
  static Color green9 = const Color.fromARGB(46, 0, 255, 26);
  static Color blue = const Color.fromARGB(255, 6, 68, 214);
  static Color bluegrey = const Color.fromARGB(255, 110, 174, 206);
  static Color bluegrey1 = const Color(0xfff5f5fd);
  static Color bluegrey2 = const Color.fromARGB(255, 232, 232, 255);
  static Color bluegrey3 = Colors.blueGrey.shade200;
  static Color bluegrey4 = Colors.blueGrey.shade700;
  static Color bulelight2 = const Color.fromARGB(60, 172, 241, 241);
  static Color bulelightlow = const Color.fromARGB(141, 159, 178, 222);
  static Color bulelightlow1 = const Color.fromARGB(194, 125, 162, 249);
  static Color bulelightlow2 = const Color.fromARGB(227, 201, 211, 236);
  static Color bulelightlow3 = const Color.fromARGB(249, 201, 211, 236);
  static Color bulelightlow3_1 = const Color.fromARGB(239, 201, 211, 236);
  static Color bule1 = const Color(0xFF174378);
  static Color white = const Color(0xF8FFFFFF);
  static Color grey = const Color(0xFF9E9E9E);
  static Color grey1 = Colors.grey.shade100;
  static Color grey2 = Colors.grey;
  static Color grey3 = const Color.fromARGB(255, 222, 219, 219);
  static Color grey4 = const Color(0x0ff32222);
  static Color grey5 = const Color(0xD18F8D8D);
  static Color grey6 = const Color(0xD1595757);
  static Color grey7 = const Color(0xffF4F4F4);
  static Color grey8 = const Color(0x978F8D8D);
  static Color grey9 = const Color(0xD17C7C7E);
  static Color grey10 = const Color(0xFF797878);
  static Color grey11 = const Color(0x6B64656A);
  static Color grey12 = const Color(0x9E504F51);
  static Color grey13 = const Color(0xFF4C4C4C);
  static Color grey14 = const Color(0xFFF3F3F3);
  static Color grey15 = const Color(0x89243865);
  static Color grey16 = const Color(0x0F595959);
  static Color grey17 = const Color(0xFF727272);
  static Color grey18 = const Color(0x26595959);
  static Color grey19 = const Color.fromARGB(209, 178, 175, 175);
  static Color grey20 = const Color.fromARGB(255, 143, 141, 141);
  static Color grey21 = const Color(0xFFECE9E9);
  static Color grey22 = const Color(0xFF7D7D7D);
  static Color grey23 = const Color(0x7AD9D9D9);
  static Color grey24 = const Color(0xffF0F0F0);
  static Color grey25 = const Color.fromARGB(255, 249, 249, 249);
  static Color grey26 = const Color(0xFF4B5B7B);
  static Color orange = const Color(0xFFFFA500);
  static Color yellow = const Color.fromARGB(255, 255, 247, 17);
  static Color yellow1 = const Color.fromARGB(255, 255, 219, 59).withValues(alpha: 0.3);
  static Color yellow2 = const Color(0x9EFFC600);
  static Color yellow3 = const Color(0xFFFFD008);
  static Color transparent = const Color(0x00000000);

  // image
  static String marker = 'assets/images/sakmarker_small.png';
  static String saklogo = 'assets/logo/saklogo.png';
  static String saklogowhite = 'assets/logo/logo-sak-white.png';
  static String graphup = 'assets/images/graph_up.png';
  static String graphup2 = 'assets/images/graph_up2.png';
  static String backgroundmap = 'assets/images/map_world.png';
  static String backgroundmap2 = 'assets/images/map_world2.png';
  static String unlock = 'assets/images/un_lock.png';
  static String card = 'assets/images/card.png';
  static String back = 'assets/images/back.png';
  static String buildingbottom = 'assets/images/person-warning.png';
  static String saklogo2 = 'assets/icons/sakcamera_icon_app.png';
   static String sakcamerasplash = 'assets/images/sakcamera-splash-full.png';

  // fonts
  static String sukhumvit = 'Sukhumvit';

  // font Weight
  static FontWeight boldfontweight = FontWeight.bold;
  static FontWeight normalfontweight = FontWeight.normal;

  //font Size
  static double h24 = 24;
  static double h22 = 22;
  static double h20 = 20;
  static double h18 = 18;
  static double h16 = 16;
  static double h14 = 14;
  static double h13 = 13;
  static double h12 = 12;
  static double h10 = 10;

  //responsive Width
  static double checkResponsive(double setint, dynamic dynamic1, int flexlow) {
    return ((setint / dynamic1) * dynamic1) - ((((setint * flexlow) / 100) / dynamic1) * dynamic1);
    // return setint - ((setint * flexlow) / 100);
  }

  static double checkResponsiveDefault(double setint, dynamic dynamic1) {
    return (((setint) / dynamic1) * dynamic1);
    // return setint;
  }

  static double setWidthFull(BuildContext context, BoxConstraints? constraints) =>
      constraints == null ? MediaQuery.of(context).size.width : constraints.maxWidth;

  static double setWidth(BuildContext context, BoxConstraints? constraints, double setint) {
    if (ResponsiveWidth.isScreen320(context, constraints)) {
      return constraints == null
          ? checkResponsive(setint, MediaQuery.of(context).size.width, 40)
          : checkResponsive(setint, constraints.maxWidth, 40);
    } else if (ResponsiveWidth.isScreen344(context, constraints)) {
      return constraints == null
          ? checkResponsive(setint, MediaQuery.of(context).size.width, 32)
          : checkResponsive(setint, constraints.maxWidth, 32);
    } else if (ResponsiveWidth.isScreen375(context, constraints)) {
      return constraints == null
          ? checkResponsive(setint, MediaQuery.of(context).size.width, 24)
          : checkResponsive(setint, constraints.maxWidth, 24);
    } else if (ResponsiveWidth.isScreen390(context, constraints)) {
      return constraints == null
          ? checkResponsive(setint, MediaQuery.of(context).size.width, 16)
          : checkResponsive(setint, constraints.maxWidth, 16);
    } else if (ResponsiveWidth.isScreen411(context, constraints)) {
      return constraints == null
          ? checkResponsive(setint, MediaQuery.of(context).size.width, 8)
          : checkResponsive(setint, constraints.maxWidth, 8);
    } else if (ResponsiveWidth.isScreen448(context, constraints)) {
      return constraints == null
          ? checkResponsiveDefault(setint, MediaQuery.of(context).size.width)
          : checkResponsiveDefault(setint, constraints.maxWidth);
    } else if (ResponsiveWidth.isScreen480(context, constraints)) {
      return constraints == null
          ? checkResponsiveDefault(setint, MediaQuery.of(context).size.width)
          : checkResponsiveDefault(setint, constraints.maxWidth);
    } else if (ResponsiveWidth.isScreen540(context, constraints)) {
      return constraints == null
          ? checkResponsiveDefault(setint, MediaQuery.of(context).size.width)
          : checkResponsiveDefault(setint, constraints.maxWidth);
    } else if (ResponsiveWidth.isScreen853(context, constraints)) {
      return constraints == null
          ? checkResponsiveDefault(setint, MediaQuery.of(context).size.width)
          : checkResponsiveDefault(setint, constraints.maxWidth);
    } else if (ResponsiveWidth.isScreen1024(context, constraints)) {
      return constraints == null
          ? checkResponsiveDefault(setint, MediaQuery.of(context).size.width)
          : checkResponsiveDefault(setint, constraints.maxWidth);
    } else if (ResponsiveWidth.isScreen1152(context, constraints)) {
      return constraints == null
          ? checkResponsiveDefault(setint, MediaQuery.of(context).size.width)
          : checkResponsiveDefault(setint, constraints.maxWidth);
    } else if (ResponsiveWidth.isScreen1440(context, constraints)) {
      return constraints == null
          ? checkResponsiveDefault(setint, MediaQuery.of(context).size.width)
          : checkResponsiveDefault(setint, constraints.maxWidth);
    } else if (ResponsiveWidth.isScreen1920(context, constraints)) {
      return constraints == null
          ? checkResponsiveDefault(setint, MediaQuery.of(context).size.width)
          : checkResponsiveDefault(setint, constraints.maxWidth);
    } else if (ResponsiveWidth.isScreen3840(context, constraints)) {
      return constraints == null
          ? checkResponsiveDefault(setint, MediaQuery.of(context).size.width)
          : checkResponsiveDefault(setint, constraints.maxWidth);
    } else {
      return constraints == null
          ? checkResponsiveDefault(setint, MediaQuery.of(context).size.width)
          : checkResponsiveDefault(setint, constraints.maxWidth);
    }
  }

  static double setWidthRowText(BuildContext context, BoxConstraints? constraints, double setint) {
    if (ResponsiveWidth.isScreen320(context, constraints)) {
      return constraints == null
          ? checkResponsive(setint, MediaQuery.of(context).size.width, 40)
          : checkResponsive(setint, constraints.maxWidth, 40);
    } else if (ResponsiveWidth.isScreen344(context, constraints)) {
      return constraints == null
          ? checkResponsive(setint, MediaQuery.of(context).size.width, 32)
          : checkResponsive(setint, constraints.maxWidth, 32);
    } else if (ResponsiveWidth.isScreen375(context, constraints)) {
      return constraints == null
          ? checkResponsive(setint, MediaQuery.of(context).size.width, 24)
          : checkResponsive(setint, constraints.maxWidth, 24);
    } else if (ResponsiveWidth.isScreen390(context, constraints)) {
      return constraints == null
          ? checkResponsive(setint, MediaQuery.of(context).size.width, 16)
          : checkResponsive(setint, constraints.maxWidth, 16);
    } else if (ResponsiveWidth.isScreen411(context, constraints)) {
      return constraints == null
          ? checkResponsive(setint, MediaQuery.of(context).size.width, 8)
          : checkResponsive(setint, constraints.maxWidth, 8);
    } else if (ResponsiveWidth.isScreen448(context, constraints)) {
      return constraints == null
          ? checkResponsiveDefault(setint, MediaQuery.of(context).size.width)
          : checkResponsiveDefault(setint, constraints.maxWidth);
    } else if (ResponsiveWidth.isScreen480(context, constraints)) {
      return constraints == null
          ? checkResponsiveDefault(setint, MediaQuery.of(context).size.width)
          : checkResponsiveDefault(setint, constraints.maxWidth);
    } else if (ResponsiveWidth.isScreen540(context, constraints)) {
      return constraints == null
          ? checkResponsiveDefault(setint, MediaQuery.of(context).size.width)
          : checkResponsiveDefault(setint, constraints.maxWidth);
    } else if (ResponsiveWidth.isScreen853(context, constraints)) {
      return constraints == null
          ? checkResponsiveDefault(setint, MediaQuery.of(context).size.width)
          : checkResponsiveDefault(setint, constraints.maxWidth);
    } else if (ResponsiveWidth.isScreen1024(context, constraints)) {
      return constraints == null
          ? checkResponsiveDefault(setint, MediaQuery.of(context).size.width)
          : checkResponsiveDefault(setint, constraints.maxWidth);
    } else if (ResponsiveWidth.isScreen1152(context, constraints)) {
      return constraints == null
          ? checkResponsiveDefault(setint, MediaQuery.of(context).size.width)
          : checkResponsiveDefault(setint, constraints.maxWidth);
    } else if (ResponsiveWidth.isScreen1440(context, constraints)) {
      return constraints == null
          ? checkResponsiveDefault(setint, MediaQuery.of(context).size.width)
          : checkResponsiveDefault(setint, constraints.maxWidth);
    } else if (ResponsiveWidth.isScreen1920(context, constraints)) {
      return constraints == null
          ? checkResponsiveDefault(setint, MediaQuery.of(context).size.width)
          : checkResponsiveDefault(setint, constraints.maxWidth);
    } else if (ResponsiveWidth.isScreen3840(context, constraints)) {
      return constraints == null
          ? checkResponsiveDefault(setint, MediaQuery.of(context).size.width)
          : checkResponsiveDefault(setint, constraints.maxWidth);
    } else {
      return constraints == null
          ? checkResponsiveDefault(setint, MediaQuery.of(context).size.width)
          : checkResponsiveDefault(setint, constraints.maxWidth);
    }
  }

  //responsive Height
  static double setHeightFull(BuildContext context, BoxConstraints? constraints) =>
      constraints == null ? MediaQuery.of(context).size.height : constraints.maxHeight;

  static double setHeight(BuildContext context, BoxConstraints? constraints, double setint) {
    // if (ResponsiveHeight.isScreen480(context, constraints)) {
    //   return constraints == null
    //       ? checkResponsive(setint, MediaQuery.of(context).size.height, 40)
    //       : checkResponsive(setint, constraints.maxHeight, 40);
    // } else if (ResponsiveHeight.isScreen576(context, constraints)) {
    //   return constraints == null
    //       ? checkResponsive(setint, MediaQuery.of(context).size.height, 32)
    //       : checkResponsive(setint, constraints.maxHeight, 32);
    // } else if (ResponsiveHeight.isScreen667(context, constraints)) {
    //   return constraints == null
    //       ? checkResponsive(setint, MediaQuery.of(context).size.height, 24)
    //       : checkResponsive(setint, constraints.maxHeight, 24);
    // } else if (ResponsiveHeight.isScreen771(context, constraints)) {
    //   return constraints == null
    //       ? checkResponsive(setint, MediaQuery.of(context).size.height, 16)
    //       : checkResponsive(setint, constraints.maxHeight, 16);
    // } else if (ResponsiveHeight.isScreen780(context, constraints)) {
    //   return constraints == null
    //       ? checkResponsive(setint, MediaQuery.of(context).size.height, 8)
    //       : checkResponsive(setint, constraints.maxHeight, 8);
    // } else if (ResponsiveHeight.isScreen800(context, constraints)) {
    //   return constraints == null
    //       ? checkResponsiveDefault(setint, MediaQuery.of(context).size.height)
    //       : checkResponsiveDefault(setint, constraints.maxHeight);
    // } else if (ResponsiveHeight.isScreen852(context, constraints)) {
    //   return constraints == null
    //       ? checkResponsiveDefault(setint, MediaQuery.of(context).size.height)
    //       : checkResponsiveDefault(setint, constraints.maxHeight);
    // } else if (ResponsiveHeight.isScreen900(context, constraints)) {
    //   return constraints == null
    //       ? checkResponsiveDefault(setint, MediaQuery.of(context).size.height)
    //       : checkResponsiveDefault(setint, constraints.maxHeight);
    // } else if (ResponsiveHeight.isScreen932(context, constraints)) {
    //   return constraints == null
    //       ? checkResponsiveDefault(setint, MediaQuery.of(context).size.height)
    //       : checkResponsiveDefault(setint, constraints.maxHeight);
    // } else if (ResponsiveHeight.isScreen1050(context, constraints)) {
    //   return constraints == null
    //       ? checkResponsiveDefault(setint, MediaQuery.of(context).size.height)
    //       : checkResponsiveDefault(setint, constraints.maxHeight);
    // } else if (ResponsiveHeight.isScreen1200(context, constraints)) {
    //   return constraints == null
    //       ? checkResponsiveDefault(setint, MediaQuery.of(context).size.height)
    //       : checkResponsiveDefault(setint, constraints.maxHeight);
    // } else if (ResponsiveHeight.isScreen1440(context, constraints)) {
    //   return constraints == null
    //       ? checkResponsiveDefault(setint, MediaQuery.of(context).size.height)
    //       : checkResponsiveDefault(setint, constraints.maxHeight);
    // } else if (ResponsiveHeight.isScreen1600(context, constraints)) {
    //   return constraints == null
    //       ? checkResponsiveDefault(setint, MediaQuery.of(context).size.height)
    //       : checkResponsiveDefault(setint, constraints.maxHeight);
    // } else if (ResponsiveHeight.isScreen2160(context, constraints)) {
    //   return constraints == null
    //       ? checkResponsiveDefault(setint, MediaQuery.of(context).size.height)
    //       : checkResponsiveDefault(setint, constraints.maxHeight);
    // } else {
    return constraints == null
        ? checkResponsiveDefault(setint, MediaQuery.of(context).size.height)
        : checkResponsiveDefault(setint, constraints.maxHeight);
    // }
  }

  static double setHeightMarginPadding(
    BuildContext context,
    BoxConstraints? constraints,
    double setint,
  ) {
    if (ResponsiveHeight.isScreen480(context, constraints)) {
      return constraints == null
          ? checkResponsive(setint, MediaQuery.of(context).size.height, 30)
          : checkResponsive(setint, constraints.maxHeight, 30);
    } else if (ResponsiveHeight.isScreen576(context, constraints)) {
      return constraints == null
          ? checkResponsive(setint, MediaQuery.of(context).size.height, 25)
          : checkResponsive(setint, constraints.maxHeight, 25);
    } else if (ResponsiveHeight.isScreen667(context, constraints)) {
      return constraints == null
          ? checkResponsive(setint, MediaQuery.of(context).size.height, 20)
          : checkResponsive(setint, constraints.maxHeight, 20);
    } else if (ResponsiveHeight.isScreen771(context, constraints)) {
      return constraints == null
          ? checkResponsive(setint, MediaQuery.of(context).size.height, 15)
          : checkResponsive(setint, constraints.maxHeight, 15);
    } else if (ResponsiveHeight.isScreen780(context, constraints)) {
      return constraints == null
          ? checkResponsive(setint, MediaQuery.of(context).size.height, 10)
          : checkResponsive(setint, constraints.maxHeight, 10);
    } else if (ResponsiveHeight.isScreen800(context, constraints)) {
      return constraints == null
          ? checkResponsiveDefault(setint, MediaQuery.of(context).size.height)
          : checkResponsiveDefault(setint, constraints.maxHeight);
    } else if (ResponsiveHeight.isScreen852(context, constraints)) {
      return constraints == null
          ? checkResponsiveDefault(setint, MediaQuery.of(context).size.height)
          : checkResponsiveDefault(setint, constraints.maxHeight);
    } else if (ResponsiveHeight.isScreen900(context, constraints)) {
      return constraints == null
          ? checkResponsiveDefault(setint, MediaQuery.of(context).size.height)
          : checkResponsiveDefault(setint, constraints.maxHeight);
    } else if (ResponsiveHeight.isScreen932(context, constraints)) {
      return constraints == null
          ? checkResponsiveDefault(setint, MediaQuery.of(context).size.height)
          : checkResponsiveDefault(setint, constraints.maxHeight);
    } else if (ResponsiveHeight.isScreen1050(context, constraints)) {
      return constraints == null
          ? checkResponsiveDefault(setint, MediaQuery.of(context).size.height)
          : checkResponsiveDefault(setint, constraints.maxHeight);
    } else if (ResponsiveHeight.isScreen1200(context, constraints)) {
      return constraints == null
          ? checkResponsiveDefault(setint, MediaQuery.of(context).size.height)
          : checkResponsiveDefault(setint, constraints.maxHeight);
    } else if (ResponsiveHeight.isScreen1440(context, constraints)) {
      return constraints == null
          ? checkResponsiveDefault(setint, MediaQuery.of(context).size.height)
          : checkResponsiveDefault(setint, constraints.maxHeight);
    } else if (ResponsiveHeight.isScreen1600(context, constraints)) {
      return constraints == null
          ? checkResponsiveDefault(setint, MediaQuery.of(context).size.height)
          : checkResponsiveDefault(setint, constraints.maxHeight);
    } else if (ResponsiveHeight.isScreen2160(context, constraints)) {
      return constraints == null
          ? checkResponsiveDefault(setint, MediaQuery.of(context).size.height)
          : checkResponsiveDefault(setint, constraints.maxHeight);
    } else {
      return constraints == null
          ? checkResponsiveDefault(setint, MediaQuery.of(context).size.height)
          : checkResponsiveDefault(setint, constraints.maxHeight);
    }
  }

  TextStyle h2_3StyleWhileMedium(BoxConstraints constraints) {
    return TextStyle(
      fontSize: MainConstant.h16,
      fontWeight: MainConstant.boldfontweight,
      color: MainConstant.white,
    );
  }
}
