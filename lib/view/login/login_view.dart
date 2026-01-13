import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sakcamera_getx/component/main_dialog_component.dart';
import 'package:sakcamera_getx/component/main_form_component.dart';
import 'package:sakcamera_getx/constant/main_constant.dart';
import 'package:sakcamera_getx/state/login/login_controller.dart';
import 'package:sakcamera_getx/util/main_util.dart';
import 'package:sakcamera_getx/util/responsive/height_responsive.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    //กำหนด status bar / navigation bar ให้เข้ากับธีมของแอป
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
              // FocusScope.of(context).unfocus();
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

                      return PopScope(
                        canPop: false, // false จะแสดง pop up เราก่อน ถ้า true จะออกเลย
                        onPopInvokedWithResult: (didPop, popResult) async {
                          final result = await MainDialog.dialogPopup(
                            context,
                            true,
                            'warning'.tr,
                            message: 'warning_close_app'.tr,
                            confirmbutton: 'ok'.tr,
                            closebutton: 'cancel'.tr,
                          );
                          if (result == true) {
                            SystemNavigator.pop(); // ออกจากแอปหรือปิดแอป
                          }
                        },
                        // โครงหน้าหลัก
                        child: Scaffold(
                          // appBar: widgetAppBar(context),
                          backgroundColor: MainConstant.primary,
                          body: SizedBox(
                            width: MainConstant.setWidthFull(context, constraints),
                            height: MainConstant.setHeightFull(context, constraints),
                            child: Form(
                              key: controller.formkey,
                              child: Stack(
                                alignment: AlignmentDirectional.topStart,
                                children: [
                                  SingleChildScrollView(
                                    physics:  const ClampingScrollPhysics(),
                                    controller: controller.scrollcontroller,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        widgetLoginHeader(orientation, context, constraints),
                                        widgetLoginForm(context, constraints, orientation),
                                      ],
                                    ),
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

  //===>> ส่วน Login Header <===//
  Widget widgetLoginHeader(
    Orientation orientation,
    BuildContext context,
    BoxConstraints constraints,
  ) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        widgetBackgroundHeader(orientation, context, constraints),
        widgetTextHeader(context, constraints),
      ],
    );
  }
  //===>> ส่วน Login Header <===//

  //===>> ส่วนพื้นหลังหัวข้อ Header <===//
  Widget widgetBackgroundHeader(
    Orientation orientation,
    BuildContext context,
    BoxConstraints constraints,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: orientation == Orientation.portrait
              ? MainConstant.setHeight(context, constraints, 310.5)
              : MainConstant.setHeight(context, constraints, 305.5),
          // : null,
          width: orientation == Orientation.portrait
              ? MainConstant.setWidthFull(context, constraints)
              : MainConstant.setWidthFull(context, constraints),
          child: Image.asset(
            orientation == Orientation.portrait ? MainConstant.graphup : MainConstant.graphup2,
            fit: orientation == Orientation.portrait ? BoxFit.fitWidth : BoxFit.fitHeight,
          ),
        ),
      ],
    );
  }
  //===>> ส่วนพื้นหลังหัวข้อ Header <===//

  //===>> ส่วนองค์ประกอบหัวข้อ Header <===//
  Widget widgetTextHeader(BuildContext context, BoxConstraints constraints) {
    return Column(
      children: [
        widgetLogoCompany(context, constraints),
        widgetNameProject(context, constraints),
        widgetNameCompany(context, constraints),
      ],
    );
  }
  //===>> ส่วนองค์ประกอบหัวข้อ Header <===//

  //===>> ส่วนโลโก้หัวข้อ Header <===//
  Widget widgetLogoCompany(BuildContext context, BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(top: MainConstant.setHeight(context, constraints, 53.5)),
      child: Image.asset(
        MainConstant.saklogowhite,
        width: MainConstant.setWidth(context, constraints, 148),
        height: MainConstant.setHeight(context, constraints, 147),
        // width: 148,
        // height: 147,
        fit: BoxFit.contain,
      ),
    );
  }
  //===>> ส่วนโลโก้หัวข้อ Header <===//

  //===>> ส่วนชื่อหัวข้อ Header <===//
  Widget widgetNameProject(BuildContext context, BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(top: MainConstant.setHeight(context, constraints, 18)),
      child: MainUtil.mainText(
        context,
        constraints,
        text: 'name_project'.tr,
        textstyle: MainUtil.mainTextStyle(
          context,
          constraints,
          fontsize: MainConstant.h20,
          fontweight: MainConstant.boldfontweight,
          fontcolor: Colors.white,
        ),
      ),
    );
  }
  //===>> ส่วนชื่อหัวข้อ Header <===//

  //===>> ส่วนชื่อบริษัทหัวข้อ Header <===//
  Widget widgetNameCompany(BuildContext context, BoxConstraints constraints) {
    return Container(
      width: MainConstant.setWidth(context, constraints, 335),
      height: MainConstant.setHeight(context, constraints, 20),
      decoration: BoxDecoration(
        color: MainConstant.yellow3,
        borderRadius: BorderRadius.circular(MainConstant.setWidth(context, constraints, 36)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MainUtil.mainText(
            context,
            constraints,
            text: 'name_company'.tr,
            textstyle: MainUtil.mainTextStyle(
              context,
              constraints,
              fontsize: MainConstant.h13,
              fontweight: MainConstant.boldfontweight,
              fontcolor: MainConstant.primary,
            ),
          ),
        ],
      ),
    );
  }
  //===>> ส่วนชื่อบริษัทหัวข้อ Header <===//

  //===>> ส่วน Login Form <===//
  Widget widgetLoginForm(
    BuildContext context,
    BoxConstraints constraints,
    Orientation orientation,
  ) {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        widgetBackgroundForm(context, constraints, orientation),
        widgetForm(context, constraints),
      ],
    );
  }
  //===>> ส่วน Login Form <===//

  //===>> ส่วนพื้นหลังฟอร์ม Form <===//
  Widget widgetBackgroundForm(
    BuildContext context,
    BoxConstraints constraints,
    Orientation orientation,
  ) {
    return Container(
      // margin: EdgeInsets.only(top: MainConstant.setHeight(context, constraints, 86.5)),
      margin: EdgeInsets.only(top: MainConstant.setHeight(context, constraints, 50)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            child: Image.asset(
              orientation == Orientation.portrait
                  ? MainConstant.backgroundmap
                  : MainConstant.backgroundmap2,
              fit: orientation == Orientation.portrait ? BoxFit.fitWidth : BoxFit.fitHeight,
            ),
          ),
        ],
      ),
    );
  }
  //===>> ส่วนพื้นหลังฟอร์ม Form <===//

  //===>> ส่วนองค์ประกอบ Login Form <===//
  Widget widgetForm(BuildContext context, BoxConstraints constraints) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        widgetNameSubject(context, constraints),
        widgetUerForm(context, constraints),
        widgetPasswordForm(context, constraints),
        widgetButtonLogin(context, constraints),
        widgetDevelop(context, constraints),
      ],
    );
  }
  //===>> ส่วนองค์ประกอบ Login Form <===//

  //===>> ส่วนชื่อ Login Form <===//
  Widget widgetNameSubject(BuildContext context, BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(top: MainConstant.setHeight(context, constraints, 10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            child: Image.asset(
              MainConstant.unlock,
              width: MainConstant.setWidth(context, constraints, 16),
              height: MainConstant.setHeight(context, constraints, 16),
              color: MainConstant.white,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: MainConstant.setWidth(context, constraints, 7)),
            child: MainUtil.mainText(
              context,
              constraints,
              text: 'login'.tr,
              textstyle: MainUtil.mainTextStyle(
                context,
                constraints,
                fontsize: MainConstant.h20,
                fontweight: MainConstant.boldfontweight,
                fontcolor: MainConstant.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
  //===>> ส่วนชื่อ Login Form <===//

  //===>> ส่วนชื่อผู้ใช้ Login Form <===//
  Widget widgetUerForm(BuildContext context, BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: MainConstant.setHeight(context, constraints, 20)),
          child: Obx(
            () => MainComponet.mainFormField(
              context,
              constraints,
              title: 'username'.tr,
              controller: controller.userid,
              textvaridation: 'username_required'.tr,
              width: MainConstant.setWidth(context, constraints, 330),
              height: MainConstant.setHeight(context, constraints, 51),
              statusvalidation: controller.uservalidation.value,
              heightvalidation: MainConstant.setHeight(context, constraints, 77),
              prefixicon: Icon(Icons.person, color: MainConstant.white),
              onchanged: (value) {
                controller.changeValidationUser(value); // เรียกตรวจทุกครั้งที่พิมพ์
              },
            ),
          ),
        ),
      ],
    );
  }
  //===>> ส่วนชื่อผู้ใช้ Login Form <===//

  //===>> ส่วนรหัสผ่านผู้ใช้ Login Form <===//
  Widget widgetPasswordForm(BuildContext context, BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: MainConstant.setHeight(context, constraints, 15)),
          child: Obx(
            () => MainComponet.mainFormField(
              context,
              constraints,
              title: 'password'.tr,
              controller: controller.password,
              prefixicon: Icon(Icons.lock, color: MainConstant.white),
              suffixicon: IconButton(
                icon: Icon(
                  controller.showpassword.value
                      ? Icons.visibility_rounded
                      : Icons.visibility_outlined,
                  color: MainConstant.white,
                ),
                onPressed: controller.switchEye,
              ),
              statusobscuretext: controller.showpassword.value,
              textvaridation: 'password_required'.tr,
              width: MainConstant.setWidth(context, constraints, 330),
              height: MainConstant.setHeight(context, constraints, 51),
              statusvalidation: controller.passwordvalidation.value,
              heightvalidation: MainConstant.setHeight(context, constraints, 77),
              onchanged: (value) {
                controller.changeValidationPassword(value);
              },
            ),
          ),
        ),
      ],
    );
  }
  //===>> ส่วนรหัสผ่านผู้ใช้ Login Form <===//

  //===>> ส่วนปุ่ม Login Form <===//
  Widget widgetButtonLogin(BuildContext context, BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // ===> ส่วนปุ่ม <=== //
        MainComponet.mainButton(
          context,
          constraints,
          onPressed: () {
            controller.submitCheckLogin(constraints);
          },
          backgroundcolor: MainConstant.grey26,
          foregroundcolor: MainConstant.white,
          width: MainConstant.setWidth(context, constraints, 330),
          height: MainConstant.setHeight(context, constraints, 40),
          margin: EdgeInsets.only(top: 17, bottom: 20),
          // ===> ส่วน text ในปุ่ม <=== //
          child: MainUtil.mainText(
            context,
            constraints,
            text: 'login'.tr,
            textstyle: MainUtil.mainTextStyle(
              context,
              constraints,
              fontsize: MainConstant.h18,
              fontweight: MainConstant.boldfontweight,
              fontcolor: MainConstant.white,
            ),
          ),
        ),
      ],
    );
  }
  //===>> ส่วนปุ่ม Login Form <===//

  //===>> ส่วน Privacy & Policy Login Form <===//
  Widget widgetDevelop(BuildContext context, BoxConstraints constraints) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(
                top: ResponsiveHeight.isMobile(context, constraints)
                    ? MainConstant.setHeight(context, constraints, 70)
                    : ResponsiveHeight.isMobileBig(context, constraints)
                    ? MainConstant.setHeight(context, constraints, 10)
                    : ResponsiveHeight.isMobileSmall(context, constraints)
                    ? MainConstant.setHeight(context, constraints, 10)
                    : ResponsiveHeight.isMobileSmallVery(context, constraints)
                    ? MainConstant.setHeight(context, constraints, 10)
                    : ResponsiveHeight.isMobileBigVery(context, constraints)
                    ? MainConstant.setHeight(context, constraints, 10)
                    : MainConstant.setHeight(context, constraints, 10),
              ),
              child: InkWell(
                onTap: () {
                  if (kDebugMode) {
                    print('===>> Tapped!');
                  }
                   Get.toNamed('/privcyandpolicy');
                },
                child: MainUtil.mainText(
                  context,
                  constraints,
                  text: 'privacy_policy'.tr,
                  textstyle: MainUtil.mainTextStyle(
                    context,
                    constraints,
                    fontsize: MainConstant.h12,
                    fontweight: MainConstant.boldfontweight,
                    fontcolor: MainConstant.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        InkWell(
          onTap: () {
            if (kDebugMode) {
              print('===>> Tapped!');
            }
            Get.toNamed('/version');
          },
          child: MainUtil.mainText(
            context,
            constraints,
            text: 'dev_by'.tr,
            textstyle: MainUtil.mainTextStyle(
              context,
              constraints,
              fontsize: MainConstant.h12,
              fontweight: MainConstant.boldfontweight,
              fontcolor: MainConstant.white,
            ),
          ),
        ),
      ],
    );
  }

  //===>> ส่วน Privacy & Policy Login Form <===//
}
