import 'dart:convert';

class SignInResponse {
  final bool? success;
  final String? role;
  final String? token;
  final String? userId;
  final String? schoolId;
  final String? classId;
  final List<RideHistory>? rideHistory;  // For actual ride records
  final String? rideHistoryMessage;  // For the "No ride records" message
  final int? statusCode;

  SignInResponse({
    this.success,
    this.role,
    this.token,
    this.userId,
    this.schoolId,
    this.classId,
    this.rideHistory,
    this.rideHistoryMessage,
    this.statusCode,
  });

  factory SignInResponse.fromJson(Map<String, dynamic> json) {
    return SignInResponse(
      success: json['success'] as bool?,
      role: json['role'] as String?,
      token: json['token'] as String?,
      userId: json['user_id'] as String?,
      schoolId: json['school_id'] as String?,
      classId: json['class_id'] as String?,
      rideHistory: (json['ride_history'] is List)
          ? (json['ride_history'] as List<dynamic>)
              .map((e) => RideHistory.fromJson(e as Map<String, dynamic>))
              .toList()
          : null, // If it's not a list, set it to null
      rideHistoryMessage: json['ride_history'] is String
          ? json['ride_history']
          : null, // Store as message if it's a string
      statusCode: json['status_code'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'role': role,
      'token': token,
      'user_id': userId,
      'school_id': schoolId,
      'class_id': classId,
      'ride_history': rideHistory != null
          ? rideHistory!.map((e) => e.toJson()).toList()
          : rideHistoryMessage, // Store as string if no list is present
      'status_code': statusCode,
    };
  }
}

class RideHistory {
  final String? studentId;
  final String? schoolId;
  final String? driverId;
  final String? status;
  final String? location;
  final String? longitude;
  final String? latitude;
  final String? locationTimestamp;

  RideHistory({
    this.studentId,
    this.schoolId,
    this.driverId,
    this.status,
    this.location,
    this.longitude,
    this.latitude,
    this.locationTimestamp,
  });

  factory RideHistory.fromJson(Map<String, dynamic> json) {
    return RideHistory(
      studentId: json['student_id'] as String?,
      schoolId: json['school_id'] as String?,
      driverId: json['driver_id'] as String?,
      status: json['status'] as String?,
      location: json['location'] as String?,
      longitude: json['longitude'] as String?,
      latitude: json['latitude'] as String?,
      locationTimestamp: json['location_timestamp'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'school_id': schoolId,
      'driver_id': driverId,
      'status': status,
      'location': location,
      'longitude': longitude,
      'latitude': latitude,
      'location_timestamp': locationTimestamp,
    };
  }
}
