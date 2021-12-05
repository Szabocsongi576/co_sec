class ConvertedCaff {
  final String id;
  final String userId;
  final String name;
  final String imageUrl;

  ConvertedCaff({
    required this.id,
    required this.userId,
    required this.name,
    required this.imageUrl,
  });

  factory ConvertedCaff.fromJson(Map<String, dynamic> json) {
    return ConvertedCaff(
      id: json["id"],
      userId: json["userId"],
      name: json["name"],
      imageUrl: json["imageUrl"],
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
