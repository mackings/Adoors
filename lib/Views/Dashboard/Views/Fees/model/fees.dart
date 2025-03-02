class FeeRecord {
  
  final String id;
  final String feeName;
  final String amount;
  final String classId;
  final String schoolId;
  final bool hasPaid;
  final String? paymentId;

  FeeRecord({
    required this.id,
    required this.feeName,
    required this.amount,
    required this.classId,
    required this.schoolId,
    required this.hasPaid,
    this.paymentId,
  });

  factory FeeRecord.fromJson(Map<String, dynamic> json) {
    return FeeRecord(
      id: json['s'],
      feeName: json['fee'],
      amount: json['amount'],
      classId: json['class'],
      schoolId: json['school'],
      hasPaid: json['hasPaid'] == "1",
      paymentId: json['payment_id'],
    );
  }

  static List<FeeRecord> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => FeeRecord.fromJson(json)).toList();
  }
}
