import 'package:intl/intl.dart';

class Announcement {
  final String id;
  final String title;
  final String details;
  final String schoolId;
  final String classId;
  final DateTime date;
  final String uploadedBy;

  Announcement({
    required this.id,
    required this.title,
    required this.details,
    required this.schoolId,
    required this.classId,
    required this.date,
    required this.uploadedBy,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['s'],
      title: json['title'],
      details: json['details'] ?? "",
      schoolId: json['school'],
      classId: json['class'],
      date: DateTime.parse(json['date']),
      uploadedBy: json['uploaded_by'],
    );
  }

  /// Method to format date as "12 June 2025, 12:00 PM"
  String get formattedDate {
    return DateFormat("dd MMMM yyyy, h:mm a").format(date);
  }

  static List<Announcement> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Announcement.fromJson(json)).toList();
  }
}

