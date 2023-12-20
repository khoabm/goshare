import 'dart:convert';

class ChatModel {
  final String from;
  final String to;
  final String content;
  final DateTime time;
  ChatModel({
    required this.from,
    required this.to,
    required this.content,
    required this.time,
  });

  ChatModel copyWith({
    String? from,
    String? to,
    String? content,
    DateTime? time,
  }) {
    return ChatModel(
      from: from ?? this.from,
      to: to ?? this.to,
      content: content ?? this.content,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'from': from,
      'to': to,
      'content': content,
      'time': time.millisecondsSinceEpoch,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      from: map['from'] ?? '',
      to: map['to'] ?? '',
      content: map['content'] ?? '',
      time: DateTime.fromMillisecondsSinceEpoch(
        DateTime.parse(map['time']).millisecondsSinceEpoch,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) =>
      ChatModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ChatModel(from: $from, to: $to, content: $content, time: $time)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatModel &&
        other.from == from &&
        other.to == to &&
        other.content == content &&
        other.time == time;
  }

  @override
  int get hashCode {
    return from.hashCode ^ to.hashCode ^ content.hashCode ^ time.hashCode;
  }
}
