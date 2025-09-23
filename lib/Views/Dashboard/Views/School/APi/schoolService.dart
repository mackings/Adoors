import 'dart:convert';

import 'package:adorss/Views/Dashboard/Views/School/Model/schoolModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SchoolService {
  static const String _baseUrl = "https://adorss.ng/scripts/school?action=schooldata&school=";

  Future<School?> fetchSchoolData(String schoolId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? userData = prefs.getString('userData');

      if (userData == null) {
        throw Exception("User not logged in.");
      }

      final Map<String, dynamic> userMap = jsonDecode(userData);
      String token = userMap['token'];

      String url = '$_baseUrl$schoolId';

      // Debugging
      print("🔹 API Request: GET $url");
      print("🔹 Headers: { Authorization: Bearer $token, Content-Type: application/json }");

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      print("🔹 Response Status Code: ${response.statusCode}");
      print("🔹 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final data = responseData["data"];

        if (data != null && data.isNotEmpty) {
          return School.fromJson(data[0]); // First school in the list
        } else {
          throw Exception("No school data found.");
        }
      } else {
        throw Exception("Failed to load school data. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error fetching school data: $e");
      return null;
    }
  }
}
