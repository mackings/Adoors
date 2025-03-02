import 'package:intl/intl.dart';

class Message {
  final String id;
  final String sender;
  final String username;
  final String message;
  final String status;
  final DateTime date;
  final bool isCurrentUser;

  Message({
    required this.id,
    required this.sender,
    required this.username,
    required this.message,
    required this.status,
    required this.date,
    required this.isCurrentUser,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      sender: json['sender'],
      username: json['username'],
      message: json['message'],
      status: json['status'],
      date: _parseDate(json['date']),
      isCurrentUser: json['is_current_user'],
    );
  }

  static List<Message> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Message.fromJson(json)).toList();
  }

static DateTime _parseDate(String dateString) {
  try {
    return DateFormat("MMM d, yyyy hh:mm a").parse(dateString);
  } catch (e) {
    print("❌ Error parsing date: $dateString - $e");
    return DateTime.now(); // Fallback to current time in case of error
  }
}
}
