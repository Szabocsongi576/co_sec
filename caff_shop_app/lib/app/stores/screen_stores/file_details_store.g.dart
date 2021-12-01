// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_details_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FileDetailsStore on _FileDetailsStore, Store {
  final _$caffFileAtom = Atom(name: '_FileDetailsStore.caffFile');

  @override
  String? get caffFile {
    _$caffFileAtom.reportRead();
    return super.caffFile;
  }

  @override
  set caffFile(String? value) {
    _$caffFileAtom.reportWrite(value, super.caffFile, () {
      super.caffFile = value;
    });
  }

  final _$commentsAtom = Atom(name: '_FileDetailsStore.comments');

  @override
  List<String> get comments {
    _$commentsAtom.reportRead();
    return super.comments;
  }

  @override
  set comments(List<String> value) {
    _$commentsAtom.reportWrite(value, super.comments, () {
      super.comments = value;
    });
  }

  final _$getCaffDetailsAsyncAction =
      AsyncAction('_FileDetailsStore.getCaffDetails');

  @override
  Future<void> getCaffDetails({required String id}) {
    return _$getCaffDetailsAsyncAction.run(() => super.getCaffDetails(id: id));
  }

  @override
  String toString() {
    return '''
caffFile: ${caffFile},
comments: ${comments}
    ''';
  }
}
