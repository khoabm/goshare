import 'package:flutter/material.dart';

class BackLeading extends StatelessWidget {
  const BackLeading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.arrow_back_ios),
        Text('Back'),
      ],
    );
  }
}
