import 'dart:typed_data';

class ProcessImage {
  final String rawfilepath;
  final String filename;

  int step;
  final String? processfilepath;
  final int? rotationangle;

  final Uint8List? mapbytes;
  final Uint8List? textoverlaybytes;

  ProcessImage({
    required this.rawfilepath,
    required this.filename,
    this.step = 0,
    this.processfilepath,
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
    'processedfilepath': processfilepath,
    'mapbytes': mapbytes,
    'textoverlaybytes': textoverlaybytes,
  };

  factory ProcessImage.fromJson(Map<String, dynamic> json) {
    return ProcessImage(
      rawfilepath: json['rawfilepath'],
      filename: json['filename'],
      step: json['step'],
      rotationangle: json['rotationangle'],
      processfilepath: json['processedfilepath'],
      mapbytes: json['mapbytes'],
      textoverlaybytes: json['textoverlaybytes'],
    );
  }
}
