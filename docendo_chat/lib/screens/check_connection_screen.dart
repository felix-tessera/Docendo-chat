import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'auth_screen.dart';

class CheckConnectionSceen extends StatefulWidget {
  const CheckConnectionSceen({super.key});

  @override
  State<CheckConnectionSceen> createState() => _CheckConnectionScreenState();
}

class _CheckConnectionScreenState extends State<CheckConnectionSceen> {
  @override
  initState() {
    super.initState();
    _checkConnection();
  }

  _checkConnection() async {
    bool isConnected = await InternetConnectionChecker().hasConnection;
    if (isConnected) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AuthScreen()));
    } else {
      checkData = Text('Отсутствует подключение к интернету');
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
