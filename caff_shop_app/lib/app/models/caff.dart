import 'package:dio/dio.dart';

class Caff {
  final String id;
  final String userId;
  final String name;
  final MultipartFile data;

  Caff({
    required this.id,
    required this.userId,
    required this.name,
    required this.data,
  });

  factory Caff.fromJson(Map<String, dynamic> json) {
    return Caff(
      id: json["id"],
      userId: json["userId"],
      name: json["name"],
      data: MultipartFile.fromString(json["data"]["data"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "name": name,
    };
  }
}
