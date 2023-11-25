import 'package:flutter/material.dart';
import 'package:goshare/models/trip_model.dart';

class DriverInfoCard extends StatelessWidget {
  final Driver driver;

  const DriverInfoCard({Key? key, required this.driver}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.white,
      elevation: 10,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text(
                    'Thông tin tài xế',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    driver.name,
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    driver.phone,
                    style: const TextStyle(fontSize: 16),
                  ),

                  // Add more driver information here
                ],
              ),
              Center(
                child: CircleAvatar(
                  radius: 50.0,
                  backgroundImage: NetworkImage(
                    driver.avatarUrl ?? '',
                  ),
                  backgroundColor: Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
