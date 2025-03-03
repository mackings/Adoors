import 'package:adorss/Views/Dashboard/Views/Library/Model/libmodel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class LibraryCard extends StatelessWidget {
  final LibraryRecord libraryRecord;

  const LibraryCard({super.key, required this.libraryRecord});

  // void _downloadFile(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     Fluttertoast.showToast(msg: "Could not open file.");
  //   }
  // }


  void _downloadFile(String url) async {
  try {
    // Get device's download directory
    Directory? directory = await getExternalStorageDirectory();
    if (directory == null) {
      Fluttertoast.showToast(msg: "Storage access error.");
      return;
    }

    String fileName = url.split('/').last; // Extract file name from URL
    String filePath = "${directory.path}/$fileName";

    // Download file using Dio
    Dio dio = Dio();
    await dio.download(url, filePath);

    // Open the downloaded file
    OpenFile.open(filePath);

    Fluttertoast.showToast(msg: "File downloaded successfully!");
  } catch (e) {
    Fluttertoast.showToast(msg: "Download failed: ${e.toString()}");
  }
}

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// **Library Title**
            Text(
              libraryRecord.title,
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 8),

            /// **Description (Stripped of HTML Tags)**
            Text(
              libraryRecord.description.replaceAll(RegExp(r'<[^>]*>'), ''),
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 10),

            /// **Date & Download Button**
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// **Date**
                Text(
                  "📅 ${libraryRecord.regDate.split(' ')[0]}",
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),

                /// **Download Button**
                ElevatedButton.icon(
                  onPressed: () => _downloadFile(libraryRecord.appendedFile),
                  icon: const Icon(Icons.download, size: 20),
                  label: Text(
                    "Download",
                    style: GoogleFonts.montserrat(fontSize: 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
