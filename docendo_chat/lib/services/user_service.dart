import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../models/user.dart' as u;

class UserService {
  DatabaseReference usersRef = FirebaseDatabase.instance.ref('users');
  DatabaseReference keyRef = FirebaseDatabase.instance.ref();
  final User? user;

  UserService({required this.user});

  postUser() async {
    final checkUserUniqueRef = FirebaseDatabase.instance
        .ref('users')
        .orderByChild('mail')
        .equalTo((user?.email).toString());
    checkUserUniqueRef.onValue.listen((event) {
      if (event.snapshot.value == null) {
        debugPrint('Пользователь записан');
        DatabaseReference postUser = usersRef.push();
        postUser.set({
          'key': postUser.key,
          'name': (user?.displayName).toString(),
          'mail': (user?.email).toString(),
          'imageUrl': (user?.photoURL).toString(),
          'friends': <String>[''],
          'chats': <String>['']
        });
      } else {
        debugPrint('Пользователь уже существует');
      }
    });
  }

  getUserFriend(String email) async {}

  addChatToUser() async {}

  Future<u.User?> searchFriend(String email) async {
    final searchFriendRef = FirebaseDatabase.instance.ref();
    final completer = Completer<u.User?>();

    final snapshot = await searchFriendRef
        .child('users')
        .orderByChild('mail')
        .equalTo(email)
        .onChildAdded
        .listen((event) async {
      if (event.snapshot.key != null) {
        debugPrint(event.snapshot.key);
        String friendKey = event.snapshot.key.toString();
        final userSnapshot =
            await searchFriendRef.child('users/$friendKey').get();
        String friendJson = jsonEncode(userSnapshot.value);
        final friendMap = jsonDecode(friendJson);
        u.User friend = u.User.fromJson(friendMap);

        completer.complete(friend);
      }
    });
    final friend = await completer.future;
    debugPrint(friend?.name.toString());
    return friend;
  }
}
