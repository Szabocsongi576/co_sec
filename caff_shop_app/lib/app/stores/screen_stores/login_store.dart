import 'package:caff_shop_app/app/stores/widget_stores/loading_store.dart';
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
      reaction((_) => email, (_) {
        emailError = null;
      }),
      reaction((_) => password, (_) {
        passwordError = null;
      }),
    ];
  }

  // store variables:-----------------------------------------------------------
  @observable
  String email = '';

  @observable
  String password = '';

  @observable
  String? emailError;

  @observable
  String? passwordError;

  @observable
  bool obscurePassword = true;

  // actions:-------------------------------------------------------------------
  @action
  Future<void> login({
    required void Function() onSuccess,
    required void Function(String) onError,
  }) async {
    if (!validate()) {
      return;
    }

    loadingStore.stackedLoading = true;

    await Future.delayed(Duration(milliseconds: 500));
    onSuccess();

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

    return valid;
  }
}
