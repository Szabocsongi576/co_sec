import 'package:caff_shop_app/app/api/api.dart';
import 'package:caff_shop_app/app/api/api_util.dart';
import 'package:caff_shop_app/app/api/error_handler.dart';
import 'package:caff_shop_app/app/api/interceptors/save_token_interceptor.dart';
import 'package:caff_shop_app/app/models/login_request.dart';
import 'package:caff_shop_app/app/models/login_response.dart';
import 'package:caff_shop_app/app/services/data_load_service.dart';
import 'package:caff_shop_app/app/stores/widget_stores/loading_store.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mobx/mobx.dart';
import 'package:validators/validators.dart';

part 'login_store.g.dart';

class LoginStore = _LoginStore with _$LoginStore;

abstract class _LoginStore with Store {
  final LoadingStore loadingStore = LoadingStore();

  _LoginStore() {
    _setupDisposers();
  }

  // disposers:-----------------------------------------------------------------
  late List<ReactionDisposer> _disposers;

  void _setupDisposers() {
    _disposers = [
      reaction((_) => username, (_) {
        usernameError = null;
      }),
      reaction((_) => password, (_) {
        passwordError = null;
      }),
    ];
  }

  // store variables:-----------------------------------------------------------
  @observable
  String username = '';

  @observable
  String password = '';

  @observable
  String? usernameError;

  @observable
  String? passwordError;

  @observable
  bool obscurePassword = true;

  // actions:-------------------------------------------------------------------
  @action
  Future<void> init() async {
    if(ApiUtil().baseUrl == null) {
      loadingStore.loading = true;

      DataLoadService loadService = DataLoadService();
      Map<String, dynamic> map = await loadService.readJson();

      ApiUtil().baseUrl = "http://${map['ip']}:${map['port']}";

      loadingStore.loading = false;
    }
  }

  @action
  Future<void> login({
    required void Function(LoginResponse) onSuccess,
    required void Function(String) onError,
  }) async {
    if (!validate()) {
      return;
    }

    loadingStore.stackedLoading = true;

    try {
      LoginRequest request = LoginRequest(
        username: username,
        password: password,
      );
      Response<LoginResponse> response =
      await Api(interceptors: [SaveBearerTokenInterceptor()])
          .getUserApi()
          .authenticateUser(request);

      if (response.isSuccess()) {
        onSuccess(response.data!);
      }
    } on DioError catch (error) {
      handleDioError(
        error: error,
        onError: onError,
      );
    }

    loadingStore.stackedLoading = false;
  }

  // general methods:-----------------------------------------------------------
  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }

  bool validate() {
    bool valid = true;

    if (username.isEmpty) {
      usernameError = tr("error.field_is_empty");
      valid = false;
    }

    if (password.isEmpty) {
      passwordError = tr("error.field_is_empty");
      valid = false;
    }

    return valid;
  }
}
