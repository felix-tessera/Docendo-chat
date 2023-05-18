import 'package:flutter/material.dart';
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
                            elevation: 9,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Column(
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
                                      httpHabs[index].description))
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
