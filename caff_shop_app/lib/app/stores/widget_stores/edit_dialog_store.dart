import 'package:caff_shop_app/app/models/user.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mobx/mobx.dart';
import 'package:validators/validators.dart';

part 'edit_dialog_store.g.dart';

class EditDialogStore = _EditDialogStore with _$EditDialogStore;

abstract class _EditDialogStore with Store {
  _EditDialogStore({required this.user}) {
    _setupDisposers();

    username = user.username;
    email = user.email;
  }

  // disposers:-----------------------------------------------------------------
  late List<ReactionDisposer> _disposers;

  void _setupDisposers() {
    _disposers = [
      reaction((_) => username, (_) {
        usernameError = null;
      }),
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
  String username = "";

  @observable
  String email = "";

  @observable
  String password = "";

  @observable
  String? usernameError;

  @observable
  String? emailError;

  @observable
  String? passwordError;

  final User user;

  // general methods:-----------------------------------------------------------
  void dispose() {
    for (final d in _disposers) {
      d();
    }
  }

  bool validate() {
    bool valid = true;


    if (!isEmail(email)) {
      emailError = tr(
        "error.invalid_content",
        namedArgs: {"field": "email"},
      );
      valid = false;
    }

    return valid;
  }

  User getUser() {
    return User(
      id: user.id,
      username: username.isEmpty ? user.username : username,
      email: email.isEmpty ? user.email : email,
      password: password.isEmpty ? user.password : password,
      roles: user.roles,
    );
  }
}
