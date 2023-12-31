import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goshare/core/constants/route_constants.dart';
import 'package:goshare/features/login/screen/log_in_screen.dart';
import 'package:goshare/features/dependent_mng/dependent_add/dependent_add_screen.dart'
    as depProv;
import 'package:goshare/providers/current_on_trip_provider.dart';
import 'package:goshare/providers/signalr_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserMenuPage extends ConsumerStatefulWidget {
  const UserMenuPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserMenuPageState();
}

class _UserMenuPageState extends ConsumerState<UserMenuPage> {
  bool _isLoading = false;
  void _onLogout(WidgetRef ref) async {
    if (mounted) {
      final connection = await ref.read(
        hubConnectionProvider.future,
      );
      ref.invalidate(userProvider);
      ref.invalidate(depProv.userProvider);
      ref.invalidate(currentDependentOnTripProvider);
      ref.invalidate(currentOnTripIdProvider);
      //ref.invalidate(userProvider);
      await connection.stop().then(
            (value) => print('DA STOP THANH CONG'),
          );
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('accessToken');
      await prefs.remove('refreshToken');

      if (mounted) {
        context.goNamed(RouteConstants.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider);
    final bool isDependent = user?.role.toLowerCase() == 'dependent';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Tài khoản'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          ListView(
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
              if (!isDependent)
                Column(
                  children: [
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
                  ],
                ),

              // const Divider(),
              // Container(
              //   color: Colors.white,
              //   child: ListTile(
              //     visualDensity: const VisualDensity(
              //         vertical: -4.0), // Reduced vertical padding
              //     title: const Text('Money History'),
              //     onTap: () {
              //       Navigator.pushNamed(context, '/moneyHistory');
              //     },
              //   ),
              // ),
              // const Divider(),
              // Container(
              //   color: Colors.white,
              //   child: ListTile(
              //     visualDensity: const VisualDensity(
              //         vertical: -4.0), // Reduced vertical padding
              //     title: const Text('Feedback'),
              //     onTap: () {
              //       context.push(RouteConstants.feedback);
              //     },
              //   ),
              // ),
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
                      builder: (abcContext) => AlertDialog(
                        title: Text('Xác nhận đăng xuất'),
                        content: Text('Bạn có chắc chắn muốn đăng xuất?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(abcContext),
                            child: const Text('Hủy'),
                          ),
                          TextButton(
                            onPressed: () {
                              _onLogout(ref);
                              Navigator.pop(abcContext);
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
        ],
      ),
    );
  }
}
