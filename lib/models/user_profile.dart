import 'dart:ui' as ui;
class UserProfile {
  final String name;
  final String academicYear;
  final String college;
  final String department;
  final String semester;
  final int score;

  UserProfile({
    required this.name,
    required this.academicYear,
    required this.college,
    required this.department,
    required this.semester,
    this.score = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'academicYear': academicYear,
      'college': college,
      'department': department,
      'semester': semester,
      'score': score,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      name: map['name'],
      academicYear: map['academicYear'],
      college: map['college'],
      department: map['department'],
      semester: map['semester'],
      score: map['score'],
    );
  }
}
