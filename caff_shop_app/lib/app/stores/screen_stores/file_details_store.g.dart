// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_details_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FileDetailsStore on _FileDetailsStore, Store {
  final _$textAtom = Atom(name: '_FileDetailsStore.text');

  @override
  String get text {
    _$textAtom.reportRead();
    return super.text;
  }

  @override
  set text(String value) {
    _$textAtom.reportWrite(value, super.text, () {
      super.text = value;
    });
  }

  final _$commentsAtom = Atom(name: '_FileDetailsStore.comments');

  @override
  ObservableList<Comment> get comments {
    _$commentsAtom.reportRead();
    return super.comments;
  }

  @override
  set comments(ObservableList<Comment> value) {
    _$commentsAtom.reportWrite(value, super.comments, () {
      super.comments = value;
    });
  }

  final _$usersAtom = Atom(name: '_FileDetailsStore.users');

  @override
  ObservableList<User> get users {
    _$usersAtom.reportRead();
    return super.users;
  }

  @override
  set users(ObservableList<User> value) {
    _$usersAtom.reportWrite(value, super.users, () {
      super.users = value;
    });
  }

  final _$initAsyncAction = AsyncAction('_FileDetailsStore.init');

  @override
  Future<void> init({required void Function(String, void Function()) onError}) {
    return _$initAsyncAction.run(() => super.init(onError: onError));
  }

  final _$getCaffDetailsAsyncAction =
      AsyncAction('_FileDetailsStore.getCaffDetails');

  @override
  Future<void> getCaffDetails() {
    return _$getCaffDetailsAsyncAction.run(() => super.getCaffDetails());
  }

  final _$getAllUserAsyncAction = AsyncAction('_FileDetailsStore.getAllUser');

  @override
  Future<void> getAllUser() {
    return _$getAllUserAsyncAction.run(() => super.getAllUser());
  }

  final _$createCommentAsyncAction =
      AsyncAction('_FileDetailsStore.createComment');

  @override
  Future<void> createComment(
      {required String userId,
      required void Function() onSuccess,
      required void Function(String) onError}) {
    return _$createCommentAsyncAction.run(() => super
        .createComment(userId: userId, onSuccess: onSuccess, onError: onError));
  }

  final _$deleteCommentAsyncAction =
      AsyncAction('_FileDetailsStore.deleteComment');

  @override
  Future<void> deleteComment(
      {required String commentId,
      required void Function(MessageResponse) onSuccess,
      required void Function(String) onError}) {
    return _$deleteCommentAsyncAction.run(() => super.deleteComment(
        commentId: commentId, onSuccess: onSuccess, onError: onError));
  }

  final _$downloadCaffAsyncAction =
      AsyncAction('_FileDetailsStore.downloadCaff');

  @override
  Future<void> downloadCaff(
      {required void Function() onSuccess,
      required void Function(String) onError}) {
    return _$downloadCaffAsyncAction
        .run(() => super.downloadCaff(onSuccess: onSuccess, onError: onError));
  }

  @override
  String toString() {
    return '''
text: ${text},
comments: ${comments},
users: ${users}
    ''';
  }
}
