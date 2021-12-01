import 'package:caff_shop_app/app/ui/screens/file_details_screen.dart';
import 'package:caff_shop_app/app/ui/screens/file_list_screen.dart';
import 'package:caff_shop_app/app/ui/screens/profile_screen.dart';
import 'package:caff_shop_app/app/ui/screens/user_details_screen.dart';
import 'package:caff_shop_app/app/ui/screens/user_list_screen.dart';
import 'package:flutter/material.dart';

class HomeRoutes {
  static const String fileList = '/file_list';
  static const String fileDetails = '/file_details';
  static const String profile = '/profile';
  static const String userList = '/userList';
  static const String userDetails = '/user_details';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final page = settings.name!;

    switch (page) {
      case fileList:
        return PageRouteBuilder<dynamic>(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => FileListScreen(),
          transitionDuration: Duration(milliseconds: 300),
          transitionsBuilder: _fadeTransitionsBuilder,
        );
      case fileDetails:
        return PageRouteBuilder<dynamic>(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => FileDetailsScreen(
            url: settings.arguments as String,
          ),
          transitionDuration: Duration(milliseconds: 300),
          transitionsBuilder: _slideTransitionsBuilder,
        );
      case profile:
        return PageRouteBuilder<dynamic>(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => ProfileScreen(),
          transitionDuration: Duration(milliseconds: 300),
          transitionsBuilder: _fadeTransitionsBuilder,
        );
      case userList:
        return PageRouteBuilder<dynamic>(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => UserListScreen(),
          transitionDuration: Duration(milliseconds: 300),
          transitionsBuilder: _fadeTransitionsBuilder,
        );
      case userDetails:
        return PageRouteBuilder<dynamic>(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => UserDetailsScreen(),
          transitionDuration: Duration(milliseconds: 300),
          transitionsBuilder: _slideTransitionsBuilder,
        );
      default:
        return null;
    }
  }

  static Widget _fadeTransitionsBuilder(context, animation, secondaryAnimation, child) {
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

  static Widget _slideTransitionsBuilder(context, animation, secondaryAnimation, child) {
    var tween = Tween(
      begin: Offset(1.0, 0.0),
      end: Offset.zero,
    ).chain(
      CurveTween(curve: Curves.easeOut),
    );

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }
}