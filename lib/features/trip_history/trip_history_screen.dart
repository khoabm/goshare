import 'package:flutter/material.dart';

class TripHistoryScreen extends StatefulWidget {
  const TripHistoryScreen({Key? key}) : super(key: key);

  @override
  _TripHistoryScreenState createState() => _TripHistoryScreenState();
}

class _TripHistoryScreenState extends State<TripHistoryScreen> {
  List<Map<String, dynamic>> trips = [];

  @override
  void initState() {
    super.initState();
    // Fetch data from API and update trips list
    fetchData();
  }

  void fetchData() async {
    // Replace this with your API call to get trip data
    // For example, you can use Dio, http package, or any other networking library
    // Here, we use a simple delay to simulate the API call
    await Future.delayed(Duration(seconds: 2));

    // Replace this with the actual API response
    List<Map<String, dynamic>> apiResponse = [
      {
        "id": "1",
        "startTime": "2023-11-15T08:00:00",
        "driver": {
          "name": "tiếng việt",
          "car": {"licensePlate": "ABC123"}
        },
        "passenger": {"name": "tiếng việt Doe"},
        "booker": {"name": "tiếng việt Doe"},
        "startLocation": {"address": "tiếng việt Address"},
        "endLocation": {"address": "tiếng việt Address"},
        "distance": 10.0,
        "price": 50.0,
        "cartype": {"capacity": 4},
      },
      {
        "id": "1",
        "startTime": "2023-11-15T08:00:00",
        "driver": {
          "name": "John Doe",
          "car": {"licensePlate": "ABC123"}
        },
        "passenger": {"name": "Jane Doe"},
        "booker": {"name": "Bob Doe"},
        "startLocation": {"address": "Start Address"},
        "endLocation": {"address": "End Address"},
        "distance": 10.0,
        "price": 50.0,
        "cartype": {"capacity": 4},
      },
    ];

    setState(() {
      trips = apiResponse;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch sử chuyến'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white, // Set background color here
      body: trips.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: trips.length,
              itemBuilder: (context, index) {
                final trip = trips[index];
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showTripDetails(context, trip);
                      },
                      child: ListTile(
                        title: Text('Trip ${index + 1}'),
                        subtitle: Text('Start: ${trip['startTime']}'),
                      ),
                    ),
                    const Divider()
                  ],
                );
              },
            ),
    );
  }

  void _showTripDetails(BuildContext context, Map<String, dynamic> trip) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Trip Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserDetails('Driver', trip['driver']),
              _buildUserDetails('Passenger', trip['passenger']),
              _buildUserDetails('Booker', trip['booker']),
              Text('Start Location: ${trip['startLocation']['address']}'),
              Text('End Location: ${trip['endLocation']['address']}'),
              Text('Distance: ${trip['distance']}'),
              Text('Price: ${trip['price']}'),
              Text('Car Type Capacity: ${trip['cartype']['capacity']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildUserDetails(String title, Map<String, dynamic> user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$title Details:'),
        Text('Name: ${user['name']}'),
        Text('Phone: ${user['phone']}'),
        // Add more details as needed
        const SizedBox(height: 10),
      ],
    );
  }
}
