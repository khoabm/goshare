import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goshare/features/trip/screens/chat_screen.dart';

class ChatProviderItem {
  final String driverId;
  final List<ChatMessage> messages;

  ChatProviderItem({
    required this.driverId,
    required this.messages,
  });
}

final chatMessagesProvider =
    StateNotifierProvider<ChatMessagesNotifier, List<ChatProviderItem>>(
        (ref) => ChatMessagesNotifier());

class ChatMessagesNotifier extends StateNotifier<List<ChatProviderItem>> {
  ChatMessagesNotifier()
      : super(
          [
            ChatProviderItem(
              driverId: '',
              messages: [],
            ),
          ],
        );

  void addMessage(ChatMessage message, String driverId) {
    print(message.message);
    print(driverId);
    print(state.first.driverId);
    state = state.map((chatProviderItem) {
      print(chatProviderItem.driverId);
      if (chatProviderItem.driverId == driverId) {
        print("SO SÁNH BẰNG");
        return ChatProviderItem(
          driverId: driverId,
          messages: [message, ...chatProviderItem.messages],
        );
      } else {
        return ChatProviderItem(
          driverId: driverId,
          messages: [message],
        );
      }
    }).toList();
    print(state.length);
    // print(state.)
  }
}
