import 'package:caff_shop_app/app/api/api_util.dart';
import 'package:dio/dio.dart';

class AddTokenInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Authorization'] = 'Bearer ${ApiUtil().bearerToken}';

    return super.onRequest(options, handler);
  }
}