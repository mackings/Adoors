import 'package:adorss/Views/Dashboard/Views/Fees/Api/feeservice.dart';
import 'package:adorss/Views/Dashboard/Views/Fees/model/fees.dart';
import 'package:adorss/Views/Dashboard/Views/Fees/widgets/feecard.dart';
import 'package:adorss/Views/Dashboard/widgets/customtext.dart';
import 'package:flutter/material.dart';




class FeesPage extends StatefulWidget {
  const FeesPage({super.key});

  @override
  State<FeesPage> createState() => _FeesPageState();
}

class _FeesPageState extends State<FeesPage> {

  final FeesService _feesService = FeesService();
  List<FeeRecord>? _fees;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFees();
  }

  Future<void> _loadFees() async {
    final fees = await _feesService.fetchFees();
    setState(() {
      _fees = fees;
      _isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: CustomText(text: "Fees")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _fees == null || _fees!.isEmpty
              ? const Center(child: Text("No fees found"))
              : ListView.builder(
                  itemCount: _fees!.length,
                  itemBuilder: (context, index) {
                    final fee = _fees![index];
                    return FeeCard(
                      feeName: fee.feeName,
                      amount: fee.amount,
                      hasPaid: fee.hasPaid,
                    );
                  },
                ),
    );
  }
}
