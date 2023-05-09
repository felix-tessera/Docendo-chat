import 'dart:convert';
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
      chatsWidgets.add(ChatWidget(
        chat: chatsData.last,
        //friend: currentChatFriend,
      ));
      callback();
    });
    //chatsData = chats;
  }

  sendMessage({
    required String message,
    required String chatId,
    required String sender,
  }) async {
    DateTime currentTime = DateTime.now();
    int currentHour = currentTime.hour;
    int currentMinute = currentTime.minute;
    String messageTime = '$currentHour:$currentMinute';

    final DatabaseReference messagesRef =
        FirebaseDatabase.instance.ref('messages/$chatId');
    final messagesPush = messagesRef.push();
    messagesPush.set({
      'sender': sender,
      'message': message,
      'time': messageTime,
    });
  }

  // getMessages({required String chatId}) async {
  //   final DatabaseReference messagesRef =
  //       FirebaseDatabase.instance.ref('messages/$chatId');
  //   messagesRef.orderByChild('sender').onChildAdded.listen((event) {
  //     debugPrint(event.snapshot.value.toString());
  //     final messageJson = jsonEncode(event.snapshot.value);
  //     final messageMap = jsonDecode(messageJson);
  //     Message message = Message.fromJson(messageMap);
  //   });
  // }
}
