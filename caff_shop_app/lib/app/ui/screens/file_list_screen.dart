import 'package:caff_shop_app/app/api/api_util.dart';
import 'package:caff_shop_app/app/config/color_constants.dart';
import 'package:caff_shop_app/app/models/caff_request.dart';
import 'package:caff_shop_app/app/models/converted_caff.dart';
import 'package:caff_shop_app/app/models/role_type.dart';
import 'package:caff_shop_app/app/routes/home_routes.dart';
import 'package:caff_shop_app/app/routes/routes.dart';
import 'package:caff_shop_app/app/stores/screen_stores/file_list_store.dart';
import 'package:caff_shop_app/app/ui/widget/caff_list_item.dart';
import 'package:caff_shop_app/app/ui/widget/loading.dart';
import 'package:caff_shop_app/app/ui/widget/upload_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FileListScreen extends StatefulWidget {
  const FileListScreen({Key? key}) : super(key: key);

  @override
  _FileListScreenState createState() => _FileListScreenState();
}

class _FileListScreenState extends State<FileListScreen> {
  late final FileListStore _store;

  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _store = FileListStore(
      isAdmin:
          ApiUtil().loginResponse?.roles.contains(RoleType.ROLE_ADMIN) ?? false,
    );
    _store.getCaffFiles(onError: _showSnackBar);

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
        title: Text(tr('appbar.caff_browser')),
        automaticallyImplyLeading: false,
        actions: [
          if (_store.isAdmin)
            IconButton(
              padding: EdgeInsets.all(10.r),
              visualDensity: VisualDensity(
                horizontal: -4.0,
                vertical: -4.0,
              ),
              onPressed: _onUserListTap,
              icon: Icon(Icons.people),
            ),
          if (ApiUtil().loginResponse != null)
            IconButton(
              padding: EdgeInsets.all(10.r),
              visualDensity: VisualDensity(
                horizontal: -4.0,
                vertical: -4.0,
              ),
              onPressed: _onProfileTap,
              icon: Icon(Icons.person),
            ),
          if (ApiUtil().loginResponse == null)
            IconButton(
              padding: EdgeInsets.all(10.r),
              visualDensity: VisualDensity(
                horizontal: -4.0,
                vertical: -4.0,
              ),
              onPressed: _onLogoutTap,
              icon: Icon(Icons.logout),
            ),
        ],
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
                  builder: (_) => IconButton(
                    onPressed: () => !_store.focused && !_store.empty
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
              builder: (_) => GridView.count(
                primary: false,
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisSpacing: 10.r,
                crossAxisSpacing: 10.r,
                children: _store.caffList.map((ConvertedCaff caff) {
                  return CaffListItem(
                    caff: caff,
                    onTap: () => _onItemTap(caff),
                    onDelete:
                        _store.isAdmin ? () => _onItemDeleteTap(caff) : null,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: (ApiUtil().loginResponse != null)
          ? FloatingActionButton(
              child: Icon(
                Icons.file_upload,
                color: ColorConstants.white,
              ),
              onPressed: () => _onFABPressed(
                id: ApiUtil().loginResponse!.id,
              ),
            )
          : null,
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

  Future<void> _onItemTap(ConvertedCaff caff) async {
    bool? result = await Navigator.of(context)
        .pushNamed(HomeRoutes.fileDetails, arguments: caff) as bool?;

    if (result ?? false) {
      await Future.delayed(Duration(milliseconds: 300));
      await _store.deleteCaff(
        caffId: caff.id,
        onSuccess: (response) => _showSnackBar(response.message),
        onError: _showSnackBar,
      );
    } else {
      _store.getCaffFiles(
        onError: _showSnackBar,
      );
    }
  }

  Future<void> _onItemDeleteTap(ConvertedCaff caff) async {
    await _store.deleteCaff(
      caffId: caff.id,
      onSuccess: (response) => _showSnackBar(response.message),
      onError: _showSnackBar,
    );
  }

  Future<void> _onFABPressed({
    required String id,
  }) async {
    CaffRequest? resource = await showDialog(
      context: context,
      builder: (context) => UploadDialog(),
    );

    if (resource != null) {
      _store.createCaff(
        userId: id,
        resource: resource,
        onSuccess: (message) {
          _showSnackBar(message.message);
          _store.getCaffFiles(
            onError: _showSnackBar,
          );
        },
        onError: _showSnackBar,
      );
    }
  }

  void _onUserListTap() {
    Navigator.of(context).pushNamed(HomeRoutes.userList);
    _store.getCaffFiles(
      onError: _showSnackBar,
    );
  }

  void _onProfileTap() {
    Navigator.of(context).pushNamed(HomeRoutes.profile);
    _store.getCaffFiles(
      onError: _showSnackBar,
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

  void _onSearchTap() {
    FocusScope.of(context).unfocus();
  }

  void _onCleanTap() {
    _textEditingController.text = "";
    _store.term = "";
    _search();
  }

  void _search() {
    _store.getCaffFiles(onError: _showSnackBar);
  }
}
