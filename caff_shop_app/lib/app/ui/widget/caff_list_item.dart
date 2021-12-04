import 'package:caff_shop_app/app/api/api_util.dart';
import 'package:caff_shop_app/app/config/color_constants.dart';
import 'package:caff_shop_app/app/models/converted_caff.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                        Expanded(
                          child: Image.network(
                            "${ApiUtil().baseUrl}${caff.imageUrl}",
                            fit: BoxFit.cover,
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
