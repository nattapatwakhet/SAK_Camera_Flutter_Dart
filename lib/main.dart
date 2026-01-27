import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sakcamera_getx/compute/internetchecker_comepute.dart';
import 'package:sakcamera_getx/constant/main_constant.dart';
import 'package:sakcamera_getx/constant/main_translation_constant.dart';
import 'package:sakcamera_getx/controller/device_controller.dart';
import 'package:sakcamera_getx/controller/user_controller.dart';
import 'package:sakcamera_getx/routes/sackcamera_pages.dart';
import 'package:sakcamera_getx/routes/sakcamera_routes.dart';
import 'package:sakcamera_getx/state/app/checkversion_controller.dart';
import 'package:sakcamera_getx/state/camera/setting_controller.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized(); // เตรียมระบบ Flutter ก่อน

  await Firebase.initializeApp(); //firebase
  if (kDebugMode) {
    print('===>> 🔥 Firebase initialized');
  }
  debugPrint('🔥 Firebase initialized');

  //INIT intl locale
  await initializeDateFormatting('th');

  // ล็อคจอให้เป็นแนวตั้งอย่างเดียว
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // await Firebase.initializeApp().timeout(const Duration(seconds: 90)).catchError((error) {
  //   if (kDebugMode) {
  //     print('===>> [error] Firebase initializeApp: $error');
  //   }
  // });

  Get.put(DeviceController());
  Get.put(UserController());
  Get.put(InternetChecker());
  Get.put(CheckVersionController());
  Get.put(SettingController());

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
