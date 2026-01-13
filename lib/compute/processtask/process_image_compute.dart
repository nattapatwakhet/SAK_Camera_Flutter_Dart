import 'dart:convert';
import 'dart:typed_data';

class ProcessImage {
  final String rawfilepath;
  final String filename;
  int step;
  String? processedfilepath;
  int? rotationangle;
  Uint8List? mapbytes;

  Uint8List? textoverlaybytes;

  ProcessImage({
    required this.rawfilepath,
    required this.filename,
    this.step = 0,
    this.processedfilepath,
    this.rotationangle,
    this.mapbytes,

    this.textoverlaybytes,
  });

  // JSON encode/decode สำหรับ queue
  Map<String, dynamic> toJson() => {
    'rawfilepath': rawfilepath,
    'filename': filename,
    'step': step,
    'rotationangle': rotationangle,
    'processedfilepath': processedfilepath,
    'mapbytes': mapbytes != null ? base64Encode(mapbytes!) : null,
    'textoverlaybytes': textoverlaybytes != null ? base64Encode(textoverlaybytes!) : null,
  };

  factory ProcessImage.fromJson(Map<String, dynamic> json) {
    return ProcessImage(
      rawfilepath: json['rawfilepath'],
      filename: json['filename'],
      step: json['step'],
      rotationangle: json['rotationangle'],
      processedfilepath: json['processedfilepath'],
      mapbytes: json['mapbytes'] != null ? base64Decode(json['mapbytes']) : null,
      textoverlaybytes: json['textoverlaybytes'] != null
          ? base64Decode(json['textoverlaybytes'])
          : null,
    );
  }
}
