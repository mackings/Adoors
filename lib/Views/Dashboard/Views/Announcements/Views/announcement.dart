import 'package:adorss/Views/Dashboard/Views/Announcements/Api/announcementservice.dart';
import 'package:adorss/Views/Dashboard/Views/Announcements/Model/announcementmodel.dart';
import 'package:adorss/Views/Dashboard/Views/Announcements/Widgets/announcemnetcard.dart';
import 'package:adorss/Views/Dashboard/widgets/customtext.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({Key? key}) : super(key: key);

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  final AnnouncementService _announcementService = AnnouncementService();
  List<Announcement>? _announcements;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnnouncements();
  }


  Future<void> _loadAnnouncements() async {
    List<Announcement>? announcements = await _announcementService.fetchAnnouncements();
    setState(() {
      _announcements = announcements;
      _isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(
          "Announcements",
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _announcements == null || _announcements!.isEmpty
              ? const Center(child: Text("No announcements available"))
              : ListView.builder(
                  itemCount: _announcements!.length,
                  itemBuilder: (context, index) {
                    return AnnouncementCard(
                      announcement: _announcements![index], // Pass Announcement object
                    );
                  },
                ),
    );
  }
}
