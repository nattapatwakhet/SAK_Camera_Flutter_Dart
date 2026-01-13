import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:sakcamera_getx/constant/main_constant.dart';

import 'package:sakcamera_getx/state/app/webinapp_controller.dart';
import 'package:sakcamera_getx/util/main_util.dart';

class WebInApp extends GetView<WebInAppController> {
  final String url;
  final String titlebar;

  const WebInApp({super.key, required this.url, required this.titlebar});

  @override
  Widget build(BuildContext context) {
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        color:
                            // Device.orientation == Orientation.portrait
                            orientation == Orientation.portrait
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
                      return PopScope(
                        canPop: false,
                        onPopInvokedWithResult: (didPop, result) async {
                          try {
                            final result = await controller.onWillPop(context, constraints);
                            if (result) Get.back();
                          } catch (error) {
                            if (kDebugMode) {
                              print('error ===>> Class(WebInApp) onPopInvokedWithResult: $error');
                            }
                            Get.back();
                          }
                        },
                        child: Scaffold(
                          appBar: AppBar(
                            backgroundColor: MainConstant.primary,
                            title: Text(
                              controller.titlebar,
                              style: MainConstant().h2_3StyleWhileMedium(BoxConstraints()),
                            ),
                            leading: IconButton(
                              icon: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: SizedBox(
                                  width: MainConstant.setWidth(context, constraints, 24),
                                  child: Image.asset(MainConstant.back, fit: BoxFit.contain),
                                ),
                              ),
                              onPressed: () => Get.back(),
                            ),
                          ),
                          body: Obx(
                            () => Container(
                              color: MainConstant.grey23,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Stack(
                                      alignment: Alignment.topCenter,
                                      children: [
                                        InAppWebView(
                                          initialUrlRequest: URLRequest(
                                            url: WebUri.uri(Uri.parse(controller.urlstring.value)),
                                          ),
                                          initialSettings: controller.inappoptions,
                                          pullToRefreshController:
                                              controller.pulltorefreshcontroller.value,
                                          onWebViewCreated: (webCtrl) =>
                                              controller.inappwebviewcontroller.value = webCtrl,
                                          onLoadStart: (c, url) =>
                                              controller.updateUrl(url.toString()),
                                          onLoadStop: (c, url) {
                                            controller.pulltorefreshcontroller.value
                                                ?.endRefreshing();
                                            controller.updateUrl(url.toString());
                                          },
                                          onProgressChanged: (c, p) {
                                            controller.progress.value = p / 100;
                                          },
                                          onPermissionRequest: (controller, request) async {
                                            return PermissionResponse(
                                              resources: request.resources,
                                              action: PermissionResponseAction.GRANT,
                                            );
                                          },
                                          shouldOverrideUrlLoading: (c, action) async {
                                            final uri = action.request.url;
                                            if (uri != null &&
                                                ![
                                                  "http",
                                                  "https",
                                                  "file",
                                                  "chrome",
                                                  "data",
                                                  "javascript",
                                                  "about",
                                                ].contains(uri.scheme)) {
                                              await MainUtil.launchURL(uri.toString());
                                              return NavigationActionPolicy.CANCEL;
                                            }
                                            return NavigationActionPolicy.ALLOW;
                                          },
                                        ),
                                        controller.progress.value < 1
                                            ? LinearProgressIndicator(
                                                color: MainConstant.primary2,
                                                value: controller.progress.value,
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                  ),
                                  buttonBar(controller),
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

  Widget buttonBar(WebInAppController c) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        iconButton(Icons.arrow_back, c.goBack),
        iconButton(Icons.arrow_forward, c.goForward),
        iconButton(Icons.refresh, c.reload),
      ],
    );
  }

  Widget iconButton(IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: MainConstant.primary,
          foregroundColor: MainConstant.white,
        ),
        onPressed: onTap,
        child: Icon(icon),
      ),
    );
  }
}
