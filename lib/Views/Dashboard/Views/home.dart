import 'dart:async';

import 'package:adorss/Views/Auth/model/signinres.dart';
import 'package:adorss/Views/Dashboard/Views/Announcements/Views/announcement.dart';
import 'package:adorss/Views/Dashboard/Views/Chat/Views/chathome.dart';
import 'package:adorss/Views/Dashboard/Views/School/APi/schoolService.dart';
import 'package:adorss/Views/Dashboard/Views/School/Model/schoolModel.dart';
import 'package:adorss/Views/Dashboard/widgets/locsheet.dart';
import 'package:adorss/Views/Dashboard/widgets/ridehistorycard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:adorss/Views/Dashboard/widgets/customtext.dart';





class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<RideHistory> rideHistory = [];

  @override
  void initState() {
    super.initState();
    _loadRideHistory();
  }

School? schoolData;

Future<void> _loadRideHistory() async {
  final prefs = await SharedPreferences.getInstance();
  final userData = prefs.getString('userData');

  if (userData != null) {
    final Map<String, dynamic> decodedData = jsonDecode(userData);
    final signInResponse = SignInResponse.fromJson(decodedData);

    setState(() {
      rideHistory = signInResponse.rideHistory ?? [];
    });

    if (signInResponse.schoolId != null) {
      SchoolService schoolService = SchoolService();
      final school = await schoolService.fetchSchoolData(signInResponse.schoolId!);
      setState(() {
        schoolData = school;
      });

      print("✅ School Name: ${school?.schoolName}");
      print("✅ School Plan: ${school?.address}");
    }
  }
}


  Future<void> _getLocationAndCallAPI(
      String studentId, Function(String) setApiResult) async {
    // Get the position (location)
    Position position = await _determinePosition();

    // Get the user data from shared preferences
    final prefs = await SharedPreferences.getInstance();
    String? userDataJson =
        prefs.getString('userData'); // Retrieve the user data JSON string

    if (userDataJson == null) {
      setApiResult('No user data found');
      return;
    }

    // Parse the user data to extract the token
    final userData = jsonDecode(userDataJson);
    String? token = userData['token']; // Extract the token from the parsed JSON

    if (token == null) {
      setApiResult('No token found');
      return;
    }

    print(
        "Retrieved Token: $token"); // Debugging to ensure the token is correctly retrieved

    // API request body
    final body = jsonEncode({
      "latitude": position.latitude.toString(),
      "longitude": position.longitude.toString(),
      "status": "in transit", // Example status
      "student_id": studentId,
    });

    // Make the API call
    final response = await http.post(
      Uri.parse('https://adorss.ng/scripts/transportation'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer $token', // Include the token in the request header
      },
      body: body,
    );

    if (response.statusCode == 200) {
      // Handle the successful response
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      print("response >>>>> $responseBody");
      String address = responseBody['address'] ?? 'No address found';
      setApiResult('$address'); // Display the address from the API
    } else {
      // Handle error response
      setApiResult('API call failed: ${response.body}');
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, handle appropriately
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error('Location permissions are denied');
      }
    }

    // Get the current location
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChatListPage()));
              },
              child: Icon(Icons.chat_bubble_outline_outlined)),
          SizedBox(
            width: 20,
          ),
          GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AnnouncementsPage()));
              },
              child: Icon(Icons.notifications)),
        ],
      ),
      body: rideHistory.isEmpty
          ? const Center(
              child: Text('No ride history available'),
            )
          : ListView.builder(
              itemCount: rideHistory.length,
              itemBuilder: (context, index) {
                final ride = rideHistory[index];
                return GestureDetector(
                  onTap: () {
                    // Show modal sheet on tap
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return BottomSheetContent(
                          studentId: ride.studentId ?? 'Unknown ID',
                          onCallAPI: _getLocationAndCallAPI,
                        );
                      },
                    );
                  },
                  child: RideHistoryCard(
                    status: ride.status ?? 'Unknown',
                    location: ride.location ?? 'Unknown location',
                    timestamp: ride.locationTimestamp ?? 'Unknown time',
                    studentId: ride.studentId ?? 'Unknown ID',
                    driverId: ride.driverId ?? '',
                  ),
                );
              },
            ),
    );
  }
}
