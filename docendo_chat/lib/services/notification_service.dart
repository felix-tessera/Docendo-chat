import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NotificationSerivce {
  Future<void> sendNotificationOnMessage(
      String token, String title, String message) async {
    final serverToken =
        'AAAAJyLXsVo:APA91bEMUnKUKdhTEUJUvrY82mq3NgeBntgg0NipQ51hekWFN4e52CiJBjZKVPcgoHfFLcJoep7yFdvx2RZmDCC6rQdRIFMzJWwyy7-4o6Um8l-_e7CB9PTU6hjekpgWWN75SRQ342DQ';

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverToken',
    };
    final body = jsonEncode({
      'notification': {'title': title, 'body': message},
      'to': token,
    });

    final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: headers,
        body: body);
    debugPrint(response.body);
  }
}
