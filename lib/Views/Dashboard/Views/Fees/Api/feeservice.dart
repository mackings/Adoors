import 'dart:convert';
import 'package:adorss/Views/Dashboard/Views/Fees/model/fees.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



class FeesService {

  static const String _baseUrl =
      "https://adorss.ng/scripts/fees?action=studentclassFee&student=";

  Future<List<FeeRecord>?> fetchFees() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      String? userData = prefs.getString('userData');

      if (userData == null) {
        throw Exception("User not logged in.");
      }

      final Map<String, dynamic> userMap = jsonDecode(userData);
      String token = userMap['token'];
      String studentId = userMap['user_id'];
      String classId = userMap['class_id'];

      String url = '$_baseUrl$studentId&class=$classId';

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
        final List<dynamic> responseData = jsonDecode(response.body);
        print("🔹 Parsed JSON Data: $responseData");

        return FeeRecord.fromJsonList(responseData);
      } else {
        throw Exception("Failed to load fees. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error fetching fees: $e");
      return null;
    }
  }
}
