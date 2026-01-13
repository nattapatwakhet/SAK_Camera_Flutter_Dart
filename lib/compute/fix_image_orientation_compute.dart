import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';

//ฟังชันหมุนภาพตามค่า Exif orientation
Future<Uint8List> fixImageOrientation(Uint8List bytes) async {
  final result = await FlutterImageCompress.compressWithList(
    bytes,
    // format: CompressFormat.jpeg,
    // quality: 100,
    autoCorrectionAngle: true, // สำคัญ!
  );
  return result;
}
