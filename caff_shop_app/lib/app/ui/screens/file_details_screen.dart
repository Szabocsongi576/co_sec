import 'dart:typed_data';

import 'package:caff_shop_app/app/api/api.dart';
import 'package:caff_shop_app/app/api/api_util.dart';
import 'package:caff_shop_app/app/config/color_constants.dart';
import 'package:caff_shop_app/app/models/converted_caff.dart';
import 'package:caff_shop_app/app/models/role_type.dart';
import 'package:caff_shop_app/app/stores/screen_stores/file_details_store.dart';
import 'package:caff_shop_app/app/ui/widget/comment_list_item.dart';
import 'package:caff_shop_app/app/ui/widget/loading.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gif_view/gif_view.dart';

class FileDetailsScreen extends StatefulWidget {
  final ConvertedCaff caff;

  const FileDetailsScreen({
    Key? key,
    required this.caff,
  }) : super(key: key);

  @override
  _FileDetailsScreenState createState() => _FileDetailsScreenState();
}

class _FileDetailsScreenState extends State<FileDetailsScreen> {
  late final FileDetailsStore _store;

  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _store = FileDetailsStore(
      caff: widget.caff,
      isAdmin: ApiUtil().loginResponse?.roles.contains(RoleType.ROLE_ADMIN) ?? false,
    );
    _store.init(onError: (message, func) => _showSnackBar(message, func));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Loading(
      store: _store.loadingStore,
      isExpandable: false,
      body: Column(
        children: [
          _buildImagePanel(context),
          Container(
            padding: EdgeInsets.all(20.r),
            child: Column(
              children: [
                if (ApiUtil().loginResponse != null)
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _textEditingController,
                            focusNode: _focusNode,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              hintText: tr("hint.comment"),
                            ),
                            onChanged: (value) {
                              _store.text = value;
                            },
                          ),
                        ),
                        IconButton(
                          onPressed: () => _onSendButtonPressed(context),
                          icon: Icon(Icons.send),
                        ),
                      ],
                    ),
                  ),
                Observer(
                  builder: (_) => ListView.separated(
                    primary: false,
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: _store.comments.length,
                    itemBuilder: (_, index) {
                      return CommentListItem(
                        userName: _store.comments[index].username,
                        text: _store.comments[index].text,
                        onDelete: _store.isAdmin
                            ? () =>
                                _onCommentDeleteTap(_store.comments[index].id)
                            : null,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _buildImagePanel(BuildContext context) {
    return Container(
      height: 0.4.sh,
      width: 1.sw,
      child: Stack(
        children: [
          FutureBuilder(
            future: Api().getCaffApi().getCaffImage(widget.caff.id),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                    child: Container(
                      width: 50.r,
                      height: 50.r,
                      child: CircularProgressIndicator(
                        color: ColorConstants.primary,
                      ),
                    ),
                  );
                default:
                  if (snapshot.hasError) {
                    return Center(
                      child: Container(
                        width: 50.r,
                        height: 50.r,
                        child: Icon(
                          Icons.error,
                          color: ColorConstants.primary,
                        ),
                      ),
                    );
                  } else {
                    return GifView.memory(
                      (snapshot.data as Response<Uint8List>).data!,
                      fit: BoxFit.cover,
                      height: 0.4.sh,
                      width: 1.sw,
                    );
                  }
              }
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20.r,
                vertical: 10.r,
              ),
              color: ColorConstants.black.withOpacity(0.4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.caff.name,
                      style: Theme.of(context).textTheme.headline3!.copyWith(
                            color: ColorConstants.white,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 20.r),
                  IconButton(
                    padding: EdgeInsets.zero,
                    visualDensity:
                        VisualDensity(horizontal: -4.0, vertical: -4.0),
                    icon: Icon(
                      Icons.download,
                      color: ColorConstants.white,
                    ),
                    onPressed: () => _onDownloadTap(),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.all(20.r),
              child: Container(
                decoration: BoxDecoration(
                  color: ColorConstants.black.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: ColorConstants.white,
                  ),
                  onPressed: () => _onBackArrowPressed(),
                ),
              ),
            ),
          ),
          if (_store.isAdmin)
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.all(20.r),
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorConstants.black.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: ColorConstants.white,
                    ),
                    onPressed: () => _onCaffDeleteTap(),
                  ),
                ),
              ),
            ),
        ],
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

  Future<void> _onBackArrowPressed() async {
    await unFocus();
    Navigator.of(context).pop();
  }

  Future<void> _onCaffDeleteTap() async {
    await unFocus();
    Navigator.of(context).pop(true);
  }

  Future<void> _onSendButtonPressed(BuildContext context) async {
    await unFocus();
    _store.createComment(
      userId: ApiUtil().loginResponse!.id,
      username: ApiUtil().loginResponse!.username,
      onSuccess: () => _textEditingController.text = "",
      onError: (message) => _showSnackBar(message),
    );
  }

  Future<void> _onCommentDeleteTap(String commentId) async {
    await unFocus();
    _store.deleteComment(
      commentId: commentId,
      onSuccess: (response) => _showSnackBar(response.message),
      onError: (message) => _showSnackBar(message),
    );
  }

  Future<void> _onDownloadTap() async {
    await unFocus();
    _store.downloadCaff(
      onSuccess: () => _showSnackBar(tr('download_success')),
      onError: (message) => _showSnackBar(message),
    );
  }

  Future<void> unFocus() async {
    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
      await Future<void>.delayed(Duration(milliseconds: 300));
    }
  }
}
