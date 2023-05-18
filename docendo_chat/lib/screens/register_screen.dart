import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameContoller = TextEditingController();
  final _emailContoller = TextEditingController();
  final _passwordContoller = TextEditingController();

  final String phoneNumber = "+375297812284";
  final String message = "Ваше сообщение";

  _sendSMS(String message, List<String> recipents) async {
    dynamic _result = await sendSMS(message: message, recipients: recipents);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _emailContoller,
                decoration: InputDecoration(
                    hintText: 'Телефон',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    )),
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                  onPressed: () async {
                    List<String> recipents = [phoneNumber];
                    await sendSMS(message: message, recipients: recipents);
                  },
                  child: const Text(
                    'Авторизация',
                  ))
            ],
          ),
        )),
      ),
    );
  }
}
