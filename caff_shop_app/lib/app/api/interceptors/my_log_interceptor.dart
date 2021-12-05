import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pretty_json/pretty_json.dart';

class MyLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      log("request data:");
      log(
        prettyJson(
          options.data,
          indent: 2,
        ),
      );
    } catch (_) {}

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    try {
      log("status code: ${response.statusCode}");
      log("response data:");
      log(
        prettyJson(
          response.data,
          indent: 2,
        ),
      );
    } catch (_) {}
    super.onResponse(response, handler);
  }
}
