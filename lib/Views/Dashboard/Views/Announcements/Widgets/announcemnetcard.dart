import 'package:adorss/Views/Dashboard/Views/Announcements/Model/announcementmodel.dart';
import 'package:flutter/material.dart';

class AnnouncementCard extends StatelessWidget {
  final Announcement announcement;

  const AnnouncementCard({
    Key? key,
    required this.announcement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              announcement.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              announcement.details.isNotEmpty ? announcement.details : "No details provided",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                announcement.formattedDate, // Now displays "12 June 2025, 12:00 PM"
                style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
