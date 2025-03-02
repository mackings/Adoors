import 'dart:convert';
import 'package:http/http.dart' as http;

class SignInService {
  
  final String _baseUrl = "https://adorss.ng/scripts/authentication";

  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // Create the multipart request
      var request = http.MultipartRequest('POST', Uri.parse(_baseUrl));

      // Add fields
      request.fields['action'] = 'login';
      request.fields['email'] = email;
      request.fields['password'] = password;

      // Send the request
      var response = await request.send();

      // Read the response
      var responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        return jsonDecode(responseBody.body);
      } else {
        print(response.stream);
        return {
          "success": false,
          "message": "Server error: ${response.statusCode}",
        };
      }
    } catch (error) {
      return {
        "success": false,
        "message": "An error occurred: $error",
      };
    }
  }
}
