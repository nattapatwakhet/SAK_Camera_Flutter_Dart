// ignore_for_file: non_constant_identifier_names, constant_identifier_names, public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LoginModel {
  final String ID_personnel;
  LoginModel({required this.ID_personnel});

  LoginModel copyWith({String? ID_personnel}) {
    return LoginModel(ID_personnel: ID_personnel ?? this.ID_personnel);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'ID_personnel': ID_personnel};
  }

  factory LoginModel.fromMap(Map<String, dynamic> map) {
    return LoginModel(ID_personnel: map['ID_personnel'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory LoginModel.fromJson(String source) =>
      LoginModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'LoginModel(ID_personnel: $ID_personnel)';

  @override
  bool operator ==(covariant LoginModel other) {
    if (identical(this, other)) return true;

    return other.ID_personnel == ID_personnel;
  }

  @override
  int get hashCode => ID_personnel.hashCode;
}
