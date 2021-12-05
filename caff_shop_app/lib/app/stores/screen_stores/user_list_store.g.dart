// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_list_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UserListStore on _UserListStore, Store {
  final _$termAtom = Atom(name: '_UserListStore.term');

  @override
  String get term {
    _$termAtom.reportRead();
    return super.term;
  }

  @override
  set term(String value) {
    _$termAtom.reportWrite(value, super.term, () {
      super.term = value;
    });
  }

  final _$focusedAtom = Atom(name: '_UserListStore.focused');

  @override
  bool get focused {
    _$focusedAtom.reportRead();
    return super.focused;
  }

  @override
  set focused(bool value) {
    _$focusedAtom.reportWrite(value, super.focused, () {
      super.focused = value;
    });
  }

  final _$emptyAtom = Atom(name: '_UserListStore.empty');

  @override
  bool get empty {
    _$emptyAtom.reportRead();
    return super.empty;
  }

  @override
  set empty(bool value) {
    _$emptyAtom.reportWrite(value, super.empty, () {
      super.empty = value;
    });
  }

  final _$userListAtom = Atom(name: '_UserListStore.userList');

  @override
  ObservableList<User> get userList {
    _$userListAtom.reportRead();
    return super.userList;
  }

  @override
  set userList(ObservableList<User> value) {
    _$userListAtom.reportWrite(value, super.userList, () {
      super.userList = value;
    });
  }

  final _$filteredUserListAtom = Atom(name: '_UserListStore.filteredUserList');

  @override
  ObservableList<User> get filteredUserList {
    _$filteredUserListAtom.reportRead();
    return super.filteredUserList;
  }

  @override
  set filteredUserList(ObservableList<User> value) {
    _$filteredUserListAtom.reportWrite(value, super.filteredUserList, () {
      super.filteredUserList = value;
    });
  }

  final _$getUsersAsyncAction = AsyncAction('_UserListStore.getUsers');

  @override
  Future<void> getUsers({required void Function(String) onError}) {
    return _$getUsersAsyncAction.run(() => super.getUsers(onError: onError));
  }

  final _$deleteUserAsyncAction = AsyncAction('_UserListStore.deleteUser');

  @override
  Future<void> deleteUser(
      {required String userId,
      required void Function(MessageResponse) onSuccess,
      required void Function(String) onError}) {
    return _$deleteUserAsyncAction.run(() => super
        .deleteUser(userId: userId, onSuccess: onSuccess, onError: onError));
  }

  @override
  String toString() {
    return '''
term: ${term},
focused: ${focused},
empty: ${empty},
userList: ${userList},
filteredUserList: ${filteredUserList}
    ''';
  }
}
