

class Chat {
  final String chatId;
  final RecipientDetails? recipient;
  final LastMessage? lastMessage;
  final int sentMessagesCount;

  Chat({
    required this.chatId,
    this.recipient,
    this.lastMessage,
    required this.sentMessagesCount,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      chatId: json["chat_id"] ?? "",
      recipient: json["recipient_details"] != null
          ? RecipientDetails.fromJson(json["recipient_details"])
          : null,
      lastMessage: json["last_message"] != null
          ? LastMessage.fromJson(json["last_message"])
          : null,
      sentMessagesCount: int.tryParse(json["sent_messages_count"] ?? "0") ?? 0,
    );
  }

  static List<Chat> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Chat.fromJson(json)).toList();
  }
}

class RecipientDetails {
  final String studentId;
  final String name;
  final String email;
  final String phone;
  final String profilePicture;

  RecipientDetails({
    required this.studentId,
    required this.name,
    required this.email,
    required this.phone,
    required this.profilePicture,
  });

  factory RecipientDetails.fromJson(Map<String, dynamic> json) {
    return RecipientDetails(
      studentId: json["student_id"] ?? "",
      name: json["name"] ?? "Unknown",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      profilePicture: json["profile_picture"] ?? "",
    );
  }
}

class LastMessage {
  final String message;
  final String sender;
  final String date;
  final String status;

  LastMessage({
    required this.message,
    required this.sender,
    required this.date,
    required this.status,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(
      message: json["message"] ?? "",
      sender: json["sender"] ?? "",
      date: json["date"] ?? "",
      status: json["status"] ?? "",
    );
  }
}
