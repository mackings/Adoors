
import 'dart:convert';
import 'package:adorss/Views/Dashboard/Views/Forum/Model/forummodel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';




class ForumService {

  static const String _baseUrl = "https://adorss.ng/scripts/forum";

Future<List<ForumTopic>?> fetchForumTopics() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    
    // Get user data from SharedPreferences
    String? userData = prefs.getString('userData');

    if (userData == null) {
      throw Exception("User not logged in.");
    }

    final Map<String, dynamic> userMap = jsonDecode(userData);
    String token = userMap['token'];
    String schoolId = userMap['school_id'];

    // Construct API URL
    String url = "$_baseUrl?action=forumdata&school=$schoolId";

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
      List<dynamic> responseData = jsonDecode(response.body);
      print("🔹 Parsed JSON Data: $responseData");

      return ForumTopic.fromJsonList(responseData);
    } else {
      throw Exception("Failed to load forum topics. Status Code: ${response.statusCode}");
    }
  } catch (e) {
    print("❌ Error fetching forum topics: $e");
    return null;
  }
}


Future<List<Comment>?> fetchComments(String blogId) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    
    // Get user data from SharedPreferences
    String? userData = prefs.getString('userData');

    if (userData == null) {
      throw Exception("User not logged in.");
    }

    final Map<String, dynamic> userMap = jsonDecode(userData);
    String token = userMap['token'];

    // Construct API URL
    String url = "$_baseUrl?action=BlogbyId&blogid=$blogId";

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
      Map<String, dynamic> responseData = jsonDecode(response.body);
      print("🔹 Parsed JSON Data: ${responseData["data"]}");

      return Comment.fromJsonList(responseData["data"]);
    } else {
      throw Exception("Failed to load comments. Status Code: ${response.statusCode}");
    }
  } catch (e) {
    print("❌ Error fetching comments: $e");
    return null;
  }
}


Future<bool> addComment(String blogId, String comment) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    
    // Get user data from SharedPreferences
    String? userData = prefs.getString('userData');

    if (userData == null) {
      throw Exception("User not logged in.");
    }

    final Map<String, dynamic> userMap = jsonDecode(userData);
    String token = userMap['token'];
    String userId = userMap['user_id'];

    // Construct API URL
    String url = _baseUrl;

    // Print API Request Details
    print("🔹 API Request: POST $url");
    print("🔹 Headers: { Authorization: Bearer $token }");
    print("🔹 Request Body: { action: addComment, blog_id: $blogId, user: $userId, comment: $comment }");

    var request = http.MultipartRequest("POST", Uri.parse(url));
    request.headers["Authorization"] = "Bearer $token";
    request.fields["action"] = "subcomment";
    request.fields["blog_id"] = blogId;
    request.fields["user"] = userId;
    request.fields["comment"] = comment;

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    final jsonResponse = jsonDecode(responseBody);

    // Print Response Details
    print("🔹 Response Status Code: ${response.statusCode}");
    print("🔹 Response Body: $jsonResponse");

    if (response.statusCode == 200 && jsonResponse["status_code"] == 200) {
      print("✅ Comment added successfully.");
      return true;
    } else {
      throw Exception(jsonResponse["message"] ?? "Failed to add comment.");
    }
  } catch (e) {
    print("❌ Error adding comment: $e");
    return false;
  }
}

}