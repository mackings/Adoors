import 'package:adorss/Views/Dashboard/Views/Timetable/Model/timetable.dart';
import 'package:flutter/material.dart';


class TimetableCard extends StatelessWidget {
  final TimetableRecord record;

  const TimetableCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              record.courseName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text("📅 Day: ${record.day}", style: const TextStyle(fontSize: 16)),
            Text("⏰ Time: ${record.startTime} - ${record.endTime}",
                style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
