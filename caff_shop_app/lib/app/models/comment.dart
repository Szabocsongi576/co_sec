class Comment {
  final String id;
  final String userId;
  final String caffId;
  final String username;
  final String text;

  Comment({
    required this.id,
    required this.userId,
    required this.caffId,
    required this.username,
    required this.text,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json["id"],
      userId: json["userId"],
      caffId: json["caffId"],
      username: json["username"],
      text: json["text"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "caffId": caffId,
      "username": username,
      "text": text,
    };
  }
}
