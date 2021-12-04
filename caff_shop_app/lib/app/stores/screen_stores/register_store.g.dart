// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$RegisterStore on _RegisterStore, Store {
  final _$usernameAtom = Atom(name: '_RegisterStore.username');

  @override
  String get username {
    _$usernameAtom.reportRead();
    return super.username;
  }

  @override
  set username(String value) {
    _$usernameAtom.reportWrite(value, super.username, () {
      super.username = value;
    });
  }

  final _$emailAtom = Atom(name: '_RegisterStore.email');

  @override
  String get email {
    _$emailAtom.reportRead();
    return super.email;
  }

  @override
  set email(String value) {
    _$emailAtom.reportWrite(value, super.email, () {
      super.email = value;
    });
  }

  final _$passwordAtom = Atom(name: '_RegisterStore.password');

  @override
  String get password {
    _$passwordAtom.reportRead();
    return super.password;
  }

  @override
  set password(String value) {
    _$passwordAtom.reportWrite(value, super.password, () {
      super.password = value;
    });
  }

  final _$passwordConfirmationAtom =
      Atom(name: '_RegisterStore.passwordConfirmation');

  @override
  String get passwordConfirmation {
    _$passwordConfirmationAtom.reportRead();
    return super.passwordConfirmation;
  }

  @override
  set passwordConfirmation(String value) {
    _$passwordConfirmationAtom.reportWrite(value, super.passwordConfirmation,
        () {
      super.passwordConfirmation = value;
    });
  }

  final _$usernameErrorAtom = Atom(name: '_RegisterStore.usernameError');

  @override
  String? get usernameError {
    _$usernameErrorAtom.reportRead();
    return super.usernameError;
  }

  @override
  set usernameError(String? value) {
    _$usernameErrorAtom.reportWrite(value, super.usernameError, () {
      super.usernameError = value;
    });
  }

  final _$emailErrorAtom = Atom(name: '_RegisterStore.emailError');

  @override
  String? get emailError {
    _$emailErrorAtom.reportRead();
    return super.emailError;
  }

  @override
  set emailError(String? value) {
    _$emailErrorAtom.reportWrite(value, super.emailError, () {
      super.emailError = value;
    });
  }

  final _$passwordErrorAtom = Atom(name: '_RegisterStore.passwordError');

  @override
  String? get passwordError {
    _$passwordErrorAtom.reportRead();
    return super.passwordError;
  }

  @override
  set passwordError(String? value) {
    _$passwordErrorAtom.reportWrite(value, super.passwordError, () {
      super.passwordError = value;
    });
  }

  final _$passwordConfirmationErrorAtom =
      Atom(name: '_RegisterStore.passwordConfirmationError');

  @override
  String? get passwordConfirmationError {
    _$passwordConfirmationErrorAtom.reportRead();
    return super.passwordConfirmationError;
  }

  @override
  set passwordConfirmationError(String? value) {
    _$passwordConfirmationErrorAtom
        .reportWrite(value, super.passwordConfirmationError, () {
      super.passwordConfirmationError = value;
    });
  }

  final _$obscurePasswordAtom = Atom(name: '_RegisterStore.obscurePassword');

  @override
  bool get obscurePassword {
    _$obscurePasswordAtom.reportRead();
    return super.obscurePassword;
  }

  @override
  set obscurePassword(bool value) {
    _$obscurePasswordAtom.reportWrite(value, super.obscurePassword, () {
      super.obscurePassword = value;
    });
  }

  final _$obscurePasswordConfirmationAtom =
      Atom(name: '_RegisterStore.obscurePasswordConfirmation');

  @override
  bool get obscurePasswordConfirmation {
    _$obscurePasswordConfirmationAtom.reportRead();
    return super.obscurePasswordConfirmation;
  }

  @override
  set obscurePasswordConfirmation(bool value) {
    _$obscurePasswordConfirmationAtom
        .reportWrite(value, super.obscurePasswordConfirmation, () {
      super.obscurePasswordConfirmation = value;
    });
  }

  final _$registerAsyncAction = AsyncAction('_RegisterStore.register');

  @override
  Future<void> register(
      {required void Function(MessageResponse) onRegisterSuccess,
      required void Function(LoginResponse) onLoginSuccess,
      required void Function(String) onError}) {
    return _$registerAsyncAction.run(() => super.register(
        onRegisterSuccess: onRegisterSuccess,
        onLoginSuccess: onLoginSuccess,
        onError: onError));
  }

  @override
  String toString() {
    return '''
username: ${username},
email: ${email},
password: ${password},
passwordConfirmation: ${passwordConfirmation},
usernameError: ${usernameError},
emailError: ${emailError},
passwordError: ${passwordError},
passwordConfirmationError: ${passwordConfirmationError},
obscurePassword: ${obscurePassword},
obscurePasswordConfirmation: ${obscurePasswordConfirmation}
    ''';
  }
}
