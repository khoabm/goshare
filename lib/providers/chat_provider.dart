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
    state = state.map((chatProviderItem) {
      if (chatProviderItem.driverId == driverId) {
        return ChatProviderItem(
          driverId: driverId,
          messages: [...chatProviderItem.messages, message],
        );
      } else {
        return chatProviderItem;
      }
    }).toList();
  }
}
