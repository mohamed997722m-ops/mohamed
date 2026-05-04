import "dart:ui" as ui;
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
        score: prefs.getInt('user_score') ?? 0,
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
    await prefs.setInt('user_score', profile.score);
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
        score: newScore < 0 ? 0 : newScore,
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('user_score', _profile!.score);
      notifyListeners();
    }
  }
}
