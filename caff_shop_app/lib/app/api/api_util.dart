import 'package:caff_shop_app/app/models/login_response.dart';

class ApiUtil {
  static final ApiUtil _instance = ApiUtil._internal();

  factory ApiUtil() {
    return _instance;
  }

  ApiUtil._internal();

  String? baseUrl;

  LoginResponse? loginResponse;

  String? username;
  String? password;

  void reset() {
    loginResponse = null;
    username = null;
    password = null;
  }
}
