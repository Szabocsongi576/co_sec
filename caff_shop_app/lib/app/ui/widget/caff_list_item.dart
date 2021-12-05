import 'dart:typed_data';

import 'package:caff_shop_app/app/api/api.dart';
import 'package:caff_shop_app/app/api/api_util.dart';
import 'package:caff_shop_app/app/config/color_constants.dart';
import 'package:caff_shop_app/app/models/converted_caff.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gif_view/gif_view.dart';

class CaffListItem extends StatelessWidget {
  final ConvertedCaff caff;
  final void Function() onTap;
  final void Function()? onDelete;

  const CaffListItem({
    Key? key,
    required this.caff,
    required this.onTap,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: GridTile(
          child: Card(
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(15.r),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /*Expanded(
                          child: Image.network(
                            "${ApiUtil().baseUrl}${caff.imageUrl}",
                            fit: BoxFit.cover,
                          ),
                        ),*/
                        Expanded(
                          child: FutureBuilder(
                            future: Api().getCaffApi().getCaffImage(caff.id),
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
                                    );
                                  }
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 5.r),
                        Text(
                          caff.name,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                  ),
                ),
                if (onDelete != null)
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.all(5.r),
                      child: Container(
                        width: 40.r,
                        height: 40.r,
                        child: FittedBox(
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
                              onPressed: onDelete,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
