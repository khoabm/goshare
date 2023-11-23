import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goshare/core/constants/route_constants.dart';

class UserMenuPage extends StatefulWidget {
  const UserMenuPage({Key? key}) : super(key: key);

  @override
  State<UserMenuPage> createState() => _UserMenuPageState();
}

class _UserMenuPageState extends State<UserMenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('User Menu'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Container(
            color: Colors.white,
            child: ListTile(
              visualDensity: const VisualDensity(
                  vertical: -4.0), // Reduced vertical padding
              title: const Text('Edit Profile'),
              onTap: () {
                // Navigator.goN(context, '/edit-profile');
                context.goNamed(RouteConstants.editProfileUrl);
              },
            ),
          ),
          const Divider(),
          Container(
            color: Colors.white,
            child: ListTile(
              visualDensity: const VisualDensity(
                  vertical: -4.0), // Reduced vertical padding
              title: const Text('Money Topup'),
              onTap: () {
                Navigator.pushNamed(context, '/moneyTopup');
              },
            ),
          ),
          const Divider(),
          Container(
            color: Colors.white,
            child: ListTile(
              visualDensity: const VisualDensity(
                  vertical: -4.0), // Reduced vertical padding
              title: const Text('Money History'),
              onTap: () {
                Navigator.pushNamed(context, '/moneyHistory');
              },
            ),
          ),
        ],
      ),
    );
  }
}
