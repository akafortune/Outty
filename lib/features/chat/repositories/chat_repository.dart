import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:outty/features/chat/models/chat_message.dart';
import 'package:outty/features/chat/models/chat_room.dart';

class ChatRepository {
  static String otherID = "";
  Future<List<ChatMessage>> getChatMessagesFromFirestore() async {
    String userID = await FirebaseAuth.instance.currentUser!.uid;
    String chatRoomID = "";
    List<Map<String, dynamic>> chatFormatted = [];
    var chatRoom = await FirebaseFirestore.instance
        .collection("ChatRooms")
        .where(
          Filter.or(
            Filter.and(
              Filter("user1ID", isEqualTo: userID),
              Filter("user2ID", isEqualTo: otherID),
            ),
            Filter.and(
              Filter("user1ID", isEqualTo: otherID),
              Filter("user2ID", isEqualTo: userID),
            ),
          ),
        )
        .get()
        .then((querySnapshot) {
          if (querySnapshot.docs.isNotEmpty) {
            chatRoomID = querySnapshot.docs.first.id;
          }
        });

    var messages = await FirebaseFirestore.instance
        .collection("ChatRooms")
        .doc(chatRoomID)
        .collection("Chats")
        .get()
        .then((querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            chatFormatted.add(docSnapshot.data());
          }
        });

    List<ChatMessage> messageList = [];

    for (Map<String, dynamic> entry in chatFormatted) {
      String receiver;

      if (entry["senderID"] == userID) {
        receiver = otherID;
      } else {
        receiver = userID;
      }

      ChatMessage msg = ChatMessage(
        id: Random().nextInt(100000).toString(),
        senderId: entry["senderID"],
        receiverID: receiver,
        content: entry["content"],
        timestamp: DateTime.now(),
        msgNum: entry["msgNum"],
      );

      messageList.add(msg);
    }

    messageList.sort((a, b) => a.msgNum.compareTo(b.msgNum));

    return messageList;
  }

  void AddMessageToChatRoom(String message) async {
    String userID = await FirebaseAuth.instance.currentUser!.uid;
    var docID;
    int msgNum = 0;
    var chatRoom = await FirebaseFirestore.instance
        .collection("ChatRooms")
        .where(
          Filter.or(
            Filter.and(
              Filter("user1ID", isEqualTo: userID),
              Filter("user2ID", isEqualTo: otherID),
            ),
            Filter.and(
              Filter("user1ID", isEqualTo: otherID),
              Filter("user2ID", isEqualTo: userID),
            ),
          ),
        )
        .get()
        .then((querySnapshot) {
          if (querySnapshot.docs.isNotEmpty) {
            docID = querySnapshot.docs.first.id;
          }
        });

    await FirebaseFirestore.instance
        .collection("ChatRooms")
        .doc(docID)
        .collection("Chats")
        .get()
        .then((querySnapshot) {
          msgNum = querySnapshot.docs.length;
        });

    var chatMessages = FirebaseFirestore.instance
        .collection("ChatRooms")
        .doc(docID)
        .collection("Chats")
        .add({"content": message, "senderID": userID, "msgNum": msgNum});
  }

  Future<List<ChatRoom>> getChatRoomsFromFirestore() async {
    String id = await FirebaseAuth.instance.currentUser!.uid;

    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = [];

    var chatRooms = await FirebaseFirestore.instance
        .collection("ChatRooms")
        .where(
          Filter.or(
            Filter("user1ID", isEqualTo: id),
            Filter("user2ID", isEqualTo: id),
          ),
        )
        .get()
        .then((querySnapshot) {
          if (querySnapshot.docs.isNotEmpty) {
            docs = querySnapshot.docs;
          }
        });

    List<ChatRoom> rooms = [];

    for (int i = 0; i < docs.length; i++) {
      var docData = docs[i].data();
      var otherUserID = "";

      if (docData["user1ID"] == id) {
        otherUserID = docData["user2ID"];
      } else {
        otherUserID = docData["user1ID"];
      }

      var userDataQuery = await FirebaseFirestore.instance
          .collection("Users")
          .where("userID", isEqualTo: id)
          .get();
      var userDoc = userDataQuery.docs.first.data();

      var otherUserQuery = await FirebaseFirestore.instance
          .collection("Users")
          .where("userID", isEqualTo: otherUserID)
          .get();
      var otherDoc = otherUserQuery.docs.first.data();

      var photo = otherDoc["photos"].toString().split(",")[0];

      ChatRoom room = ChatRoom(
        id: docData["roomID"],
        userId: id,
        matchId: otherUserID,
        matchName: otherDoc["name"],
        matchImage: photo,
        createdAt: DateTime.now(),
        isMatchOnline: false,
      );

      rooms.add(room);
    }

    return rooms;
  }

  Future<List<ChatRoom>> getChatRooms(String userId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return [];
  }

  Future<List<ChatMessage>> getChatMessages(String chatRoomId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return [];
  }

  Future<void> sendMessage(ChatMessage message) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> markMessageAsRead(String chatRoomId) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<ChatRoom?> getChatRoomByMatchId(String userId, String matchId) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<ChatRoom> createChatRoom(ChatRoom chatRoom) async {
    var db = FirebaseFirestore.instance;
    String? auth = FirebaseAuth.instance.currentUser?.uid;

    DocumentReference doc = await db.collection("ChatRooms").add({
      'user1ID': auth,
      'user2ID': chatRoom.id,
    });
    doc.collection('Chats').add({'room': doc});
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
