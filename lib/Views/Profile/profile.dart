import 'package:adorss/Views/Dashboard/Views/Fees/Views/fees.dart';
import 'package:adorss/Views/Dashboard/Views/Library/views/librarypage.dart';
import 'package:adorss/Views/Dashboard/Views/Timetable/views/timetable.dart';
import 'package:adorss/Views/Dashboard/widgets/customtext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';





class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late String studentId;
  late String classId;
  late String schoolId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userData = prefs.getString('userData');

    if (userData != null) {
      final Map<String, dynamic> userMap = jsonDecode(userData);
      studentId = userMap['user_id'] ?? "N/A";
      classId = userMap['class_id'] ?? "N/A";
      schoolId = userMap['school_id'] ?? "N/A";
    } else {
      studentId = "N/A";
      classId = "N/A";
      schoolId = "N/A";
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          "Profile",
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
       // backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  _buildProfileCard(),
                  const SizedBox(height: 10),
                  Expanded(child: _buildProfileOptions()),
                ],
              ),
            ),
    );
  }

  /// **Modern Profile Card with Gradient & Better Design**
  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.symmetric(vertical: 19,horizontal: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.blue.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade300.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Student Card",
            style: GoogleFonts.montserrat(
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
    );
  }

  /// **Profile Options with Modern UI**
  Widget _buildProfileOptions() {
    return ListView(
      children: [
        _buildListTile(
          title: "E-Library",
          icon: Icons.library_books,
          onTap: () => _navigateTo(const LibraryPage()),
        ),
        _buildListTile(
          title: "Fees",
          icon: Icons.account_balance_wallet,
          onTap: () => _navigateTo(const FeesPage()),
        ),
        _buildListTile(
          title: "Time Table",
          icon: Icons.schedule,
          onTap: () => _navigateTo(const TimetablePage()),
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
          isLogout: true,
        ),
      ],
    );
  }

  /// **Reusable ListTile with Google Fonts**
  Widget _buildListTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Icon(icon, color: isLogout ? Colors.red : Colors.blue),
        title: Text(
          title,
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  /// **Reusable Copyable Text**
  Widget _buildCopyableText(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: SelectableText(
            "$label$value",
            style: GoogleFonts.montserrat(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.copy, color: Colors.white, size: 18),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: value));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("$label copied!"),
                backgroundColor: Colors.blue.shade700,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
      ],
    );
  }

  /// **Reusable Navigation Function**
  void _navigateTo(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  /// **Logout Function with Navigation Reset**
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
    }
  }
}