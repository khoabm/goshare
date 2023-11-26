import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goshare/core/constants/constants.dart';
import 'package:goshare/core/constants/route_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:goshare/core/utils/http_utils.dart';

class Dependent {
  final String id;
  final String name;
  final String phone;
  final String avatarUrl;
  final String guardianId;
  final int status;
  final DateTime createTime;
  final DateTime updatedTime;
  final int gender;
  final DateTime birth;
  final Map<String, dynamic>? car;

  Dependent({
    required this.id,
    required this.name,
    required this.phone,
    required this.avatarUrl,
    required this.guardianId,
    required this.status,
    required this.createTime,
    required this.updatedTime,
    required this.gender,
    required this.birth,
    this.car,
  });
}

Future<List<Dependent>> fetchDependents() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final accessToken = prefs.getString('accessToken');
  final client = HttpClientWithAuth(accessToken ?? '');
  String baseUrl = Constants.apiBaseUrl;
  final response = await client.get(Uri.parse('$baseUrl/user/dependents'));

  if (response.statusCode == 200) {
    final decodedData = json.decode(response.body) as Map<String, dynamic>;
    final items = decodedData['items'] as List;

    return items.map((item) {
      final id = item['id'] as String;
      final name = item['name'] as String;
      final phone = item['phone'] as String;
      final avatarUrl = item['avatarUrl'] as String;
      final guardianId = item['guardianId'] as String;
      final status = item['status'] as int;
      final createTime = DateTime.parse(item['createTime'] as String);
      final updatedTime = DateTime.parse(item['updatedTime'] as String);
      final gender = item['gender'] as int;
      final birth = DateTime.parse(item['birth'] as String);
      final car = item['car'];

      return Dependent(
        id: id,
        name: name,
        phone: phone,
        avatarUrl: avatarUrl,
        guardianId: guardianId,
        status: status,
        createTime: createTime,
        updatedTime: updatedTime,
        gender: gender,
        birth: birth,
        car: car,
      );
    }).toList();
  } else {
    throw Exception('Failed to load dependents');
  }
}

class DependentScreen extends StatefulWidget {
  const DependentScreen({Key? key}) : super(key: key);

  @override
  State<DependentScreen> createState() => _DependentScreenState();
}

class DependentCard extends StatelessWidget {
  final String name;
  final String phoneNumber;
  final String avatarUrl;

  const DependentCard(
      {Key? key,
      required this.name,
      required this.phoneNumber,
      required this.avatarUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => print('hehehheeehhehe'),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(avatarUrl),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      phoneNumber,
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DependentScreenState extends State<DependentScreen> {
  List<Dependent> dependents = [];

  @override
  void initState() {
    super.initState();
    fetchDependents().then((dependentsData) {
      setState(() {
        dependents = dependentsData;
      });
    });
  }

  final List<Contact> contacts = [
    Contact(
        name: 'John Doe',
        phoneNumber: '(123) 456-7890',
        avatarUrl: 'https://imgflip.com/s/meme/Cute-Cat.jpg'),
    Contact(
        name: 'Jane Doe',
        phoneNumber: '(987) 654-3210',
        avatarUrl: 'https://imgflip.com/s/meme/Cute-Cat.jpg'),
    Contact(
        name: 'Peter Jones',
        phoneNumber: '(555) 123-4567',
        avatarUrl: 'https://imgflip.com/s/meme/Cute-Cat.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Quản lý người phụ thuộc'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () => context.push(RouteConstants.dependentAddUrl),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.add,
                  size: 20.0,
                ),
                const SizedBox(width: 4.0),
                Text(
                  'Thêm người',
                  style: const TextStyle(fontSize: 14.0),
                ),
              ],
            ),
            style: ElevatedButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: dependents.length,
              itemBuilder: (context, index) {
                final dependent = dependents[index];
                return DependentCard(
                  name: dependent.name,
                  phoneNumber: dependent.phone,
                  avatarUrl: dependent.avatarUrl,
                  // Add onTap or any other logic as needed
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Contact {
  final String name;
  final String phoneNumber;
  final String avatarUrl;

  Contact(
      {required this.name, required this.phoneNumber, required this.avatarUrl});
}
