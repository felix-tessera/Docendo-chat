import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  AccountScreen({super.key, required this.user});

  User? user;

  @override
  State<AccountScreen> createState() => _AccountScreenState(user);
}

class _AccountScreenState extends State<AccountScreen> {
  User? user;
  _AccountScreenState(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Image.network((user?.photoURL).toString()),
        Text((user?.displayName).toString()),
        Text((user?.email).toString())
      ]),
    );
  }
}
