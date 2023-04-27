import 'package:docendo_chat/screens/news_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import '../services/auth_service.dart';
import 'messages_screen.dart';

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
      appBar: AppBar(
        title: const Text('Профиль'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 12,
                top: 10,
                right: 18,
              ),
              child: CircleAvatar(
                backgroundImage: NetworkImage((user?.photoURL).toString()),
                radius: 50,
              ),
            ),
            Container(
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: 230,
                      height: 22,
                      child: buildMarquee((user?.displayName).toString() +
                          '\t\t\t\t\t\t\t\t\t\t')),
                  Text(
                    (user?.email).toString(),
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0XFF888888)),
                  ),
                ],
              ),
            )
          ]),
          const SizedBox(
            height: 11,
          ),
          const AccountSettingsWidget(),
          const ThemeSettingsWidget(),
          const SettingsFriendsWidget(),
          const MemorySettingsWidget()
        ],
      ),
    );
  }
}

class MemorySettingsWidget extends StatelessWidget {
  const MemorySettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SettingsDeviderWidget(),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.only(left: 27),
            child: Text(
              'Память',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0XFF888888)),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.only(left: 27),
            child: Text(
              'Очистить кэш',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ]);
    ;
  }
}

class SettingsFriendsWidget extends StatelessWidget {
  const SettingsFriendsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SettingsDeviderWidget(),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.only(left: 27),
            child: Text(
              'Друзья',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0XFF888888)),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.only(left: 27),
            child: Text(
              'Показать свой QR',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.only(left: 27),
            child: Text(
              'Сканировать QR друга',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          )
        ]);
  }
}

class ThemeSettingsWidget extends StatelessWidget {
  const ThemeSettingsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SettingsDeviderWidget(),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.only(left: 27),
            child: Text(
              'Персонализация',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0XFF888888)),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.only(left: 27),
            child: Text(
              'Изменить тему',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          )
        ]);
  }
}

class SettingsDeviderWidget extends StatelessWidget {
  const SettingsDeviderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 0,
      thickness: 1,
      indent: 0,
      endIndent: 0,
      color: Color(0XFF1d1d1d),
    );
  }
}

class AccountSettingsWidget extends StatelessWidget {
  const AccountSettingsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsDeviderWidget(),
        const SizedBox(
          height: 10,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 27),
          child: Text(
            'Аккаунт',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0XFF888888)),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 27),
          child: Text(
            'Добавить учетную запись',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () async {
            AuthService.signOut(context: context);
          },
          child: const Padding(
            padding: EdgeInsets.only(left: 27),
            child: Text(
              'Выйти',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}

Widget buildMarquee(String text) {
  return Marquee(
    text: text,
    style: const TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 22,
    ),
    scrollAxis: Axis.horizontal,
    crossAxisAlignment: CrossAxisAlignment.start,
    velocity: 50.0,
    fadingEdgeStartFraction: 0.1,
    fadingEdgeEndFraction: 0.1,
    accelerationDuration: const Duration(seconds: 0),
    accelerationCurve: Curves.linear,
    decelerationDuration: const Duration(milliseconds: 0),
  );
}
