import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:goshare/core/constants/constants.dart';
import 'package:goshare/core/failure.dart';
import 'package:goshare/core/type_def.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HttpClientWithAuth extends http.BaseClient {
  final http.Client _inner = http.Client();
  String token;

  HttpClientWithAuth(this.token);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    request.headers['Authorization'] = 'Bearer $token';
    final response = await _inner.send(request);
    print(response.statusCode);
    if (response.statusCode == 401) {
      final renewResponse = await renewToken();

      if (renewResponse.isRight()) {
        print('isRight');
        token = renewResponse.getOrElse((l) => l.message);
        request.headers['Authorization'] = 'Bearer $token';

        final newRequest = _copyRequest(request);
        return _inner.send(newRequest);
        // return _inner.send(request);
      } else {
        return response;
      }
    }

    return response;
  }

  http.BaseRequest _copyRequest(http.BaseRequest request) {
    http.BaseRequest requestCopy;

    if (request is http.Request) {
      requestCopy = http.Request(request.method, request.url)
        ..encoding = request.encoding
        ..bodyBytes = request.bodyBytes;
    } else if (request is http.MultipartRequest) {
      requestCopy = http.MultipartRequest(request.method, request.url)
        ..fields.addAll(request.fields)
        ..files.addAll(request.files);
    } else if (request is http.StreamedRequest) {
      throw Exception('copying streamed requests is not supported');
    } else {
      throw Exception('request type is unknown, cannot copy');
    }

    requestCopy
      ..persistentConnection = request.persistentConnection
      ..followRedirects = request.followRedirects
      ..maxRedirects = request.maxRedirects
      ..headers.addAll(request.headers);

    return requestCopy;
  }

  FutureEither<String> renewToken() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');
      final response = await _inner.post(
        Uri.parse('${Constants.apiBaseUrl}/auth/refresh-token'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'AccessToken': accessToken,
          'RefreshToken': 'GNREV+2PPbJ6M7LnqIsS1EKrieMyNdlHXTJFpUAUPv0=',
        }),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('200 refresh token');
        final Map<String, dynamic> jsonData = json.decode(response.body);
        print(jsonData);
        return right(jsonData['accessToken']);
      } else {
        return left(UnauthorizedFailure('Fail to renew token'));
      }
    } catch (e) {
      print(e.toString());
      return left(UnauthorizedFailure('Fail to renew token'));
    }
  }
}
