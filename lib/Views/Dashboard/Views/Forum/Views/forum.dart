import 'package:adorss/Views/Dashboard/Views/Forum/Api/forumservice.dart';
import 'package:adorss/Views/Dashboard/Views/Forum/Model/forummodel.dart';
import 'package:adorss/Views/Dashboard/Views/Forum/Views/details.dart';
import 'package:flutter/material.dart';


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
      appBar: AppBar(title: const Text("Forum")),
      body: FutureBuilder<List<ForumTopic>?>(
        future: _forumTopics,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text("Error loading forum topics."));
          }

          final topics = snapshot.data!;
          return ListView.builder(
            itemCount: topics.length,
            itemBuilder: (context, index) {
              final topic = topics[index];
              return ListTile(
                title: Text(topic.title),
                subtitle: Text("By ${topic.userName} - ${topic.date}"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ForumDetailPage(topic: topic),
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
