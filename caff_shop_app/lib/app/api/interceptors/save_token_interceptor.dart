import 'package:caff_shop_app/app/api/api_util.dart';
import 'package:caff_shop_app/app/models/login_response.dart';
import 'package:dio/dio.dart';

class SaveBearerTokenInterceptor extends Interceptor {
  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    LoginResponse resource = LoginResponse.fromJson(response.data);

    ApiUtil().bearerToken = resource.accessToken;

    super.onResponse(response, handler);
  }
}
