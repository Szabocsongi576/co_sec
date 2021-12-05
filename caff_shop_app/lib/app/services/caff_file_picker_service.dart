import 'dart:io';

import 'package:caff_shop_app/app/exceptions/my_exception.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';

class CaffFilePickerService {
  Future<File?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
    );

    File? file;
    if (result != null) {
      String path = result.files.single.name;
      String extension = path.split('.')[1];

      if(extension == 'caff') {
        file = File(result.files.single.path!);
      } else {
        throw MyException(message: tr('error.extension'));
      }
    }

    return file;
  }
}