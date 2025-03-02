import 'dart:convert';
import 'package:adorss/Views/Dashboard/Views/Announcements/Model/announcementmodel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AnnouncementService {
  static const String _baseUrl =
      "https://adorss.ng/scripts/annoucements?action=databyclass&class=";

  Future<List<Announcement>?> fetchAnnouncements() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? userData = prefs.getString('userData');

      if (userData == null) {
        throw Exception("User not logged in.");
      }

      final Map<String, dynamic> userMap = jsonDecode(userData);
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

        return Announcement.fromJsonList(responseData["data"]);
      } else {
        throw Exception("Failed to load announcements. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error fetching announcements: $e");
      return null;
    }
  }
}
