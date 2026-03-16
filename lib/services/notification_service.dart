import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/foundation.dart' show kIsWeb;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  factory NotificationService() => _instance;

  NotificationService._internal();

  Future<void> init() async {
    if (kIsWeb) return;
    tz.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    try {
       await (flutterLocalNotificationsPlugin as dynamic).initialize(initializationSettings);
    } catch (e) {
      print("Notification init error: $e");
    }
  }

  Future<void> showNotification(int id, String title, String body, {bool silent = false, String? sound}) async {
    if (silent || kIsWeb) return;

    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'masar_channel',
      'Masar Notifications',
      importance: Importance.max,
      priority: Priority.high,
      sound: sound != null ? RawResourceAndroidNotificationSound(sound) : null,
      playSound: true,
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    try {
      await (flutterLocalNotificationsPlugin as dynamic).show(id, title, body, platformChannelSpecifics);
    } catch (e) {
      print("Show notification error: $e");
    }
  }

  Future<void> scheduleNotification(int id, String title, String body, DateTime scheduledTime, {bool silent = false, String? sound}) async {
    if (silent || kIsWeb) return;

    try {
      await (flutterLocalNotificationsPlugin as dynamic).zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledTime, tz.local),
        NotificationDetails(
          android: AndroidNotificationDetails(
            'masar_channel',
            'Masar Notifications',
            sound: sound != null ? RawResourceAndroidNotificationSound(sound) : null,
            playSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: (dynamic as dynamic).UILocalNotificationDateInterpretation?.absoluteTime ?? (dynamic as dynamic).absoluteTime,
      );
    } catch (e) {
       print("Schedule notification error: $e");
    }
  }

  Future<void> cancelAll() async {
    if (kIsWeb) return;
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
