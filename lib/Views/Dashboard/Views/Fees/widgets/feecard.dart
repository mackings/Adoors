import 'package:flutter/material.dart';

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
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(
          hasPaid ? Icons.check_circle : Icons.cancel,
          color: hasPaid ? Colors.green : Colors.red,
        ),
        title: Text(
          feeName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("Amount: ₦$amount"),
        trailing: Text(
          hasPaid ? "Paid" : "Unpaid",
          style: TextStyle(
            color: hasPaid ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
