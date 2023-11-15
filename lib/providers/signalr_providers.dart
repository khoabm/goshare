import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signalr_core/signalr_core.dart';

final hubConnectionProvider = Provider<HubConnection>((ref) {
  return HubConnectionBuilder()
      .withUrl(
          "https://goshareapi.azurewebsites.net/goshareHub?userId=532d73ca-ac5d-4732-a48b-750502d19c37")
      .build();
});
// final hubConnectionProvider = Provider<HubConnection>((ref) {
//   return HubConnectionBuilder()
//       .withUrl("https://goshareapi.azurewebsites.net/goshareHub")
//       .build();
// });
