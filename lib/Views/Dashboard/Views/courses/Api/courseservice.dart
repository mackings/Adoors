import 'dart:convert';
import 'package:adorss/Views/Dashboard/Views/courses/model/coursemodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CourseService {
  static const String _baseUrl =
      "https://adorss.ng/scripts/course?action=coursesdata&class=";

  Future<List<Course>?> fetchCourses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? userData = prefs.getString('userData');

      if (userData == null) {
        throw Exception("User not logged in.");
      }

      // Decode stored user data
      final Map<String, dynamic> userMap = jsonDecode(userData);
      print(userMap);
      String token = userMap['token'];
      String classId = userMap['class_id'];

      // Build the API URL
      String url = '$_baseUrl$classId';

      // Print the request details
      print("🔹 API Request: GET $url");
      print(
          "🔹 Headers: { Authorization: Bearer $token, Content-Type: application/json }");

      // Make the API request
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      // Print response details
      print("🔹 Response Status Code: ${response.statusCode}");
      print("🔹 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print("🔹 Parsed JSON Data: $responseData");

        return Course.fromJsonList(responseData["data"]);
      } else {
        throw Exception(
            "Failed to load courses. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error fetching courses: $e");
      return null;
    }
  }
}
