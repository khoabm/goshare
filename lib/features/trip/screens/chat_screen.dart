import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goshare/features/login/screen/log_in_screen.dart';
import 'package:goshare/models/chat_model.dart';
import 'package:signalr_core/signalr_core.dart';

import 'package:goshare/features/trip/controller/trip_controller.dart';
import 'package:goshare/providers/chat_provider.dart';
import 'package:goshare/providers/signalr_providers.dart';

class ChatMessage {
  final String message;
  final bool isCurrentUser;

  ChatMessage(
    this.message,
    this.isCurrentUser,
  );
}

class ChatScreen extends ConsumerStatefulWidget {
  final String receiver;
  final String driverAvatar;
  final String tripId;
  const ChatScreen({
    super.key,
    required this.receiver,
    required this.driverAvatar,
    required this.tripId,
  });

  @override
  ConsumerState createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  List<ChatModel> _messages = [];
  //List<ChatModel> chats = [];
  @override
  void initState() {
    if (!mounted) return;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initSignalR(ref);
      if (mounted) {
        _messages = await ref.read(tripControllerProvider.notifier).getChat(
              context,
              widget.tripId,
            );
      }
      setState(() {});
    });
  }

  ChatMessage chatModelToChatMessage(ChatModel chatModel, String userId) {
    return ChatMessage(
      chatModel.content,
      chatModel.from == userId,
    );
  }

  List<ChatMessage> chatModelsToChatMessages(
      List<ChatModel> chatModels, String userId) {
    return chatModels
        .map((chatModel) => chatModelToChatMessage(chatModel, userId))
        .toList();
  }

  void _handleSubmitted(String text) async {
    _textController.clear();
    await ref.read(tripControllerProvider.notifier).sendChat(
          context,
          text,
          widget.receiver,
          widget.tripId,
        );
    setState(() {
      // Assuming you have userId available here
      _messages.insert(
        0,
        ChatModel(
          from: ref.read(userProvider)?.id ?? '',
          to: widget.receiver,
          content: text,
          time: DateTime.now(),
        ),
      );
    });

    // ref.read(chatMessagesProvider.notifier).addMessage(
    //       ChatMessage(
    //         text,
    //         true,
    //       ),
    //       widget.receiver,
    //     );
    // print(widget.receiver);
    // var chatProviderItem = ref.watch(chatMessagesProvider).firstWhere(
    //   (item) {
    //     print('TÌM THẤY RỒI');
    //     return item.driverId == widget.receiver;
    //   },
    //   orElse: () => ChatProviderItem(driverId: widget.receiver, messages: []),
    // );
  }

  Future<void> initSignalR(WidgetRef ref) async {
    try {
      final hubConnection = await ref.read(
        hubConnectionProvider.future,
      );

      hubConnection.on('ReceiveSMSMessages', (message) {
        if (mounted) {
          print(
              "${message.toString()} DAY ROI SIGNAL R DAY ROI RECEIVE SMS MESSAGE");
          setState(() {
            // _messages.insert(
            //     0, ChatMessage(message?.first.toString() ?? '', false));
            _messages.insert(
              0,
              ChatModel(
                from: widget.receiver,
                to: ref.read(userProvider)?.id ?? '',
                content: message?.first.toString() ?? '',
                time: DateTime.now(),
              ),
            );
          });
        }
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

  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration:
                  const InputDecoration.collapsed(hintText: "Gửi tin nhắn"),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
              icon: const Icon(Icons.send),
              onPressed: () => _handleSubmitted(_textController.text),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(ChatMessage message) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
      ),
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: message.isCurrentUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: message.isCurrentUser
                ? const CircleAvatar(
                    radius: 10.0,
                    child: Text('Tôi'),
                  )
                : Center(
                    child: CircleAvatar(
                      radius: 10.0,
                      backgroundImage: NetworkImage(
                        widget.driverAvatar,
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(message.isCurrentUser ? 'Tôi' : 'Tài xế'),
              Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: Text(message.message),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Nhắn tin')),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) => _buildMessage(
                chatModelToChatMessage(
                  _messages[index],
                  ref.read(userProvider)?.id ?? '',
                ),
              ),
              itemCount: _messages.length,
            ),
          ),
          const Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }
}
