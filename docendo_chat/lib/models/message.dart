class Message {
  final String message;
  final String time;
  final String sender;

  Message({required this.message, required this.time, required this.sender});

  static Message fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'],
      time: json['time'],
      sender: json['sender'],
    );
  }
}
