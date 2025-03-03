import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeeCard extends StatelessWidget {
  final String feeName;
  final String amount;
  final bool hasPaid;

  const FeeCard({
    Key? key,
    required this.feeName,
    required this.amount,
    required this.hasPaid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            _buildStatusIcon(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    feeName,
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Amount: ₦$amount",
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            _buildPaymentStatus(),
          ],
        ),
      ),
    );
  }

  /// **Builds the payment status badge**
  Widget _buildPaymentStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: hasPaid ? Colors.green.shade100 : Colors.red.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        hasPaid ? "Paid" : "Unpaid",
        style: GoogleFonts.montserrat(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: hasPaid ? Colors.green : Colors.red,
        ),
      ),
    );
  }

  /// **Builds the leading status icon**
  Widget _buildStatusIcon() {
    return Icon(
      hasPaid ? Icons.verified : Icons.payment,
      color: hasPaid ? Colors.green : Colors.red,
      size: 28,
    );
  }
}
