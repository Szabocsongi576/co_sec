// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_details_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UserDetailsStore on _UserDetailsStore, Store {
  final _$userAtom = Atom(name: '_UserDetailsStore.user');

  @override
  User get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(User value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  final _$editUserAsyncAction = AsyncAction('_UserDetailsStore.editUser');

  @override
  Future<void> editUser(
      {required User editedUser,
      required void Function(MessageResponse) onSuccess,
      required void Function(String) onError}) {
    return _$editUserAsyncAction.run(() => super.editUser(
        editedUser: editedUser, onSuccess: onSuccess, onError: onError));
  }

  @override
  String toString() {
    return '''
user: ${user}
    ''';
  }
}
