import 'dart:convert';
import 'package:adorss/Views/Dashboard/Views/Chat/Model/chatmodel.dart';
import 'package:adorss/Views/Dashboard/Views/Chat/Model/messagemodel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



class ChatService {

  static const String _baseUrl = "https://adorss.ng/scripts/chatroom";

  /// Fetches student chats
  Future<List<Chat>?> fetchStudentChats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? userData = prefs.getString('userData');

      if (userData == null) {
        throw Exception("User not logged in.");
      }

      final Map<String, dynamic> userMap = jsonDecode(userData);
      String token = userMap['token'];
      String studentId = userMap['user_id'];

      String url = "$_baseUrl?action=studentchats&student=$studentId";

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> responseData = jsonDecode(response.body);
        return Chat.fromJsonList(responseData);
      } else {
        throw Exception("Failed to load chats. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error fetching chats: $e");
      return null;
    }
  }


  Future<List<Message>?> fetchMessages(String chatId) async {

    try {
      final prefs = await SharedPreferences.getInstance();
      String? userData = prefs.getString('userData');

      if (userData == null) {
        throw Exception("User not logged in.");
      }

      final Map<String, dynamic> userMap = jsonDecode(userData);
      String token = userMap['token'];
      String userId = userMap['user_id'];

      var request = http.MultipartRequest("POST", Uri.parse(_baseUrl));
      request.fields['action'] = "fetchchat2";
      request.fields['user'] = userId;
      request.fields['chat'] = chatId;
      request.fields['limit'] = "20";
      request.fields['offset'] = '0';
      request.headers["Authorization"] = "Bearer $token";

      print("🔹 API Request: POST $_baseUrl");
      print("🔹 Request Fields: ${request.fields}");

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print("🔹 Response Status Code: ${response.statusCode}");
      print("🔹 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData["success"] == true) {
          return Message.fromJsonList(responseData["data"]);
        } else {
          throw Exception("Failed to fetch messages.");
        }
      } else {
        throw Exception("Failed to load messages. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error fetching messages: $e");
      return null;
    }
  }



Future<bool> sendMessage(String chatId, String message) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('userData');

    if (userData == null) {
      throw Exception("User not logged in.");
    }

    final Map<String, dynamic> userMap = jsonDecode(userData);
    String token = userMap['token'];
    String userId = userMap['user_id'];

    var request = http.MultipartRequest("POST", Uri.parse(_baseUrl));
    request.fields['action'] = "sendchat";
    request.fields['user'] = userId;
    request.fields['chatid'] = chatId;
    request.fields['message'] = message;
    request.headers["Authorization"] = "Bearer $token";

    print("🔹 Sending Message: $message to Chat ID: $chatId");

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    print("🔹 Response Status Code: ${response.statusCode}");
    print("🔹 Response Body: ${response.body}");

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      return responseData["success"] == true;
    } else {
      return false;
    }
  } catch (e) {
    print("❌ Error sending message: $e");
    return false;
  }
}


}
