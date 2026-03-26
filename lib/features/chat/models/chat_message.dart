import 'package:outty/core/enums/message_type.dart';

class ChatMessage {
  final String id;
  final String senderId;
  final String receiverID;
  final String content;
  final DateTime timestamp;
  final bool isRead;
  final String? mediaUrl;
  final MessageType messageType;
  final String? replyToId;
  final String? replyToContent;
  final String? replyToSenderId;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverID,
    required this.content,
    required this.timestamp,
    this.isRead = false,
    this.mediaUrl,
    this.messageType = MessageType.text,
    this.replyToId,
    this.replyToContent,
    this.replyToSenderId,
  });

  ChatMessage copyWith({
    String? id,
    String? senderId,
    String? receiverID,
    String? content,
    DateTime? timestamp,
    bool? isRead,
    String? mediaUrl,
    MessageType? messageType,
    String? replyToId,
    String? replyToContent,
    String? replyToSenderId,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverID: receiverID ?? this.receiverID,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      messageType: messageType ?? this.messageType,
      replyToId: replyToId ?? this.replyToId,
      replyToContent: replyToContent ?? this.replyToContent,
      replyToSenderId: replyToSenderId ?? this.replyToSenderId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverID,
      'content': content,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'isRead': isRead,
      'mediaUrl': mediaUrl,
      'messageType': MessageType.typeToString(messageType),
      'replyToId': replyToId,
      'replyToContent': replyToContent,
      'replyToSenderId': replyToSenderId,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] ?? '',
      senderId: map['senderId'] ?? '',
      receiverID: map['receiverId'] ?? '',
      content: map['content'] ?? '',
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      isRead: map['isRead'] ?? false,
      mediaUrl: map['mediaUrl'],
      messageType: map['messageType'] != null
          ? MessageType.fromString(map['messageType'])
          : MessageType.text,
      replyToId: map['replyToId'] ?? '',
      replyToContent: map['replyToContent'] ?? '',
      replyToSenderId: map['replyToSenderId'] ?? '',
    );
  }
}
