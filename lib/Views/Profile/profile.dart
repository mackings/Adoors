import 'package:adorss/Views/Dashboard/Views/Fees/Views/fees.dart';
import 'package:adorss/Views/Dashboard/Views/Library/views/librarypage.dart';
import 'package:adorss/Views/Dashboard/Views/Timetable/views/timetable.dart';
import 'package:adorss/Views/Dashboard/widgets/customtext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String studentId = "";
  String classId = "";
  String schoolId = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('userData');

    if (userData != null) {
      final Map<String, dynamic> userMap = jsonDecode(userData);
      setState(() {
        studentId = userMap['user_id'] ?? "N/A";
        classId = userMap['class_id'] ?? "N/A";
        schoolId = userMap['school_id'] ?? "N/A";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(text: "Profile"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            // Header with Student Info
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Student Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildCopyableText("📌 Student ID: ", studentId),
                  _buildCopyableText("🏫 School ID: ", schoolId),
                  _buildCopyableText("📚 Class ID: ", classId),
                ],
              ),
            ),

            // Profile Options List
            Expanded(
              child: ListView(
                children: [
                  _buildListTile(
                      title: "E-Library",
                      icon: Icons.calendar_today,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LibraryPage()));
                      }),
                  _buildListTile(
                    title: "Fees",
                    icon: Icons.account_balance_outlined,
                    onTap: (){
                   Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FeesPage()));
                    }
                  ),

             _buildListTile(
                    title: "Time table",
                    icon: Icons.calendar_today_outlined,
                    onTap: (){
                   Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TimetablePage()));
                    }
                  ),

                  _buildListTile(
                    title: "Settings",
                    icon: Icons.settings,
                    onTap: () => Navigator.pushNamed(context, "/settings"),
                  ),
                  _buildListTile(
                    title: "Logout",
                    icon: Icons.logout,
                    onTap: _logout,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(
      {required String title,
      required IconData icon,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildCopyableText(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: SelectableText(
            "$label$value",
            style: const TextStyle(color: Colors.white),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.copy, color: Colors.white, size: 18),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: value));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("$label copied!")),
            );
          },
        ),
      ],
    );
  }
}

void _logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear(); // Clear all stored data
  //   Navigator.pushReplacementNamed(context, "/login"); // Redirect to login page
}
