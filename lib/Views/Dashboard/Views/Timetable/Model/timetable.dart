import 'dart:convert';

class TimetableRecords {
  final String id;
  final String day;
  final String startTime;
  final String endTime;
  final String courseId;
  final String courseName;

  TimetableRecords({
    required this.id,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.courseId,
    required this.courseName,
  });

  factory TimetableRecords.fromJson(Map<String, dynamic> json) {
    return TimetableRecords(
      id: json['s'],
      day: json['day'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      courseId: json['course_id'],
      courseName: json['coursename'].trim(),
    );
  }

  static List<TimetableRecords> fromJsonList(List<dynamic> list) {
    return list.map((item) => TimetableRecords.fromJson(item)).toList();
  }
}
