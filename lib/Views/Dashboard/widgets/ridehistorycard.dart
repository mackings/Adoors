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
      return DateFormat('d MMM yyyy, h:mm a').format(parsedDate);
    } catch (e) {
      return timestamp; // Fallback to raw value if parsing fails
    }
  }

  Color _getStatusColor() {
    switch (widget.status.toLowerCase()) {
      case "awaiting pickup":
        return Colors.orange;
      case "dropped":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 6,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(Icons.location_on, widget.location, Colors.blue),
         // const SizedBox(height: 12),
        //  _buildInfoRow(Icons.person, "ID: ${widget.studentId}", Colors.orange),
          const SizedBox(height: 12),
          _buildStatusRow(),
          const SizedBox(height: 12),
          _buildInfoRow(
            Icons.drive_eta,
            widget.driverId.isEmpty ? "Driver ID: N/A" : "Driver ID: ${widget.driverId}",
            Colors.purple,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.calendar_today, _formatTimestamp(widget.timestamp), Colors.grey),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        _iconContainer(icon, color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusRow() {
    return Row(
      children: [
        _iconContainer(Icons.info, _getStatusColor()),
        const SizedBox(width: 8),
        Expanded(
          child: widget.status.toLowerCase() == "awaiting pickup"
              ? AnimatedOpacity(
                  opacity: _isVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    widget.status,
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
        ),
      ],
    );
  }

  Widget _iconContainer(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}

