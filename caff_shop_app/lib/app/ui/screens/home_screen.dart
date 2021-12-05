import 'package:caff_shop_app/app/models/login_response.dart';
import 'package:caff_shop_app/app/routes/home_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final LoginResponse loginResponse;

  const HomeScreen({Key? key, required this.loginResponse}) : super(key: key);

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
      child: MultiProvider(
        providers: [
          Provider<LoginResponse>(
            create: (_) => widget.loginResponse,
          ),
        ],
        child: Scaffold(
          body: Navigator(
            key: _navigatorKey,
            initialRoute: HomeRoutes.fileList,
            onGenerateRoute: HomeRoutes.onGenerateRoute,
          ),
        ),
      ),
    );
  }
}
