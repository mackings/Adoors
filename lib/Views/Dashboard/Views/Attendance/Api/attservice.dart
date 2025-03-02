import 'dart:convert';
import 'package:adorss/Views/Dashboard/Views/Attendance/Model/attmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AttendanceService {
  static const String _baseUrl =
      "https://adorss.ng/scripts/classes?action=showattendanceforstudent&class=";

  Future<List<AttendanceRecord>?> fetchAttendance() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? userData = prefs.getString('userData');

      if (userData == null) {
        throw Exception("User not logged in.");
      }

      final Map<String, dynamic> userMap = jsonDecode(userData);
      print(userMap);
      String token = userMap['token'];
      String classId = userMap['class_id'];
      String studentId = userMap['user_id'];

      String url = '$_baseUrl$classId&student=$studentId';

      // Print API Request Details
      print("🔹 API Request: GET $url");
      print("🔹 Headers: { Authorization: Bearer $token, Content-Type: application/json }");

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      // Print Response Details
      print("🔹 Response Status Code: ${response.statusCode}");
      print("🔹 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print("🔹 Parsed JSON Data: $responseData");

        return AttendanceRecord.fromJsonList(responseData["data"]);
      } else {
        throw Exception("Failed to load attendance. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error fetching attendance: $e");
      return null;
    }
  }
}
