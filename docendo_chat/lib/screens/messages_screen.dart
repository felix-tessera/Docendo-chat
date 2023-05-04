import 'package:docendo_chat/screens/chat_screen.dart';
import 'package:docendo_chat/services/chat_service.dart';
import 'package:docendo_chat/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/chat.dart';
import '../models/user.dart' as u;

class MassagesScreen extends StatefulWidget {
  const MassagesScreen({super.key});

  @override
  State<MassagesScreen> createState() => _MassagesScreenState();
}

List<Chat> chatsData = [];
List<Widget> chatsWidgets = [];

class _MassagesScreenState extends State<MassagesScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  bool _searching = false;
  u.User? friend;
  _toggleSearch() {
    setState(() {
      _searching = !_searching;
      debugPrint(friend?.name.toString());
      debugPrint('chatsWidgets ' + chatsWidgets.length.toString());
    });
  }

  loadData() {
    setState(() {
      debugPrint('state upd');
    });
  }

  @override
  initState() {
    super.initState();
    ChatService(callback: loadData).getChats();
  }

  // List<Widget> _setChats() {
  //   chatsWidgets.clear();
  //   chatsData.forEach((chat) {
  //     chatsWidgets.add(ChatWidget(
  //       chat: chat,
  //     ));
  //   });
  //   debugPrint('cWIDGETS ' + chatsWidgets.length.toString());
  //   debugPrint('cDATA ' + (chatsData.length).toString());
  //   setState(() {});
  //   return chatsWidgets;
  // }

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
                    debugPrint(DateTime.now().toString());
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
                children: chatsWidgets
                    .toList(), //TODO: запретить создание нескольких чатов в одним человеком
              ));
  }
}

class ChatWidget extends StatefulWidget {
  final Chat chat;
  const ChatWidget({super.key, required this.chat});

  @override
  State<ChatWidget> createState() => _ChatWidgetState(chat: chat);
}

class _ChatWidgetState extends State<ChatWidget> {
  u.User? friend;
  Chat chat;

  @override
  initState() {
    super.initState();
    getCurrentChatFriend();
  }

  getCurrentChatFriend() async {
    String currentChatFriendEmail = '';
    chat.members.forEach((element) {
      if (element != FirebaseAuth.instance.currentUser?.email.toString()) {
        currentChatFriendEmail = element;
      }
    });
    friend = await UserService(user: FirebaseAuth.instance.currentUser)
        .searchFriendForChats(currentChatFriendEmail);

    debugPrint('friend email  ${chat.members[0]}');
    setState(() {});
    // debugPrint('friend  ${friend?.name.toString()}');
  }

  _ChatWidgetState({required this.chat, this.friend});

  ImageProvider _setFriendAvatar() {
    if ((friend?.imageUrl) == null) {
      return Image.asset('assets/images/docendo_logo_avatar.png').image;
    } else {
      return Image.network((friend?.imageUrl).toString()).image;
    }
  }

  Widget _setFriendName() {
    String name = (friend?.name != null) ? (friend?.name).toString() : '';
    return Text(name);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          child: CircleAvatar(
            backgroundImage: _setFriendAvatar(),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  _setFriendName(),
                  const Spacer(),
                  Container(
                    color: Colors.yellow,
                    width: 40,
                    height: 40,
                  ),
                ],
              ),
              //TODO: отображать последнее сообщение
              Text(chat.members
                  .where((element) =>
                      element !=
                      FirebaseAuth.instance.currentUser?.email.toString())
                  .toString()),
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
    return ListView(
      children: friend == null ? [] : [FindedFriendTile(friend: friend)],
    );
  }
}

class FindedFriendTile extends StatelessWidget {
  u.User? friend;

  FindedFriendTile({super.key, required this.friend});
  ImageProvider _setFriendAvatar() {
    if ((friend?.imageUrl) == null) {
      return Image.asset('assets/images/docendo_logo_avatar.png').image;
    } else {
      return Image.network((friend?.imageUrl).toString()).image;
    }
  }

  Widget _setFriendName() {
    String name = (friend?.name != null) ? (friend?.name).toString() : '';
    return Text(name);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          child: CircleAvatar(
            backgroundImage: _setFriendAvatar(),
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
                  ChatService(callback: () {})
                      .createChat((friend?.mail).toString());
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
