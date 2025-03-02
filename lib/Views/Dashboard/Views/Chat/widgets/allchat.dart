import 'package:adorss/Views/Dashboard/Views/Chat/Model/chatmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';




class ChatItemWidget extends StatelessWidget {
  final Chat chat;
  final VoidCallback onTap;

  const ChatItemWidget({Key? key, required this.chat, required this.onTap}) : super(key: key);

  String formatTimestamp(String timestamp) {
    try {
      DateTime dateTime = DateTime.parse(timestamp);
      return DateFormat("d, MMM hh:mma").format(dateTime);
    } catch (e) {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: chat.recipient?.profilePicture.isNotEmpty == true
          ? CircleAvatar(
              radius: 25,
              backgroundColor: Colors.blueGrey,
              child: Icon(Icons.person, color: Colors.white),
            )
          // CircleAvatar(
          //     backgroundImage: NetworkImage("https://adorss.ng/uploads/${chat.recipient!.profilePicture}"),
          //     radius: 25,
          //   )
          : const CircleAvatar(
              radius: 25,
              backgroundColor: Colors.blueGrey,
              child: Icon(Icons.person, color: Colors.white),
            ),
      title: Text(
        chat.recipient?.name ?? "User",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(chat.lastMessage?.message ?? "No messages yet"),
      trailing: Text(
        formatTimestamp(chat.lastMessage?.date ?? ""),
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      onTap: onTap,
    );
  }
}
