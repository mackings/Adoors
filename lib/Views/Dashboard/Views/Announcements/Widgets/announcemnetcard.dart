import 'package:adorss/Views/Dashboard/Views/Announcements/Model/announcementmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class AnnouncementCard extends StatelessWidget {
  final Announcement announcement;

  const AnnouncementCard({
    Key? key,
    required this.announcement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleRow(),
          const SizedBox(height: 10),
          _buildDescription(),
          const SizedBox(height: 12),
          _buildDateRow(),
        ],
      ),
    );
  }

  /// **Title section with an icon**
  Widget _buildTitleRow() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.announcement, color: Colors.blue, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            announcement.title,
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  /// **Announcement details with better readability**
  Widget _buildDescription() {
    return Text(
      announcement.details.isNotEmpty ? announcement.details : "No details provided",
      style: GoogleFonts.montserrat(
        fontSize: 14,
        color: Colors.black87,
        height: 1.5, // Better line spacing
      ),
    );
  }

  /// **Date section aligned to the right with an icon**
  Widget _buildDateRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Icon(Icons.access_time, size: 16, color: Colors.blueGrey),
        const SizedBox(width: 6),
        Text(
          announcement.formattedDate,
          style: GoogleFonts.montserrat(
            fontSize: 12,
            color: Colors.blueGrey,
          ),
        ),
      ],
    );
  }
}
