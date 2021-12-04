import 'package:caff_shop_app/app/api/api_util.dart';
import 'package:caff_shop_app/app/api/caff_api.dart';
import 'package:caff_shop_app/app/api/interceptors/my_log_interceptor.dart';
import 'package:caff_shop_app/app/api/user_api.dart';
import 'package:dio/dio.dart';

class Api {
  late final Dio dio;

  Api({
    List<Interceptor>? interceptors,
  }) {
    this.dio = Dio(
      BaseOptions(
        baseUrl: ApiUtil().baseUrl!,
        connectTimeout: 8000,
        receiveTimeout: 8000,
      ),
    );

    this.dio.interceptors.add(MyLogInterceptor());
    if(interceptors != null) {
      this.dio.interceptors.addAll(interceptors);
    }
  }

  CaffApi getCaffApi() {
    return CaffApi(dio);
  }

  UserApi getUserApi() {
    return UserApi(dio);
  }
}

extension isSuccessResponseExtension on Response {
  bool isSuccess() {
    return this.statusCode! >= 200 && this.statusCode! < 300;
  }
}
