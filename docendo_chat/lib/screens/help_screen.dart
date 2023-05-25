import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  final String markdown = """
___
## Вход
В Docendo-chat вам не нужно проходить долгий процесс регистрации. Используйте свой аккаунт Google чтобы войти.
![300](resource:assets/images/Screenshot_1684927471.png)
  
## Новости
Лента новостей показывает посты на сайте habr.com, однако не полностью. Чтобы полностью прочитать новость, можно нажать на стрелочку внизу каждого поста. Это перенаправит вас в браузер.
![300](resource:assets/images/Screenshot_1684927403.png)

## Друзья
Находите своих друзей и общайтесь. Найти друга можно введя его почту на экране сообщений, типо показать ему свой qr-код на странице профиля.
![300](resource:assets/images/Screenshot_1684928307.png)
![300](resource:assets/images/Screenshot_1684928334.png)

## Сообщения
Отправляйте тектовые сообщения своим друзьям.
![300](resource:assets/images/Screenshot_1684928416.png)
  
## Темы
Меняйте тему приложения. Найдите цветовое сочетание себе по вкусу.
![300](resource:assets/images/Screenshot_1684928555.png)
  
## Память
Чтобы Docendo chat не использовал слишком много вашей памяти, своевременно очищайте кэш. Кэшируются все изображения приложения.
![300](resource:assets/images/Screenshot_1684929005.png)
""";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Помощь'),
      ),
      body: SafeArea(child: Markdown(data: markdown)),
    );
  }
}
