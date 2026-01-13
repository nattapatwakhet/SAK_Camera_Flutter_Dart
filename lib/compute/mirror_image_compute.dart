import 'dart:typed_data';
import 'package:image/image.dart' as img;

// ฟังก์ชันสำหรับ mirror ภาพ
Uint8List mirrorImageBytes(Uint8List bytes) {
  final mirrorimage = img.decodeImage(bytes);
  if (mirrorimage != null) {
    final mirrored = img.flipHorizontal(mirrorimage);
    return Uint8List.fromList(img.encodeJpg(mirrored));
  }
  return bytes;
}
