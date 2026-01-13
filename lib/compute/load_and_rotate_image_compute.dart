import 'dart:typed_data';
import 'package:image/image.dart' as img;

Future<Uint8List> rotateImageCompute(Map params) async {
  final bytes = params['bytes'] as Uint8List;
  final rotation = params['rotation'] as int;

  img.Image? src = img.decodeImage(bytes);
  if (src == null) return bytes;

  switch (rotation) {
    case 1:
      src = img.copyRotate(src, angle: -90);
      break;
    case 3:
      src = img.copyRotate(src, angle: 90);
      break;
    case 2:
      src = img.copyRotate(src, angle: 180);
      break;
  }

  return Uint8List.fromList(img.encodeJpg(src));
}
