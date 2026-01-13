// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AddressModel {
  final String placeid;
  
  AddressModel({required this.placeid});

  AddressModel copyWith({String? placeid}) {
    return AddressModel(placeid: placeid ?? this.placeid);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'place_id': placeid};
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(placeid: map['place_id'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory AddressModel.fromJson(String source) =>
      AddressModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AddressModel(placeid: $placeid)';

  @override
  bool operator ==(covariant AddressModel other) {
    if (identical(this, other)) return true;

    return other.placeid == placeid;
  }

  @override
  int get hashCode => placeid.hashCode;
}
