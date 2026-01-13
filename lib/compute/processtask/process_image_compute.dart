class ProcessImage {
  final String rawfilepath;
  int step;
  String? processedfilepath;
  int? rotationangle;

  ProcessImage({
    required this.rawfilepath,
    this.step = 0,
    this.processedfilepath,
    this.rotationangle,
  });

  // JSON encode/decode สำหรับ queue
  Map<String, dynamic> toJson() => {
    'rawfilepath': rawfilepath,
    'step': step,
    'rotationangle': rotationangle,
    'processedfilepath': processedfilepath,
  };

  factory ProcessImage.fromJson(Map<String, dynamic> json) {
    return ProcessImage(
      rawfilepath: json['rawfilepath'],
      step: json['step'],
      rotationangle: json['rotationangle'],
      processedfilepath: json['processedfilepath'],
    );
  }
}
