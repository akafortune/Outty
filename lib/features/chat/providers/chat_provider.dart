import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:outty/core/enums/message_type.dart';
import 'package:outty/features/chat/models/chat_message.dart';
import 'package:outty/features/chat/models/chat_room.dart';
import 'package:outty/features/chat/repositories/chat_repository.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepository _repository;

  List<ChatRoom> _chatRooms = [];
  Map<String, List<ChatMessage>> _messages = {};
  bool _isLoading = false;
  String? _error;
  String _currentUserId = FirebaseAuth.instance.currentUser!.uid;

  ChatProvider({required ChatRepository repository})
    : _repository = repository {
    _loadChatRooms();
  }

  List<ChatRoom> get chatRooms => _chatRooms;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get currentUserId => _currentUserId;

  List<ChatMessage> getMessagesForChatRoom(String chatRoomId) {
    return _messages[chatRoomId] ?? [];
  }

  Future<void> SetChatMessageIndex(int index) async {
    List<ChatRoom> rooms = await _repository.getChatRoomsFromFirestore();

    ChatRepository.otherID = rooms[index].matchId;
  }

  Future<void> _loadChatRooms() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _chatRooms = await _repository.getChatRoomsFromFirestore();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> loadMessages(String chatRoomId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final messages = await _repository.getChatMessagesFromFirestore();
      _messages[chatRoomId] = messages;

      await _repository.markMessageAsRead(chatRoomId);

      final index = _chatRooms.indexWhere((room) => room.id == chatRoomId);
      if (index != -1) {
        _chatRooms[index] = _chatRooms[index].copyWith(unreadCount: 0);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> sendMessage(
    String chatRoomId,
    String content, {
    String? mediaUrl,
  }) async {
    try {
      final message = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: _currentUserId,
        receiverID: _chatRooms
            .firstWhere((room) => room.id == chatRoomId)
            .matchId,
        content: content,
        timestamp: DateTime.now(),
        isRead: false,
        mediaUrl: mediaUrl,
        msgNum: 0,
      );

      if (_messages.containsKey(chatRoomId)) {
        _messages[chatRoomId] = [..._messages[chatRoomId]!, message];
      } else {
        _messages[chatRoomId] = [message];
      }

      final index = chatRooms.indexWhere((room) => room.id == chatRoomId);

      if (index != -1) {
        _chatRooms[index] = _chatRooms[index].copyWith(
          lastMessage: message,
          lastActivity: DateTime.now(),
        );
      }

      notifyListeners();

      await _repository.sendMessage(message);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<ChatRoom> getOrCreateChatRoomForMatch(
    String matchId,
    String matchName,
    String matchImage,
    bool isMatchOnline,
  ) async {
    try {
      final existingRoom = await _repository.getChatRoomByMatchId(
        _currentUserId,
        matchId,
      );
      return existingRoom!;
    } catch (e) {
      final newRoom = ChatRoom(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: _currentUserId,
        matchId: matchId,
        matchName: matchName,
        matchImage: matchImage,
        isMatchOnline: isMatchOnline,
        createdAt: DateTime.now(),
        lastActivity: DateTime.now(),
      );

      final createdRoom = await _repository.createChatRoom(newRoom);

      _chatRooms = [..._chatRooms, createdRoom];
      notifyListeners();
      return createdRoom;
    }
  }

  Future<void> refreshChatRooms() async {
    await _loadChatRooms();
  }

  Future<void> sendMediaMessage(
    String chatRoomId,
    String mediaPath,
    MessageType messageType, {
    String caption = '',
  }) async {
    try {
      final String mediaUrl = mediaPath;
      final message = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: _currentUserId,
        receiverID: _chatRooms
            .firstWhere((room) => room.id == chatRoomId)
            .matchId,
        content: caption,
        timestamp: DateTime.now(),
        isRead: false,
        mediaUrl: mediaUrl,
        messageType: messageType,
        msgNum: 0,
      );

      if (_messages.containsKey(chatRoomId)) {
        _messages[chatRoomId] = [..._messages[chatRoomId]!, message];
      } else {
        _messages[chatRoomId] = [message];
      }

      final index = _chatRooms.indexWhere((room) => room.id == chatRoomId);
      if (index != 1) {
        _chatRooms[index] = _chatRooms[index].copyWith(
          lastMessage: message,
          lastActivity: DateTime.now(),
        );
      }

      notifyListeners();

      await _repository.sendMessage(message);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> sendReplyMessage(
    String chatRoomId,
    String content,
    ChatMessage replyToMessage, {
    String? mediaUrl,
    MessageType messageType = MessageType.text,
  }) async {
    try {
      final message = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: _currentUserId,
        receiverID: _chatRooms
            .firstWhere((room) => room.id == chatRoomId)
            .matchId,
        content: content,
        timestamp: DateTime.now(),
        isRead: false,
        mediaUrl: mediaUrl,
        messageType: messageType,
        replyToId: replyToMessage.id,
        replyToContent: replyToMessage.content,
        replyToSenderId: replyToMessage.senderId,
        msgNum: 0,
      );

      if (_messages.containsKey(chatRoomId)) {
        _messages[chatRoomId] = [..._messages[chatRoomId]!, message];
      } else {
        _messages[chatRoomId] = [message];
      }

      final index = _chatRooms.indexWhere((room) => room.id == chatRoomId);
      if (index != -1) {
        _chatRooms[index] = _chatRooms[index].copyWith(
          lastMessage: message,
          lastActivity: DateTime.now(),
        );
      }

      notifyListeners();

      await _repository.sendMessage(message);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> blockUser(String blockedUserId) async {
    try {
      const String currentUserId = 'current_user';

      await _repository.blockUser(currentUserId, blockedUserId);

      notifyListeners();
    } catch (e) {
      print('Error blocking user: $e');
    }
  }

  Future<void> reportUser(String reportedUserId, String reason) async {
    try {
      const String current = 'current_user';

      await _repository.reportUser(currentUserId, reportedUserId, reason);
    } catch (e) {
      print('Error reporting user: $e');
    }
  }
}
