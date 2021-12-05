import 'package:caff_shop_app/app/api/api_util.dart';
import 'package:caff_shop_app/app/models/login_request.dart';
import 'package:caff_shop_app/app/models/login_response.dart';
import 'package:dio/dio.dart';

class SaveBearerTokenInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    LoginRequest resource = LoginRequest.fromJson(options.data);

    ApiUtil().username = resource.username;
    ApiUtil().password = resource.password;

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    LoginResponse resource = LoginResponse.fromJson(response.data);

    ApiUtil().bearerToken = resource.accessToken;

    return super.onResponse(response, handler);
  }
}
