// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_dialog_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UploadDialogStore on _UploadDialogStore, Store {
  final _$fileAtom = Atom(name: '_UploadDialogStore.file');

  @override
  File? get file {
    _$fileAtom.reportRead();
    return super.file;
  }

  @override
  set file(File? value) {
    _$fileAtom.reportWrite(value, super.file, () {
      super.file = value;
    });
  }

  final _$nameAtom = Atom(name: '_UploadDialogStore.name');

  @override
  String get name {
    _$nameAtom.reportRead();
    return super.name;
  }

  @override
  set name(String value) {
    _$nameAtom.reportWrite(value, super.name, () {
      super.name = value;
    });
  }

  final _$errorAtom = Atom(name: '_UploadDialogStore.error');

  @override
  String? get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(String? value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  final _$getCaffAsyncAction = AsyncAction('_UploadDialogStore.getCaff');

  @override
  Future<void> getCaff({required void Function(String) onSuccess}) {
    return _$getCaffAsyncAction.run(() => super.getCaff(onSuccess: onSuccess));
  }

  @override
  String toString() {
    return '''
file: ${file},
name: ${name},
error: ${error}
    ''';
  }
}
