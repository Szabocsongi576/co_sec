import 'dart:developer';

import 'package:caff_shop_app/app/api/api.dart';
import 'package:caff_shop_app/app/api/api_util.dart';
import 'package:caff_shop_app/app/api/interceptors/save_token_interceptor.dart';
import 'package:caff_shop_app/app/models/login_request.dart';
import 'package:caff_shop_app/app/models/login_response.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

Future<void> handleDioError({
  required DioError error,
  required void Function(String) onError,
  required void Function() failedFunction,
}) async {
  log("error:");
  log(error.toString());
  log("Message: ${error.message}");
  log("StatusCode: ${error.response?.statusCode}");

  switch (error.type) {
    case DioErrorType.connectTimeout:
    case DioErrorType.sendTimeout:
    case DioErrorType.receiveTimeout:
      onError(tr("error.timeout"));
      break;
    case DioErrorType.response:
      switch(error.response!.statusCode) {
        case 400:
          if(error.response!.data["message"] != null) {
            onError(error.response!.data["message"]);
          } else {
            onError(tr("error.basic_error"));
          }
          break;
        case 401:
          try {
            LoginRequest request = LoginRequest(
              username: ApiUtil().username!,
              password: ApiUtil().password!,
            );
            Response<LoginResponse> response =
                await Api(interceptors: [SaveBearerTokenInterceptor()])
                .getUserApi()
                .authenticateUser(request);

            if (response.isSuccess()) {
              failedFunction();
            }
          } on DioError catch (_) {
            onError(tr("error.401_unauthorized"));
          }
          break;
        case 404:
          onError(tr("error.404_not_found"));
          break;
        default:
          onError(tr("error.basic_error"));
          break;
      }
      break;
    case DioErrorType.cancel:
      break;
    case DioErrorType.other:
      onError(tr("error.basic_error"));
      break;
  }
}