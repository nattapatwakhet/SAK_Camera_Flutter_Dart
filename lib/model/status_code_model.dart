// ignore_for_file: non_constant_identifier_names, constant_identifier_names, public_member_api_docs, sort_constructors_first
import 'dart:convert';

class StatusAndMessageModel {
  final int status;
  final String message;
  final dynamic dataildata;
  StatusAndMessageModel({required this.status, required this.message, required this.dataildata});

  StatusAndMessageModel copyWith({int? status, String? message, dynamic dataildata}) {
    return StatusAndMessageModel(
      status: status ?? this.status,
      message: message ?? this.message,
      dataildata: dataildata ?? this.dataildata,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'status': status, 'message': message, 'dataildata': dataildata};
  }

  factory StatusAndMessageModel.fromMap(Map<String, dynamic> map) {
    return StatusAndMessageModel(
      status: map['status'] ?? 0,
      message: map['message'] ?? '',
      dataildata: map['dataildata'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory StatusAndMessageModel.fromJson(String source) =>
      StatusAndMessageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'StatusAndMessageModel(status: $status, message: $message, dataildata: $dataildata)';

  @override
  bool operator ==(covariant StatusAndMessageModel other) {
    if (identical(this, other)) return true;

    return other.status == status && other.message == message && other.dataildata == dataildata;
  }

  @override
  int get hashCode => status.hashCode ^ message.hashCode ^ dataildata.hashCode;
}
