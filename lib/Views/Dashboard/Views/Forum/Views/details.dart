


import 'package:adorss/Views/Dashboard/Views/Forum/Api/forumservice.dart';
import 'package:adorss/Views/Dashboard/Views/Forum/Model/forummodel.dart';
import 'package:flutter/material.dart';
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
      appBar: AppBar(title: Text(widget.topic.title)),
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
                  return const Center(child: Text("No comments found."));
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
  String username = comment.realName ?? "User"; // Show real name if available, else user ID
  String formattedTime = _formatDate(comment.commentedTime); // Format comment time

  return Align(
    alignment: Alignment.centerLeft,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Username at the top
          Text(
            username,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade900),
          ),
          const SizedBox(height: 5),

          // Comment Text
          Text(
            comment.comment,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 5),

          // Comment Time (Placed Below the Comment)
          Text(
            formattedTime,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    ),
  );
}


  /// **Formats the comment date as "28 Feb 2025"**
  String _formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return DateFormat("dd MMM yyyy").format(date); // Example: 28 Feb 2025
    } catch (e) {
      return dateString; // Return original string if parsing fails
    }
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
                decoration: const InputDecoration(
                  hintText: "Write a comment...",
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
                    icon: const Icon(Icons.send, color: Colors.blue),
                    onPressed: _addComment,
                  ),
          ],
        ),
      ),
    );
  }
}