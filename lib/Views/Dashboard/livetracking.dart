import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';





class LiveTrackingPage extends StatefulWidget {
  final String schoolAddress;

  const LiveTrackingPage({super.key, required this.schoolAddress});

  @override
  State<LiveTrackingPage> createState() => _LiveTrackingPageState();
}

class _LiveTrackingPageState extends State<LiveTrackingPage> {


  final Completer<GoogleMapController> _controller = Completer();
  LatLng? _currentLocation;
  LatLng? _destination;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _initMap();
  }

StreamSubscription<Position>? _positionStream;

Future<void> _initMap() async {
  // 🔹 Request permissions first
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return;
  }
  if (permission == LocationPermission.deniedForever) return;

  // 🔹 Get initial position
  Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
  _currentLocation = LatLng(position.latitude, position.longitude);

  // 🔹 Destination (use Google Geocoding API instead of locationFromAddress)
  final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? "";
  final url =
      "https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(widget.schoolAddress)}&key=$apiKey";

  try {
    final response = await Dio().get(url);
    if (response.data["status"] == "OK") {
      final loc = response.data["results"][0]["geometry"]["location"];
      _destination = LatLng(loc["lat"], loc["lng"]);
    } else {
      debugPrint("❌ Google Geocoding failed: ${response.data["status"]}");
      return; // stop if no destination found
    }
  } catch (e) {
    debugPrint("❌ Geocoding request error: $e");
    return;
  }

  // 🔹 Custom icons
  final userIcon =
      await _bitmapDescriptorFromIcon(Icons.person_pin_circle, Colors.blue);
  final schoolIcon =
      await _bitmapDescriptorFromIcon(Icons.school, Colors.black);

  // 🔹 Add school marker only once
  _markers.add(
    Marker(
      markerId: const MarkerId("school"),
      position: _destination!,
      icon: schoolIcon,
      infoWindow: const InfoWindow(title: "School"),
    ),
  );

  // 🔹 Listen to live updates
  _positionStream = Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5, // update every 5 meters
    ),
  ).listen((Position newPos) async {
    final newLocation = LatLng(newPos.latitude, newPos.longitude);

    setState(() {
      _currentLocation = newLocation;

      // Update user marker
      _markers.removeWhere((m) => m.markerId == const MarkerId("current"));
      _markers.add(
        Marker(
          markerId: const MarkerId("current"),
          position: newLocation,
          icon: userIcon,
          infoWindow: const InfoWindow(title: "You"),
        ),
      );
    });

    // 🔹 Re-draw polyline with updated position
    await _drawRoute();

    // 🔹 Move camera to follow user
    final controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLng(newLocation));
  });

  // Draw initial route
  await _drawRoute();
  await _fitCameraToBounds();

  setState(() {});
}



@override
void dispose() {
  _positionStream?.cancel();
  super.dispose();
}



Future<void> _drawRoute() async {
  if (_currentLocation == null || _destination == null) return;

  bool isEmulator = false;

  try {
    if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      if (deviceInfo.isPhysicalDevice == false) {
        isEmulator = true;
      }
    } else if (Platform.isIOS) {
      final iosInfo = await DeviceInfoPlugin().iosInfo;
      if (iosInfo.isPhysicalDevice == false) {
        isEmulator = true;
      }
    }
  } catch (e) {
    debugPrint("Device check failed: $e");
  }

  if (isEmulator) {
    // ✅ Mock route: straight line (useful in simulator/emulator)
    setState(() {
      _polylines = {
        Polyline(
          polylineId: const PolylineId("mock_route"),
          color: Colors.blue,
          width: 6,
          points: [
            _currentLocation!,
            _destination!,
          ],
        ),
      };
    });
    return;
  }

  // ✅ Real Directions API
  final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? "";
  PolylinePoints polylinePoints = PolylinePoints(apiKey: apiKey);

  PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
    request: PolylineRequest(
      origin: PointLatLng(
        _currentLocation!.latitude,
        _currentLocation!.longitude,
      ),
      destination: PointLatLng(
        _destination!.latitude,
        _destination!.longitude,
      ),
      mode: TravelMode.driving,
    ),
  );

  if (result.points.isNotEmpty) {
    List<LatLng> polylineCoords =
        result.points.map((p) => LatLng(p.latitude, p.longitude)).toList();

    setState(() {
      _polylines = {
        Polyline(
          polylineId: const PolylineId("real_route"),
          color: Colors.blue,
          width: 6,
          points: polylineCoords,
        ),
      };
    });
  } else {
    debugPrint("❌ No polyline points found: ${result.errorMessage}");
    setState(() {
      _polylines = {}; // clear so at least markers show
    });
  }
}




  Future<void> _fitCameraToBounds() async {
    final GoogleMapController controller = await _controller.future;

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        (_currentLocation!.latitude <= _destination!.latitude)
            ? _currentLocation!.latitude
            : _destination!.latitude,
        (_currentLocation!.longitude <= _destination!.longitude)
            ? _currentLocation!.longitude
            : _destination!.longitude,
      ),
      northeast: LatLng(
        (_currentLocation!.latitude > _destination!.latitude)
            ? _currentLocation!.latitude
            : _destination!.latitude,
        (_currentLocation!.longitude > _destination!.longitude)
            ? _currentLocation!.longitude
            : _destination!.longitude,
      ),
    );

    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
  }

  Future<BitmapDescriptor> _bitmapDescriptorFromIcon(
      IconData iconData, Color color) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    final textSpan = TextSpan(
      text: String.fromCharCode(iconData.codePoint),
      style: TextStyle(
        fontSize: 80.0,
        color: color,
        fontFamily: iconData.fontFamily,
      ),
    );
    textPainter.text = textSpan;
    textPainter.layout();
    textPainter.paint(canvas, const Offset(0.0, 0.0));

    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(100, 100);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(
          "Live Movement",
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: (_currentLocation == null || _destination == null)
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentLocation!,
          zoom: 14,
        ),
        markers: _markers,
        polylines: _polylines,
        onMapCreated: (controller) => _controller.complete(controller),
        myLocationEnabled: true, // ✅ show user blue dot too
        myLocationButtonEnabled: true,
      ),
    );
  }
}
