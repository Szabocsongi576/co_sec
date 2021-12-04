class CommentRequest {
  final String userId;
  final String caffId;
  final String text;

  CommentRequest({
    required this.userId,
    required this.caffId,
    required this.text,
  });

  factory CommentRequest.fromJson(Map<String, dynamic> json) {
    return CommentRequest(
      userId: json["userId"],
      caffId: json["caffId"],
      text: json["text"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "caffId": caffId,
      "text": text,
    };
  }
}