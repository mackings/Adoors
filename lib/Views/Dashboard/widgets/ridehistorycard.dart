import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';


class RideHistoryCard extends StatefulWidget {
  final String status;
  final String location;
  final String timestamp;
  final String studentId;
  final String driverId;

  const RideHistoryCard({
    Key? key,
    required this.status,
    required this.location,
    required this.timestamp,
    required this.studentId,
    required this.driverId,
  }) : super(key: key);

  @override
  _RideHistoryCardState createState() => _RideHistoryCardState();
}

class _RideHistoryCardState extends State<RideHistoryCard>
    with SingleTickerProviderStateMixin {
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    if (widget.status.toLowerCase() == "awaiting pickup") {
      _startBlinking();
    }
  }

  void _startBlinking() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 5));
      if (mounted) {
        setState(() {
          _isVisible = !_isVisible;
        });
      }
      return true;
    });
  }

  String _formatTimestamp(String timestamp) {
    try {
      final parsedDate = DateTime.parse(timestamp);
      return DateFormat('d MMMM yyyy h:mm a').format(parsedDate);
    } catch (e) {
      return timestamp; // Return the raw value if parsing fails
    }
  }

  Color _getStatusColor() {
    if (widget.status.toLowerCase() == "awaiting pickup") {
      return Colors.orange;
    } else if (widget.status.toLowerCase() == "dropped") {
      return Colors.green;
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.blue),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.location,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.person, color: Colors.orange),
              const SizedBox(width: 8),
              Text(
                "ID: ${widget.studentId}",
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.info, color: Colors.green),
              const SizedBox(width: 8),
              widget.status.toLowerCase() == "awaiting pickup"
                  ? AnimatedOpacity(
                      opacity: _isVisible ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 500),
                      child: Text(
                        "${widget.status}",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: _getStatusColor(),
                        ),
                      ),
                    )
                  : Text(
                      "Status: ${widget.status}",
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: _getStatusColor(),
                      ),
                    ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.drive_eta, color: Colors.purple),
              const SizedBox(width: 8),
              Text(
                widget.driverId.isEmpty
                    ? "Driver ID: N/A"
                    : "Driver ID: ${widget.driverId}",
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.calendar_today, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                _formatTimestamp(widget.timestamp),
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

