import 'package:docendo_chat/screens/help_screen.dart';
import 'package:docendo_chat/screens/messages_screen.dart';
import 'package:docendo_chat/screens/qr_generate_screen.dart';
import 'package:docendo_chat/screens/themes_screen.dart';
import 'package:docendo_chat/services/chat_service.dart';
import 'package:docendo_chat/services/theme_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:marquee/marquee.dart';
import '../services/auth_service.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class AccountScreen extends StatefulWidget {
  AccountScreen({super.key, required this.user});

  User? user;

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: const TextStyle(
            color: Color.fromARGB(255, 255, 255, 255), letterSpacing: 0.5),
      ),
    );
  }

  @override
  State<AccountScreen> createState() => _AccountScreenState(user);
}

class _AccountScreenState extends State<AccountScreen> {
  User? user;
  DefaultCacheManager manager = DefaultCacheManager();

  _AccountScreenState(this.user);

  @override
  void initState() {
    ChatService(callback: () {}).getChats(mounted);
    themeModel.addListener(_accountUpdate);
    super.initState();
  }

  _accountUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: IconButton(
              icon: const Icon(Icons.help),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HelpScreen()));
              },
            ),
          )
        ],
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
              child: CircleAvatarWidget(imageUrl: (user?.photoURL).toString()),
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
                        fontSize: 16,
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
          Expanded(
            child: ListView(
              children: [
                Card(
                  color: themeModel.currentTheme.colorScheme.background,
                  elevation: 5,
                  child: const AccountSettingsWidget(),
                ),
                Card(
                    color: themeModel.currentTheme.colorScheme.background,
                    elevation: 5,
                    child: const ThemeSettingsWidget()),
                Card(
                    color: themeModel.currentTheme.colorScheme.background,
                    elevation: 5,
                    child: const SettingsFriendsWidget()),
                Card(
                    color: themeModel.currentTheme.colorScheme.background,
                    elevation: 5,
                    child: const MemorySettingsWidget())
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MemorySettingsWidget extends StatelessWidget {
  const MemorySettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(
        height: 10,
      ),
      const Padding(
        padding: EdgeInsets.only(left: 27),
        child: Text(
          'Память',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0XFF888888)),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 27),
        child: Row(
          children: [
            const Icon(Icons.delete_outline_outlined),
            const SizedBox(
              width: 7,
            ),
            TextButton(
              onPressed: () async {
                await DefaultCacheManager().emptyCache();
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Кэш очищен')));
                debugPrint('Кэш очищен');
              },
              child: const Text(
                'Очистить кэш',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}

class SettingsFriendsWidget extends StatelessWidget {
  const SettingsFriendsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(
        height: 10,
      ),
      const Padding(
        padding: EdgeInsets.only(left: 27),
        child: Text(
          'Друзья',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0XFF888888)),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 27),
        child: Row(
          children: [
            const Icon(Icons.qr_code),
            const SizedBox(
              width: 7,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => QRGenerateScreen()));
              },
              child: const Text(
                'Показать свой QR',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
      GestureDetector(
        onTap: () async {
          String barcodeScanRes;
          barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
              "#38ff63", "Cancel", true, ScanMode.QR);
          if (barcodeScanRes != '-1' &&
              chatsData.every(
                  (element) => !element.members.contains(barcodeScanRes))) {
            ChatService(callback: () {}).createChat(barcodeScanRes);
            ScaffoldMessenger.of(context).showSnackBar(
              AccountScreen.customSnackBar(
                content: 'Чат с пользователем создан',
              ),
            );
          } else {
            debugPrint(
                'Чат создать не удалось, либо такой чат уже сушествует.');
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 27),
          child: Row(
            children: [
              const Icon(Icons.camera_alt_outlined),
              const SizedBox(
                width: 7,
              ),
              TextButton(
                onPressed: () async {
                  String barcodeScanRes;
                  barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                      "#38ff63", "Cancel", true, ScanMode.QR);
                  if (barcodeScanRes != '-1' &&
                      chatsData.every((element) =>
                          !element.members.contains(barcodeScanRes))) {
                    ChatService(callback: () {}).createChat(barcodeScanRes);
                    ScaffoldMessenger.of(context).showSnackBar(
                      AccountScreen.customSnackBar(
                        content: 'Чат с пользователем создан',
                      ),
                    );
                  } else {
                    debugPrint(
                        'Чат создать не удалось, либо такой чат уже сушествует.');
                  }
                },
                child: const Text(
                  'Сканировать QR друга',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(
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
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(
        height: 10,
      ),
      const Padding(
        padding: EdgeInsets.only(left: 27),
        child: Text(
          'Персонализация',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0XFF888888)),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 27),
        child: Row(
          children: [
            const Icon(Icons.brush_outlined),
            const SizedBox(
              width: 7,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ThemesScreen()));
              },
              child: const Text(
                'Изменить тему',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
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
      thickness: 0.7,
      indent: 0,
      endIndent: 0,
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
        const SizedBox(
          height: 10,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 27),
          child: Text(
            'Аккаунт',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0XFF888888)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 27),
          child: Row(
            children: [
              const Icon(Icons.person_add_outlined),
              const SizedBox(
                width: 7,
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Добавить учетную запись',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 27),
          child: Row(
            children: [
              const Icon(Icons.exit_to_app),
              const SizedBox(
                width: 7,
              ),
              TextButton(
                onPressed: () {
                  AuthService.signOut(context: context);
                },
                child: const Text(
                  'Выйти',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
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

class CircleAvatarWidget extends StatelessWidget {
  final String imageUrl;

  const CircleAvatarWidget({Key? key, required this.imageUrl})
      : super(key: key);

  Future<File> getImageFile(String url) async {
    // await FirebaseAuth.instance.currentUser?.sendEmailVerification();
    debugPrint(FirebaseAuth.instance.currentUser?.email);

    final cacheManager = DefaultCacheManager();
    final file = await cacheManager.getSingleFile(url);
    return file;
  }

  Future<ImageProvider<Object>> getCachedImage(String url) async {
    final file = await getImageFile(url);
    return Image.file(file).image;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCachedImage(imageUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Text('Error loading image');
          } else {
            return CircleAvatar(
              backgroundImage: snapshot.data,
              radius: 40,
            );
          }
        } else {
          return const CircleAvatar(
            backgroundColor: Colors.grey,
            radius: 40,
          );
        }
      },
    );
  }
}
