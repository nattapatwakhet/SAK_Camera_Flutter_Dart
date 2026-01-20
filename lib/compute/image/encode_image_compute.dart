// import 'dart:typed_data';
// import 'package:image/image.dart' as img;

// // Decode -> Encode ใหม่ให้แน่ใจว่าเป็น JPG ที่ดี
// Uint8List encodeToJpg(Uint8List imageBytes) {
//   final img.Image? encodeimage = img.decodeImage(imageBytes);
//   if (encodeimage == null) throw 'ไม่สามารถ decode ภาพได้';
//   return Uint8List.fromList(img.encodeJpg(encodeimage, quality: 100));
// }
