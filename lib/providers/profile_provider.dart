import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';

class ProfileProvider with ChangeNotifier {
  UserProfile? _profile;

  UserProfile? get profile => _profile;

  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_name');
    if (name != null) {
      _profile = UserProfile(
        name: name,
        academicYear: prefs.getString('user_year') ?? '',
        college: prefs.getString('user_college') ?? '',
        department: prefs.getString('user_dept') ?? '',
        semester: prefs.getString('user_semester') ?? '',
        phone: prefs.getString('user_phone'),
        address: prefs.getString('user_address'),
        age: prefs.getInt('user_age') ?? 0,
        score: prefs.getInt('user_score') ?? 0,
        semesterStartDate: prefs.getString('user_semester_start'),
      );
      notifyListeners();
    }
  }

  Future<void> saveProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', profile.name);
    await prefs.setString('user_year', profile.academicYear);
    await prefs.setString('user_college', profile.college);
    await prefs.setString('user_dept', profile.department);
    await prefs.setString('user_semester', profile.semester);
    if (profile.phone != null) await prefs.setString('user_phone', profile.phone!);
    if (profile.address != null) await prefs.setString('user_address', profile.address!);
    await prefs.setInt('user_age', profile.age);
    await prefs.setInt('user_score', profile.score);
    if (profile.semesterStartDate != null) await prefs.setString('user_semester_start', profile.semesterStartDate!);
    _profile = profile;
    notifyListeners();
  }

  Future<void> updateScore(int delta) async {
    if (_profile != null) {
      final newScore = _profile!.score + delta;
      _profile = UserProfile(
        name: _profile!.name,
        academicYear: _profile!.academicYear,
        college: _profile!.college,
        department: _profile!.department,
        semester: _profile!.semester,
        phone: _profile!.phone,
        address: _profile!.address,
        age: _profile!.age,
        score: newScore < 0 ? 0 : newScore,
        semesterStartDate: _profile!.semesterStartDate,
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('user_score', _profile!.score);
      notifyListeners();
    }
  }

  String get rank {
    if (_profile == null) return "طالب جديد";
    int score = _profile!.score;
    if (score >= 1000) return "بروفيسور";
    if (score >= 500) return "طالب مجتهد";
    if (score >= 200) return "طالب نشيط";
    return "طالب مستجد";
  }
}
