import 'package:flutter/material.dart';

class ScrollExpandable extends StatelessWidget {
  final Widget child;

  const ScrollExpandable({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return ScrollConfiguration(
          behavior: ScrollBehavior().copyWith(
            overscroll: false,
          ),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraint.maxHeight,
              ),
              child: IntrinsicHeight(
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}