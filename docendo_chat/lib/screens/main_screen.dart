import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'account_screen.dart';
import 'messages_screen.dart';
import 'news_screen.dart';

class MainScreen extends StatefulWidget {
  User? user;

  MainScreen({super.key, this.user});

  @override
  State<MainScreen> createState() => _MainScreenState(user: user);
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  User? user;

  List<Widget> _pages = <Widget>[];

  _MainScreenState({required this.user});

  @override
  initState() {
    super.initState();
    _initPages();
  }

  _initPages() {
    _pages = [
      const NewsScreen(),
      const MassagesScreen(),
      AccountScreen(user: user)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.newspaper_outlined), label: 'Новости'),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_outlined), label: 'Сообщения'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined), label: 'Профиль'),
        ],
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: _pages.elementAt(_selectedIndex),
    );
  }
}
