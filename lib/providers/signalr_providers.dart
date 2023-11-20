import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_core/signalr_core.dart';

final hubConnectionProvider = FutureProvider<HubConnection>((ref) async {
  try {
    print('hubConnection');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    print(accessToken);
    final httpClient = _HttpClient(
      token: accessToken ?? '',
    );
    return HubConnectionBuilder()
        .withUrl(
          "https://goshareapi.azurewebsites.net/goshareHub",
          HttpConnectionOptions(
            client: httpClient,
            //accessTokenFactory: () async => accessToken,
          ),
        )
        .build();
  } catch (e) {
    print(e.toString());
    rethrow; // Re-throw the exception
  }
});

class _HttpClient extends http.BaseClient {
  final _httpClient = http.Client();
  String token;

  _HttpClient({required this.token});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Authorization'] = 'Bearer $token';
    // request.headers.addAll(defaultHeaders);
    return _httpClient.send(request);
  }
}
