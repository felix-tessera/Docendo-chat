class User {
  final String key;
  final String name;
  final String mail;
  final String imageUrl;
  final List<String?> friends;
  final String token;

  User(
      {required this.key,
      required this.name,
      required this.mail,
      required this.imageUrl,
      required this.friends,
      required this.token});

  Map<String, dynamic> toJson(User user) {
    return {
      'key': user.key,
      'name': user.name,
      'mail': user.mail,
      'imageUrl': imageUrl,
      'friends': user.friends,
      'token': user.token
    };
  }

  static User fromJson(Map<String, dynamic> json) {
    return User(
        key: json['key'],
        name: json['name'],
        mail: json['mail'],
        imageUrl: json['imageUrl'],
        friends: (json['friends'] as List).cast<String?>(),
        token: json['token']);
  }
}
