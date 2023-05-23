import 'package:docendo_chat/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemesScreen extends StatefulWidget {
  const ThemesScreen({super.key});

  @override
  State<ThemesScreen> createState() => _ThemesScreenState();
}

List<String> names = [
  'Морская волна\n(Светлая)',
  'Зеленый туман\n(Темная)',
  'Тропический\nцветок\n(Светлая)',
  'Яблочный\nконстраст\n(Темная)',
  'Садовая свежесть\n(Светлая)',
  'Сумеречные\nоблака\n(Темная)',
  'Величественный\nзамок\n(Светлая)',
  'Вишня\nна снегу\n(Светлая)',
  'Дымчатый\nпурпур\n(Светлая)',
];

List<ColorScheme> colorSchemes = [
  const ColorScheme.light(
    primary: Color(0xFF66A6AD),
    secondary: Color(0xFF07575B),
    background: Color.fromARGB(255, 235, 246, 255),
    onBackground: Colors.white,
  ),
  const ColorScheme.dark(
      primary: Color(0xFF5B7065),
      secondary: Color(0xFF3040404),
      background: Color(0xFF04202C),
      onBackground: Colors.white),
  const ColorScheme.light(
    primary: Color(0xFFF52549),
    secondary: Color(0xFFFa6775),
    tertiary: Color(0xFFFFD64D),
    background: Color.fromARGB(255, 255, 235, 246),
  ),
  const ColorScheme.dark(
      primary: Color(0XFFA11F0C),
      secondary: Color(0xFFBBCF4A),
      background: Color.fromARGB(255, 30, 0, 0)),
  const ColorScheme.light(
    primary: Color(0xFFEE693F),
    secondary: Color(0xFFF69454),
    background: Color.fromARGB(255, 255, 248, 235),
  ),
  const ColorScheme.dark(
    primary: Color(0xFF7f5377),
    secondary: Color(0xFF644a87),
  ),
  const ColorScheme.light(
    primary: Color.fromARGB(255, 39, 39, 39),
    secondary: Color.fromARGB(255, 150, 150, 150),
    background: Color.fromARGB(255, 229, 229, 229),
  ),
  const ColorScheme.light(
    primary: Color(0xFFA10115),
    secondary: Color.fromARGB(255, 255, 166, 166),
    background: Color.fromARGB(255, 255, 255, 255),
  ),
  const ColorScheme.light(
    primary: Color.fromARGB(255, 81, 79, 85),
    secondary: Color(0xFF997887),
    background: Color(0xFFEED8C9),
  ),
];

class _ThemesScreenState extends State<ThemesScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  initState() {
    super.initState();
  }

  String title = 'Темы';

  List<Color> colors = [
    Colors.blue,
    Colors.green,
    Colors.pink,
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.grey,
    Colors.red,
    Colors.brown,
  ];

  ScrollController scrollController = ScrollController();
  List<Widget> themeItems = [];

  List<Widget> generateThemeItems() {
    for (int i = 0; i < colors.length; i++) {
      themeItems.add(ThemeItemWidget(
        themeItemColorScheme: colorSchemes[i],
        themeItemColor: colors[i],
        name: names[i],
      ));
    }
    return themeItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          title,
        ),
      ),
      body: ListWheelScrollView(
        controller: themeScrollController,
        perspective: 0.001,
        offAxisFraction: 1,
        physics: fixedExtentScrollPhysics,
        itemExtent: 230,
        children: generateThemeItems().toList(),
      ),
    );
  }
}

ScrollPhysics fixedExtentScrollPhysics = const FixedExtentScrollPhysics();
ScrollController themeScrollController = FixedExtentScrollController();

class ThemeItemWidget extends StatefulWidget {
  @override
  State<ThemeItemWidget> createState() => _ThemeItemWidgetState();

  const ThemeItemWidget({
    super.key,
    required this.themeItemColorScheme,
    required this.themeItemColor,
    required this.name,
  });

  final ColorScheme themeItemColorScheme;
  final Color themeItemColor;
  final String name;
}

late AnimationController controller;
late Animation<double> animation;
late Animation tween;

class _ThemeItemWidgetState extends State<ThemeItemWidget>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    animation = CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    tween = Tween<double>(begin: 150, end: 200).animate(animation);

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      }
    });
    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.removeListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        themeModel.currentTheme =
            ThemeData.from(colorScheme: widget.themeItemColorScheme);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('currentTheme', widget.name);

        controller.forward();
      },
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Row(
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                  border: const Border(
                      top: BorderSide(
                          color: Color.fromARGB(255, 220, 220, 220), width: 7),
                      left: BorderSide(
                          color: Color.fromARGB(255, 220, 220, 220), width: 7),
                      right: BorderSide(
                          color: Color.fromARGB(255, 220, 220, 220), width: 7),
                      bottom: BorderSide(
                          color: Color.fromARGB(255, 220, 220, 220), width: 7)),
                  borderRadius: BorderRadius.circular(100),
                  gradient: LinearGradient(begin: Alignment.topLeft, colors: [
                    widget.themeItemColorScheme.primary,
                    widget.themeItemColorScheme.secondary
                  ])),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              widget.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }
}
