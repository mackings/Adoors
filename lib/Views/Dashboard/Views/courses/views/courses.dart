import 'package:adorss/Views/Dashboard/Views/courses/Api/courseservice.dart';
import 'package:adorss/Views/Dashboard/Views/courses/model/coursemodel.dart';
import 'package:adorss/Views/Dashboard/Views/courses/widgets/coursecard.dart';
import 'package:adorss/Views/Dashboard/widgets/customtext.dart';
import 'package:flutter/material.dart';




class Courses extends StatefulWidget {
  @override
  _CoursesState createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  late Future<List<Course>?> _coursesFuture;

  @override
  void initState() {
    super.initState();
    _coursesFuture = CourseService().fetchCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const CustomText(text: "Courses",)),
      body: FutureBuilder<List<Course>?>(
        future: _coursesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text("No courses found."));
          } else {
            final courses = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: CourseCard(
                    courseId: course.courseId ?? "Unknown Course",
                    courseName: course.courseName ?? "Unknown Course",
                    courseClass: course.courseClass ?? "N/A",
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}