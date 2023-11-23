import 'package:flutter/material.dart';

class OnTripGoing extends StatelessWidget {
  const OnTripGoing({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 100,
            height: 100,
            child: Image.network(
              'https://your-image-url.com',
              fit: BoxFit.cover,
            ),
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Bạn đang có 1 chuyến xe đang chạy',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
