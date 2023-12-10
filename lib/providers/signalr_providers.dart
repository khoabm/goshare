import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_core/signalr_core.dart';

final hubConnectionProvider =
    FutureProvider.autoDispose<HubConnection>((ref) async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    print('signalR HUB');
    print(accessToken);
    return HubConnectionBuilder()
        .withUrl(
          "https://goshareapi.azurewebsites.net/goshareHub?access_token=$accessToken",
        )
        .withAutomaticReconnect()
        .build();
  } catch (e) {
    rethrow; // Re-throw the exception
  }
});
