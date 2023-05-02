import 'package:flutter/material.dart';
import '../models/user.dart';

class ChatScreen extends StatefulWidget {
  final User? friend;

  const ChatScreen({super.key, required this.friend});

  @override
  State<ChatScreen> createState() => _ChatScreenState(friend: friend);
}

class _ChatScreenState extends State<ChatScreen> {
  final User? friend;
  _ChatScreenState({required this.friend});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
