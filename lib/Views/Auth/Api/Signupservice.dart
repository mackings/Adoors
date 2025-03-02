import 'dart:convert';
import 'package:http/http.dart' as http;


class SignupService {
  final String _baseUrl = "https://adorss.ng/scripts/student";

  Future<Map<String, dynamic>> signUpStudent({
    required String name,
    required String email,
    required String school,
    required String phone,
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(_baseUrl));

      // Add form fields
      request.fields['action'] = 'register';
      request.fields['student-name'] = name;
      request.fields['student-email'] = email;
      request.fields['student-phone'] = phone;
      request.fields['school'] = school;

      // Set headers
      request.headers.addAll({
        'Content-Type': 'multipart/form-data',
      });

      // ✅ PRINT REQUEST DATA BEFORE SENDING
      print("📤 Sending Request:");
      print("URL: $_baseUrl");
      print("Headers: ${request.headers}");
      print("Body: ${request.fields}");

      var response = await request.send();
      var responseBody = await http.Response.fromStream(response);

      // ✅ PRINT RESPONSE DATA
      print("📥 Response Received:");
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${responseBody.body}");

      if (response.statusCode == 200) {
        var jsonData = json.decode(responseBody.body);
        return jsonData;
      } else {
        return {
          "success": false,
          "message": "Server error: ${response.statusCode}",
        };
      }
    } catch (error) {
      print("❌ Error: $error"); // Print error in case of failure
      return {
        "success": false,
        "message": "An error occurred: $error",
      };
    }
  }
}

