


import 'package:adorss/Views/Dashboard/Views/Forum/Api/forumservice.dart';
import 'package:adorss/Views/Dashboard/Views/Forum/Model/forummodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';




class ForumDetailPage extends StatefulWidget {
  final ForumTopic topic;

  const ForumDetailPage({Key? key, required this.topic}) : super(key: key);

  @override
  _ForumDetailPageState createState() => _ForumDetailPageState();
}

class _ForumDetailPageState extends State<ForumDetailPage> {
  final ForumService _forumService = ForumService();
  late Future<List<Comment>?> _comments;
  final TextEditingController _commentController = TextEditingController();
  bool _isSending = false; // Tracks loading state when sending a comment

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  void _fetchComments() {
    setState(() {
      _comments = _forumService.fetchComments(widget.topic.id);
    });
  }

  void _addComment() async {
    if (_commentController.text.isNotEmpty && !_isSending) {
      setState(() => _isSending = true);

      bool success = await _forumService.addComment(widget.topic.id, _commentController.text);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Comment added successfully")),
        );
        _fetchComments(); // Refresh comments
        _commentController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to add comment. Try again.")),
        );
      }

      setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       // automaticallyImplyLeading: false,
        title: Text(
          widget.topic.title,
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          // Display comments
          Expanded(
            child: FutureBuilder<List<Comment>?>(
              future: _comments,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _buildErrorMessage("No comments found.");
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final comment = snapshot.data![index];
                    return _buildChatBubble(comment);
                  },
                );
              },
            ),
          ),

          // Comment Input Box
          _buildCommentInput(),
        ],
      ),
    );
  }

  /// **Builds Chat Bubble for Each Comment**
  Widget _buildChatBubble(Comment comment) {
    String username = _shortenName(comment.realName ?? "User");
    String formattedTime = _formatDate(comment.commentedTime);

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: Colors.blue),
                const SizedBox(width: 6),
                Text(
                  username,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),

            // Comment Text
            Text(
              comment.comment,
              style: GoogleFonts.montserrat(fontSize: 15),
            ),
            const SizedBox(height: 5),

            // Comment Time
            Row(
              children: [
                const Icon(Icons.access_time, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  formattedTime,
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// **Shortens long names**
  String _shortenName(String name) {
    return name.length > 15 ? '${name.substring(0, 12)}...' : name;
  }

  /// **Formats the comment date as "28 Feb 2025"**
  String _formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return DateFormat("dd MMM yyyy").format(date);
    } catch (e) {
      return dateString;
    }
  }

  /// **Builds Error Message UI**
  Widget _buildErrorMessage(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  /// **Builds the Comment Input Field with Send Button**
  Widget _buildCommentInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _commentController,
                style: GoogleFonts.montserrat(fontSize: 14),
                decoration: InputDecoration(
                  hintText: "Write a comment...",
                  hintStyle: GoogleFonts.montserrat(color: Colors.grey.shade600),
                  border: InputBorder.none,
                ),
              ),
            ),
            _isSending
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : IconButton(
                    icon: const Icon(Icons.send, color: Colors.blueAccent),
                    onPressed: _addComment,
                  ),
          ],
        ),
      ),
    );
  }
}