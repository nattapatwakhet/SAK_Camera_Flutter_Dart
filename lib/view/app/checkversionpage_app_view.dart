import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sakcamera_getx/component/main_form_component.dart';
import 'package:sakcamera_getx/constant/main_constant.dart';
import 'package:sakcamera_getx/state/app/checkversion_controller.dart';
import 'package:sakcamera_getx/util/main_util.dart';

class Version extends GetView<CheckVersionController> {
  const Version({super.key});

  @override
  Widget build(BuildContext context) {
    //กำหนด status bar / navigation bar ให้เข้ากับธีมของแอป
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: MainConstant.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: MainConstant.black,
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
                        color: Orientation.portrait == orientation
                            ? MainConstant.primary
                            : MainConstant.transparent,
                      ),
                    ),
                    Expanded(flex: 1, child: Container(color: MainConstant.transparent)),
                  ],
                ),
                SafeArea(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (kDebugMode) {
                        print('=== LayoutBuilder Constraints ===');
                        print('MaxWidth: ${constraints.maxWidth}');
                        print('MaxHeight: ${constraints.maxHeight}');
                      }
                      return PopScope(
                        canPop: true, // false จะแสดง pop up เราก่อน ถ้า true จะออกเลย

                        // onPopInvokedWithResult: (didPop, popResult) async {
                        //   Get.back();
                        // },
                        child: Scaffold(
                          appBar: widgetAppBar(context),
                          backgroundColor: MainConstant.white,
                          body: SizedBox(
                            width: MainConstant.setWidthFull(context, constraints),
                            height: MainConstant.setHeightFull(context, constraints),
                            child: Form(
                              key: controller.formkey,
                              child: Stack(
                                alignment: AlignmentDirectional.topStart,
                                children: [
                                  SingleChildScrollView(
                                    physics: const ClampingScrollPhysics(),
                                    controller: controller.scrollcontroller,
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: MainConstant.setWidth(
                                                context,
                                                constraints,
                                                420,
                                              ),
                                              margin: EdgeInsets.only(top: 40, bottom: 20),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        alignment: Alignment.center,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(
                                                            MainConstant.setWidth(
                                                              context,
                                                              constraints,
                                                              36,
                                                            ),
                                                          ),
                                                          color: MainConstant.white,
                                                        ),
                                                        width: MainConstant.setWidthFull(
                                                          context,
                                                          constraints,
                                                        ),
                                                        height: MainConstant.setHeight(
                                                          context,
                                                          constraints,
                                                          605,
                                                        ),
                                                        padding: EdgeInsets.symmetric(
                                                          horizontal: MainConstant.setWidth(
                                                            context,
                                                            constraints,
                                                            20,
                                                          ),
                                                          vertical: MainConstant.setHeight(
                                                            context,
                                                            constraints,
                                                            15,
                                                          ),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            widgetCompanyLogo(context, constraints),
                                                            widgetCheckVersion(
                                                              context,
                                                              constraints,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: MainConstant.primary,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(
                                              MainConstant.setWidth(context, constraints, 36),
                                            ),
                                            bottomRight: Radius.circular(
                                              MainConstant.setWidth(context, constraints, 36),
                                            ),
                                          ),
                                        ),
                                        child: SizedBox(
                                          width: MainConstant.setWidthFull(context, constraints),
                                          height: MainConstant.setHeight(context, constraints, 20),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
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
              Positioned(
                bottom: 0,
                left: 15,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: MainConstant.white),
                  onPressed: () {
                    Get.back();
                  },
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ),
              Positioned(
                bottom: 6,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'name_version'.tr,
                    style: TextStyle(
                      fontSize: MainConstant.h18,
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

  //===>> CompanyLogo <===//
  Widget widgetCompanyLogo(BuildContext context, BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: MainConstant.setHeight(context, constraints, 10)),
          child: Image.asset(MainConstant.saklogo2, height: 100, fit: BoxFit.cover),
        ),
      ],
    );
  }
  //===>> CompanyLogo <===//

  //===>> CheckVersion <===//
  Widget widgetCheckVersion(BuildContext context, BoxConstraints constraints) {
    return Obx(() {
      return Container(
        margin: EdgeInsets.only(top: MainConstant.setHeight(context, constraints, 25)),
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
          //มุมกล่อง
          borderRadius: BorderRadius.circular(MainConstant.setWidth(context, constraints, 36)),
          color: MainConstant.white,
        ),
        //กำหนาดขนาดกล่อง
        width: MainConstant.setWidthFull(context, constraints),
        height: MainConstant.setHeight(context, constraints, 300),

        padding: EdgeInsets.symmetric(horizontal: MainConstant.setWidth(context, constraints, 15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (controller.loadingversion.value) ...[
              Container(
                margin: EdgeInsets.only(bottom: MainConstant.setHeight(context, constraints, 10)),
                child: LoadingAnimationWidget.threeArchedCircle(
                  color: MainConstant.primary,
                  size: 50,
                ),
              ),
            ],
            MainUtil.mainText(
              context,
              constraints,
              textSpan: TextSpan(
                text: '${'current_version'.tr} ',
                style: MainUtil.mainTextStyle(
                  context,
                  constraints,
                  fontsize: MainConstant.h16,
                  fontweight: MainConstant.boldfontweight,
                  fontcolor: MainConstant.primary,
                ),
                children: [
                  TextSpan(
                    text: MainConstant.version,
                    style: MainUtil.mainTextStyle(
                      context,
                      constraints,
                      fontsize: MainConstant.h16,
                      fontweight: MainConstant.boldfontweight,
                      fontcolor: MainConstant.red, // สีเฉพาะคำนี้
                    ),
                  ),
                ],
              ),
            ),
            MainUtil.mainText(
              context,
              constraints,
              textSpan: TextSpan(
                text: controller.versionStatusMessage,
                style: MainUtil.mainTextStyle(
                  context,
                  constraints,
                  fontsize: MainConstant.h16,
                  fontweight: MainConstant.boldfontweight,
                  fontcolor: controller.versionStatusColor,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MainComponet.mainButton(
                  context,
                  constraints,
                  onPressed: controller.loadingversion.value
                      ? null
                      : () async {
                          await controller.checkVersion();
                        },
                  backgroundcolor: MainConstant.primary,
                  foregroundcolor: MainConstant.white,
                  width: MainConstant.setWidth(context, constraints, 160),
                  height: MainConstant.setHeight(context, constraints, 40),
                  margin: EdgeInsets.only(top: 50),
                  // ===> ส่วน text ในปุ่ม <=== //
                  child: MainUtil.mainText(
                    context,
                    constraints,
                    text: 'name_version'.tr,
                    textstyle: MainUtil.mainTextStyle(
                      context,
                      constraints,
                      fontsize: MainConstant.h14,
                      fontweight: MainConstant.boldfontweight,
                      fontcolor: MainConstant.white,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MainComponet.mainButton(
                  context,
                  constraints,
                  onPressed: () async {
                    await controller.openStore(context, constraints);
                  },
                  backgroundcolor: MainConstant.primary,
                  foregroundcolor: MainConstant.white,
                  width: MainConstant.setWidth(context, constraints, 160),
                  height: MainConstant.setHeight(context, constraints, 40),
                  margin: EdgeInsets.only(top: 15),
                  // ===> ส่วน text ในปุ่ม <=== //
                  child: MainUtil.mainText(
                    context,
                    constraints,
                    text: controller.nameStore,
                    textstyle: MainUtil.mainTextStyle(
                      context,
                      constraints,
                      fontsize: MainConstant.h14,
                      fontweight: MainConstant.boldfontweight,
                      fontcolor: MainConstant.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  //===>> CheckVersion <===//
}
