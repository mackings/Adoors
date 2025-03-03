import 'dart:async';

import 'package:adorss/Views/Auth/model/signinres.dart';
import 'package:adorss/Views/Dashboard/Views/Announcements/Views/announcement.dart';
import 'package:adorss/Views/Dashboard/Views/Chat/Views/chathome.dart';
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

  Future<void> _loadRideHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('userData');

    if (userData != null) {
      final Map<String, dynamic> decodedData = jsonDecode(userData);
      final signInResponse = SignInResponse.fromJson(decodedData);

      setState(() {
        rideHistory = signInResponse.rideHistory ?? [];
      });
    }
  }



Future<void> _getLocationAndCallAPI(String studentId, Function(String) setApiResult) async {
  // Get the position (location)
  Position position = await _determinePosition();
  
  // Get the user data from shared preferences
  final prefs = await SharedPreferences.getInstance();
  String? userDataJson = prefs.getString('userData'); // Retrieve the user data JSON string

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

  print("Retrieved Token: $token");  // Debugging to ensure the token is correctly retrieved

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
      'Authorization': 'Bearer $token', // Include the token in the request header
    },
    body: body,
  );

  if (response.statusCode == 200) {
    // Handle the successful response
    final Map<String, dynamic> responseBody = jsonDecode(response.body);
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
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        return Future.error('Location permissions are denied');
      }
    }

    // Get the current location
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
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
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>
             ChatListPage()
              ));
            },
            child: Icon(Icons.chat_bubble_outline_outlined)
            ),

          SizedBox(width: 20,),

          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>
              AnnouncementsPage()
              ));
            },
            child: Icon(Icons.notifications)
            ),
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






















class BottomSheetContent extends StatefulWidget {
  final String studentId;
  final Function(String studentId, Function(String) setApiResult) onCallAPI;

  const BottomSheetContent({
    Key? key,
    required this.studentId,
    required this.onCallAPI,
  }) : super(key: key);

  @override
  _BottomSheetContentState createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  String apiResult = ''; // To hold the API result
  bool isLoading = false; // To track the loading state

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4, // Increase height to show location
      width: MediaQuery.of(context).size.width, // Full screen width
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start, // Start alignment to allow space for close icon
        children: [
          // Close button at the top right of the modal
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.black),
              onPressed: () {
                Navigator.pop(context); // Close the modal
              },
            ),
          ),
          
          // Instructional text
          Text(
            'Enable location services to get your live location for the transportation service',
            style: GoogleFonts.montserrat(
              fontSize: 15, // Adjust the size as needed
              fontWeight: FontWeight.w400,
              color: Colors.black87, // You can customize the color
            ),
          ),
          
          const SizedBox(height: 20),

          // Display loading indicator or result message
          if (isLoading)
            CircularProgressIndicator(),
          if (!isLoading && apiResult.isNotEmpty) 
            Text(
              apiResult, // Show the API response (address)
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.green, fontSize: 19.0),
            ),
          const SizedBox(height: 20),

          // "View location" button
          Container(
            width: MediaQuery.of(context).size.width - 32, // Button width with padding
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            decoration: BoxDecoration(
              color: Colors.orange, // Button background color
              borderRadius: BorderRadius.circular(10.0), // Rounded corners
            ),
            child: TextButton(
              onPressed: () {
                setState(() {
                  isLoading = true; // Set loading state to true
                });

                widget.onCallAPI(widget.studentId, (result) {
                  setState(() {
                    isLoading = false; // Set loading state to false
                    apiResult = result; // Update the UI with API result
                  });
                }); // Call the API and update the result
              },
              child: const Text(
                'View location',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}




class AnimatedBackground extends StatelessWidget {
  final double carPosition;

  const AnimatedBackground({Key? key, required this.carPosition})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Sky Background
        Container(color: Colors.lightBlue.shade100),
        // Moving Car 1
        AnimatedPositioned(
          duration: const Duration(milliseconds: 0),
          left: carPosition,
          bottom: 50,
          child: const CarWidget(color: Colors.red),
        ),
        // Moving Car 2 (Delayed start and different height)
        AnimatedPositioned(
          duration: const Duration(milliseconds: 0),
          left: carPosition - 200,
          bottom: 100,
          child: const CarWidget(color: Colors.yellow),
        ),
        // Moving Car 3 (Further delay and different height)
        AnimatedPositioned(
          duration: const Duration(milliseconds: 0),
          left: carPosition - 400,
          bottom: 150,
          child: const CarWidget(color: Colors.blue),
        ),
      ],
    );
  }
}

class CarWidget extends StatelessWidget {
  final Color color;

  const CarWidget({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.directions_car,
      size: 40,
      color: color,
    );
  }
}

