import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../models/chat.dart';
import '../models/message.dart';
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
      'lastMessage': '',
      'lastMessageTime': '',
    });
  }

  getChats(bool mounted) async {
    final DatabaseReference chatsRef = FirebaseDatabase.instance.ref('chats');
    List<Chat> chats = [];
    chatsWidgets.clear();
    chatsData.clear();
    chats.clear();
    chatsRef.orderByValue().onChildAdded.listen((event) async {
      String jsonChat = jsonEncode(event.snapshot.value);
      final mapChat = jsonDecode(jsonChat);
      Chat chat = Chat.fromJson(mapChat);
      if (chat.members.contains(currentUser?.email)) {
        //получение последнего сообщшения
        final DatabaseReference messagesRef =
            FirebaseDatabase.instance.ref('messages/${chat.key}');
        messagesRef.orderByValue().limitToLast(1).onChildAdded.listen((event) {
          final lastMessageJson = jsonEncode(event.snapshot.value);
          debugPrint(lastMessageJson);
          final messageMap = jsonDecode(lastMessageJson);
          Message lastMessage = Message.fromJson(messageMap);
          chat.lastMessage = lastMessage.message;
          chat.lastMessageTime = lastMessage.time;
          if (mounted) {
            callback();
          }
        });
        chats.add(chat);
        chatsData = chats;
        chatsWidgets.add(ChatWidget(
          chat: chatsData.last,
        ));
        if (mounted) {
          callback();
        }
      } else {}
    });
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

  getLastMessage({required String chatId}) async {
    final DatabaseReference messagesRef =
        FirebaseDatabase.instance.ref('messages/$chatId');
    messagesRef.orderByChild('sender').onChildAdded.listen((event) {
      debugPrint(event.snapshot.value.toString());
      final messageJson = jsonEncode(event.snapshot.value);
      final messageMap = jsonDecode(messageJson);
      Message message = Message.fromJson(messageMap);
    });
  }
}
