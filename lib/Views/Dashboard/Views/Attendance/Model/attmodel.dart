class AttendanceRecord {
  final String id;
  final String studentId;
  final String classId;
  final String schoolId;
  final String date;
  final String status;

  AttendanceRecord({
    required this.id,
    required this.studentId,
    required this.classId,
    required this.schoolId,
    required this.date,
    required this.status,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['s'] ?? '',
      studentId: json['student'] ?? '',
      classId: json['class'] ?? '',
      schoolId: json['school'] ?? '',
      date: json['date'] ?? '',
      status: json['status'] ?? '',
    );
  }

  static List<AttendanceRecord> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => AttendanceRecord.fromJson(json)).toList();
  }
}
