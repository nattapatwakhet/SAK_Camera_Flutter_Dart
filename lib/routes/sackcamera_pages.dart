import 'package:get/get.dart';
import 'package:sakcamera_getx/constant/main_constant.dart';
import 'package:sakcamera_getx/routes/sakcamera_routes.dart';
import 'package:sakcamera_getx/state/camera/camera_controller.dart';
import 'package:sakcamera_getx/state/app/checkversion_controller.dart';
import 'package:sakcamera_getx/state/login/login_controller.dart';
import 'package:sakcamera_getx/state/app/splashscreen_controller.dart';
import 'package:sakcamera_getx/state/app/webinapp_controller.dart';
import 'package:sakcamera_getx/view/camera/camera_view.dart';
import 'package:sakcamera_getx/view/app/checkversionpage_app_view.dart';
import 'package:sakcamera_getx/view/login/login_view.dart';
import 'package:sakcamera_getx/view/app/webinapp_view.dart';
import 'package:sakcamera_getx/view/app/splashscreen_view.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.splashscreen,
      page: () => Splashscreen(),
      transition: Transition.fadeIn, // ใช้ fade
      // transitionDuration: const Duration(milliseconds: 600),
      binding: BindingsBuilder(() {
        Get.put(SplashScreenController());
      }),
    ),
    GetPage(
      name: Routes.login,
      page: () => LoginView(),
      transition: Transition.fadeIn, // ใช้ fade
      transitionDuration: const Duration(milliseconds: 600),
      binding: BindingsBuilder(() {
        Get.put(LoginController());
      }),
    ),
    GetPage(
      name: Routes.privcyandpolicy,
      page: () => WebInApp(url: MainConstant.webpolicy, titlebar: 'privacy_policy'.tr),
      transition: Transition.cupertino, // ใช้ fade
      transitionDuration: const Duration(milliseconds: 600),
      binding: BindingsBuilder(() {
        Get.put(WebInAppController(url: MainConstant.webpolicy, titlebar: 'privacy_policy'.tr));
      }),
    ),
    GetPage(
      name: Routes.version,
      page: () => Version(),
      transition: Transition.cupertino, // ใช้ fade
      transitionDuration: const Duration(milliseconds: 600),
      binding: BindingsBuilder(() {
        Get.put(CheckVersionController());
      }),
    ),
    GetPage(
      name: Routes.camera,
      page: () => Camera(),
      transition: Transition.cupertino, // ใช้ fade
      transitionDuration: const Duration(milliseconds: 600),
      binding: BindingsBuilder(() {
        Get.put(CameraPageController());
      }),
    ),
    // GetPage(
    //   name: Routes.GALLERY,
    //   page: () => const GalleryView(),
    //   binding: BindingsBuilder(() {
    //     Get.put(GalleryController());
    //   }),
    // ),
  ];
}
