import 'package:flutter/material.dart';

class ImageGestureDetector extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onTapLeft;
  final VoidCallback? onTapRight;
  final Function(DragEndDetails)? onHorizontalDragEnd;
  final VoidCallback? onLongPress;

  const ImageGestureDetector({
    super.key,
    required this.child,
    this.onTap,
    this.onTapLeft,
    this.onTapRight,
    this.onHorizontalDragEnd,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onHorizontalDragEnd: onHorizontalDragEnd,
      onLongPress: onLongPress,
      child: Stack(
        children: [
          child,
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            child: GestureDetector(
              onTap: onTapLeft,
              behavior: HitTestBehavior.translucent,
              child: Container(color: Colors.transparent),
            ),
          ),

          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            child: GestureDetector(
              onTap: onTapRight,
              behavior: HitTestBehavior.translucent,
              child: Container(color: Colors.transparent),
            ),
          ),
        ],
      ),
    );
  }
}
