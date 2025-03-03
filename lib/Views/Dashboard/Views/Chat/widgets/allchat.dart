import 'package:adorss/Views/Dashboard/Views/Chat/Model/chatmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';




class ChatItemWidget extends StatelessWidget {
  final Chat chat;
  final VoidCallback onTap;

  const ChatItemWidget({Key? key, required this.chat, required this.onTap}) : super(key: key);

  /// **Formats the timestamp for display**
  String formatTimestamp(String timestamp) {
    try {
      DateTime dateTime = DateTime.parse(timestamp);
      return DateFormat("d MMM, hh:mma").format(dateTime); // Example: "12 Feb, 08:30PM"
    } catch (e) {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 1,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildProfileImage(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.recipient?.name ?? "User",
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    chat.lastMessage?.message ?? "No messages yet",
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                     // overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              formatTimestamp(chat.lastMessage?.date ?? ""),
              style: GoogleFonts.montserrat(
                fontSize: 12,
                color: Colors.blueGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// **Builds the profile image with a fallback**
  Widget _buildProfileImage() {
    return CircleAvatar(
      radius: 26,
      backgroundColor: Colors.blueGrey.shade200,
      
      // backgroundImage: chat.recipient?.profilePicture?.isNotEmpty == true
      //     ? NetworkImage(chat.recipient!.profilePicture)
      //     : null,
      // child: chat.recipient?.profilePicture?.isNotEmpty == true
      //     ? null
      //     : const 
      child:Icon(Icons.person, color: Colors.white, size: 28),
    );
  }
}