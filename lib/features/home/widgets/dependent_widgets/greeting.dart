import 'package:flutter/material.dart';

class GreetingWidget extends StatelessWidget {
  final String name;
  const GreetingWidget({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Text.rich(
        TextSpan(
          children: [
            const TextSpan(
              text: 'Chào ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.normal,
              ),
            ),
            TextSpan(
              text: name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w700,
                height: 0,
              ),
            ),
            const TextSpan(
              text: ', ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
