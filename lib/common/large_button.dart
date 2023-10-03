import 'package:flutter/material.dart';
import 'package:goshare/theme/pallet.dart';

class LargeButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  const LargeButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
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
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
        ),
      ),
    );
  }
}
