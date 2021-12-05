import 'package:caff_shop_app/app/config/color_constants.dart';
import 'package:caff_shop_app/app/models/login_response.dart';
import 'package:caff_shop_app/app/models/user.dart';
import 'package:caff_shop_app/app/stores/screen_stores/user_details_store.dart';
import 'package:caff_shop_app/app/ui/widget/edit_dialog.dart';
import 'package:caff_shop_app/app/ui/widget/loading.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class UserDetailsScreen extends StatefulWidget {
  final User user;

  const UserDetailsScreen({Key? key, required this.user}) : super(key: key);

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  late final UserDetailsStore _store;

  @override
  void initState() {
    _store = UserDetailsStore(
      user: widget.user,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Loading(
      store: _store.loadingStore,
      isExpandable: true,
      appBar: AppBar(
        title: Text(tr('appbar.user_profile')),
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete,
              color: ColorConstants.white,
            ),
            onPressed: () => _onUserDeleteTap(),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
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
                      child: Observer(
                        builder: (_) => Text(
                          _store.user.username,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
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
                      child: Observer(
                        builder: (_) => Text(
                          _store.user.email,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.r),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        tr("hint.password"),
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
                        '**********',
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            ElevatedButton(
                onPressed: _onEditTap,
                child: Text(tr('button.edit')),
            )
          ],
        ),
      ),
    );
  }

  //general methods:------------------------------------------------------------
  void _showSnackBar(String text, [void Function()? failedFunction]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        action: failedFunction != null
            ? SnackBarAction(
                onPressed: failedFunction,
                label: tr('refresh'),
              )
            : null,
      ),
    );
  }

  void _onUserDeleteTap() {
    Navigator.of(context).pop(true);
  }

  Future<void> _onEditTap() async {
    User? response = await showDialog(
      context: context,
      builder: (context) => EditDialog(user: _store.user,),
    );

    if (response != null) {
      _store.editUser(
        editedUser: response,
        onSuccess: (response) {
          _showSnackBar(response.message);
        },
        onError: _showSnackBar,
      );
    }
  }
}
