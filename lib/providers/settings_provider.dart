import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  bool _isSilentMode = false;
  String _reminderTime = "22:00";
  bool _isDarkMode = false;

  bool get isSilentMode => _isSilentMode;
  String get reminderTime => _reminderTime;
  bool get isDarkMode => _isDarkMode;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isSilentMode = prefs.getBool('silent_mode') ?? false;
    _reminderTime = prefs.getString('reminder_time') ?? "22:00";
    _isDarkMode = prefs.getBool('dark_mode') ?? false;
    notifyListeners();
  }

  Future<void> toggleSilentMode() async {
    _isSilentMode = !_isSilentMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('silent_mode', _isSilentMode);
    notifyListeners();
  }

  Future<void> setReminderTime(String time) async {
    _reminderTime = time;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('reminder_time', _reminderTime);
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', _isDarkMode);
    notifyListeners();
  }
}
