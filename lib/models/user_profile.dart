class UserProfile {
  final String name;
  final String academicYear;
  final String college;
  final String department;
  final String semester;
  final String? phone;
  final String? address;
  final int age;
  final int score;
  final String? semesterStartDate;

  UserProfile({
    required this.name,
    required this.academicYear,
    required this.college,
    required this.department,
    required this.semester,
    this.phone,
    this.address,
    this.age = 0,
    this.score = 0,
    this.semesterStartDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'academicYear': academicYear,
      'college': college,
      'department': department,
      'semester': semester,
      'phone': phone,
      'address': address,
      'age': age,
      'score': score,
      'semesterStartDate': semesterStartDate,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      name: map['name'] ?? '',
      academicYear: map['academicYear'] ?? '',
      college: map['college'] ?? '',
      department: map['department'] ?? '',
      semester: map['semester'] ?? '',
      phone: map['phone'],
      address: map['address'],
      age: map['age'] ?? 0,
      score: map['score'] ?? 0,
      semesterStartDate: map['semesterStartDate'],
    );
  }
}
