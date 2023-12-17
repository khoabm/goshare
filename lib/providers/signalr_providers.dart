import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_core/signalr_core.dart';

final hubConnectionProvider = FutureProvider<HubConnection>((ref) async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    print('signalR HUB');
    return HubConnectionBuilder()
        .withAutomaticReconnect()
        .withUrl(
          "https://goshareapi.azurewebsites.net/goshareHub?access_token=$accessToken",
        )
        .build();
  } catch (e) {
    print('LOI SIGNAL R NEF');
    print(e.toString());
    rethrow; // Re-throw the exception
  }
});
