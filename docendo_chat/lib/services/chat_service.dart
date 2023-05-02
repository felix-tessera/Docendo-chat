import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../models/user.dart' as u;

class ChatService {
  final DatabaseReference createChatRef =
      FirebaseDatabase.instance.ref('chats');
  final DatabaseReference membersRef = FirebaseDatabase.instance.ref('members');
  User? currentUser = FirebaseAuth.instance.currentUser;

  createChat(String friendEmail) async {
    DatabaseReference createChatPush = createChatRef.push();

    createChatPush.set({
      'key': createChatPush.key,
      'members': [friendEmail, (currentUser?.email).toString()],
      'lastMessage': ''
    });
    DatabaseReference friendRef = FirebaseDatabase.instance.ref();
    final friendSnapshot = await friendRef
        .child('users')
        .orderByChild('mail')
        .equalTo(friendEmail)
        .get();
    String friendJson = jsonEncode(friendSnapshot.value);
    final friendMap = jsonDecode(friendJson);
    u.User friend = u.User.fromJson(friendMap);
    final friendKey = friend.key;
    friendRef.child('users/$friendKey').set({'chats/0': createChatPush.key});
    debugPrint('успешно');
    // final friendKey = friendSnapshot.snapshot.key;
  }

  getChats() async {
    final DatabaseReference chats = FirebaseDatabase.instance.ref('chats');

    chats
        .orderByChild('members')
        .equalTo(currentUser?.email.toString())
        .onChildAdded
        .listen((event) {
      debugPrint(event.snapshot.value.toString());
    });
  }
}
