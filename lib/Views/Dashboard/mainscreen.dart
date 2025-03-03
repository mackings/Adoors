import 'package:adorss/Views/Dashboard/Views/Attendance/views/attendance.dart';
import 'package:adorss/Views/Dashboard/Views/Forum/Views/forum.dart';
import 'package:adorss/Views/Dashboard/Views/Routes/routes.dart';
import 'package:adorss/Views/Dashboard/Views/Timetable/views/timetable.dart';
import 'package:adorss/Views/Dashboard/Views/courses/views/courses.dart';
import 'package:adorss/Views/Dashboard/Views/home.dart';
import 'package:adorss/Views/Profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    Courses(),
    Attendance(),
    ForumPage(),
    Profile()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.flip, 
        backgroundColor: Colors.white,
        color: Colors.grey,
        activeColor: Colors.blueGrey,
        elevation: 5.0,
        curveSize: 100, 
        height: 60,
        items: const [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.book, title: 'Courses'),
          TabItem(icon: Icons.calendar_today, title: 'Attendance'),
          TabItem(icon: Icons.chat_bubble_rounded, title: 'Forum'),
          TabItem(icon: Icons.person, title: 'Profile'),
        ],
        initialActiveIndex: 0, // Default selected tab
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}