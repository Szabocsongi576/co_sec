import 'package:caff_shop_app/app/api/api_util.dart';
import 'package:caff_shop_app/app/config/color_constants.dart';
import 'package:caff_shop_app/app/models/converted_caff.dart';
import 'package:caff_shop_app/app/models/login_response.dart';
import 'package:caff_shop_app/app/models/role_type.dart';
import 'package:caff_shop_app/app/models/user.dart';
import 'package:caff_shop_app/app/stores/screen_stores/file_details_store.dart';
import 'package:caff_shop_app/app/ui/widget/comment_list_item.dart';
import 'package:caff_shop_app/app/ui/widget/loading.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

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
      isAdmin: Provider.of<LoginResponse>(context, listen: false)
        .roles.contains(RoleType.ROLE_ADMIN),
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
          Container(
            height: 0.4.sh,
            width: 1.sw,
            child: Stack(
              children: [
                Image.network(
                  "${ApiUtil().baseUrl}${widget.caff.imageUrl}",
                  fit: BoxFit.cover,
                  height: 0.4.sh,
                  width: 1.sw,
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
                            style:
                                Theme.of(context).textTheme.headline3!.copyWith(
                                      color: ColorConstants.white,
                                    ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
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
                        onPressed: _onBackArrowPressed,
                      ),
                    ),
                  ),
                ),
                if(_store.isAdmin)
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
          ),
          Container(
            padding: EdgeInsets.all(20.r),
            child: Column(
              children: [
                Row(
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
                SizedBox(height: 20.h),
                Observer(
                  builder: (_) => ListView.separated(
                    primary: false,
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: _store.comments.length,
                    itemBuilder: (_, index) {
                      User? user;
                      try {
                        user = _store.users.firstWhere(
                            (e) => e.id == _store.comments[index].userId);
                      } on StateError catch (_) {}

                      return CommentListItem(
                        userName: user?.username ?? "",
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

  void _onBackArrowPressed() {
    Navigator.of(context).pop();
  }

  void _onCaffDeleteTap() {
    Navigator.of(context).pop(true);
  }

  void _onSendButtonPressed(BuildContext context) {
    String userId = Provider.of<LoginResponse>(context, listen: false).id;
    _store.createComment(
      userId: userId,
      onSuccess: () => _textEditingController.text = "",
      onError: (message) => _showSnackBar(message),
    );
  }

  void _onCommentDeleteTap(String commentId) {
    _store.deleteComment(
      commentId: commentId,
      onSuccess: (response) => _showSnackBar(response.message),
      onError: (message) => _showSnackBar(message),
    );
  }
}