import 'package:docendo_chat/screens/chat_screen.dart';
import 'package:docendo_chat/services/chat_service.dart';
import 'package:docendo_chat/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user.dart' as u;

class MassagesScreen extends StatefulWidget {
  const MassagesScreen({super.key});

  @override
  State<MassagesScreen> createState() => _MassagesScreenState();
}

class _MassagesScreenState extends State<MassagesScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  bool _searching = false;
  u.User? friend;
  void _toggleSearch() {
    setState(() {
      _searching = !_searching;
      debugPrint(friend?.name.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: _searching
              ? TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'myfriendemail@gmail.com',
                    border: UnderlineInputBorder(),
                  ),
                  onSubmitted: (email) async {
                    friend = await UserService(user: user).searchFriend(email);
                    debugPrint(friend?.name.toString());
                    setState(() {});
                  },
                )
              : const Text('Сообщения'),
          actions: <Widget>[
            IconButton(
              icon: _searching
                  ? const Icon(
                      Icons.close,
                      color: Colors.white,
                    )
                  : const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
              onPressed: () {
                _toggleSearch();
              },
            )
          ],
          centerTitle: true,
          elevation: 0,
        ),
        body: _searching
            ? FindedFriendWidget(friend: friend)
            : ListView(
                children: [ChatsWidget()],
              ));
  }
}

class ChatsWidget extends StatelessWidget {
  u.User? friend;

  ChatsWidget({super.key});

  ImageProvider setFriendAvatar() {
    if ((friend?.imageUrl) == null) {
      return Image.asset('assets/images/docendo_logo_avatar.png').image;
    } else {
      return Image.network((friend?.imageUrl).toString()).image;
    }
  }

  @override
  Widget build(BuildContext context) {
    ChatService().getChats();

    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          child: CircleAvatar(
            backgroundImage: setFriendAvatar(),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text((friend?.name).toString()),
                  const Spacer(),
                  Container(
                    color: Colors.yellow,
                    width: 40,
                    height: 40,
                  ),
                ],
              ),
              Container(
                color: Colors.grey,
                width: 40,
                height: 40,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class FindedFriendWidget extends StatelessWidget {
  final u.User? friend;
  const FindedFriendWidget({super.key, required this.friend});

  ImageProvider setFriendAvatar() {
    if ((friend?.imageUrl) == null) {
      return Image.asset('assets/images/docendo_logo_avatar.png').image;
    } else {
      return Image.network((friend?.imageUrl).toString()).image;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          child: CircleAvatar(
            backgroundImage: setFriendAvatar(),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text((friend?.name).toString()),
                  const SizedBox(
                    width: 40,
                    height: 40,
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  ChatService().createChat((friend?.mail).toString());
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatScreen(friend: friend)));
                },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)))),
                child: const Icon(Icons.chat_rounded),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
