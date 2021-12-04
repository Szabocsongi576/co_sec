import 'dart:io';

import 'package:caff_shop_app/app/exceptions/my_exception.dart';
import 'package:caff_shop_app/app/services/caff_file_picker_service.dart';
import 'package:mobx/mobx.dart';

part 'upload_dialog_store.g.dart';

class UploadDialogStore = _UploadDialogStore with _$UploadDialogStore;

abstract class _UploadDialogStore with Store {

  // store variables:-----------------------------------------------------------
  @observable
  File? file;

  @observable
  String name = "";

  @observable
  String? error;

  @action
  Future<void> getCaff({
    required void Function(String) onSuccess,
  }) async {
    try {
      File? caff = await CaffFilePickerService().pickFile();

      if (caff != null) {
        error = null;
        file = caff;

        if(name.isEmpty) {
          List<String> parts = caff.path.split('/');
          String newName = parts.last.split('.')[0];
          onSuccess(newName);
        }
      }
    } on MyException catch (e) {
      error = e.message;
    }
  }

  bool validate() {
    return error == null;
  }
}
