import 'package:adorss/Views/Dashboard/Views/Attendance/Api/attservice.dart';
import 'package:adorss/Views/Dashboard/Views/Attendance/Model/attmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Attendance",
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder<List<AttendanceRecord>?>(
        future: _attendanceFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return _buildErrorMessage("Error: ${snapshot.error}");
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return _buildErrorMessage("No attendance records found.");
          } else {
            final attendanceRecords = snapshot.data!;
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
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleTextStyle: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.blueAccent),
                  rightChevronIcon: const Icon(Icons.chevron_right, color: Colors.blueAccent),
                ),
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  defaultTextStyle: GoogleFonts.montserrat(fontSize: 14),
                  weekendTextStyle: GoogleFonts.montserrat(fontSize: 14, color: Colors.red),
                  outsideDaysVisible: false,
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  weekendStyle: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
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

  /// Normalizes DateTime to remove time component (keeps only date)
  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Builds a circle marker for attendance status
  Widget _buildAttendanceMarker(DateTime date, Color color) {
    return Center(
      child: Container(
        width: 36,
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
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color == Colors.blue ? Colors.blue : Colors.white,
          ),
        ),
      ),
    );
  }

  /// Builds an error message UI
  Widget _buildErrorMessage(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
      ),
    );
  }
}
