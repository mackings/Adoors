import 'package:adorss/Views/Dashboard/Views/Attendance/Api/attservice.dart';
import 'package:adorss/Views/Dashboard/Views/Attendance/Model/attmodel.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';



class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  late Future<List<AttendanceRecord>?> _attendanceFuture;
  Map<DateTime, String> _attendanceMap = {};

  @override
  void initState() {
    super.initState();
    _attendanceFuture = AttendanceService().fetchAttendance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Attendance")),
      body: FutureBuilder<List<AttendanceRecord>?>(
        future: _attendanceFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text("No attendance records found."));
          } else {
            final attendanceRecords = snapshot.data!;

            // Convert API data to a map with normalized DateTime keys (date-only)
            _attendanceMap = {
              for (var record in attendanceRecords)
                _normalizeDate(DateTime.parse(record.date)): record.status
            };

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: TableCalendar(
                firstDay: DateTime.utc(2024, 1, 1),
                lastDay: DateTime.utc(2025, 12, 31),
                focusedDay: DateTime.now(),
                calendarFormat: CalendarFormat.month,
                availableGestures: AvailableGestures.all,
                headerStyle: const HeaderStyle(formatButtonVisible: false),
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  outsideDaysVisible: false,
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: Colors.black),
                  weekendStyle: TextStyle(color: Colors.red),
                ),
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    // Normalize the day to compare only the date component
                    final normalizedDay = _normalizeDate(day);
                    final status = _attendanceMap[normalizedDay];

                    if (status == "present") {
                      return _buildAttendanceMarker(normalizedDay, Colors.blue);
                    } else if (status == "absent") {
                      return _buildAttendanceMarker(normalizedDay, Colors.red);
                    }
                    return null;
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }

  // Helper function to normalize DateTime to date-only (ignoring time)
  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  Widget _buildAttendanceMarker(DateTime date, Color color) {
    return Center(
      child: Container(
        width: 36,  // Adjusted size
        height: 36,
        decoration: BoxDecoration(
          color: color == Colors.blue ? Colors.transparent : color,
          shape: BoxShape.circle,
          border: color == Colors.blue
              ? Border.all(color: Colors.blue, width: 2)
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          "${date.day}",
          style: TextStyle(
            color: color == Colors.blue ? Colors.blue : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
