import 'package:flutter/material.dart';

class HomeCenterContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final double? verticalPadding;
  final double? horizontalPadding;
  final Widget? child;
  const HomeCenterContainer({
    super.key,
    this.width,
    this.height,
    this.verticalPadding,
    this.horizontalPadding,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding ?? 12.0,
        horizontal: horizontalPadding ?? 12.0,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          bottomLeft: Radius.circular(20),
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(20),
        ),
      ),
      width: width,
      height: height,
      child: child,
    );
  }
}
