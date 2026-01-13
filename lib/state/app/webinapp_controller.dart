import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:sakcamera_getx/constant/main_constant.dart';

class WebInAppController extends GetxController {
  final String url;
  final String titlebar;

  WebInAppController({required this.url, required this.titlebar});

  final inappwebviewcontroller = Rxn<InAppWebViewController>();
  final pulltorefreshcontroller = Rxn<PullToRefreshController>();
  final urlstring = ''.obs;
  final progress = 0.0.obs;
  final urltext = TextEditingController();

  final inappoptions = InAppWebViewSettings(
    useShouldOverrideUrlLoading: true,
    mediaPlaybackRequiresUserGesture: false,
    useHybridComposition: true, // แทน Android options
    allowsInlineMediaPlayback: true, // แทน iOS options
  );

  @override
  void onInit() {
    super.onInit();
    urlstring.value = url;
    pulltorefreshcontroller.value = PullToRefreshController(
      settings: PullToRefreshSettings(
        backgroundColor: MainConstant.white,
        color: MainConstant.primary2,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          await InAppWebViewController.setWebContentsDebuggingEnabled(true);
          inappwebviewcontroller.value?.reload();
        } else if (Platform.isIOS) {
          final current = await inappwebviewcontroller.value?.getUrl();
          if (current != null) {
            inappwebviewcontroller.value?.loadUrl(urlRequest: URLRequest(url: current));
          }
        }
      },
    );
  }

  Future<void> goBack() async => inappwebviewcontroller.value?.goBack();
  Future<void> goForward() async => inappwebviewcontroller.value?.goForward();
  Future<void> reload() async => inappwebviewcontroller.value?.reload();

  void updateUrl(String newUrl) {
    urlstring.value = newUrl;
    urltext.text = newUrl;
  }

  Future<bool> onWillPop(BuildContext context, BoxConstraints constraints) async {
    return true;
  }
}
