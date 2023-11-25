import 'package:flutter/material.dart';
import 'package:goshare/features/menu_user/money-topup/web-view-page.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goshare/features/menu_user/money-topup/money-topup-controller.dart';
import 'package:goshare/theme/pallet.dart';

import 'package:goshare/providers/signalr_providers.dart';
import 'package:signalr_core/signalr_core.dart';

class MoneyTopupPage extends ConsumerStatefulWidget {
  const MoneyTopupPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MoneyTopupPageState();
}

class _MoneyTopupPageState extends ConsumerState<MoneyTopupPage> {
  final TextEditingController _topupAmountController = TextEditingController();
  double currentBalance = 0.0;

  @override
  void dispose() {
    super.dispose();
    _topupAmountController.dispose();
  }

  void _onSubmit(WidgetRef ref) async {
    int topupAmount = int.parse(_topupAmountController.text);

    final result = await ref
        .read(MoneyTopupControllerProvider.notifier)
        .moneyTopup(topupAmount, context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewPage(url: result),
      ),
    );
  }

  // @override
  // void initState() {
  //   if (!mounted) return;
  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     await initSignalR(ref);
  //     final location = ref.watch(locationProvider);
  //     currentLocation = await location.getCurrentLocation();
  //     //updateMarker();

  //     setState(() {});
  //   });
  //   super.initState();
  // }

  Future<void> initSignalR(WidgetRef ref) async {
    try {
      final hubConnection = await ref.watch(
        hubConnectionProvider.future,
      );

      hubConnection.on('', (message) {
        print("${message.toString()} DAY ROI SIGNAL R DAY ROI");
        // _handleNotifyPassengerDriverPickUp(message);
      });

      hubConnection.onclose((exception) async {
        print(exception.toString() + "LOI CUA SIGNALR ON CLOSE");
        await Future.delayed(
          const Duration(seconds: 3),
          () async {
            if (hubConnection.state == HubConnectionState.disconnected) {
              await hubConnection.start();
            }
          },
        );
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Ví của bạn'),
        automaticallyImplyLeading: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Pallete.primaryColor,
              ),
              child: Column(
                children: [
                  SizedBox(height: 16.0),
                  const Text(
                    'Số dư hiện tại',
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    '${currentBalance}đ',
                    style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 16.0),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            const Text(
              'Nạp tiền',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _topupAmountController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Số tiền',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Xác nhận nạp tiền'),
                    content: Text(
                        'Bạn có chắc chắn muốn nạp đ vào ví của bạn không?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Hủy'),
                      ),
                      TextButton(
                        onPressed: () {
                          final topupAmount =
                              double.tryParse(_topupAmountController.text) ??
                                  0.0;
                          _onSubmit(ref);
                          Navigator.pop(context);
                        },
                        child: const Text('Xác nhận'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Topup'),
            ),
          ],
        ),
      ),
    );
  }
}
