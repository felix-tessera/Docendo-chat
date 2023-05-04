import 'dart:async';
import 'dart:convert';
import 'package:docendo_chat/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../models/chat.dart';
import '../models/user.dart' as u;
import '../screens/messages_screen.dart';

class ChatService {
  Function callback;
  ChatService({required this.callback});

  final DatabaseReference createChatRef =
      FirebaseDatabase.instance.ref('chats');
  User? currentUser = FirebaseAuth.instance.currentUser;

  createChat(String friendEmail) async {
    DatabaseReference createChatPush = createChatRef.push();

    createChatPush.set({
      'key': createChatPush.key,
      'members': [friendEmail, (currentUser?.email).toString()],
      'lastMessage': ''
    });
  }

  getChats() async {
    final DatabaseReference chatsRef = FirebaseDatabase.instance.ref('chats');
    List<Chat> chats = [];
    chatsWidgets.clear();
    chatsData.clear();
    chats.clear();
    chatsRef
        .orderByValue()
        .startAt(currentUser?.email)
        .onChildAdded
        .listen((event) async {
      debugPrint('найден ' + event.snapshot.key.toString());
      debugPrint(event.snapshot.value.toString());
      String jsonChat = jsonEncode(event.snapshot.value);
      final mapChat = jsonDecode(jsonChat);
      Chat chat = Chat.fromJson(mapChat);
      chats.add(chat);
      debugPrint('first member' + chat.members.first);
      debugPrint('chatsData ' + (chatsData.length).toString());
      chatsData = chats;

      // String currentChatFriendEmail = chats.last.members
      //     .where((element) =>
      //         element != FirebaseAuth.instance.currentUser?.email.toString())
      //     .toString();

      // final currentChatFriend =
      //     await UserService(user: FirebaseAuth.instance.currentUser)
      //         .searchFriend(currentChatFriendEmail);

      chatsWidgets.add(ChatWidget(
        chat: chatsData.last,
        //friend: currentChatFriend,
      ));
      callback();
    });
    //chatsData = chats;
  }
}
