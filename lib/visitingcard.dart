class VisitingCard {
  final String name;
  final String phoneNumber;
  final String email;
  final String company;

  VisitingCard({
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.company,
  });

  factory VisitingCard.fromJson(Map<String, dynamic> json) {
    return VisitingCard(
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
      company: json['company'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'company': company,
    };
  }
}
