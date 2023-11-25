import 'package:flutter/material.dart';

class OnTripGoing extends StatelessWidget {
  const OnTripGoing({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 160,
            height: 100,
            child: Image.network(
              'https://firebasestorage.googleapis.com/v0/b/goshare-bc3c4.appspot.com/o/banner.png?alt=media&token=5d75a6a5-9d09-4d58-afc1-a800bf8cde96&fbclid=IwAR0j7kkgWROmbOPD72LkqSrCy9uQVikmxtnWTIgzPhyyhWxWB_9Q8JqWLFE',
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
