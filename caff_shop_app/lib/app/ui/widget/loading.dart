import 'package:caff_shop_app/app/config/color_constants.dart';
import 'package:caff_shop_app/app/stores/widget_stores/loading_store.dart';
import 'package:caff_shop_app/app/ui/widget/scroll_column_expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Loading extends StatelessWidget {
  final LoadingStore store;

  final Widget body;
  final Widget? appBar;
  final bool enableScrolling;

  const Loading({
    Key? key,
    required this.store,
    this.appBar,
    required this.body,
    this.enableScrolling = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: 1.sh,
            child: Column(
              children: [
                if (appBar != null)
                  Stack(
                    children: [
                      appBar!,
                      Observer(
                        builder: (_) {
                          if (store.stackedLoading) {
                            return Container(
                              color: ColorConstants.black.withOpacity(0.3),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ],
                  ),
                Expanded(
                  child: Stack(
                    children: [
                      Observer(
                        builder: (_) {
                          if (store.loading) {
                            return _buildLoading();
                          } else {
                            if (enableScrolling) {
                              return ScrollExpandable(
                                child: body,
                              );
                            } else {
                              return body;
                            }
                          }
                        },
                      ),
                      Observer(
                        builder: (_) {
                          if (store.stackedLoading) {
                            return Container(
                              color: ColorConstants.black.withOpacity(0.3),
                              child: _buildLoading(),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
}
