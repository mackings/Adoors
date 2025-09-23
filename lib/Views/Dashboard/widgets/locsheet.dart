import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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