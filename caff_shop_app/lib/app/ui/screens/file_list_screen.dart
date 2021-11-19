import 'dart:async';

import 'package:caff_shop_app/app/config/color_constants.dart';
import 'package:caff_shop_app/app/stores/screen_stores/file_list_store.dart';
import 'package:caff_shop_app/app/ui/widget/loading.dart';
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
  final FileListStore _store = FileListStore();

  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _store.getCaffFiles(onError: _showSnackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Loading(
      store: _store.loadingStore,
      isExpandable: false,
      appBar: AppBar(
        title: Text(tr('appbar.caff_browser')),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.person),
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
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.search),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Observer(
              builder: (_) =>
                  GridView.count(
                    primary: false,
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    mainAxisSpacing: 10.r,
                    crossAxisSpacing: 10.r,
                    children: _store.caffSrcList.map((String url) {
                      return GridTile(
                        child: Card(
                          child: Container(
                            padding: EdgeInsets.all(15.r),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: Image.network(
                                      url,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(height: 5.r),
                                  Text("Sample.caff"),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
            ),
          ],
        ),
      ),
      /*body: Loading(
        store: _store.loadingStore,
        enableScrolling: false,
        appBar: AppBar(
          title: Text(tr('appbar.caff_browser')),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.person),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20.r),
              child: Column(
                //mainAxisSize: MainAxisSize.min,
                children: [
                  Container(),
                  Observer(
                    builder: (_) => GridView.count(
                      primary: false,
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      mainAxisSpacing: 10.r,
                      crossAxisSpacing: 10.r,
                      children: _store.caffSrcList.map((String url) {
                        return GridTile(
                          child: Card(
                            child: Container(
                              padding: EdgeInsets.all(15.r),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: Image.network(
                                        url,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(height: 5.r),
                                    Text("Sample.caff"),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),*/
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: ColorConstants.lightGrey,
          borderRadius: BorderRadius.circular(50.r),
          boxShadow: [
            BoxShadow(
              color: ColorConstants.shadow,
              blurRadius: 40.r,
              offset: Offset(0, 16.r), // changes position of shadow
            ),
          ],
        ),
        width: 100.r,
        height: 100.r,
        child: Center(
          child: Container(
            width: 50.r,
            height: 50.r,
            child: CircularProgressIndicator(),
          ),
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
}
