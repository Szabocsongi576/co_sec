// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_list_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FileListStore on _FileListStore, Store {
  final _$caffSrcListAtom = Atom(name: '_FileListStore.caffSrcList');

  @override
  ObservableList<String> get caffSrcList {
    _$caffSrcListAtom.reportRead();
    return super.caffSrcList;
  }

  @override
  set caffSrcList(ObservableList<String> value) {
    _$caffSrcListAtom.reportWrite(value, super.caffSrcList, () {
      super.caffSrcList = value;
    });
  }

  final _$getCaffFilesAsyncAction = AsyncAction('_FileListStore.getCaffFiles');

  @override
  Future<void> getCaffFiles({required void Function(String) onError}) {
    return _$getCaffFilesAsyncAction
        .run(() => super.getCaffFiles(onError: onError));
  }

  @override
  String toString() {
    return '''
caffSrcList: ${caffSrcList}
    ''';
  }
}
