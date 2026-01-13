import 'dart:typed_data';
import 'package:image/image.dart' as img;

Uint8List forcePortrait(Uint8List bytes) {
  // decode ปกติ (ไม่มี EXIF auto rotate ใน image 4.x)
  final image = img.decodeImage(bytes);
  if (image == null) return bytes;

  img.Image corrected = image;

  // ถ้ายังเป็น landscape → หมุนให้เป็น portrait
  if (corrected.width > corrected.height) {
    corrected = img.copyRotate(corrected, angle: 90);
  }

  // encode ใหม่ทิ้ง EXIF ทั้งหมด
  return Uint8List.fromList(img.encodeJpg(corrected, quality: 95));
}
