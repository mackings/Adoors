import 'package:adorss/Views/Dashboard/Views/Forum/Api/forumservice.dart';
import 'package:adorss/Views/Dashboard/Views/Forum/Model/forummodel.dart';
import 'package:adorss/Views/Dashboard/Views/Forum/Views/details.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class ForumPage extends StatefulWidget {
  const ForumPage({Key? key}) : super(key: key);

  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  final ForumService _forumService = ForumService();
  late Future<List<ForumTopic>?> _forumTopics;

  @override
  void initState() {
    super.initState();
    _forumTopics = _forumService.fetchForumTopics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Forum",
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder<List<ForumTopic>?>(
        future: _forumTopics,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
            return _buildErrorMessage("No forum topics found.");
          }

          final topics = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: topics.length,
            itemBuilder: (context, index) {
              final topic = topics[index];
              return _buildForumItem(topic);
            },
          );
        },
      ),
    );
  }

  /// Modernized forum item layout with icons
  Widget _buildForumItem(ForumTopic topic) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ForumDetailPage(topic: topic)),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          children: [
            // User Profile Icon
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.blueAccent.withOpacity(0.2),
              child: const Icon(Icons.chat_outlined, color: Colors.blueAccent, size: 24),
            ),
            const SizedBox(width: 12),

            // Title and Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topic.title,
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // User and Date
                  Row(
                    children: [
                      const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
Text(
  _shortenName(topic.userName),
  style: GoogleFonts.montserrat(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: Colors.grey[700],
  ),
),
                      const SizedBox(width: 12),
                      const Icon(Icons.access_time, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        topic.date,
                        style: GoogleFonts.montserrat(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Comments Count
            Row(
              children: [
                const Icon(Icons.comment, size: 18, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  topic.commentCount.toString(),
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Error message UI
  Widget _buildErrorMessage(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
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

  String _shortenName(String name) {
  return name.length > 15 ? '${name.substring(0, 12)}...' : name;
}

}
