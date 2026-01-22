import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:sakcamera_getx/compute/image/prepare_logo.dart';

class ImageProcessPayload {
  final Uint8List bytes;

  final PreparedOverlay? logo;
  final PreparedOverlay? map;
  final PreparedOverlay? text;
  final PreparedOverlay? emptybase;

  ImageProcessPayload({required this.bytes, this.logo, this.map, this.text, this.emptybase});
}

Future<Uint8List> processImageIsolate(ImageProcessPayload payload) async {
  // mirror front camera
  // if (payload.camerafront) {
  //   final img.Image? decoded = img.decodeImage(bytes);
  //   if (decoded != null) {
  //     bytes = Uint8List.fromList(img.encodeJpg(img.flipHorizontal(decoded), quality: 92));
  //   }
  // }

  final img.Image? base = img.decodeImage(payload.bytes);
  if (base == null) {
    return payload.bytes;
  }

  // mirror เฉพาะกล้องหน้า
  // if (payload.camerafront) {
  //   working = img.flipHorizontal(working);

  //   // rotate หลัง mirror
  //   switch (payload.rotationangle) {
  //     case 1: // หมุนซ้าย
  //       working = img.copyRotate(working, angle: -90);
  //       break;
  //     case 3: // หมุนขวา
  //       working = img.copyRotate(working, angle: 90);
  //       break;
  //     case 2: // กลับหัว
  //       working = img.copyRotate(working, angle: 180);
  //       break;
  //     default:
  //       break;
  //   }
  // }

  void draw(PreparedOverlay? overlay) {
    if (overlay == null) {
      return;
    }

    final x = overlay.x.clamp(0, base.width - overlay.image.width);
    final y = overlay.y.clamp(0, base.height - overlay.image.height);

    img.compositeImage(base, overlay.image, dstX: x, dstY: y, blend: img.BlendMode.alpha);
  }
  if (payload.logo != null) {
    draw(payload.logo);
  }
  if (payload.map != null) {
    draw(payload.map);
  }
  if (payload.text != null) {
    draw(payload.text);
  }
  // if (payload.emptybase != null) {
  //   draw(payload.emptybase);
  // }
  // img.compositeImage(base, resizelogo, dstX: x, dstY: y, blend: img.BlendMode.alpha);

  // ===== encode กลับ =====
  // bytes = Uint8List.fromList(img.encodeJpg(base, quality: 92));
  // bytes = Uint8List.fromList(img.encodePng(base));
  // return bytes;
  return Uint8List.fromList(img.encodeJpg(base, quality: 82));
}
