// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_list_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FileListStore on _FileListStore, Store {
  final _$termAtom = Atom(name: '_FileListStore.term');

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

  final _$focusedAtom = Atom(name: '_FileListStore.focused');

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

  final _$emptyAtom = Atom(name: '_FileListStore.empty');

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

  final _$caffListAtom = Atom(name: '_FileListStore.caffList');

  @override
  ObservableList<ConvertedCaff> get caffList {
    _$caffListAtom.reportRead();
    return super.caffList;
  }

  @override
  set caffList(ObservableList<ConvertedCaff> value) {
    _$caffListAtom.reportWrite(value, super.caffList, () {
      super.caffList = value;
    });
  }

  final _$getCaffFilesAsyncAction = AsyncAction('_FileListStore.getCaffFiles');

  @override
  Future<void> getCaffFiles({required void Function(String) onError}) {
    return _$getCaffFilesAsyncAction
        .run(() => super.getCaffFiles(onError: onError));
  }

  final _$createCaffAsyncAction = AsyncAction('_FileListStore.createCaff');

  @override
  Future<void> createCaff(
      {required String userId,
      required CaffRequest resource,
      required void Function(MessageResponse) onSuccess,
      required void Function(String) onError}) {
    return _$createCaffAsyncAction.run(() => super.createCaff(
        userId: userId,
        resource: resource,
        onSuccess: onSuccess,
        onError: onError));
  }

  final _$deleteCaffAsyncAction = AsyncAction('_FileListStore.deleteCaff');

  @override
  Future<void> deleteCaff(
      {required String caffId,
      required void Function(MessageResponse) onSuccess,
      required void Function(String) onError}) {
    return _$deleteCaffAsyncAction.run(() => super
        .deleteCaff(caffId: caffId, onSuccess: onSuccess, onError: onError));
  }

  @override
  String toString() {
    return '''
term: ${term},
focused: ${focused},
empty: ${empty},
caffList: ${caffList}
    ''';
  }
}
