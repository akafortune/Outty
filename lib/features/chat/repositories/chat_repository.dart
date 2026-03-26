import 'package:outty/features/chat/models/chat_message.dart';
import 'package:outty/features/chat/models/chat_room.dart';

class ChatRepository {
  Future<List<ChatRoom>> getChatRooms(String userId) async {
    await Future.delayed(const Duration(milliseconds: 800));

    return [
      ChatRoom(
        id: '1',
        userId: 'current_user',
        matchId: '1',
        matchName: 'Jessica',
        matchImage: 'images/user11.jpg',
        isMatchOnline: true,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        lastActivity: DateTime.now().subtract(const Duration(minutes: 2)),
        lastMessage: ChatMessage(
          id: 'm1',
          senderId: '1',
          receiverID: 'current_user',
          content: 'Hey, how are you doing?',
          timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
          isRead: false,
        ),
        unreadCount: 2,
      ),
      ChatRoom(
        id: '2',
        userId: 'current_user',
        matchId: '3',
        matchName: 'Sophia',
        matchImage: 'images/user22.jpg',
        isMatchOnline: true,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        lastActivity: DateTime.now().subtract(const Duration(hours: 1)),
        lastMessage: ChatMessage(
          id: 'm2',
          senderId: '3',
          receiverID: 'current_user',
          content: 'I would love to go hiking this weekend!',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          isRead: true,
        ),
        unreadCount: 0,
      ),
      ChatRoom(
        id: '3',
        userId: 'current_user',
        matchId: '5',
        matchName: 'Emma',
        matchImage: 'images/user31.jpg',
        isMatchOnline: false,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        lastActivity: DateTime.now().subtract(const Duration(hours: 3)),
        lastMessage: ChatMessage(
          id: 'm3',
          senderId: 'current_user',
          receiverID: '5',
          content: 'That sounds like a great idea',
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
          isRead: true,
        ),
        unreadCount: 0,
      ),
    ];
  }

  Future<List<ChatMessage>> getChatMessages(String chatRoomId) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (chatRoomId == '1') {
      return [
        ChatMessage(
          id: 'm1',
          senderId: '1',
          receiverID: 'current_user',
          content: 'Hey how are you doing',
          timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
          isRead: false,
        ),
        ChatMessage(
          id: 'm1-1',
          senderId: '1',
          receiverID: 'current_user',
          content:
              'I saw your profile and thought we might have a lot in common!',
          timestamp: DateTime.now().subtract(
            const Duration(minutes: 1, seconds: 45),
          ),
          isRead: false,
        ),
      ];
    } else if (chatRoomId == '2') {
      return [
        ChatMessage(
          id: 'm2-1',
          senderId: 'current_user',
          receiverID: '3',
          content: 'Hi sophia! I noticed you like hiking too',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          isRead: true,
        ),
        ChatMessage(
          id: 'm2-2',
          senderId: '3',
          receiverID: 'current_user',
          content: 'Yes! I try to go every weekend when the weather is nice.',
          timestamp: DateTime.now().subtract(
            const Duration(hours: 1, minutes: 30),
          ),
          isRead: true,
        ),
        ChatMessage(
          id: 'm2-3',
          senderId: 'current_user',
          receiverID: '3',
          content: 'That sounds amazing, do you have a favorite trail?',
          timestamp: DateTime.now().subtract(
            const Duration(hours: 1, minutes: 15),
          ),
          isRead: true,
        ),
        ChatMessage(
          id: 'm2-4',
          senderId: '3',
          receiverID: 'current_user',
          content: 'I would love to go hiking this weekend!',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          isRead: true,
        ),
      ];
    } else {
      return [
        ChatMessage(
          id: 'm3-1',
          senderId: '5',
          receiverID: 'current_user',
          content:
              'I was thinking we could check out that new restaurant downtown',
          timestamp: DateTime.now().subtract(const Duration(hours: 4)),
          isRead: true,
        ),

        ChatMessage(
          id: 'm3-2',
          senderId: 'current_user',
          receiverID: '5',
          content: 'That sounds like a great idea',
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
          isRead: true,
        ),
      ];
    }
  }

  Future<void> sendMessage(ChatMessage message) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> markMessageAsRead(String chatRoomId) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<ChatRoom?> getChatRoomByMatchId(String userId, String matchId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final rooms = await getChatRooms(userId);
    return rooms.firstWhere(
      (room) => room.matchId == matchId,
      orElse: () => throw Exception('Chat room not found'),
    );
  }

  Future<ChatRoom> createChatRoom(ChatRoom chatRoom) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return chatRoom;
  }

  Future<void> blockUser(String userId, String blockedUserId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    print('User $userId blocked user $blockedUserId');
  }

  Future<void> reportUser(
    String userId,
    String reportedUserId,
    String reason,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));

    print('User $userId blocked user $reportedUserId for reason: $reason');
  }
}
