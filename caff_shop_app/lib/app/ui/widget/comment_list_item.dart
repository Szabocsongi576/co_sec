import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommentListItem extends StatelessWidget {
  final String text;
  final String userName;

  const CommentListItem({
    Key? key,
    required this.text,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  userName,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.r),
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        ],
      ),
    );
  }
}
