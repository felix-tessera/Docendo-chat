class Chat {
  final String key;
  final List<String> members;
  String lastMessage;
  String lastMessageTime;

  Chat(
      {required this.key,
      required this.members,
      required this.lastMessage,
      required this.lastMessageTime});

  static Chat fromJson(Map<String, dynamic> json) {
    return Chat(
        key: json['key'],
        members: (json['members'] as List).cast<String>(),
        lastMessage: json['lastMessage'],
        lastMessageTime: json['lastMessageTime']);
  }
}
