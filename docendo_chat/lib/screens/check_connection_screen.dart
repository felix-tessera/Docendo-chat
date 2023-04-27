import 'package:docendo_chat/screens/account_screen.dart';
import 'package:docendo_chat/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'auth_screen.dart';
import '..\\firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';

class CheckConnectionSceen extends StatefulWidget {
  const CheckConnectionSceen({super.key});

  @override
  State<CheckConnectionSceen> createState() => _CheckConnectionScreenState();
}

class _CheckConnectionScreenState extends State<CheckConnectionSceen> {
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  @override
  initState() {
    super.initState();
    _checkConnection();
  }

  _checkConnection() async {
    bool isConnected = await InternetConnectionChecker().hasConnection;
    if (isConnected) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => MainScreen(user: user)));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const AuthScreen()));
      }
    } else {
      checkData = const Text('Отсутствует подключение к интернету');
      setState(() {});
    }
  }

  Widget checkData = const CircularProgressIndicator();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: checkData,
    ));
  }
}
