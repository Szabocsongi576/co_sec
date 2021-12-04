import 'package:caff_shop_app/app/config/color_constants.dart';
import 'package:caff_shop_app/app/models/caff_request.dart';
import 'package:caff_shop_app/app/stores/widget_stores/upload_dialog_store.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UploadDialog extends StatefulWidget {
  const UploadDialog({Key? key}) : super(key: key);

  @override
  _UploadDialogState createState() => _UploadDialogState();
}

class _UploadDialogState extends State<UploadDialog> {
  final UploadDialogStore _store = UploadDialogStore();

  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

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
                            tr("add_file"),
                            style: Theme.of(context).textTheme.headline2,
                          ),
                          SizedBox(height: 30.h),
                          Row(
                            children: [
                              Expanded(
                                child: Observer(
                                  builder: (_) => TextFormField(
                                    controller: _textEditingController,
                                    focusNode: _focusNode,
                                    decoration: InputDecoration(
                                      hintText: tr("hint.name"),
                                      errorText: _store.error,
                                    ),
                                    onChanged: (value) {
                                      _store.name = value;
                                    },
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () => _onAddButtonTap(),
                                icon: Icon(
                                  Icons.add_box,
                                  color: ColorConstants.primary,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.h),
                          ElevatedButton(
                            onPressed: () => _onUploadButtonTap(),
                            child: Text(tr("button.upload")),
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
  Future<void> _onAddButtonTap() async {
    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
      await Future.delayed(Duration(milliseconds: 300));
    }

    _store.getCaff(
      onSuccess: (name) {
        _textEditingController.text = name;
      },
    );
  }

  Future<void> _onUploadButtonTap() async {
    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
      await Future.delayed(Duration(milliseconds: 300));
    }

    if (_store.validate()) {
      Navigator.of(context).pop(
        CaffRequest(
          name: _store.name,
          data: await MultipartFile.fromFile(
            _store.file!.path,
          ),
        ),
      );
    }
  }
}
