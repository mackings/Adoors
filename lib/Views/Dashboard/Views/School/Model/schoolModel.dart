class School {
  final String schoolId;
  final String schoolName;
  final String email;
  final String phoneNumber;
  final String planType;
  final String status;
  final String websiteUrl;
  final String websiteLogo;
  final String address;

  School({
    required this.schoolId,
    required this.schoolName,
    required this.email,
    required this.phoneNumber,
    required this.planType,
    required this.status,
    required this.websiteUrl,
    required this.websiteLogo,
    required this.address,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      schoolId: json["school_id"] ?? "",
      schoolName: json["schoolname"] ?? "",
      email: json["email"] ?? "",
      phoneNumber: json["phone_number"] ?? "",
      planType: json["plan_type"] ?? "",
      status: json["status"] ?? "",
      websiteUrl: json["website_url"] ?? "",
      websiteLogo: json["website_logo"] ?? "",
      address: json["address"] ?? "",
    );
  }

  static List<School> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => School.fromJson(json)).toList();
  }
}
