import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

class BitmapFontLoader {
  static img.BitmapFont? bitmapkanit;

  static Future<img.BitmapFont> load() async {
    if (bitmapkanit != null) return bitmapkanit!;

    // โหลด fnt
    final fontdata = await rootBundle.loadString('assets/fonts/bitmap-kanit.fnt');

    // โหลด png
    final imagedata = await rootBundle.load('assets/fonts/bitmap-kanit_0.png');

    // decode Uint8List → img.Image
    final img.Image? fontimage = img.decodeImage(imagedata.buffer.asUint8List());

    if (fontimage == null) {
      throw Exception('Decode bitmap-kanit_0.png failed');
    }

    // ส่ง img.Image เข้าไป
    bitmapkanit = img.BitmapFont.fromFnt(fontdata, fontimage);

    return bitmapkanit!;
  }
}
