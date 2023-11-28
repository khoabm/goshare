import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goshare/features/trip/controller/trip_controller.dart';
import 'package:goshare/providers/signalr_providers.dart';
import 'package:signalr_core/signalr_core.dart';

class ChatMessage {
  final String message;
  final bool isCurrentUser;

  ChatMessage(this.message, this.isCurrentUser);
}

class ChatScreen extends ConsumerStatefulWidget {
  final String receiver;
  final String driverAvatar;
  const ChatScreen({
    super.key,
    required this.receiver,
    required this.driverAvatar,
  });

  @override
  ConsumerState createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initSignalR(ref);
    });
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    ref.read(tripControllerProvider.notifier).sendChat(
          context,
          text,
          widget.receiver,
        );
    setState(() {
      _messages.insert(0, ChatMessage(text, true));
      // Add a message from the other user for testing
    });
  }

  Future<void> initSignalR(WidgetRef ref) async {
    try {
      final hubConnection = await ref.read(
        hubConnectionProvider.future,
      );

      hubConnection.on('ReceiveSMSMessages', (message) {
        print(
            "${message.toString()} DAY ROI SIGNAL R DAY ROI RECEIVE SMS MESSAGE");
        setState(() {
          _messages.insert(
              0, ChatMessage(message?.first.toString() ?? '', false));
        });
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
      appBar: AppBar(title: const Text('Chat Screen')),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) => _buildMessage(_messages[index]),
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
