import 'package:image/image.dart' as img;

class PreparedOverlay {
  final img.Image image; // resize + rotate แล้ว
  final int x;
  final int y;

  PreparedOverlay({required this.image, required this.x, required this.y});
}
