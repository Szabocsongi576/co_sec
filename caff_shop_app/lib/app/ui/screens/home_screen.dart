import 'package:caff_shop_app/app/routes/home_routes.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late final GlobalObjectKey<NavigatorState> _navigatorKey;

  @override
  void initState() {
    super.initState();
    _navigatorKey = GlobalObjectKey<NavigatorState>(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_navigatorKey.currentState!.canPop()) {
          _navigatorKey.currentState!.pop();
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: Navigator(
          key: _navigatorKey,
          initialRoute: HomeRoutes.fileList,
          onGenerateRoute: HomeRoutes.onGenerateRoute,
        ),
      ),
    );
  }
}
