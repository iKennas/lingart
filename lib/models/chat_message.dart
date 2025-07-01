
// models/chat_message.dart
class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String message;
  final DateTime timestamp;
  final MessageType type;
  final bool isFromTeacher;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.timestamp,
    this.type = MessageType.text,
    this.isFromTeacher = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      senderId: json['senderId'],
      senderName: json['senderName'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
      type: MessageType.values.firstWhere((e) => e.name == json['type']),
      isFromTeacher: json['isFromTeacher'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'type': type.name,
      'isFromTeacher': isFromTeacher,
    };
  }
}

enum MessageType { text, image, audio }
