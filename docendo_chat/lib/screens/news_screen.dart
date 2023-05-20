import 'package:docendo_chat/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/news_service.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Новости'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
            future: getHttpHabs(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Container(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: httpHabs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 15,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    httpHabs[index].title,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(parseDescription(
                                      httpHabs[index].description)),
                                  TextButton(
                                      onPressed: () {
                                        String url =
                                            httpHabs[index].link; // ваша ссылка
                                        launch(url);
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: themeModel.currentTheme
                                                      .colorScheme.primary,
                                                  width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child:
                                              Icon(Icons.arrow_forward_sharp)))
                                ],
                              ),
                            ),
                          );
                        }));
              }
            }),
      ),
    );
  }
}
