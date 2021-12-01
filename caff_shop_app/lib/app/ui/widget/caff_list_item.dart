import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CaffListItem extends StatelessWidget {
  final String url;
  final void Function() onTap;

  const CaffListItem({
    Key? key,
    required this.url,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: GridTile(
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
        ),
      ),
    );
  }
}
