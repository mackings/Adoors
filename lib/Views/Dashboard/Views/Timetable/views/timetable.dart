import 'package:adorss/Views/Dashboard/Views/Timetable/Api/ttservice.dart';
import 'package:adorss/Views/Dashboard/Views/Timetable/Model/timetable.dart';
import 'package:adorss/Views/Dashboard/Views/Timetable/widgets/timetable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TimetablePage extends StatefulWidget {
  const TimetablePage({super.key});

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  late Future<List<TimetableRecords>?> _timetableFuture;

  @override
  void initState() {
    super.initState();
    _timetableFuture = TimetableService().fetchTimetable();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Time Table",
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder<List<TimetableRecords>?>(
        future: _timetableFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text("No timetable records found."));
          } else {
            final timetableRecords = snapshot.data!;

            return ListView.builder(
  padding: const EdgeInsets.all(16.0),
  itemCount: timetableRecords.length,
  itemBuilder: (context, index) {
    return TimetableCard(
      record: TheTimetableRecord(  // ✅ Convert TimetableRecords to TheTimetableRecord
        courseName: timetableRecords[index].courseName,
        day: timetableRecords[index].day,
        startTime: timetableRecords[index].startTime,
        endTime: timetableRecords[index].endTime,
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
