import 'dart:convert';
import 'package:docendo_chat/services/chat_service.dart';
import 'package:docendo_chat/services/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../models/chat.dart';
import '../models/message.dart';
import '../models/user.dart' as u;

class ChatScreen extends StatefulWidget {
  final u.User? friend;
  final Chat chat;
  const ChatScreen({super.key, required this.friend, required this.chat});

  @override
  State<ChatScreen> createState() =>
      _ChatScreenState(friend: friend, chat: chat);
}

class _ChatScreenState extends State<ChatScreen> {
  final u.User? friend;
  final Chat chat;
  _ChatScreenState({required this.friend, required this.chat});
  bool _showFloatingActionButton = false;

  @override
  void initState() {
    getMessages(chatId: chat.key);
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _showFloatingActionButton = _scrollController.offset <
            _scrollController.position.maxScrollExtent;
      });
    });
  }

  ImageProvider _setFriendAvatar() {
    if ((friend?.imageUrl) == null) {
      return Image.asset('assets/images/docendo_logo_avatar.png').image;
    } else {
      return Image.network((friend?.imageUrl).toString()).image;
    }
  }

  List<Message> messages = [];
  List<Widget> messagesWidgets = [];

  Widget _setFriendName() {
    String name = (friend?.name != null) ? (friend?.name).toString() : '';

    return Text(name);
  }

  getMessages({required String chatId}) async {
    final DatabaseReference messagesRef =
        FirebaseDatabase.instance.ref('messages/$chatId');
    messagesRef.orderByValue().onChildAdded.listen((event) {
      final messageJson = jsonEncode(event.snapshot.value);
      final messageMap = jsonDecode(messageJson);
      Message message = Message.fromJson(messageMap);
      messages.add(message);

      if (mounted) {
        setState(() {
          messagesWidgets.add(MessageWidget(message: message));
        });
      }
      try {
        _scrollToDown();
      } catch (e) {
        debugPrint(e.toString());
      }
    });
  }

  _scrollToDown() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          CircleAvatar(
            backgroundImage: _setFriendAvatar(),
          ),
          const SizedBox(
            width: 10,
          ),
          _setFriendName()
        ]),
      ),
      floatingActionButton: _showFloatingActionButton
          ? FloatingActionButton(
              onPressed: () {
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 5),
                  curve: Curves.easeInOut,
                );
              },
              child: const Icon(Icons.keyboard_arrow_down),
            )
          : null,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: _scrollController,
              children: messagesWidgets.toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onTap: () {
                      _scrollToDown();
                    },
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      hintText: 'Сообщение',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_textEditingController.text != '') {
                      ChatService(callback: () {
                        setState(() {});
                      }).sendMessage(
                          message: _textEditingController.text,
                          chatId: chat.key,
                          sender: (FirebaseAuth.instance.currentUser?.email)
                              .toString());
                      // Отправить сообщение
                      //Отправка уведомления
                      NotificationSerivce().sendNotificationOnMessage(
                          (friend?.token).toString(),
                          (friend?.name).toString(),
                          _textEditingController.text);
                      _textEditingController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  final Message message;

  const MessageWidget({super.key, required this.message});

  getMessageAlign() {
    if (message.sender == FirebaseAuth.instance.currentUser?.email.toString()) {
      return Alignment.topRight;
    } else {
      return Alignment.topLeft;
    }
  }

  getMessageColor() {
    if (message.sender == FirebaseAuth.instance.currentUser?.email.toString()) {
      return Colors.black87;
    } else {
      return Colors.black54;
    }
  }

  getBoxDecoration() {
    if (message.sender == FirebaseAuth.instance.currentUser?.email.toString()) {
      return BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
              bottomLeft: Radius.circular(50)),
          color: getMessageColor());
    } else {
      return BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
              bottomRight: Radius.circular(50)),
          color: getMessageColor());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: getMessageAlign(),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          decoration: getBoxDecoration(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  message.message,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  message.time,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
