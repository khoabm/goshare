// import 'package:goshare/core/constants/constants.dart';
// import 'package:signalr_netcore/hub_connection_builder.dart';

// class SignalRUtils {
//   static Future<void> connection(List<String>? arguments) async {
// // Creates the connection by using the HubConnectionBuilder.
//     final hubConnection =
//         HubConnectionBuilder().withUrl(Constants.signalRBaseUrl).build();
// // When the connection is closed, print out a message to the console.
//     await hubConnection.start();
//     hubConnection.on('NotifyDriverNewTripRequest', (message) {
//       print(message.toString());
//     });
//     hubConnection.onclose(({error}) {
//       print(error.toString());
//     });
//   }
// }
