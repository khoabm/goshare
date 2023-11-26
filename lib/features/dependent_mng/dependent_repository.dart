import 'dart:async';

import 'package:goshare/core/constants/constants.dart';
import 'package:goshare/core/utils/http_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DependentMngRepository {
  Future fetchDependents() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final client = HttpClientWithAuth(accessToken ?? '');
    String baseUrl = Constants.apiBaseUrl;
    final response = await client.get(Uri.parse('$baseUrl/user/dependents'));
    print('koollll' + response.body);
    // if (response.statusCode == 200) {
    //   final decodedData = json.decode(response.body) as List;
    //   return decodedData.map((data) => Contact.fromJson(data)).toList();
    // } else {
    //   throw Exception('Failed to load dependents');
    // }
  }
}
