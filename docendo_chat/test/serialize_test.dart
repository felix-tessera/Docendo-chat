import 'package:docendo_chat/models/chat.dart';
import 'package:docendo_chat/models/message.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/models/user.dart';

void main() {
  test('user model toJson function test', () {
    final user = User(
        key: 'key',
        name: 'name',
        mail: "mail",
        imageUrl: "imageUrl",
        friends: ['friends', 'friends'],
        token: 'token');
    Map<String, dynamic> userJson = user.toJson(user);
    expect(userJson, {
      'key': 'key',
      'name': 'name',
      'mail': 'mail',
      'imageUrl': 'imageUrl',
      'friends': ['friends', 'friends'],
      'token': 'token'
    });
  });
  test('user model fromJson function test', () {
    final Map<String, dynamic> json = {
      'key': 'key',
      'name': 'name',
      'mail': 'mail',
      'imageUrl': 'imageUrl',
      'friends': ['friends', 'friends'],
      'token': 'token'
    };
    final actualUser = User.fromJson(json);
    final matcherUser = User(
        key: 'key',
        name: 'name',
        mail: "mail",
        imageUrl: "imageUrl",
        friends: ['friends', 'friends'],
        token: 'token');

    expect(
        actualUser.name == matcherUser.name &&
            actualUser.key == matcherUser.key &&
            actualUser.mail == matcherUser.mail &&
            actualUser.token == matcherUser.token &&
            actualUser.imageUrl == matcherUser.imageUrl &&
            actualUser.friends[0] == matcherUser.friends[0] &&
            actualUser.friends[1] == matcherUser.friends[0],
        true);
  });
  test('message model fromJson function test', () {
    final Map<String, dynamic> json = {
      'message': 'message',
      'time': 'time',
      'sender': 'sender'
    };
    final actualMessage = Message.fromJson(json);
    final matcherMessage =
        Message(message: 'message', time: 'time', sender: 'sender');

    expect(
        actualMessage.message == matcherMessage.message &&
            actualMessage.time == matcherMessage.time &&
            actualMessage.sender == matcherMessage.sender,
        true);
  });

  test('chat model fromJson function test', () {
    final Map<String, dynamic> json = {
      'key': 'key',
      'members': ['members', 'members'],
      'lastMessage': 'lastMessage',
      'lastMessageTime': 'lastMessageTime'
    };
    final actualChat = Chat.fromJson(json);
    final matcherChat = Chat(
        key: 'key',
        members: ['members', 'members'],
        lastMessage: 'lastMessage',
        lastMessageTime: 'lastMessageTime');

    expect(
        actualChat.key == matcherChat.key &&
            actualChat.lastMessage == matcherChat.lastMessage &&
            actualChat.lastMessageTime == matcherChat.lastMessageTime &&
            actualChat.members[0] == matcherChat.members[0] &&
            actualChat.members[1] == matcherChat.members[1],
        true);
  });
}
