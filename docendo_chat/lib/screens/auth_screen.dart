import 'package:docendo_chat/screens/account_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Image.asset(
                'assets/images/docendo_logo.png',
              ),
            ),
            const Center(
              child: Text(
                'Вход',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const SignInButtonWidget(),
          ],
        ),
      ),
    );
  }
}

class SignInButtonWidget extends StatelessWidget {
  const SignInButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))),
        ),
        onPressed: () async {
          User? user = await AuthService.signInWithGoogle();
          if (user != null) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => AccountScreen(user: user)));
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Image.asset(
                'assets/images/google_logo.png',
                width: 35,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              'Войдите с помощью Google',
              style: TextStyle(),
            ),
          ],
        ));
  }
}
