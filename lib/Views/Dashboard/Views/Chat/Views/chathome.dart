import 'package:adorss/Views/Dashboard/Views/Chat/Api/chatservice.dart';
import 'package:adorss/Views/Dashboard/Views/Chat/Model/chatmodel.dart';
import 'package:adorss/Views/Dashboard/Views/Chat/Views/chatscreen.dart';
import 'package:adorss/Views/Dashboard/Views/Chat/widgets/allchat.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';




class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final ChatService _chatService = ChatService();
  late Future<List<Chat>?> _chats;

  @override
  void initState() {
    super.initState();
    _chats = _chatService.fetchStudentChats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(
          "Chats",
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),),
      body: FutureBuilder<List<Chat>?>(
        future: _chats,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No chats available."));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final chat = snapshot.data![index];

              return ChatItemWidget(
                chat: chat,
                onTap: () {

                    Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ChatScreen(
        chatId: chat.chatId,
        chatTitle: chat.recipient?.name ?? "Chat",
      ),
    ),
  );
            
                },
              );
            },
          );
        },
      ),
    );
  }
}