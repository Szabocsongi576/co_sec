import 'dart:convert';

import 'package:flutter/services.dart' as rootBundle;

class DataLoadService {
  Future<Map<String, dynamic>> readJson() async {
    final jsonData = await rootBundle.rootBundle.loadString('assets/config/config.json');
    Map<String, dynamic> map = json.decode(jsonData) as Map<String, dynamic>;

    return map;
  }
}