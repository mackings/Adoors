import 'dart:convert';

import 'package:adorss/Views/Dashboard/Views/Library/Model/libmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LibraryService {
  static const String _baseUrl = "https://adorss.ng/scripts/school?action=librariesdata&school=";

  Future<List<LibraryRecord>?> fetchLibraryData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? userData = prefs.getString('userData');

      if (userData == null) {
        throw Exception("User not logged in.");
      }

      final Map<String, dynamic> userMap = jsonDecode(userData);
      String token = userMap['token'];
      String schoolId = userMap['school_id'];

      String url = '$_baseUrl$schoolId';

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
        return LibraryRecord.fromJsonList(responseData["data"]);
      } else {
        throw Exception("Failed to load library data. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error fetching library data: $e");
      return null;
    }
  }
}