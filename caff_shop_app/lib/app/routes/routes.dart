import 'package:caff_shop_app/app/ui/screens/home_screen.dart';
import 'package:caff_shop_app/app/ui/screens/login_screen.dart';
import 'package:caff_shop_app/app/ui/screens/register_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final page = settings.name!;

    switch (page) {
      case login:
        return PageRouteBuilder<dynamic>(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) =>
              LoginScreen(),
          transitionDuration: Duration(milliseconds: 300),
          transitionsBuilder: _fadeTransitionsBuilder,
        );
      case register:
        return PageRouteBuilder<dynamic>(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) =>
              RegisterScreen(),
          transitionDuration: Duration(milliseconds: 300),
          transitionsBuilder: _fadeTransitionsBuilder,
        );
      case home:
        return PageRouteBuilder<dynamic>(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(),
          transitionDuration: Duration(milliseconds: 300),
          transitionsBuilder: _fadeTransitionsBuilder,
        );
      default:
        return null;
    }
  }

  static Widget _fadeTransitionsBuilder(
      context, animation, secondaryAnimation, child) {
    var tween = Tween(
      begin: 0.0,
      end: 1.0,
    ).chain(
      CurveTween(curve: Curves.easeOut),
    );

    return FadeTransition(
      opacity: animation.drive(tween),
      child: child,
    );
  }
}
