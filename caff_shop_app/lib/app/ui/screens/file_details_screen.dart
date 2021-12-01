import 'package:caff_shop_app/app/config/color_constants.dart';
import 'package:caff_shop_app/app/stores/screen_stores/file_details_store.dart';
import 'package:caff_shop_app/app/ui/widget/comment_list_item.dart';
import 'package:caff_shop_app/app/ui/widget/loading.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FileDetailsScreen extends StatefulWidget {
  final String url;

  const FileDetailsScreen({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  _FileDetailsScreenState createState() => _FileDetailsScreenState();
}

class _FileDetailsScreenState extends State<FileDetailsScreen> {
  final FileDetailsStore _store = FileDetailsStore();

  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _store.getCaffDetails(
      id: "id",
    );
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
                  widget.url,
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
                            "Sample.caff",
                            style: Theme.of(context).textTheme.headline3!.copyWith(
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
                        icon: Icon(Icons.arrow_back, color: ColorConstants.white,),
                        onPressed: _onBackArrowPressed,
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
                        decoration: InputDecoration(
                          hintText: tr("hint.comment"),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _onSendButtonPressed,
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
                    itemBuilder: (context, index) {
                      return CommentListItem(
                          userName: "userName",
                          text: _store.comments[index],
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

  void _onBackArrowPressed() {
    Navigator.of(context).pop();
  }

  void _onSendButtonPressed() {

  }
}
