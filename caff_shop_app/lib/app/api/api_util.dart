class ApiUtil {
  static final ApiUtil _instance = ApiUtil._internal();

  factory ApiUtil() {
    return _instance;
  }

  ApiUtil._internal();

  String? baseUrl;

  String? bearerToken;

  String? username;
  String? password;

  void reset() {
    bearerToken = null;
  }
}
