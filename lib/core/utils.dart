import 'package:flutter/material.dart';

void showSnackBar({
  required BuildContext context,
  required String message,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
}

String convertPhoneNumber(String phoneNumber) {
  // Check if the phone number starts with '0'
  if (phoneNumber.startsWith('0')) {
    // Remove the leading '0' and add '84' at the beginning
    return '+84${phoneNumber.substring(1)}';
  } else {
    // If the phone number doesn't start with '0', return as is
    return phoneNumber;
  }
}
