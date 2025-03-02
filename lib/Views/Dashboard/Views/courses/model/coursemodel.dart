import 'dart:convert';

class Course {
  final String? courseId;
  final String? courseName;
  final String? courseClass;
  final String? schoolId;

  Course({
    this.courseId,
    this.courseName,
    this.courseClass,
    this.schoolId,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      courseId: json['course_id']?.toString() ?? '',
      courseName: json['coursename']?.toString() ?? 'Unknown Course',
      courseClass: json['class']?.toString() ?? '',
      schoolId: json['school_id']?.toString() ?? '',
    );
  }

  static List<Course> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Course.fromJson(json)).toList();
  }
}
