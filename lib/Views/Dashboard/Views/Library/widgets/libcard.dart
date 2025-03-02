import 'package:adorss/Views/Dashboard/Views/Library/Model/libmodel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class LibraryCard extends StatelessWidget {
  final LibraryRecord libraryRecord;

  const LibraryCard({super.key, required this.libraryRecord});

  void _downloadFile(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(msg: "Could not open file.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              libraryRecord.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              libraryRecord.description.replaceAll(RegExp(r'<[^>]*>'), ''), // Remove HTML tags
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "📅 Date: ${libraryRecord.regDate.split(' ')[0]}",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () => _downloadFile(libraryRecord.appendedFile),
                  tooltip: "Download File",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}