// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MarginDrawImg {
  final String name;
  final double xtop;
  final double xbottom;
  final double yleft;
  final double yright;
  final double angle;
  MarginDrawImg({
    required this.name,
    required this.xtop,
    required this.xbottom,
    required this.yleft,
    required this.yright,
    required this.angle,
  });

  MarginDrawImg copyWith({
    String? name,
    double? xtop,
    double? xbottom,
    double? yleft,
    double? yright,
    double? angle,
  }) {
    return MarginDrawImg(
      name: name ?? this.name,
      xtop: xtop ?? this.xtop,
      xbottom: xbottom ?? this.xbottom,
      yleft: yleft ?? this.yleft,
      yright: yright ?? this.yright,
      angle: angle ?? this.angle,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'xtop': xtop,
      'xbottom': xbottom,
      'yleft': yleft,
      'yright': yright,
      'angle': angle,
    };
  }

  factory MarginDrawImg.fromMap(Map<String, dynamic> map) {
    return MarginDrawImg(
      name: map['name'] ?? '',
      xtop: map['xtop'] ?? 0,
      xbottom: map['xbottom'] ?? 0,
      yleft: map['yleft'] ?? 0,
      yright: map['yright'] ?? 0,
      angle: map['angle'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory MarginDrawImg.fromJson(String source) =>
      MarginDrawImg.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'margindrawimg(name: $name, xtop: $xtop, xbottom: $xbottom, yleft: $yleft, yright: $yright, angle: $angle)';
  }

  @override
  bool operator ==(covariant MarginDrawImg other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.xtop == xtop &&
        other.xbottom == xbottom &&
        other.yleft == yleft &&
        other.yright == yright &&
        other.angle == angle;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        xtop.hashCode ^
        xbottom.hashCode ^
        yleft.hashCode ^
        yright.hashCode ^
        angle.hashCode;
  }
}
