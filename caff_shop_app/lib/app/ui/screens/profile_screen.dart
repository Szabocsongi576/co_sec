import 'package:caff_shop_app/app/api/api_util.dart';
import 'package:caff_shop_app/app/routes/routes.dart';
import 'package:caff_shop_app/app/stores/screen_stores/profile_store.dart';
import 'package:caff_shop_app/app/ui/widget/loading.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileStore _store = ProfileStore();

  @override
  Widget build(BuildContext context) {
    return Loading(
      store: _store.loadingStore,
      isExpandable: false,
      appBar: AppBar(
        title: Text(tr('appbar.profile')),
        actions: [
          IconButton(
            onPressed: _onLogoutTap,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20.r),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    tr("hint.username"),
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    ApiUtil().loginResponse!.username,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.r),
            Row(
              children: [
                Expanded(
                  child: Text(
                    tr("hint.email"),
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    ApiUtil().loginResponse!.email,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onLogoutTap() {
    _store.logout(
      onSuccess: () {
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.of(context, rootNavigator: true)
            .pushReplacementNamed(Routes.login);
      },
    );
  }
}
