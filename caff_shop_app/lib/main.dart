import 'package:caff_shop_app/app/app.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setEnabledSystemUIOverlays([
    SystemUiOverlay.bottom,
    SystemUiOverlay.top,
  ]);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en', 'EN')],
      path: 'assets/translations',
      fallbackLocale: Locale('en', 'EN'),
      startLocale: Locale('en', 'EN'),
      saveLocale: true,
      child: MyApp(),
    ),
  );
}