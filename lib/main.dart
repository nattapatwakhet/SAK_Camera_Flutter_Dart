import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sakcamera_getx/compute/internetchecker_comepute.dart';
import 'package:sakcamera_getx/constant/main_constant.dart';
import 'package:sakcamera_getx/constant/main_translation_constant.dart';
import 'package:sakcamera_getx/controller/device_controller.dart';
import 'package:sakcamera_getx/controller/user_controller.dart';
import 'package:sakcamera_getx/routes/sackcamera_pages.dart';
import 'package:sakcamera_getx/routes/sakcamera_routes.dart';
import 'package:sakcamera_getx/state/app/checkversion_controller.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized(); // เตรียมระบบ Flutter ก่อน
  // ล็อคจอให้เป็นแนวตั้งอย่างเดียว
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  Get.put(DeviceController());
  Get.put(UserController());
  Get.put(InternetChecker());
  Get.put(CheckVersionController());

  runApp(MyApp());
  // runApp(
  //   DevicePreview(
  //     enabled: !kReleaseMode,
  //     builder: (context) => MyApp(), // Wrap your app
  //   ),
  // );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: Get.key,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: MainConstant.sukhumvit, textTheme: const TextTheme()),
      translations: TranslationService(),
      locale: Get.deviceLocale,
      // locale: const Locale('th', 'TH'),
      fallbackLocale: const Locale('en', 'US'),
      getPages: AppPages.routes,
      initialRoute: Routes.splashscreen,
    );
  }
}
