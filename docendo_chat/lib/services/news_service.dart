import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';
import 'package:html/parser.dart';

List httpHabs = [];

getHttpHabs() async {
  try {
    dynamic responce =
        await http.get(Uri.parse('https://habr.com/ru/rss/all/'));
    dynamic body = responce.body;
    dynamic chanel = RssFeed.parse(body);
    chanel.items.forEach((element) => {httpHabs.add(element)});

    return httpHabs;
  } catch (e) {
    debugPrint('Не удалось получить');
  }
}

parseDescription(description) {
  dynamic descriptionData = parse(description);
  dynamic txtDescription =
      parse(descriptionData.body.text).documentElement?.text;
  return txtDescription.toString();
}
