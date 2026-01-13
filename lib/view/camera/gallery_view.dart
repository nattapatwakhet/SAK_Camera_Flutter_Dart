import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sakcamera_getx/component/main_dialog_component.dart';
import 'package:sakcamera_getx/constant/main_constant.dart';
import 'package:sakcamera_getx/state/login/login_controller.dart';

class Login extends StatelessWidget {
  final LoginController logincontroller = Get.put(LoginController());

  Login({super.key});

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
              FocusScope.of(context).unfocus();
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
                            ? MainConstant.black
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
                      logincontroller.lastconstraints.value = constraints;

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
                            Localizations.localeOf(context).languageCode == 'th'
                                ? 'แจ้งเตือน'
                                : 'warning',
                            message: Localizations.localeOf(context).languageCode == 'th'
                                ? 'ต้องการปิดแอปหรือไม่'
                                : 'Want to close the app?',
                            confirmbutton: Localizations.localeOf(context).languageCode == 'th'
                                ? 'ตกลง'
                                : 'Ok',
                            closebutton: Localizations.localeOf(context).languageCode == 'th'
                                ? 'ยกเลิก'
                                : 'Cancle',
                          );
                          if (result == true) {
                            SystemNavigator.pop(); // ออกจากแอปหรือปิดแอป
                          }
                        },
                        child: Scaffold(
                          appBar: widgetAppBar(context),
                          backgroundColor: MainConstant.grey,
                          body: SizedBox(
                            width: MainConstant.setWidthFull(context, constraints),
                            height: MainConstant.setHeightFull(context, constraints),
                            child: Form(
                              key: logincontroller.formkey,
                              child: Stack(
                                alignment: AlignmentDirectional.topStart,
                                children: [
                                  SingleChildScrollView(
                                    physics: const ClampingScrollPhysics(),
                                    controller: logincontroller.scrollcontroller,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        widgetForm(context, constraints),
                                        // widgetLoginHeader(context, constraints, orientation),
                                        // widgetLoginForm(context, constraints, orientation),
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

  Widget widgetForm(BuildContext context, BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MainConstant.setWidth(context, constraints, 430),
          margin: EdgeInsets.only(top: 15),

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
                        MainConstant.setWidth(context, constraints, 36),
                      ),
                      color: MainConstant.primary,
                    ),
                    width: MainConstant.setWidthFull(context, constraints),
                    height: MainConstant.setHeight(context, constraints, 650),

                    padding: EdgeInsets.symmetric(
                      horizontal: MainConstant.setWidth(context, constraints, 20),
                      vertical: MainConstant.setHeight(context, constraints, 15),
                    ),

                    // child: Scrollbar(
                    //   thumbVisibility: true,
                    //   radius: const Radius.circular(12),
                    //   thickness: 5,
                    child: Column(children: [
                       
                      ],
                    ),
                  ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
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
