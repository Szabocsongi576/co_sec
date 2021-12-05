import 'package:caff_shop_app/app/api/api.dart';
import 'package:caff_shop_app/app/api/error_handler.dart';
import 'package:caff_shop_app/app/api/interceptors/save_token_interceptor.dart';
import 'package:caff_shop_app/app/models/login_request.dart';
import 'package:caff_shop_app/app/models/login_response.dart';
import 'package:caff_shop_app/app/models/registration_request.dart';
import 'package:caff_shop_app/app/models/response.dart';
import 'package:caff_shop_app/app/stores/widget_stores/loading_store.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mobx/mobx.dart';
import 'package:validators/validators.dart';

part 'register_store.g.dart';

class RegisterStore = _RegisterStore with _$RegisterStore;

abstract class _RegisterStore with Store {
  final LoadingStore loadingStore = LoadingStore();

  _RegisterStore() {
    _setupDisposers();
  }

  // disposers:-----------------------------------------------------------------
  late List<ReactionDisposer> _disposers;

  void _setupDisposers() {
    _disposers = [
      reaction((_) => email, (_) {
        emailError = null;
      }),
      reaction((_) => email, (_) {
        emailError = null;
      }),
      reaction((_) => password, (_) {
        passwordError = null;
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
  String email = '';

  @observable
  String password = '';

  @observable
  String passwordConfirmation = '';


  @observable
  String? usernameError;

  @observable
  String? emailError;

  @observable
  String? passwordError;

  @observable
  String? passwordConfirmationError;


  @observable
  bool obscurePassword = true;

  @observable
  bool obscurePasswordConfirmation = true;

  // actions:-------------------------------------------------------------------
  @action
  Future<void> register({
    required void Function(MessageResponse) onRegisterSuccess,
    required void Function(LoginResponse) onLoginSuccess,
    required void Function(String) onError,
  }) async {
    if (!validate()) {
      return;
    }

    loadingStore.stackedLoading = true;

    try {
      RegistrationRequest registrationRequest = RegistrationRequest(
          username: username,
          email: email,
          password: password,
      );
      Response<MessageResponse> registrationResponse =
      await Api()
          .getUserApi()
          .registerUser(registrationRequest);

      if (registrationResponse.isSuccess()) {
        onRegisterSuccess(registrationResponse.data!);
      }

      LoginRequest loginRequest = LoginRequest(
        username: username,
        password: password,
      );
      Response<LoginResponse> loginResponse =
      await Api(interceptors: [SaveBearerTokenInterceptor()])
          .getUserApi()
          .authenticateUser(loginRequest);

      if (loginResponse.isSuccess()) {
        onLoginSuccess(loginResponse.data!);
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

    if (email.isEmpty) {
      emailError = tr("error.field_is_empty");
      valid = false;
    } else if (!isEmail(email)) {
      emailError = tr(
        "error.invalid_content",
        namedArgs: {"field": "email"},
      );
      valid = false;
    }

    if (password.isEmpty) {
      passwordError = tr("error.field_is_empty");
      valid = false;
    }

    if (passwordConfirmation.isEmpty) {
      passwordConfirmationError = tr("error.field_is_empty");
      valid = false;
    } else if (passwordConfirmation != password){
      passwordConfirmationError = tr("error.passwords_different");
      valid = false;
    }

    return valid;
  }
}
