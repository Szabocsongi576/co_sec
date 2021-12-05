class Comment {
  final String id;
  final String userId;
  final String caffId;
  final String text;

  Comment({
    required this.id,
    required this.userId,
    required this.caffId,
    required this.text,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json["id"],
      userId: json["userId"],
      caffId: json["caffId"],
      text: json["text"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "caffId": caffId,
      "text": text,
    };
  }
}
