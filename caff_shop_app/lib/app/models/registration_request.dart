class RegistrationRequest {
  final String username;
  final String email;
  final String password;

  RegistrationRequest({
    required this.username,
    required this.email,
    required this.password,
  });

  factory RegistrationRequest.fromJson(Map<String, dynamic> json) {
    return RegistrationRequest(
      username: json["username"],
      email: json["email"],
      password: json["password"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "email": email,
      "password": password,
    };
  }
}
