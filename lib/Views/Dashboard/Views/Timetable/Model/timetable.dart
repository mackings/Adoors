import 'dart:convert';

class TimetableRecord {
  final String id;
  final String day;
  final String startTime;
  final String endTime;
  final String courseId;
  final String courseName;

  TimetableRecord({
    required this.id,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.courseId,
    required this.courseName,
  });

  factory TimetableRecord.fromJson(Map<String, dynamic> json) {
    return TimetableRecord(
      id: json['s'],
      day: json['day'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      courseId: json['course_id'],
      courseName: json['coursename'].trim(),
    );
  }

  static List<TimetableRecord> fromJsonList(List<dynamic> list) {
    return list.map((item) => TimetableRecord.fromJson(item)).toList();
  }
}
