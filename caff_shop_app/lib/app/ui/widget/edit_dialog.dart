import 'package:caff_shop_app/app/models/user.dart';
import 'package:caff_shop_app/app/stores/widget_stores/edit_dialog_store.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditDialog extends StatefulWidget {
  final User user;

  const EditDialog({Key? key, required this.user}) : super(key: key);

  @override
  _EditDialogState createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  late final EditDialogStore _store;

  final Map<String, TextEditingController> _controllers = {
    'username': TextEditingController(),
    'email': TextEditingController(),
    'password': TextEditingController(),
  };

  @override
  void initState() {
    _store = EditDialogStore(
      user: widget.user,
    );
    super.initState();
    _initControllers();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: ScrollConfiguration(
        behavior: ScrollBehavior().copyWith(
          overscroll: false,
        ),
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
              constraints: BoxConstraints(
                minHeight: 1.sh -
                    ScreenUtil().bottomBarHeight -
                    ScreenUtil().statusBarHeight,
              ),
              child: Center(
                child: Dialog(
                  insetPadding: EdgeInsets.all(20.r),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Container(
                    padding: EdgeInsets.all(20.r),
                    child: Material(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            tr("edit_data"),
                            style: Theme.of(context).textTheme.headline2,
                          ),
                          SizedBox(height: 30.h),
                          Row(
                            children: [
                              Expanded(
                                child: Observer(
                                  builder: (_) => TextFormField(
                                    controller: _controllers['username'],
                                    decoration: InputDecoration(
                                      hintText: tr("hint.username"),
                                      errorText: _store.usernameError,
                                    ),
                                    onChanged: (value) => _store.username = value,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.h),
                          Row(
                            children: [
                              Expanded(
                                child: Observer(
                                  builder: (_) => TextFormField(
                                    controller: _controllers['email'],
                                    decoration: InputDecoration(
                                      hintText: tr("hint.email"),
                                      errorText: _store.emailError,
                                    ),
                                    onChanged: (value) => _store.email = value,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.h),
                          Row(
                            children: [
                              Expanded(
                                child: Observer(
                                  builder: (_) => TextFormField(
                                    controller: _controllers['password'],
                                    decoration: InputDecoration(
                                      hintText: tr("hint.password"),
                                      errorText: _store.passwordError,
                                    ),
                                    onChanged: (value) => _store.password = value,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.h),
                          ElevatedButton(
                            onPressed: () => _onModifyButtonTap(),
                            child: Text(tr("button.edit")),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //general methods:------------------------------------------------------------
  Future<void> _onModifyButtonTap() async {
    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
      await Future.delayed(Duration(milliseconds: 300));
    }


    Navigator.of(context).pop(_store.getUser());
  }

  void _initControllers() {
    _controllers['username']!.text = widget.user.username;
    _controllers['email']!.text = widget.user.email;
  }
}
