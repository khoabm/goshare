import 'package:flutter/material.dart';
import 'package:goshare/theme/pallet.dart';

class AppButton extends StatelessWidget {
  final String buttonText;
  final double? fontSize;
  final VoidCallback onPressed;
  const AppButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Pallete.primaryColor, // text color

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // border shape
        ),
      ),
      child: Text(
        buttonText,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize ?? 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
