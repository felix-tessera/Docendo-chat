import 'package:flutter/material.dart';

class MassagesScreen extends StatefulWidget {
  const MassagesScreen({super.key});

  @override
  State<MassagesScreen> createState() => _MassagesScreenState();
}

class _MassagesScreenState extends State<MassagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Сообщения'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(children: [FriendContactWidget()]),
    );
    ;
  }
}

class FriendContactWidget extends StatefulWidget {
  const FriendContactWidget({super.key});

  @override
  State<FriendContactWidget> createState() => _FriendContactWidgetState();
}

class _FriendContactWidgetState extends State<FriendContactWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
