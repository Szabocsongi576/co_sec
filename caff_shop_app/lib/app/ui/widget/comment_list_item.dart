import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommentListItem extends StatelessWidget {
  final String text;
  final String userName;
  final void Function()? onDelete;

  const CommentListItem({
    Key? key,
    required this.text,
    required this.userName,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  userName,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              if(onDelete != null)
                IconButton(
                  onPressed: onDelete,
                  icon: Icon(Icons.delete),
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
