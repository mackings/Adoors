import 'dart:convert';
import 'package:adorss/Views/Dashboard/Views/Timetable/Model/timetable.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class TimetableService {
  static const String _baseUrl =
      "https://adorss.ng/scripts/course?action=coursetimetable&class=";

  Future<List<TimetableRecord>?> fetchTimetable() async {
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

      String url = '$_baseUrl$classId';

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

        return TimetableRecord.fromJsonList(responseData["data"]);
      } else {
        throw Exception("Failed to load timetable. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error fetching timetable: $e");
      return null;
    }
  }
}
