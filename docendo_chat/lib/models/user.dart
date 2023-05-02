class User {
  final String key;
  final String name;
  final String mail;
  final String imageUrl;
  final List<String?> friends;
  final List<String?> chats;

  User(
      {required this.key,
      required this.name,
      required this.mail,
      required this.imageUrl,
      required this.friends,
      required this.chats});

  Map<String, dynamic> toJson(User user) {
    return {
      'key': user.key,
      'name': user.name,
      'mail': user.mail,
      'imageUrl': imageUrl,
      'friends': user.friends,
      'chats': user.chats
    };
  }

  static User fromJson(Map<String, dynamic> json) {
    return User(
        key: json['key'],
        name: json['name'],
        mail: json['mail'],
        imageUrl: json['imageUrl'],
        friends: (json['friends'] as List).cast<String?>(),
        chats: (json['chats'] as List).cast<String?>());
  }
}
