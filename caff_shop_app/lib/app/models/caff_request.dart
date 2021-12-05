import 'package:dio/dio.dart';

class CaffRequest {

  final String name;
  final MultipartFile data;

  CaffRequest({
    required this.name,
    required this.data,
  });

  factory CaffRequest.fromJson(Map<String, dynamic> json) {
    return CaffRequest(
      name: json["name"],
      data: json["data"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "data": data,
    };
  }
}