import 'package:caff_shop_app/app/models/user.dart';
import 'package:caff_shop_app/app/routes/home_routes.dart';
import 'package:caff_shop_app/app/stores/screen_stores/user_list_store.dart';
import 'package:caff_shop_app/app/ui/widget/loading.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late final UserListStore _store = UserListStore();

  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _store.getUsers(onError: _showSnackBar);

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _store.focused = false;
        _search();
      } else {
        _store.focused = true;
      }
    });
    _textEditingController.addListener(() {
      if (_textEditingController.text.isEmpty) {
        _store.empty = true;
      } else {
        _store.empty = false;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Loading(
      store: _store.loadingStore,
      isExpandable: false,
      appBar: AppBar(
        title: Text(tr('appbar.users')),
      ),
      body: Container(
        padding: EdgeInsets.all(20.r),
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _textEditingController,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      hintText: tr("hint.search"),
                    ),
                    onChanged: (value) => _store.term = value,
                  ),
                ),
                Observer(
                  builder: (_) =>
                      IconButton(
                        onPressed: () =>
                        !_store.focused && !_store.empty
                            ? _onCleanTap()
                            : _onSearchTap(),
                        icon: Icon(!_store.focused && !_store.empty
                            ? Icons.close
                            : Icons.search),
                      ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Observer(
              builder: (_) =>
                  ListView.separated(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: _store.filteredUserList.length,
                    separatorBuilder: (context, index) => Divider(),
                    itemBuilder: (context, index) {
                      User user = _store.filteredUserList[index];

                      return ListTile(
                        title: Text(
                          user.username,
                          style: Theme
                              .of(context)
                              .textTheme
                              .subtitle1,
                        ),
                        trailing: IconButton(
                          onPressed: () => _onItemDeleteTap(user),
                          icon: Icon(
                            Icons.delete,
                          ),
                        ),
                        onTap: () => _onItemTap(user),
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }

  //general methods:------------------------------------------------------------
  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  Future<void> _onItemTap(User user) async {
    bool? result = await Navigator.of(context)
        .pushNamed(HomeRoutes.userDetails, arguments: user) as bool?;

    if (result ?? false) {
      await Future.delayed(Duration(milliseconds: 300));
      await _store.deleteUser(
        userId: user.id,
        onSuccess: (response) => _showSnackBar(response.message),
        onError: _showSnackBar,
      );
    } else {
      _store.getUsers(
        onError: _showSnackBar,
      );
    }
  }

  Future<void> _onItemDeleteTap(User user) async {
    await _store.deleteUser(
      userId: user.id,
      onSuccess: (response) => _showSnackBar(response.message),
      onError: _showSnackBar,
    );
  }

  void _onSearchTap() {
    FocusScope.of(context).unfocus();
  }

  void _onCleanTap() {
    _textEditingController.text = "";
    _store.term = "";
    _search();
  }

  void _search() {
    _store.filterUsers();
  }
}
