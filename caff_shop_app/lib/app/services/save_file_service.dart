import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

class SaveFileService {
  Future<void> saveCaff(Uint8List bytes, String name) async {
    Directory? externalStorageDirectory = await getExternalStorageDirectory();
    String path = externalStorageDirectory!.path;

    String filePath = '$path/${name.toLowerCase().replaceAll(' ', '_')}.caff';

    File file = await File(filePath).create(recursive: true);
    file.writeAsBytes(bytes);
  }
}