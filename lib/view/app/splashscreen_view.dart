import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sakcamera_getx/constant/main_constant.dart';
import 'package:sakcamera_getx/state/app/splashscreen_controller.dart';

class Splashscreen extends GetView<SplashScreenController> {
  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: MainConstant.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: MainConstant.primary,
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
              alignment: AlignmentDirectional.center,
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

                // ใช้ Obx เพื่อจับค่าจาก Controller
                SafeArea(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      controller.lastconstraints.value = constraints;

                      if (kDebugMode) {
                        print('=== LayoutBuilder Constraints ===');
                        print('MaxWidth: ${constraints.maxWidth}');
                        print('MaxHeight: ${constraints.maxHeight}');
                      }

                      return Scaffold(
                        // appBar: widgetAppBar(context),
                        backgroundColor: MainConstant.primary,
                        body: SizedBox(
                          width: MainConstant.setWidthFull(context, constraints),
                          height: MainConstant.setHeightFull(context, constraints),
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  widgetLogoSplashScreen(context, constraints),

                                  // widgetForm(context, constraints),
                                  // widgetLoginHeader(context, constraints, orientation),
                                  // widgetLoginForm(context, constraints, orientation),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [widgetLoading(context, constraints)],
                              ),
                            ],
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
              // Positioned(
              //   bottom: 0,
              //   left: 15,
              //   child: IconButton(
              //     icon: Icon(Icons.arrow_back_ios, color: MainConstant.white),
              //     onPressed: () => Navigator.pop(context),
              //     padding: EdgeInsets.zero,
              //     constraints: BoxConstraints(),
              //   ),
              // ),
              Positioned(
                bottom: 6,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'nameapp'.tr,
                    style: TextStyle(
                      fontSize: MainConstant.h24,
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
  //===>> AppBar <===//

  //===>> SplashScreen <===//
  Widget widgetLogoSplashScreen(BuildContext context, BoxConstraints constraints) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            Image.asset(
              MainConstant.sakcamerasplash,
              width: MainConstant.setWidth(context, constraints, 150),
              height: MainConstant.setHeight(context, constraints, 150),
              fit: BoxFit.contain,
            ),
          ],
        ),
      ],
    );
  }
  //===>> SplashScreen <===//

  //===>> Loading <===//
  Widget widgetLoading(BuildContext context, BoxConstraints constraints) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: MainConstant.setHeight(context, constraints, 100)),
          child: Column(
            children: [
              LoadingAnimationWidget.threeArchedCircle(
                color: MainConstant.white,
                size: MainConstant.setWidth(context, constraints, 50),
              ),
            ],
          ),
        ),
        Obx(
          () => Text(
            '${controller.progress.value.toStringAsFixed(0)} %',
            style: TextStyle(
              color: MainConstant.white,
              fontSize: MainConstant.h14,
              fontWeight: MainConstant.boldfontweight,
            ),
          ),
        ),
      ],
    );
  }

  //===>> Loading <===//
}
