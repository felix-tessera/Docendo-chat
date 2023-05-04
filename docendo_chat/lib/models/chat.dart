class Chat {
  final String key;
  final List<String> members;
  final String lastMessage;

  Chat({required this.key, required this.members, required this.lastMessage});

  static Chat fromJson(Map<String, dynamic> json) {
    return Chat(
        key: json['key'],
        members: (json['members'] as List).cast<String>(),
        lastMessage: json['lastMessage']);
  }
}
