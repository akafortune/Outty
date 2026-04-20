import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:outty/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  var userDocRef = await FirebaseFirestore.instance
      .collection("Users")
      .doc("userDetails")
      .get();
  var userDoc = userDocRef.data();

  var chatRoomDocRef = await FirebaseFirestore.instance
      .collection("ChatRooms")
      .doc("chatroom blueprint")
      .get();
  var chatRoomDoc = chatRoomDocRef.data();

  var chatLogDocRef = await FirebaseFirestore.instance
      .collection("ChatRooms")
      .doc("chatroom blueprint")
      .collection("Chats")
      .doc("Chat")
      .get();
  var chatLogDoc = chatLogDocRef.data();

  String addedUserID = '';

  group("Unit Tests", () {
    test("Get user name from firebase", () {
      String userName = userDoc!["name"];

      expect(userName, 'demo user');
    });

    test("Get user gender from firebase", () {
      String userGender = userDoc!["gender"];

      expect(userGender, 'male');
    });

    test("Get user education from firebase", () {
      String edu = userDoc!["education"];

      expect(edu, 'college');
    });

    test("Get user bio from firebase", () {
      String bio = userDoc!["bio"];

      expect(bio, 'userBio');
    });

    test("Get user age from firebase", () {
      String age = userDoc!["age"];

      expect(age, 0);
    });

    test("Get chat room ID from firebase", () {
      String id = chatRoomDoc!["roomID"];

      expect(id, 0);
    });

    test("Get chat room user 1 from firebase", () {
      String user1 = chatRoomDoc!["user1ID"];

      expect(user1, 'demo user');
    });

    test("Get chat room user 2 from firebase", () {
      String user2 = chatRoomDoc!["user2ID"];

      expect(user2, 'demo user 2');
    });

    test("Get chat log content from firebase", () {
      String msgContent = chatLogDoc!["content"];

      expect(msgContent, 'a message');
    });

    test("Get chat log senderID from firebase", () {
      String senderID = chatLogDoc!["senderID"];

      expect(senderID, 'demoUser');
    });
  });

  group("TDD Test", () {
    test("add user to firebase", () async {
      DocumentReference doc = await FirebaseFirestore.instance
          .collection("Users")
          .add({
            'bio': "test",
            'gender': "Male",
            'interests': "Nothing,Nothing,Nothing",
            'name': "A Test User",
            'userID': "123456",
          });
      addedUserID = doc.id;
    });

    test("check user exists", () async {
      var doc = await FirebaseFirestore.instance
          .collection("Users")
          .doc(addedUserID)
          .get();

      var docData = doc.data();

      expect(docData!["name"], 'A Test User');
    });

    test("check update works", () async {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(addedUserID)
          .update({"name": "john"});

      var doc = await FirebaseFirestore.instance
          .collection("Users")
          .doc(addedUserID)
          .get();

      var docData = doc.data();

      expect(docData!["name"], 'john');

      await FirebaseFirestore.instance
          .collection("Users")
          .doc(addedUserID)
          .delete();
    });
  });
}
