// image_process_isolate.dart
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

class ImageProcessPayload {
  final Uint8List bytes;
  final Uint8List logobytes;
  final Uint8List? mapbytes;
  final bool camerafront;
  final int rotationangle;
  final double previewwidth;
  final double previewheight;

  final Uint8List textOverlayBytes;

  //logo
  final double logouiwidth;
  final double logouitop;
  final double logouibottom;
  final double logouileft;
  final double logouiright;
  final double logouiangle;

  //map
  final double? mapuiwidth;
  final double? mapuitop;
  final double? mapuibottom;
  final double? mapuileft;
  final double? mapuiright;
  final double? mapuiangle;

  // text
  final double? textuitop;
  final double? textuibottom;
  final double? textuileft;
  final double? textuiright;
  // final double? textuiangle;

  ImageProcessPayload({
    required this.bytes,
    required this.logobytes,
    required this.mapbytes,
    required this.camerafront,
    required this.rotationangle,
    required this.previewwidth,
    required this.previewheight,

    required this.textOverlayBytes,

    //logo
    required this.logouiwidth,
    required this.logouitop,
    required this.logouibottom,
    required this.logouileft,
    required this.logouiright,
    required this.logouiangle,

    //map
    required this.mapuiwidth,
    required this.mapuitop,
    required this.mapuibottom,
    required this.mapuileft,
    required this.mapuiright,
    required this.mapuiangle,

    //text
    required this.textuitop,
    required this.textuibottom,
    required this.textuileft,
    required this.textuiright,
    // required this.textuiangle,
  });
}

//ฟังก์ชันวาดโค้งมุมแผนที่
img.Image roundTopRightCorner(img.Image src, {int radius = 16}) {
  final w = src.width;
  final h = src.height;

  // clamp radius ไม่ให้เกินขนาดภาพ
  final int safeRadius = radius.clamp(0, min(w, h)).toInt();
  if (safeRadius == 0) return src;

  for (int y = 0; y < safeRadius; y++) {
    for (int x = w - safeRadius; x < w; x++) {
      final dx = x - (w - safeRadius);
      final dy = safeRadius - y;
      if (dx * dx + dy * dy > safeRadius * safeRadius) {
        src.setPixelRgba(x, y, 0, 0, 0, 0);
      }
    }
  }
  return src;
}

void drawTextWithShadowRight(img.Image image, img.BitmapFont font, int rightX, int y, String text) {
  if (text.isEmpty) return;

  // shadow
  img.drawString(
    image,
    text,
    font: font,
    x: rightX + 1,
    y: y + 1,
    rightJustify: true,
    color: img.ColorRgb8(0, 0, 0),
  );

  // text
  img.drawString(
    image,
    text,
    font: font,
    x: rightX,
    y: y,
    rightJustify: true,
    color: img.ColorRgb8(255, 255, 255),
  );
}

Future<Uint8List> processImageIsolate(ImageProcessPayload payload) async {
  if (payload.previewwidth <= 0 ||
      payload.previewheight <= 0 ||
      !payload.previewwidth.isFinite ||
      !payload.previewheight.isFinite) {
    return payload.bytes;
  }

  Uint8List bytes = payload.bytes;

  // mirror front camera
  // if (payload.camerafront) {
  //   final img.Image? decoded = img.decodeImage(bytes);
  //   if (decoded != null) {
  //     bytes = Uint8List.fromList(img.encodeJpg(img.flipHorizontal(decoded), quality: 92));
  //   }
  // }

  // final img.Image? base = img.decodeImage(bytes);
  final img.Image? decoded = img.decodeImage(bytes);
  if (decoded == null) return bytes;

  img.Image working = decoded;

  // mirror เฉพาะกล้องหน้า
  if (payload.camerafront) {
    working = img.flipHorizontal(working);

    // rotate หลัง mirror
    switch (payload.rotationangle) {
      case 1: // หมุนซ้าย
        working = img.copyRotate(working, angle: -90);
        break;
      case 3: // หมุนขวา
        working = img.copyRotate(working, angle: 90);
        break;
      case 2: // กลับหัว
        working = img.copyRotate(working, angle: 180);
        break;
      default:
        break;
    }
  }

  // ใช้ภาพที่ normalize แล้วเป็น base
  final img.Image base = working;

  final img.Image? logo = img.decodeImage(payload.logobytes);
  final img.Image? mapimage = (payload.mapbytes == null || payload.mapbytes!.isEmpty)
      ? null
      : img.decodeImage(payload.mapbytes!);

  final img.Image? textimage = img.decodePng(payload.textOverlayBytes);

  if (textimage == null) {
    return bytes;
  }

  if (base == null || logo == null) {
    return bytes;
  }

  if (payload.mapbytes != null) {
    if (kDebugMode) {
      print('===>> mapbytes length = ${payload.mapbytes!.length}');
    }
  }

  // ===== scale =====
  final bool landscape = base.width > base.height;

  final double safeprevieww = payload.previewwidth <= 0 ? 1 : payload.previewwidth;
  final double safepreviewh = payload.previewheight <= 0 ? 1 : payload.previewheight;

  // final imagescale = base.width / payload.previewwidth;
  final imagescale = base.width / safeprevieww;

  // scale สำหรับ logo เท่านั้น
  // final double overlayscale = landscape
  //     ? min(base.width, base.height) / min(payload.previewwidth, payload.previewheight)
  //     : imagescale;
  final double overlayscale = landscape
      ? min(base.width, base.height) / min(safeprevieww, safepreviewh)
      : imagescale;

  final double reallogowidth = payload.logouiwidth * overlayscale;
  final double reallogoheight = logo.height * (reallogowidth / logo.width);

  // resize โลโก้
  int safeW(double v) => max(1, v.round());

  final img.Image resizelogo = img.copyResize(
    logo,
    width: safeW(reallogowidth),
    height: safeW(reallogoheight),
  );

  int x = 0;
  int y = 0;

  // ===== แปลงจาก Positioned (UI) → pixel จริง =====
  if (payload.logouileft > 0) {
    x = (payload.logouileft * imagescale).round();
  } else if (payload.logouiright > 0) {
    x = (base.width - resizelogo.width - payload.logouiright * imagescale).round();
  }

  if (payload.logouitop > 0) {
    y = (payload.logouitop * imagescale).round();
  } else if (payload.logouibottom > 0) {
    y = (base.height - resizelogo.height - payload.logouibottom * imagescale).round();
  }

  // ===== กันหลุดขอบ =====
  x = x.clamp(0, base.width - resizelogo.width);
  y = y.clamp(0, base.height - resizelogo.height);

  // ===== วาดโลโก้ลงภาพ =====
  img.compositeImage(base, resizelogo, dstX: x, dstY: y, blend: img.BlendMode.alpha);

  // ===== วาด map ลงภาพ =====
  if (mapimage != null) {
    final double mapuiwidth = 105;
    final double realmapwidth = mapuiwidth * overlayscale;
    final double realmapheight = mapimage.height * (realmapwidth / mapimage.width);

    var resizemap = img.copyResize(
      mapimage,
      width: safeW(realmapwidth),
      height: safeW(realmapheight),
    );

    // round corner
    resizemap = roundTopRightCorner(resizemap, radius: max(1, (12 * imagescale).round()));

    int mapx = 0;
    int mapy = 0;

    mapx = 0;
    mapy = base.height - resizemap.height;

    mapx = mapx.clamp(0, base.width - resizemap.width);
    mapy = mapy.clamp(0, base.height - resizemap.height);

    img.compositeImage(base, resizemap, dstX: mapx, dstY: mapy);
  }

  // ===== TEXT =====
  const double textscalewidth = 0.9;
  // เช็คแนวนอน / แนวตั้ง
  final bool textlandscape = base.width > base.height;
  // แนวนอนเล็กกว่าแนวตั้ง
  final double orientationscale = textlandscape ? 0.8 : 1.0;
  // scale text ตามภาพจริงอย่างเดียว
  final double textscale = (base.width / 1080) * orientationscale;

  img.Image textimg = img.copyResize(
    textimage,
    width: safeW(textimage.width * textscale * textscalewidth),
    height: safeW(textimage.height * textscale * textscalewidth),
  );

  final int marginright = (12 * textscale).round();
  final int marginbottom = (12 * textscale).round();

  final int tx = (base.width - textimg.width - marginright).clamp(
    0,
    max(0, base.width - textimg.width),
  );
  final int ty = (base.height - textimg.height - marginbottom).clamp(
    0,
    max(0, base.height - textimg.height),
  );

  img.compositeImage(base, textimg, dstX: tx, dstY: ty);

  // ===== encode กลับ =====
  bytes = Uint8List.fromList(img.encodeJpg(base, quality: 92));

  return bytes;
}
