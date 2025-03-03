import 'package:adorss/Views/Dashboard/Views/Library/Api/libservice.dart';
import 'package:adorss/Views/Dashboard/Views/Library/Model/libmodel.dart';
import 'package:adorss/Views/Dashboard/Views/Library/widgets/libcard.dart';
import 'package:adorss/Views/Dashboard/widgets/customtext.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  late Future<List<LibraryRecord>?> _libraryFuture;

  @override 
  void initState() {
    super.initState();
    _libraryFuture = LibraryService().fetchLibraryData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(
          "E-Library",
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),),
      body: FutureBuilder<List<LibraryRecord>?>(
        future: _libraryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text("No library records found."));
          } else {
            final libraryRecords = snapshot.data!;

            return ListView.builder(
              itemCount: libraryRecords.length,
              itemBuilder: (context, index) {
                return LibraryCard(libraryRecord: libraryRecords[index]);
              },
            );
          }
        },
      ),
    );
  }
}