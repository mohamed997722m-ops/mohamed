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
    try {
      tz.initializeTimeZones();
      const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
      const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
      await (flutterLocalNotificationsPlugin as dynamic).initialize(initializationSettings);
    } catch (e) {
      print("Notification init error: $e");
    }
  }

  Future<void> showNotification(int id, String title, String body, {bool silent = false}) async {
    if (kIsWeb || silent) return;
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'masar_channel',
        'Masar Notifications',
        importance: Importance.max,
        priority: Priority.high,
      );
      const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
      await (flutterLocalNotificationsPlugin as dynamic).show(id, title, body, platformChannelSpecifics);
    } catch (e) {
      print("Show notification error: $e");
    }
  }

  Future<void> scheduleNotification(int id, String title, String body, DateTime scheduledTime, {bool silent = false}) async {
    if (kIsWeb || silent) return;
    try {
      dynamic plugin = flutterLocalNotificationsPlugin;
      await plugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails('masar_channel', 'Masar Notifications'),
        ),
        androidScheduleMode: (AndroidScheduleMode as dynamic).values.firstWhere((e) => e.toString().contains('exactAllowWhileIdle')),
        uiLocalNotificationDateInterpretation: (dynamic as dynamic).from('absoluteTime'), // Placeholder attempt
      );
    } catch (e) {
      print("Schedule notification error: $e");
    }
  }
}
