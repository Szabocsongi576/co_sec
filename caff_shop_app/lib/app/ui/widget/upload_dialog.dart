import 'package:caff_shop_app/app/config/color_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UploadDialog extends StatefulWidget {
  const UploadDialog({Key? key}) : super(key: key);

  @override
  _UploadDialogState createState() => _UploadDialogState();
}

class _UploadDialogState extends State<UploadDialog> {
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
                          /*Row(
                            children: [
                              Icon(
                                Icons.add_box,
                                color: ColorConstants.primary,
                              ),
                              SizedBox(width: 10.w),
                              Text("Sample.caff", style: Theme.of(context).textTheme.subtitle1,),
                            ],
                          ),*/
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _textEditingController,
                                  focusNode: _focusNode,
                                  decoration: InputDecoration(
                                    hintText: tr("hint.name"),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.add_box,
                                  color: ColorConstants.primary,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.h),
                          ElevatedButton(
                            onPressed: () {},
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
}
