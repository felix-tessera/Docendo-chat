import 'package:docendo_chat/screens/main_screen.dart';
import 'package:docendo_chat/services/theme_service.dart';
import 'package:docendo_chat/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                  color: themeModel.currentTheme.colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(150),
                      bottomRight: Radius.circular(150))),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(
                  'assets/images/docendo_logo.png',
                ),
              ),
            ),
            const Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Text(
                    'Docendo Chat',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Connecting Minds, Sharing Knowledge!',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Spacer(),
            SignInButtonWidget(),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}

class SignInButtonWidget extends StatelessWidget {
  SignInButtonWidget({
    super.key,
  });

  DatabaseReference usersRef = FirebaseDatabase.instance.ref('users');

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
            UserService(user: user).postUser();

            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => MainScreen(user: user)));
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
