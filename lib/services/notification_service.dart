import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/foundation.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  factory NotificationService() => _instance;

  NotificationService._internal();

  Future<void> init() async {
    if (kIsWeb) return;
    tz.initializeTimeZones();
    const dynamic initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const dynamic initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await (flutterLocalNotificationsPlugin as dynamic).initialize(initializationSettings);
  }

  Future<void> showNotification(int id, String title, String body, {bool silent = false}) async {
    if (silent || kIsWeb) return;
    const dynamic androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'masar_channel',
      'Masar Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const dynamic platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await (flutterLocalNotificationsPlugin as dynamic).show(id, title, body, platformChannelSpecifics);
  }

  Future<void> scheduleNotification(int id, String title, String body, DateTime scheduledTime, {bool silent = false}) async {
    if (silent || kIsWeb) return;
    dynamic plugin = flutterLocalNotificationsPlugin;
    await plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails('masar_channel', 'Masar Notifications'),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: _getAbsoluteTimeInterpretation(),
    );
  }

  dynamic _getAbsoluteTimeInterpretation() {
    try {
      return (dynamic as dynamic).UILocalNotificationDateInterpretation.absoluteTime;
    } catch (_) {
      return null;
    }
  }
}
