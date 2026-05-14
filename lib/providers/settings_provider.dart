import "dart:ui" as ui;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  bool _isSilentMode = false;
  String _reminderOffset = "night_before"; // night_before, 1_hour, 30_min

  bool get isSilentMode => _isSilentMode;
  String get reminderOffset => _reminderOffset;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isSilentMode = prefs.getBool('silent_mode') ?? false;
    _reminderOffset = prefs.getString('reminder_offset') ?? "night_before";
    notifyListeners();
  }

  Future<void> toggleSilentMode() async {
    _isSilentMode = !_isSilentMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('silent_mode', _isSilentMode);
    notifyListeners();
  }

  Future<void> setReminderOffset(String offset) async {
    _reminderOffset = offset;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('reminder_offset', _reminderOffset);
    notifyListeners();
  }
}
