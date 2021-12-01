import 'dart:io';

import 'package:mobx/mobx.dart';

part 'upload_dialog_store.g.dart';

class UploadDialogStore = _UploadDialogStore with _$UploadDialogStore;

abstract class _UploadDialogStore with Store {

  // store variables:-----------------------------------------------------------
  @observable
  File? file;
}
