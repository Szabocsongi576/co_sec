import 'package:caff_shop_app/app/config/theme_config.dart';
import 'package:caff_shop_app/app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      builder: () => MaterialApp(
        title: "CAFF Shop",
        theme: ThemeConfig.createTheme(),
        onGenerateRoute: Routes.onGenerateRoute,
        initialRoute: Routes.login,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
      ),
    );
  }
}
