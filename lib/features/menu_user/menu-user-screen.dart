import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goshare/core/constants/route_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserMenuPage extends StatefulWidget {
  const UserMenuPage({Key? key}) : super(key: key);

  @override
  State<UserMenuPage> createState() => _UserMenuPageState();
}

class _UserMenuPageState extends State<UserMenuPage> {
  void _onLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('accessToken');
    context.goNamed(RouteConstants.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Tài khoản'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Container(
            color: Colors.white,
            child: ListTile(
              visualDensity: const VisualDensity(vertical: -4.0),
              title: const Text('Thông tin cá nhân'),
              onTap: () {
                context.push(RouteConstants.editProfileUrl);
              },
            ),
          ),
          const Divider(),
          Container(
            color: Colors.white,
            child: ListTile(
              visualDensity: const VisualDensity(vertical: -4.0),
              title: const Text('Ví của tôi'),
              onTap: () {
                context.push(RouteConstants.moneyTopupUrl);
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
          const Divider(),
          Container(
            color: Colors.white,
            child: ListTile(
              visualDensity: const VisualDensity(
                  vertical: -4.0), // Reduced vertical padding
              title: const Text('Feedback'),
              onTap: () {
                context.push(RouteConstants.feedback);
              },
            ),
          ),
          const Divider(),
          Container(
            color: Colors.white,
            child: ListTile(
              visualDensity: const VisualDensity(
                  vertical: -4.0), // Reduced vertical padding
              title: const Text('Đăng xuất'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Xác nhận đăng xuất'),
                    content: Text('Bạn có chắc chắn muốn đăng xuất?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Hủy'),
                      ),
                      TextButton(
                        onPressed: () {
                          _onLogout();
                        },
                        child: const Text('Xác nhận'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
