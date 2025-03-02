import 'dart:convert';

class LibraryRecord {
  final String id;
  final String title;
  final String description;
  final String mediaFile;
  final String appendedFile;
  final String regDate;

  LibraryRecord({
    required this.id,
    required this.title,
    required this.description,
    required this.mediaFile,
    required this.appendedFile,
    required this.regDate,
  });

  factory LibraryRecord.fromJson(Map<String, dynamic> json) {
    return LibraryRecord(
      id: json['s'],
      title: json['title'],
      description: json['description'],
      mediaFile: json['media_file'],
      appendedFile: json['appended_file'],
      regDate: json['reg_date'],
    );
  }

  static List<LibraryRecord> fromJsonList(List<dynamic> list) {
    return list.map((item) => LibraryRecord.fromJson(item)).toList();
  }
}
